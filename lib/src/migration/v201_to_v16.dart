import '../v16/messages.dart' as v16;
import '../v201/messages.dart' as v2;

/// Translates OCPP 2.0.1 messages back to OCPP 1.6.
///
/// Only conversions that have a meaningful v1.6 target are provided. Fields
/// that exist only in 2.0.1 are dropped (documented per method and in
/// MIGRATION.md).
abstract final class V201ToV16Translator {
  /// `BootNotificationRequest` -> `BootNotification.req`.
  /// Lost: `reason`, `modem` fields are kept (iccid/imsi); `statusInfo` n/a.
  static v16.BootNotificationReq bootNotification(
          v2.BootNotificationRequest r) =>
      v16.BootNotificationReq(
        chargePointVendor: r.chargingStation.vendorName,
        chargePointModel: r.chargingStation.model,
        chargePointSerialNumber: r.chargingStation.serialNumber,
        firmwareVersion: r.chargingStation.firmwareVersion,
        iccid: r.chargingStation.modem?.iccid,
        imsi: r.chargingStation.modem?.imsi,
      );

  /// `AuthorizeRequest` -> `Authorize.req`. Lost: token `type`,
  /// `certificate`.
  static v16.AuthorizeReq authorize(v2.AuthorizeRequest r) =>
      v16.AuthorizeReq(idTag: r.idToken.idToken);

  /// `AuthorizationStatusEnumType` -> v1.6 `AuthorizationStatus`.
  /// NoCredit, NotAllowedTypeEVSE, NotAtThisLocation, NotAtThisTime and
  /// Unknown all collapse to `Invalid` (v1.6 has no finer values).
  static v16.AuthorizationStatus authorizationStatus(
          v2.AuthorizationStatusEnumType s) =>
      switch (s) {
        v2.AuthorizationStatusEnumType.accepted =>
          v16.AuthorizationStatus.accepted,
        v2.AuthorizationStatusEnumType.blocked =>
          v16.AuthorizationStatus.blocked,
        v2.AuthorizationStatusEnumType.concurrentTx =>
          v16.AuthorizationStatus.concurrentTx,
        v2.AuthorizationStatusEnumType.expired =>
          v16.AuthorizationStatus.expired,
        _ => v16.AuthorizationStatus.invalid,
      };

  /// `StatusNotificationRequest` -> `StatusNotification.req`.
  ///
  /// `Occupied` has no single v1.6 equivalent; it becomes [occupiedAs]
  /// (default `Preparing`). `errorCode` is always `NoError` unless the
  /// status is `Faulted` (then `OtherError`). `evseId` is dropped: the v1.6
  /// `connectorId` is taken from the v2.0.1 `connectorId`.
  static v16.StatusNotificationReq statusNotification(
    v2.StatusNotificationRequest r, {
    v16.ChargePointStatus occupiedAs = v16.ChargePointStatus.preparing,
  }) {
    final status = switch (r.connectorStatus) {
      v2.ConnectorStatusEnumType.available => v16.ChargePointStatus.available,
      v2.ConnectorStatusEnumType.occupied => occupiedAs,
      v2.ConnectorStatusEnumType.reserved => v16.ChargePointStatus.reserved,
      v2.ConnectorStatusEnumType.unavailable =>
        v16.ChargePointStatus.unavailable,
      v2.ConnectorStatusEnumType.faulted => v16.ChargePointStatus.faulted,
    };
    return v16.StatusNotificationReq(
      connectorId: r.connectorId,
      errorCode: status == v16.ChargePointStatus.faulted
          ? v16.ChargePointErrorCode.otherError
          : v16.ChargePointErrorCode.noError,
      status: status,
      timestamp: r.timestamp,
    );
  }

  /// `TransactionEvent(Started)` -> `StartTransaction.req`.
  ///
  /// v1.6 requires `meterStart` and `idTag`; they are read from the event's
  /// Energy.Active.Import.Register sample (converted to Wh) and `idToken`.
  /// [meterStart] overrides. Throws [ArgumentError] if no idToken exists.
  static v16.StartTransactionReq startTransaction(
    v2.TransactionEventRequest r, {
    int? meterStart,
  }) {
    final tag = r.idToken?.idToken;
    if (tag == null) {
      throw ArgumentError('StartTransaction requires an idToken');
    }
    return v16.StartTransactionReq(
      connectorId: r.evse?.connectorId ?? r.evse?.id ?? 1,
      idTag: tag,
      meterStart: meterStart ?? _wh(r.meterValue) ?? 0,
      timestamp: r.timestamp,
      reservationId: r.reservationId,
    );
  }

  /// `TransactionEvent(Ended)` -> `StopTransaction.req`.
  ///
  /// The v1.6 integer `transactionId` must be supplied (v2.0.1 ids are
  /// arbitrary strings). Lost: triggerReason, seqNo, chargingState,
  /// timeSpentCharging, evse, offline, cableMaxCurrent, numberOfPhasesUsed.
  static v16.StopTransactionReq stopTransaction(
    v2.TransactionEventRequest r, {
    required int transactionId,
    int? meterStop,
  }) =>
      v16.StopTransactionReq(
        idTag: r.idToken?.idToken,
        meterStop: meterStop ?? _wh(r.meterValue) ?? 0,
        timestamp: r.timestamp,
        transactionId: transactionId,
        reason: r.transactionInfo.stoppedReason == null
            ? null
            : _reason(r.transactionInfo.stoppedReason!),
        transactionData: r.meterValue?.map(_meterValue).toList(),
      );

  /// `TransactionEvent(Updated)` -> `MeterValues.req`.
  /// `transactionId` is parsed to int when numeric, else omitted (lossy).
  static v16.MeterValuesReq meterValues(v2.TransactionEventRequest r) =>
      v16.MeterValuesReq(
        connectorId: r.evse?.connectorId ?? r.evse?.id ?? 0,
        transactionId: int.tryParse(r.transactionInfo.transactionId),
        meterValue: (r.meterValue ?? const []).map(_meterValue).toList(),
      );

  /// `DataTransferRequest` -> `DataTransfer.req`. Non-string `data` is
  /// JSON-encoded-by-toString (lossy); strings pass through.
  static v16.DataTransferReq dataTransfer(v2.DataTransferRequest r) =>
      v16.DataTransferReq(
          vendorId: r.vendorId,
          messageId: r.messageId,
          data: r.data?.toString());

  static v16.Reason _reason(v2.ReasonEnumType r) => switch (r) {
        v2.ReasonEnumType.immediateReset => v16.Reason.hardReset,
        v2.ReasonEnumType.emergencyStop => v16.Reason.emergencyStop,
        v2.ReasonEnumType.deAuthorized => v16.Reason.deAuthorized,
        v2.ReasonEnumType.evDisconnected => v16.Reason.evDisconnected,
        v2.ReasonEnumType.local => v16.Reason.local,
        v2.ReasonEnumType.powerLoss => v16.Reason.powerLoss,
        v2.ReasonEnumType.reboot => v16.Reason.reboot,
        v2.ReasonEnumType.remote => v16.Reason.remote,
        _ => v16.Reason.other,
      };

  static int? _wh(List<v2.MeterValueType>? mvs) {
    for (final mv in mvs ?? const <v2.MeterValueType>[]) {
      for (final s in mv.sampledValue) {
        if (s.measurand == null ||
            s.measurand == 'Energy.Active.Import.Register') {
          final unit = s.unitOfMeasure?.unit;
          final factor = unit == 'kWh' ? 1000 : 1;
          return (s.value * factor).round();
        }
      }
    }
    return null;
  }

  static v16.MeterValue _meterValue(v2.MeterValueType m) => v16.MeterValue(
        timestamp: m.timestamp,
        sampledValue: [
          for (final s in m.sampledValue)
            v16.SampledValue(
              value: s.value == s.value.roundToDouble()
                  ? s.value.round().toString()
                  : s.value.toString(),
              context: s.context == null
                  ? null
                  : v16.ReadingContext.values.byName(s.context!.name),
              measurand: s.measurand,
              phase: s.phase,
              location: s.location == null
                  ? null
                  : v16.Location.values.byName(s.location!.name),
              unit: s.unitOfMeasure?.unit,
            )
        ],
      );

  // ------------------------------------------------------------ Reservation

  /// `ReserveNowRequest` -> `ReserveNow.req`. A null `evseId` becomes
  /// connector 0 (any). Lost: `connectorType`, token types. `groupIdToken`
  /// becomes `parentIdTag`.
  static v16.ReserveNowReq reserveNow(v2.ReserveNowRequest r) =>
      v16.ReserveNowReq(
        connectorId: r.evseId ?? 0,
        expiryDate: r.expiryDateTime,
        idTag: r.idToken.idToken,
        parentIdTag: r.groupIdToken?.idToken,
        reservationId: r.id,
      );

  /// `ReserveNowResponse` -> `ReserveNow.conf`. Lost: `statusInfo`.
  static v16.ReserveNowConf reserveNowResponse(v2.ReserveNowResponse c) =>
      v16.ReserveNowConf(
          status: v16.ReservationStatus.values.byName(c.status.name));

  /// `CancelReservationRequest` -> `CancelReservation.req`.
  static v16.CancelReservationReq cancelReservation(
          v2.CancelReservationRequest r) =>
      v16.CancelReservationReq(reservationId: r.reservationId);

  /// `CancelReservationResponse` -> `CancelReservation.conf`.
  static v16.CancelReservationConf cancelReservationResponse(
          v2.CancelReservationResponse c) =>
      v16.CancelReservationConf(
          status: v16.CancelReservationStatus.values.byName(c.status.name));

  // --------------------------------------------------------- Smart charging

  /// 2.0.1 purpose -> v1.6 purpose. `ChargingStationMaxProfile` becomes
  /// `ChargePointMaxProfile`. `ChargingStationExternalConstraints` has no
  /// v1.6 equivalent (and a CSMS cannot set it) so [ArgumentError] is thrown.
  static v16.ChargingProfilePurpose chargingProfilePurpose(
          v2.ChargingProfilePurposeEnumType p) =>
      switch (p) {
        v2.ChargingProfilePurposeEnumType.chargingStationMaxProfile =>
          v16.ChargingProfilePurpose.chargePointMaxProfile,
        v2.ChargingProfilePurposeEnumType.txDefaultProfile =>
          v16.ChargingProfilePurpose.txDefaultProfile,
        v2.ChargingProfilePurposeEnumType.txProfile =>
          v16.ChargingProfilePurpose.txProfile,
        v2.ChargingProfilePurposeEnumType.chargingStationExternalConstraints =>
          throw ArgumentError('ChargingStationExternalConstraints has no '
              'OCPP 1.6 equivalent'),
      };

  /// `ChargingScheduleType` -> `ChargingSchedule`. Lost: `id`, `salesTariff`,
  /// period `phaseToUse`.
  static v16.ChargingSchedule chargingSchedule(v2.ChargingScheduleType s) =>
      v16.ChargingSchedule(
        duration: s.duration,
        startSchedule: s.startSchedule,
        chargingRateUnit:
            v16.ChargingRateUnit.values.byName(s.chargingRateUnit.name),
        minChargingRate: s.minChargingRate,
        chargingSchedulePeriod: _periods(s.chargingSchedulePeriod),
      );

  static List<v16.ChargingSchedulePeriod> _periods(
          List<v2.ChargingSchedulePeriodType> ps) =>
      [
        for (final p in ps)
          v16.ChargingSchedulePeriod(
              startPeriod: p.startPeriod,
              limit: p.limit,
              numberPhases: p.numberPhases)
      ];

  /// `ChargingProfileType` -> `ChargingProfile`.
  ///
  /// **Lossy**: v1.6 holds a single schedule, so only the first of the
  /// 1..3 schedules is kept; `salesTariff`, schedule `id` and `phaseToUse`
  /// are dropped; a non-numeric `transactionId` is dropped (v1.6 uses
  /// integers).
  static v16.ChargingProfile chargingProfile(v2.ChargingProfileType p) {
    if (p.chargingSchedule.isEmpty) {
      throw ArgumentError('ChargingProfileType needs at least one schedule');
    }
    return v16.ChargingProfile(
      chargingProfileId: p.id,
      transactionId:
          p.transactionId == null ? null : int.tryParse(p.transactionId!),
      stackLevel: p.stackLevel,
      chargingProfilePurpose: chargingProfilePurpose(p.chargingProfilePurpose),
      chargingProfileKind:
          v16.ChargingProfileKind.values.byName(p.chargingProfileKind.name),
      recurrencyKind: p.recurrencyKind == null
          ? null
          : v16.RecurrencyKind.values.byName(p.recurrencyKind!.name),
      validFrom: p.validFrom,
      validTo: p.validTo,
      chargingSchedule: chargingSchedule(p.chargingSchedule.first),
    );
  }

  /// `SetChargingProfileRequest` -> `SetChargingProfile.req`
  /// (`connectorId == evseId`).
  static v16.SetChargingProfileReq setChargingProfile(
          v2.SetChargingProfileRequest r) =>
      v16.SetChargingProfileReq(
          connectorId: r.evseId,
          csChargingProfiles: chargingProfile(r.chargingProfile));

  /// `SetChargingProfileResponse` -> `SetChargingProfile.conf`. Lost:
  /// `statusInfo`.
  static v16.SetChargingProfileConf setChargingProfileResponse(
          v2.SetChargingProfileResponse c) =>
      v16.SetChargingProfileConf(
          status: v16.ChargingProfileStatus.values.byName(c.status.name));

  /// `ClearChargingProfileRequest` -> `ClearChargingProfile.req`. Throws
  /// [ArgumentError] when the criteria purpose is
  /// `ChargingStationExternalConstraints` (silently widening a clear would be
  /// unsafe).
  static v16.ClearChargingProfileReq clearChargingProfile(
      v2.ClearChargingProfileRequest r) {
    final c = r.chargingProfileCriteria;
    return v16.ClearChargingProfileReq(
      id: r.chargingProfileId,
      connectorId: c?.evseId,
      chargingProfilePurpose: c?.chargingProfilePurpose == null
          ? null
          : chargingProfilePurpose(c!.chargingProfilePurpose!),
      stackLevel: c?.stackLevel,
    );
  }

  /// `ClearChargingProfileResponse` -> `ClearChargingProfile.conf`.
  static v16.ClearChargingProfileConf clearChargingProfileResponse(
          v2.ClearChargingProfileResponse c) =>
      v16.ClearChargingProfileConf(
          status: v16.ClearChargingProfileStatus.values.byName(c.status.name));

  /// `GetCompositeScheduleRequest` -> `GetCompositeSchedule.req`.
  static v16.GetCompositeScheduleReq getCompositeSchedule(
          v2.GetCompositeScheduleRequest r) =>
      v16.GetCompositeScheduleReq(
        connectorId: r.evseId,
        duration: r.duration,
        chargingRateUnit: r.chargingRateUnit == null
            ? null
            : v16.ChargingRateUnit.values.byName(r.chargingRateUnit!.name),
      );

  /// `GetCompositeScheduleResponse` -> `GetCompositeSchedule.conf`.
  /// `CompositeScheduleType` is unpacked into `connectorId`,
  /// `scheduleStart` and a `ChargingSchedule`. Lost: `statusInfo`.
  static v16.GetCompositeScheduleConf getCompositeScheduleResponse(
      v2.GetCompositeScheduleResponse c) {
    final s = c.schedule;
    return v16.GetCompositeScheduleConf(
      status: v16.GetCompositeScheduleStatus.values.byName(c.status.name),
      connectorId: s?.evseId,
      scheduleStart: s?.scheduleStart,
      chargingSchedule: s == null
          ? null
          : v16.ChargingSchedule(
              duration: s.duration,
              startSchedule: s.scheduleStart,
              chargingRateUnit:
                  v16.ChargingRateUnit.values.byName(s.chargingRateUnit.name),
              chargingSchedulePeriod: _periods(s.chargingSchedulePeriod),
            ),
    );
  }

  // ------------------------------------------------- Local authorization list

  /// `IdTokenInfoType` -> `IdTagInfo`. Status via [authorizationStatus]
  /// (lossy). `cacheExpiryDateTime` -> `expiryDate`, `groupIdToken` ->
  /// `parentIdTag`. Lost: `chargingPriority`, `language1`, `language2`,
  /// `evseId`.
  static v16.IdTagInfo idTagInfo(v2.IdTokenInfoType i) => v16.IdTagInfo(
        status: authorizationStatus(i.status),
        expiryDate: i.cacheExpiryDateTime,
        parentIdTag: i.groupIdToken?.idToken,
      );

  /// `AuthorizationDataType` -> `AuthorizationData`. Lost: token type.
  static v16.AuthorizationData authorizationData(v2.AuthorizationDataType d) =>
      v16.AuthorizationData(
        idTag: d.idToken.idToken,
        idTagInfo: d.idTokenInfo == null ? null : idTagInfo(d.idTokenInfo!),
      );

  /// `SendLocalListRequest` -> `SendLocalList.req`
  /// (`versionNumber` -> `listVersion`).
  static v16.SendLocalListReq sendLocalList(v2.SendLocalListRequest r) =>
      v16.SendLocalListReq(
        listVersion: r.versionNumber,
        updateType: v16.UpdateType.values.byName(r.updateType.name),
        localAuthorizationList:
            r.localAuthorizationList?.map(authorizationData).toList(),
      );

  /// `SendLocalListResponse` -> `SendLocalList.conf`. Lost: `statusInfo`.
  static v16.SendLocalListConf sendLocalListResponse(
          v2.SendLocalListResponse c) =>
      v16.SendLocalListConf(
          status: v16.UpdateStatus.values.byName(c.status.name));

  /// `GetLocalListVersionRequest` -> `GetLocalListVersion.req`.
  static v16.GetLocalListVersionReq getLocalListVersion(
          v2.GetLocalListVersionRequest r) =>
      const v16.GetLocalListVersionReq();

  /// `GetLocalListVersionResponse` -> `GetLocalListVersion.conf`.
  static v16.GetLocalListVersionConf getLocalListVersionResponse(
          v2.GetLocalListVersionResponse c) =>
      v16.GetLocalListVersionConf(listVersion: c.versionNumber);
}
