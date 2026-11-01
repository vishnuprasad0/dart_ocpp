import '../v16/messages.dart' as v16;
import '../v201/messages.dart' as v2;

/// Translates OCPP 1.6 messages to their OCPP 2.0.1 counterparts.
///
/// Every conversion is best-effort and **lossy** in places; see MIGRATION.md.
/// General assumptions (chosen defaults, not mandated by either spec):
///
/// * v1.6 connector ids are flat (1..N); v2.0.1 has EVSE + connector. We map
///   `evseId == connectorId` and `connectorId == connectorId`. Use the
///   `evseId` parameter where available to override.
/// * v1.6 transaction ids are integers assigned by the Central System in the
///   `StartTransaction.conf`; v2.0.1 ids are client-generated strings, so the
///   id must be supplied by the caller.
/// * v1.6 `idTag` has no type; it is mapped to `IdTokenEnumType.iso14443`.
abstract final class V16ToV201Translator {
  static const _energyMeasurand = 'Energy.Active.Import.Register';

  /// `BootNotification.req` -> `BootNotificationRequest`.
  ///
  /// Lost: `chargeBoxSerialNumber`, `meterType`, `meterSerialNumber`
  /// (no equivalent). `chargePointSerialNumber` becomes `serialNumber`.
  /// New in v2.0.1 and defaulted: [reason].
  static v2.BootNotificationRequest bootNotification(
    v16.BootNotificationReq r, {
    v2.BootReasonEnumType reason = v2.BootReasonEnumType.powerUp,
  }) =>
      v2.BootNotificationRequest(
        reason: reason,
        chargingStation: v2.ChargingStationType(
          serialNumber: r.chargePointSerialNumber ?? r.chargeBoxSerialNumber,
          model: r.chargePointModel,
          vendorName: r.chargePointVendor,
          firmwareVersion: r.firmwareVersion,
          modem: (r.iccid != null || r.imsi != null)
              ? v2.ModemType(iccid: r.iccid, imsi: r.imsi)
              : null,
        ),
      );

  /// `Authorize.req` -> `AuthorizeRequest`. The idTag type is assumed
  /// [v2.IdTokenEnumType.iso14443].
  static v2.AuthorizeRequest authorize(v16.AuthorizeReq r,
          {v2.IdTokenEnumType type = v2.IdTokenEnumType.iso14443}) =>
      v2.AuthorizeRequest(
          idToken: v2.IdTokenType(idToken: r.idTag, type: type));

  /// `StartTransaction.req` -> `TransactionEventRequest(Started)`.
  ///
  /// eventType = Started, triggerReason = Authorized. [transactionId] is
  /// required because v1.6 only learns its id from the response. The
  /// `meterStart` reading is carried as a `Transaction.Begin` sampled value
  /// in Wh.
  static v2.TransactionEventReq fromStartTransaction(
    v16.StartTransactionReq r, {
    required String transactionId,
    int seqNo = 0,
    int? evseId,
  }) =>
      v2.TransactionEventRequest(
        eventType: v2.TransactionEventEnumType.started,
        timestamp: r.timestamp,
        triggerReason: v2.TriggerReasonEnumType.authorized,
        seqNo: seqNo,
        transactionInfo: v2.TransactionType(transactionId: transactionId),
        evse: v2.EVSEType(
            id: evseId ?? r.connectorId, connectorId: r.connectorId),
        idToken:
            v2.IdTokenType(idToken: r.idTag, type: v2.IdTokenEnumType.iso14443),
        reservationId: r.reservationId,
        meterValue: [
          v2.MeterValueType(timestamp: r.timestamp, sampledValue: [
            _energy(r.meterStart.toDouble(),
                v2.ReadingContextEnumType.transactionBegin)
          ])
        ],
      );

  /// `StopTransaction.req` -> `TransactionEventRequest(Ended)`.
  ///
  /// eventType = Ended. triggerReason defaults to `EVDeparted` (the closest
  /// v2.0.1 value to the "EV disconnected" intent; v2.0.1 has no
  /// `EVDisconnected` trigger) unless the v1.6 [v16.Reason] implies a more
  /// precise one (Remote -> RemoteStop, DeAuthorized -> Deauthorized,
  /// Local -> StopAuthorized). `reason` becomes `transactionInfo.stoppedReason`
  /// (default `EVDisconnected` when absent, matching the v1.6 spec default).
  /// `transactionData` is carried over as meter values.
  static v2.TransactionEventReq fromStopTransaction(
    v16.StopTransactionReq r, {
    int seqNo = 0,
    int evseId = 1,
    int? connectorId,
  }) {
    final trigger = switch (r.reason) {
      v16.Reason.remote => v2.TriggerReasonEnumType.remoteStop,
      v16.Reason.deAuthorized => v2.TriggerReasonEnumType.deauthorized,
      v16.Reason.local => v2.TriggerReasonEnumType.stopAuthorized,
      _ => v2.TriggerReasonEnumType.evDeparted,
    };
    return v2.TransactionEventRequest(
      eventType: v2.TransactionEventEnumType.ended,
      timestamp: r.timestamp,
      triggerReason: trigger,
      seqNo: seqNo,
      transactionInfo: v2.TransactionType(
        transactionId: r.transactionId.toString(),
        stoppedReason: _reason(r.reason ?? v16.Reason.evDisconnected),
      ),
      evse: v2.EVSEType(id: evseId, connectorId: connectorId ?? evseId),
      idToken: r.idTag == null
          ? null
          : v2.IdTokenType(
              idToken: r.idTag!, type: v2.IdTokenEnumType.iso14443),
      meterValue: [
        v2.MeterValueType(timestamp: r.timestamp, sampledValue: [
          _energy(
              r.meterStop.toDouble(), v2.ReadingContextEnumType.transactionEnd)
        ]),
        ...?r.transactionData?.map(_meterValue),
      ],
    );
  }

  /// `MeterValues.req` -> `TransactionEventRequest(Updated)`.
  ///
  /// triggerReason = MeterValuePeriodic. A transaction id is mandatory in
  /// v2.0.1; it is taken from [transactionId], else from the v1.6 request.
  /// Throws [ArgumentError] when neither exists (v1.6 allows meter values
  /// outside a transaction; those have no TransactionEvent equivalent).
  static v2.TransactionEventReq fromMeterValues(
    v16.MeterValuesReq r, {
    String? transactionId,
    int seqNo = 0,
    int? evseId,
  }) {
    final id = transactionId ?? r.transactionId?.toString();
    if (id == null) {
      throw ArgumentError(
          'MeterValues outside a transaction cannot become a TransactionEvent');
    }
    final mv = r.meterValue.map(_meterValue).toList();
    return v2.TransactionEventRequest(
      eventType: v2.TransactionEventEnumType.updated,
      timestamp: mv.isEmpty ? DateTime.now().toUtc() : mv.last.timestamp,
      triggerReason: v2.TriggerReasonEnumType.meterValuePeriodic,
      seqNo: seqNo,
      transactionInfo: v2.TransactionType(transactionId: id),
      evse:
          v2.EVSEType(id: evseId ?? r.connectorId, connectorId: r.connectorId),
      meterValue: mv,
    );
  }

  /// `StatusNotification.req` -> `StatusNotificationRequest`.
  ///
  /// Mapping: Available->Available; Preparing, Charging, SuspendedEV,
  /// SuspendedEVSE, Finishing->Occupied; Reserved->Reserved;
  /// Unavailable->Unavailable; Faulted->Faulted. Lost: `errorCode`, `info`,
  /// `vendorId`, `vendorErrorCode`, and the fine-grained occupied states
  /// (those move to `TransactionEvent.transactionInfo.chargingState`).
  /// A missing timestamp is replaced by the current UTC time.
  static v2.StatusNotificationRequest statusNotification(
    v16.StatusNotificationReq r, {
    int? evseId,
  }) =>
      v2.StatusNotificationRequest(
        timestamp: r.timestamp ?? DateTime.now().toUtc(),
        connectorStatus: connectorStatus(r.status),
        evseId: evseId ?? r.connectorId,
        connectorId: r.connectorId,
      );

  /// Alias of [statusNotification] (named after the brief's `v201(...)`).
  static v2.StatusNotificationRequest v201(v16.StatusNotificationReq r) =>
      statusNotification(r);

  /// `ChargePointStatus` -> `ConnectorStatusEnumType` (lossy, see above).
  static v2.ConnectorStatusEnumType connectorStatus(v16.ChargePointStatus s) =>
      switch (s) {
        v16.ChargePointStatus.available => v2.ConnectorStatusEnumType.available,
        v16.ChargePointStatus.reserved => v2.ConnectorStatusEnumType.reserved,
        v16.ChargePointStatus.unavailable =>
          v2.ConnectorStatusEnumType.unavailable,
        v16.ChargePointStatus.faulted => v2.ConnectorStatusEnumType.faulted,
        v16.ChargePointStatus.preparing ||
        v16.ChargePointStatus.charging ||
        v16.ChargePointStatus.suspendedEV ||
        v16.ChargePointStatus.suspendedEVSE ||
        v16.ChargePointStatus.finishing =>
          v2.ConnectorStatusEnumType.occupied,
      };

  /// Charging state a v1.6 status implies inside a transaction, or `null`.
  static v2.ChargingStateEnumType? chargingState(v16.ChargePointStatus s) =>
      switch (s) {
        v16.ChargePointStatus.charging => v2.ChargingStateEnumType.charging,
        v16.ChargePointStatus.suspendedEV =>
          v2.ChargingStateEnumType.suspendedEV,
        v16.ChargePointStatus.suspendedEVSE =>
          v2.ChargingStateEnumType.suspendedEVSE,
        v16.ChargePointStatus.preparing => v2.ChargingStateEnumType.evConnected,
        v16.ChargePointStatus.finishing => v2.ChargingStateEnumType.idle,
        _ => null,
      };

  /// `DataTransfer.req` -> `DataTransferRequest`. The v1.6 string `data` is
  /// passed through unchanged (v2.0.1 allows any JSON).
  static v2.DataTransferRequest dataTransfer(v16.DataTransferReq r) =>
      v2.DataTransferRequest(
          vendorId: r.vendorId, messageId: r.messageId, data: r.data);

  /// `FirmwareStatusNotification.req` -> v2.0.1. Statuses map by name;
  /// v2.0.1 has extra states with no v1.6 source. `requestId` is not
  /// available in v1.6 and stays null.
  static v2.FirmwareStatusNotificationRequest firmwareStatus(
          v16.FirmwareStatusNotificationReq r) =>
      v2.FirmwareStatusNotificationRequest(
          status: v2.FirmwareStatusEnumType.values.byName(r.status.name));

  /// `ReadingContext` -> `ReadingContextEnumType` (identical members).
  static v2.ReadingContextEnumType _context(v16.ReadingContext c) =>
      v2.ReadingContextEnumType.values.byName(c.name);

  static v2.ReasonEnumType _reason(v16.Reason r) => switch (r) {
        // v1.6 `HardReset`/`SoftReset`/`UnlockCommand` have no 1:1 member.
        v16.Reason.hardReset ||
        v16.Reason.softReset =>
          v2.ReasonEnumType.immediateReset,
        v16.Reason.unlockCommand => v2.ReasonEnumType.other,
        _ => v2.ReasonEnumType.values.byName(r.name),
      };

  static v2.SampledValueType _energy(
          double wh, v2.ReadingContextEnumType context) =>
      v2.SampledValueType(
        value: wh,
        context: context,
        measurand: _energyMeasurand,
        unitOfMeasure: v2.UnitOfMeasureType(unit: 'Wh'),
      );

  static v2.MeterValueType _meterValue(v16.MeterValue m) => v2.MeterValueType(
        timestamp: m.timestamp,
        sampledValue: [
          for (final s in m.sampledValue)
            v2.SampledValueType(
              // Lossy: non-numeric (SignedData) readings become 0.
              value: double.tryParse(s.value) ?? 0,
              context: s.context == null ? null : _context(s.context!),
              measurand: s.measurand,
              phase: s.phase,
              location: s.location == null
                  ? null
                  : v2.LocationEnumType.values.byName(s.location!.name),
              unitOfMeasure:
                  s.unit == null ? null : v2.UnitOfMeasureType(unit: s.unit),
            )
        ],
      );

  // ------------------------------------------------------------ Reservation

  /// `ReserveNow.req` -> `ReserveNowRequest`. `connectorId` 0 (any
  /// connector) becomes a null `evseId`; otherwise `evseId == connectorId`.
  /// `parentIdTag` becomes `groupIdToken`. [type] is the assumed token type;
  /// [connectorType] is new in 2.0.1 and left unset by default.
  static v2.ReserveNowRequest reserveNow(
    v16.ReserveNowReq r, {
    v2.IdTokenEnumType type = v2.IdTokenEnumType.iso14443,
    v2.ConnectorEnumType? connectorType,
  }) =>
      v2.ReserveNowRequest(
        id: r.reservationId,
        expiryDateTime: r.expiryDate,
        connectorType: connectorType,
        evseId: r.connectorId == 0 ? null : r.connectorId,
        idToken: v2.IdTokenType(idToken: r.idTag, type: type),
        groupIdToken: r.parentIdTag == null
            ? null
            : v2.IdTokenType(idToken: r.parentIdTag!, type: type),
      );

  /// `ReserveNow.conf` -> `ReserveNowResponse` (statuses map 1:1).
  static v2.ReserveNowResponse reserveNowResponse(v16.ReserveNowConf c) =>
      v2.ReserveNowResponse(
          status: v2.ReserveNowStatusEnumType.values.byName(c.status.name));

  /// `CancelReservation.req` -> `CancelReservationRequest`.
  static v2.CancelReservationRequest cancelReservation(
          v16.CancelReservationReq r) =>
      v2.CancelReservationRequest(reservationId: r.reservationId);

  /// `CancelReservation.conf` -> `CancelReservationResponse`.
  static v2.CancelReservationResponse cancelReservationResponse(
          v16.CancelReservationConf c) =>
      v2.CancelReservationResponse(
          status:
              v2.CancelReservationStatusEnumType.values.byName(c.status.name));

  // --------------------------------------------------------- Smart charging

  /// v1.6 purpose -> 2.0.1 purpose (`ChargePointMaxProfile` becomes
  /// `ChargingStationMaxProfile`).
  static v2.ChargingProfilePurposeEnumType chargingProfilePurpose(
          v16.ChargingProfilePurpose p) =>
      switch (p) {
        v16.ChargingProfilePurpose.chargePointMaxProfile =>
          v2.ChargingProfilePurposeEnumType.chargingStationMaxProfile,
        v16.ChargingProfilePurpose.txDefaultProfile =>
          v2.ChargingProfilePurposeEnumType.txDefaultProfile,
        v16.ChargingProfilePurpose.txProfile =>
          v2.ChargingProfilePurposeEnumType.txProfile,
      };

  /// `ChargingSchedule` -> `ChargingScheduleType`. v1.6 schedules have no
  /// id; [id] is required by 2.0.1 and defaults to 1 (**DEFAULT**).
  static v2.ChargingScheduleType chargingSchedule(v16.ChargingSchedule s,
          {int id = 1}) =>
      v2.ChargingScheduleType(
        id: id,
        startSchedule: s.startSchedule,
        duration: s.duration,
        chargingRateUnit:
            v2.ChargingRateUnitEnumType.values.byName(s.chargingRateUnit.name),
        minChargingRate: s.minChargingRate,
        chargingSchedulePeriod: [
          for (final p in s.chargingSchedulePeriod)
            v2.ChargingSchedulePeriodType(
                startPeriod: p.startPeriod,
                limit: p.limit,
                numberPhases: p.numberPhases)
        ],
      );

  /// `ChargingProfile` -> `ChargingProfileType`. `chargingProfileId` becomes
  /// `id` (and the schedule id); `transactionId` is stringified.
  static v2.ChargingProfileType chargingProfile(v16.ChargingProfile p) =>
      v2.ChargingProfileType(
        id: p.chargingProfileId,
        stackLevel: p.stackLevel,
        chargingProfilePurpose:
            chargingProfilePurpose(p.chargingProfilePurpose),
        chargingProfileKind: v2.ChargingProfileKindEnumType.values
            .byName(p.chargingProfileKind.name),
        recurrencyKind: p.recurrencyKind == null
            ? null
            : v2.RecurrencyKindEnumType.values.byName(p.recurrencyKind!.name),
        validFrom: p.validFrom,
        validTo: p.validTo,
        transactionId: p.transactionId?.toString(),
        chargingSchedule: [
          chargingSchedule(p.chargingSchedule, id: p.chargingProfileId)
        ],
      );

  /// `SetChargingProfile.req` -> `SetChargingProfileRequest`
  /// (`evseId == connectorId`; 0 = whole station in both versions).
  static v2.SetChargingProfileRequest setChargingProfile(
          v16.SetChargingProfileReq r) =>
      v2.SetChargingProfileRequest(
          evseId: r.connectorId,
          chargingProfile: chargingProfile(r.csChargingProfiles));

  /// `SetChargingProfile.conf` -> `SetChargingProfileResponse`.
  /// `NotSupported` collapses to `Rejected`.
  static v2.SetChargingProfileResponse setChargingProfileResponse(
          v16.SetChargingProfileConf c) =>
      v2.SetChargingProfileResponse(
          status: c.status == v16.ChargingProfileStatus.accepted
              ? v2.ChargingProfileStatusEnumType.accepted
              : v2.ChargingProfileStatusEnumType.rejected);

  /// `ClearChargingProfile.req` -> `ClearChargingProfileRequest`. `id`,
  /// `connectorId`, `chargingProfilePurpose` and `stackLevel` move into
  /// `chargingProfileCriteria` where applicable.
  static v2.ClearChargingProfileRequest clearChargingProfile(
          v16.ClearChargingProfileReq r) =>
      v2.ClearChargingProfileRequest(
        chargingProfileId: r.id,
        chargingProfileCriteria: (r.connectorId == null &&
                r.chargingProfilePurpose == null &&
                r.stackLevel == null)
            ? null
            : v2.ClearChargingProfileType(
                evseId: r.connectorId,
                chargingProfilePurpose: r.chargingProfilePurpose == null
                    ? null
                    : chargingProfilePurpose(r.chargingProfilePurpose!),
                stackLevel: r.stackLevel),
      );

  /// `ClearChargingProfile.conf` -> `ClearChargingProfileResponse`.
  static v2.ClearChargingProfileResponse clearChargingProfileResponse(
          v16.ClearChargingProfileConf c) =>
      v2.ClearChargingProfileResponse(
          status: v2.ClearChargingProfileStatusEnumType.values
              .byName(c.status.name));

  /// `GetCompositeSchedule.req` -> `GetCompositeScheduleRequest`.
  static v2.GetCompositeScheduleRequest getCompositeSchedule(
          v16.GetCompositeScheduleReq r) =>
      v2.GetCompositeScheduleRequest(
        evseId: r.connectorId,
        duration: r.duration,
        chargingRateUnit: r.chargingRateUnit == null
            ? null
            : v2.ChargingRateUnitEnumType.values
                .byName(r.chargingRateUnit!.name),
      );

  /// `GetCompositeSchedule.conf` -> `GetCompositeScheduleResponse`.
  ///
  /// 2.0.1 `CompositeScheduleType` requires `evseId`, `scheduleStart` and
  /// `duration`. They are taken from `connectorId`, `scheduleStart` (else
  /// `chargingSchedule.startSchedule`) and `chargingSchedule.duration`
  /// (**DEFAULT** 0). Throws [ArgumentError] when a schedule is present but
  /// `connectorId` or a start time is missing.
  static v2.GetCompositeScheduleResponse getCompositeScheduleResponse(
      v16.GetCompositeScheduleConf c) {
    final status = v2.GenericStatusEnumType.values.byName(c.status.name);
    final s = c.chargingSchedule;
    if (s == null) return v2.GetCompositeScheduleResponse(status: status);
    final evse = c.connectorId;
    final start = c.scheduleStart ?? s.startSchedule;
    if (evse == null || start == null) {
      throw ArgumentError('GetCompositeSchedule.conf with a schedule needs '
          'connectorId and scheduleStart to map to CompositeScheduleType');
    }
    return v2.GetCompositeScheduleResponse(
      status: status,
      schedule: v2.CompositeScheduleType(
        chargingSchedulePeriod: chargingSchedule(s).chargingSchedulePeriod,
        evseId: evse,
        duration: s.duration ?? 0,
        scheduleStart: start,
        chargingRateUnit:
            v2.ChargingRateUnitEnumType.values.byName(s.chargingRateUnit.name),
      ),
    );
  }

  // ------------------------------------------------- Local authorization list

  /// `IdTagInfo` -> `IdTokenInfoType`. `expiryDate` becomes
  /// `cacheExpiryDateTime`; `parentIdTag` becomes `groupIdToken` (type
  /// [type]).
  static v2.IdTokenInfoType idTokenInfo(v16.IdTagInfo i,
          {v2.IdTokenEnumType type = v2.IdTokenEnumType.iso14443}) =>
      v2.IdTokenInfoType(
        status: v2.AuthorizationStatusEnumType.values.byName(i.status.name),
        cacheExpiryDateTime: i.expiryDate,
        groupIdToken: i.parentIdTag == null
            ? null
            : v2.IdTokenType(idToken: i.parentIdTag!, type: type),
      );

  /// `AuthorizationData` -> `AuthorizationDataType`.
  static v2.AuthorizationDataType authorizationData(v16.AuthorizationData d,
          {v2.IdTokenEnumType type = v2.IdTokenEnumType.iso14443}) =>
      v2.AuthorizationDataType(
        idToken: v2.IdTokenType(idToken: d.idTag, type: type),
        idTokenInfo:
            d.idTagInfo == null ? null : idTokenInfo(d.idTagInfo!, type: type),
      );

  /// `SendLocalList.req` -> `SendLocalListRequest`
  /// (`listVersion` -> `versionNumber`).
  static v2.SendLocalListRequest sendLocalList(v16.SendLocalListReq r,
          {v2.IdTokenEnumType type = v2.IdTokenEnumType.iso14443}) =>
      v2.SendLocalListRequest(
        versionNumber: r.listVersion,
        updateType: v2.UpdateEnumType.values.byName(r.updateType.name),
        localAuthorizationList: r.localAuthorizationList
            ?.map((d) => authorizationData(d, type: type))
            .toList(),
      );

  /// `SendLocalList.conf` -> `SendLocalListResponse`. `NotSupported`
  /// collapses to `Failed` (2.0.1 has no such status).
  static v2.SendLocalListResponse sendLocalListResponse(
          v16.SendLocalListConf c) =>
      v2.SendLocalListResponse(
          status: switch (c.status) {
        v16.UpdateStatus.accepted => v2.SendLocalListStatusEnumType.accepted,
        v16.UpdateStatus.versionMismatch =>
          v2.SendLocalListStatusEnumType.versionMismatch,
        _ => v2.SendLocalListStatusEnumType.failed,
      });

  /// `GetLocalListVersion.req` -> `GetLocalListVersionRequest`.
  static v2.GetLocalListVersionRequest getLocalListVersion(
          v16.GetLocalListVersionReq r) =>
      const v2.GetLocalListVersionRequest();

  /// `GetLocalListVersion.conf` -> `GetLocalListVersionResponse`
  /// (`listVersion` -> `versionNumber`; -1 is passed through unchanged).
  static v2.GetLocalListVersionResponse getLocalListVersionResponse(
          v16.GetLocalListVersionConf c) =>
      v2.GetLocalListVersionResponse(versionNumber: c.listVersion);
}
