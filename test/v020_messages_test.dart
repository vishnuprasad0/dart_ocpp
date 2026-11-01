import 'dart:async';
import 'dart:convert';

import 'package:dart_ocpp/dart_ocpp.dart';
import 'package:test/test.dart';

/// Round-trips an object through JSON text and returns the decoded map.
Map<String, dynamic> wire(Map<String, dynamic> j) =>
    jsonDecode(jsonEncode(j)) as Map<String, dynamic>;

void main() {
  final t0 = DateTime.utc(2026, 1, 1, 12);
  final t1 = DateTime.utc(2026, 1, 2, 12);

  final profile16 = ChargingProfile(
    chargingProfileId: 5,
    transactionId: 42,
    stackLevel: 2,
    chargingProfilePurpose: ChargingProfilePurpose.txProfile,
    chargingProfileKind: ChargingProfileKind.recurring,
    recurrencyKind: RecurrencyKind.daily,
    validFrom: t0,
    validTo: t1,
    chargingSchedule: ChargingSchedule(
      duration: 3600,
      startSchedule: t0,
      chargingRateUnit: ChargingRateUnit.amperes,
      minChargingRate: 6.5,
      chargingSchedulePeriod: [
        ChargingSchedulePeriod(startPeriod: 0, limit: 16, numberPhases: 3),
        ChargingSchedulePeriod(startPeriod: 1800, limit: 8.5),
      ],
    ),
  );

  final profile2 = ChargingProfileType(
    id: 5,
    stackLevel: 2,
    chargingProfilePurpose: ChargingProfilePurposeEnumType.txProfile,
    chargingProfileKind: ChargingProfileKindEnumType.recurring,
    recurrencyKind: RecurrencyKindEnumType.weekly,
    validFrom: t0,
    transactionId: 'tx-abc',
    chargingSchedule: [
      ChargingScheduleType(
        id: 1,
        chargingRateUnit: ChargingRateUnitEnumType.watts,
        chargingSchedulePeriod: [
          ChargingSchedulePeriodType(
              startPeriod: 0, limit: 7000, numberPhases: 1, phaseToUse: 2),
        ],
        salesTariff: SalesTariffType(id: 9, salesTariffEntry: [
          SalesTariffEntryType(
            relativeTimeInterval:
                RelativeTimeIntervalType(start: 0, duration: 100),
            ePriceLevel: 1,
            consumptionCost: [
              ConsumptionCostType(startValue: 0, cost: [
                CostType(
                    costKind: CostKindEnumType.relativePricePercentage,
                    amount: 50,
                    amountMultiplier: -1)
              ])
            ],
          )
        ]),
      ),
      ChargingScheduleType(
        id: 2,
        chargingRateUnit: ChargingRateUnitEnumType.watts,
        chargingSchedulePeriod: [
          ChargingSchedulePeriodType(startPeriod: 0, limit: 3000),
        ],
      ),
    ],
  );

  group('codec roundtrip v1.6', () {
    test('reservation', () {
      final r = ReserveNowReq.fromJson(wire(ReserveNowReq(
              connectorId: 1,
              expiryDate: t1,
              idTag: 'A',
              parentIdTag: 'P',
              reservationId: 7)
          .toJson()));
      expect(r.expiryDate, t1);
      expect(r.parentIdTag, 'P');
      expect(r.reservationId, 7);
      expect(
          ReserveNowConf.fromJson(wire(
                  ReserveNowConf(status: ReservationStatus.occupied).toJson()))
              .status,
          ReservationStatus.occupied);
      expect(
          CancelReservationReq.fromJson(
                  wire(CancelReservationReq(reservationId: 3).toJson()))
              .reservationId,
          3);
      expect(
          wire(CancelReservationConf(status: CancelReservationStatus.rejected)
              .toJson()),
          {'status': 'Rejected'});
    });

    test('smart charging', () {
      final json = wire(
          SetChargingProfileReq(connectorId: 1, csChargingProfiles: profile16)
              .toJson());
      expect(json['csChargingProfiles']['chargingProfilePurpose'], 'TxProfile');
      expect(json['csChargingProfiles']['chargingSchedule']['chargingRateUnit'],
          'A');
      final back = SetChargingProfileReq.fromJson(json);
      final p = back.csChargingProfiles;
      expect(p.transactionId, 42);
      expect(p.recurrencyKind, RecurrencyKind.daily);
      expect(p.chargingSchedule.minChargingRate, 6.5);
      expect(p.chargingSchedule.chargingSchedulePeriod[1].limit, 8.5);
      expect(p.chargingSchedule.chargingSchedulePeriod[0].numberPhases, 3);

      expect(
          ClearChargingProfileReq.fromJson(wire(ClearChargingProfileReq(
                      id: 1,
                      connectorId: 2,
                      chargingProfilePurpose:
                          ChargingProfilePurpose.txDefaultProfile,
                      stackLevel: 3)
                  .toJson()))
              .stackLevel,
          3);
      expect(wire(ClearChargingProfileReq().toJson()), isEmpty);
      expect(
          GetCompositeScheduleReq.fromJson(wire(GetCompositeScheduleReq(
                      connectorId: 1,
                      duration: 600,
                      chargingRateUnit: ChargingRateUnit.watts)
                  .toJson()))
              .chargingRateUnit,
          ChargingRateUnit.watts);
      final conf = GetCompositeScheduleConf.fromJson(wire(
          GetCompositeScheduleConf(
                  status: GetCompositeScheduleStatus.accepted,
                  connectorId: 1,
                  scheduleStart: t0,
                  chargingSchedule: profile16.chargingSchedule)
              .toJson()));
      expect(conf.chargingSchedule!.chargingSchedulePeriod, hasLength(2));
      expect(SetChargingProfileConf.fromJson({'status': 'NotSupported'}).status,
          ChargingProfileStatus.notSupported);
      expect(ClearChargingProfileConf.fromJson({'status': 'Unknown'}).status,
          ClearChargingProfileStatus.unknown);
    });

    test('local list', () {
      final req = SendLocalListReq.fromJson(wire(SendLocalListReq(
        listVersion: 4,
        updateType: UpdateType.differential,
        localAuthorizationList: [
          AuthorizationData(
              idTag: 'A',
              idTagInfo: IdTagInfo(
                  status: AuthorizationStatus.accepted,
                  expiryDate: t1,
                  parentIdTag: 'P')),
          AuthorizationData(idTag: 'GONE'),
        ],
      ).toJson()));
      expect(req.updateType, UpdateType.differential);
      expect(req.localAuthorizationList![0].idTagInfo!.parentIdTag, 'P');
      expect(req.localAuthorizationList![1].idTagInfo, isNull);
      expect(SendLocalListConf.fromJson({'status': 'VersionMismatch'}).status,
          UpdateStatus.versionMismatch);
      expect(wire(const GetLocalListVersionReq().toJson()), isEmpty);
      expect(GetLocalListVersionConf.fromJson({'listVersion': -1}).listVersion,
          -1);
    });
  });

  group('codec roundtrip v2.0.1', () {
    test('reservation', () {
      final r = ReserveNowRequest.fromJson(wire(ReserveNowRequest(
        id: 7,
        expiryDateTime: t1,
        connectorType: ConnectorEnumType.cCCS2,
        evseId: 2,
        idToken: IdTokenType(idToken: 'A', type: IdTokenEnumType.iso14443),
        groupIdToken: IdTokenType(idToken: 'G', type: IdTokenEnumType.central),
      ).toJson()));
      expect(r.connectorType, ConnectorEnumType.cCCS2);
      expect(r.groupIdToken!.idToken, 'G');
      final c = ReserveNowResponse.fromJson(wire(ReserveNowResponse(
              status: ReserveNowStatusEnumType.faulted,
              statusInfo: StatusInfoType(reasonCode: 'X'))
          .toJson()));
      expect(c.status, ReserveNowStatusEnumType.faulted);
      expect(c.statusInfo!.reasonCode, 'X');
      expect(
          CancelReservationRequest.fromJson(
                  wire(CancelReservationRequest(reservationId: 3).toJson()))
              .reservationId,
          3);
      expect(
          wire(CancelReservationResponse(
                  status: CancelReservationStatusEnumType.accepted)
              .toJson()),
          {'status': 'Accepted'});
      expect(
          ReserveNowRequest(
                  id: 1,
                  expiryDateTime: t0,
                  connectorType: ConnectorEnumType.s309_1P_16A,
                  idToken:
                      IdTokenType(idToken: 'a', type: IdTokenEnumType.local))
              .toJson()['connectorType'],
          's309-1P-16A');
    });

    test('smart charging', () {
      final json = wire(
          SetChargingProfileRequest(evseId: 1, chargingProfile: profile2)
              .toJson());
      final p = SetChargingProfileRequest.fromJson(json).chargingProfile;
      expect(p.transactionId, 'tx-abc');
      expect(p.recurrencyKind, RecurrencyKindEnumType.weekly);
      expect(p.chargingSchedule, hasLength(2));
      final s = p.chargingSchedule.first;
      expect(s.chargingSchedulePeriod.single.phaseToUse, 2);
      expect(
          s.salesTariff!.salesTariffEntry.single.consumptionCost!.single.cost
              .single.amountMultiplier,
          -1);

      expect(
          ClearChargingProfileRequest.fromJson(wire(ClearChargingProfileRequest(
                      chargingProfileId: 1,
                      chargingProfileCriteria: ClearChargingProfileType(
                          evseId: 1,
                          chargingProfilePurpose: ChargingProfilePurposeEnumType
                              .chargingStationExternalConstraints,
                          stackLevel: 0))
                  .toJson()))
              .chargingProfileCriteria!
              .chargingProfilePurpose,
          ChargingProfilePurposeEnumType.chargingStationExternalConstraints);
      final resp = GetCompositeScheduleResponse.fromJson(
          wire(GetCompositeScheduleResponse(
        status: GenericStatusEnumType.accepted,
        schedule: CompositeScheduleType(
            chargingSchedulePeriod: [
              ChargingSchedulePeriodType(startPeriod: 0, limit: 10)
            ],
            evseId: 1,
            duration: 600,
            scheduleStart: t0,
            chargingRateUnit: ChargingRateUnitEnumType.amperes),
      ).toJson()));
      expect(resp.schedule!.scheduleStart, t0);
      expect(
          GetCompositeScheduleRequest.fromJson(wire(
                  GetCompositeScheduleRequest(duration: 60, evseId: 0)
                      .toJson()))
              .evseId,
          0);
      expect(
          ChargingLimitType.fromJson(wire(ChargingLimitType(
                      chargingLimitSource: ChargingLimitSourceEnumType.so,
                      isGridCritical: true)
                  .toJson()))
              .chargingLimitSource,
          ChargingLimitSourceEnumType.so);
      expect(SetChargingProfileResponse.fromJson({'status': 'Rejected'}).status,
          ChargingProfileStatusEnumType.rejected);
      expect(
          ClearChargingProfileResponse.fromJson({'status': 'Unknown'}).status,
          ClearChargingProfileStatusEnumType.unknown);
    });

    test('local list', () {
      final req = SendLocalListRequest.fromJson(wire(SendLocalListRequest(
        versionNumber: 3,
        updateType: UpdateEnumType.full,
        localAuthorizationList: [
          AuthorizationDataType(
            idToken: IdTokenType(idToken: 'A', type: IdTokenEnumType.iso14443),
            idTokenInfo: IdTokenInfoType(
                status: AuthorizationStatusEnumType.noCredit,
                cacheExpiryDateTime: t1,
                language1: 'en'),
          ),
        ],
      ).toJson()));
      expect(req.updateType, UpdateEnumType.full);
      expect(req.localAuthorizationList!.single.idTokenInfo!.status,
          AuthorizationStatusEnumType.noCredit);
      expect(SendLocalListResponse.fromJson({'status': 'Failed'}).status,
          SendLocalListStatusEnumType.failed);
      expect(wire(const GetLocalListVersionRequest().toJson()), isEmpty);
      expect(
          GetLocalListVersionResponse.fromJson({'versionNumber': 0})
              .versionNumber,
          0);
    });
  });

  group('migration', () {
    test('reserveNow both directions', () {
      final req = ReserveNowReq(
          connectorId: 2,
          expiryDate: t1,
          idTag: 'A',
          parentIdTag: 'P',
          reservationId: 7);
      final v2r = V16ToV201Translator.reserveNow(req);
      expect(v2r.id, 7);
      expect(v2r.evseId, 2);
      expect(v2r.idToken.type, IdTokenEnumType.iso14443);
      expect(v2r.groupIdToken!.idToken, 'P');
      final any = V16ToV201Translator.reserveNow(ReserveNowReq(
          connectorId: 0, expiryDate: t1, idTag: 'A', reservationId: 1));
      expect(any.evseId, isNull);

      final back = V201ToV16Translator.reserveNow(v2r);
      expect(back.connectorId, 2);
      expect(back.parentIdTag, 'P');
      expect(V201ToV16Translator.reserveNow(any).connectorId, 0);

      expect(
          V16ToV201Translator.reserveNowResponse(
                  ReserveNowConf(status: ReservationStatus.unavailable))
              .status,
          ReserveNowStatusEnumType.unavailable);
      expect(
          V201ToV16Translator.reserveNowResponse(
                  ReserveNowResponse(status: ReserveNowStatusEnumType.faulted))
              .status,
          ReservationStatus.faulted);
    });

    test('cancelReservation both directions', () {
      expect(
          V16ToV201Translator.cancelReservation(
                  CancelReservationReq(reservationId: 4))
              .reservationId,
          4);
      expect(
          V201ToV16Translator.cancelReservation(
                  CancelReservationRequest(reservationId: 5))
              .reservationId,
          5);
      expect(
          V16ToV201Translator.cancelReservationResponse(CancelReservationConf(
                  status: CancelReservationStatus.rejected))
              .status,
          CancelReservationStatusEnumType.rejected);
      expect(
          V201ToV16Translator.cancelReservationResponse(
                  CancelReservationResponse(
                      status: CancelReservationStatusEnumType.accepted))
              .status,
          CancelReservationStatus.accepted);
    });

    test('setChargingProfile 1.6 -> 2.0.1', () {
      final r = V16ToV201Translator.setChargingProfile(
          SetChargingProfileReq(connectorId: 1, csChargingProfiles: profile16));
      expect(r.evseId, 1);
      expect(r.chargingProfile.id, 5);
      expect(r.chargingProfile.transactionId, '42');
      expect(r.chargingProfile.chargingProfileKind,
          ChargingProfileKindEnumType.recurring);
      expect(r.chargingProfile.chargingSchedule.single.id, 5);
      expect(r.chargingProfile.chargingSchedule.single.chargingRateUnit,
          ChargingRateUnitEnumType.amperes);
      expect(
          r.chargingProfile.chargingSchedule.single.chargingSchedulePeriod[0]
              .numberPhases,
          3);
      final maxp = V16ToV201Translator.chargingProfilePurpose(
          ChargingProfilePurpose.chargePointMaxProfile);
      expect(maxp, ChargingProfilePurposeEnumType.chargingStationMaxProfile);
      expect(
          V16ToV201Translator.setChargingProfileResponse(SetChargingProfileConf(
                  status: ChargingProfileStatus.notSupported))
              .status,
          ChargingProfileStatusEnumType.rejected);
    });

    test('setChargingProfile 2.0.1 -> 1.6 is lossy', () {
      final r = V201ToV16Translator.setChargingProfile(
          SetChargingProfileRequest(evseId: 0, chargingProfile: profile2));
      expect(r.connectorId, 0);
      // First schedule only; salesTariff gone; tx id non-numeric -> null.
      expect(
          r.csChargingProfiles.chargingSchedule.chargingSchedulePeriod.single
              .limit,
          7000);
      expect(r.csChargingProfiles.transactionId, isNull);
      expect(r.csChargingProfiles.recurrencyKind, RecurrencyKind.weekly);

      final numeric = V201ToV16Translator.chargingProfile(ChargingProfileType(
        id: 1,
        stackLevel: 0,
        chargingProfilePurpose:
            ChargingProfilePurposeEnumType.chargingStationMaxProfile,
        chargingProfileKind: ChargingProfileKindEnumType.absolute,
        transactionId: '77',
        chargingSchedule: profile2.chargingSchedule,
      ));
      expect(numeric.transactionId, 77);
      expect(numeric.chargingProfilePurpose,
          ChargingProfilePurpose.chargePointMaxProfile);

      expect(
          () => V201ToV16Translator.chargingProfilePurpose(
              ChargingProfilePurposeEnumType
                  .chargingStationExternalConstraints),
          throwsArgumentError);
      expect(
          V201ToV16Translator.setChargingProfileResponse(
                  SetChargingProfileResponse(
                      status: ChargingProfileStatusEnumType.accepted))
              .status,
          ChargingProfileStatus.accepted);
    });

    test('clearChargingProfile both directions', () {
      final r = V16ToV201Translator.clearChargingProfile(
          ClearChargingProfileReq(
              id: 3,
              connectorId: 1,
              chargingProfilePurpose: ChargingProfilePurpose.txProfile,
              stackLevel: 2));
      expect(r.chargingProfileId, 3);
      expect(r.chargingProfileCriteria!.evseId, 1);
      expect(r.chargingProfileCriteria!.stackLevel, 2);
      expect(
          V16ToV201Translator.clearChargingProfile(
                  ClearChargingProfileReq(id: 3))
              .chargingProfileCriteria,
          isNull);
      final back = V201ToV16Translator.clearChargingProfile(r);
      expect(back.connectorId, 1);
      expect(back.chargingProfilePurpose, ChargingProfilePurpose.txProfile);
      expect(
          () => V201ToV16Translator.clearChargingProfile(
              ClearChargingProfileRequest(
                  chargingProfileCriteria: ClearChargingProfileType(
                      chargingProfilePurpose: ChargingProfilePurposeEnumType
                          .chargingStationExternalConstraints))),
          throwsArgumentError);
      expect(
          V16ToV201Translator.clearChargingProfileResponse(
                  ClearChargingProfileConf(
                      status: ClearChargingProfileStatus.unknown))
              .status,
          ClearChargingProfileStatusEnumType.unknown);
      expect(
          V201ToV16Translator.clearChargingProfileResponse(
                  ClearChargingProfileResponse(
                      status: ClearChargingProfileStatusEnumType.accepted))
              .status,
          ClearChargingProfileStatus.accepted);
    });

    test('getCompositeSchedule both directions', () {
      final req = V16ToV201Translator.getCompositeSchedule(
          GetCompositeScheduleReq(
              connectorId: 2,
              duration: 900,
              chargingRateUnit: ChargingRateUnit.watts));
      expect(req.evseId, 2);
      expect(req.chargingRateUnit, ChargingRateUnitEnumType.watts);
      expect(V201ToV16Translator.getCompositeSchedule(req).connectorId, 2);

      final conf = GetCompositeScheduleConf(
          status: GetCompositeScheduleStatus.accepted,
          connectorId: 2,
          scheduleStart: t0,
          chargingSchedule: profile16.chargingSchedule);
      final v2resp = V16ToV201Translator.getCompositeScheduleResponse(conf);
      expect(v2resp.schedule!.evseId, 2);
      expect(v2resp.schedule!.duration, 3600);
      expect(v2resp.schedule!.chargingSchedulePeriod, hasLength(2));
      final back = V201ToV16Translator.getCompositeScheduleResponse(v2resp);
      expect(back.connectorId, 2);
      expect(back.scheduleStart, t0);
      expect(back.chargingSchedule!.chargingRateUnit, ChargingRateUnit.amperes);
      expect(
          () => V16ToV201Translator.getCompositeScheduleResponse(
              GetCompositeScheduleConf(
                  status: GetCompositeScheduleStatus.accepted,
                  chargingSchedule: profile16.chargingSchedule)),
          throwsArgumentError);
      expect(
          V16ToV201Translator.getCompositeScheduleResponse(
                  GetCompositeScheduleConf(
                      status: GetCompositeScheduleStatus.rejected))
              .schedule,
          isNull);
    });

    test('sendLocalList both directions', () {
      final req = SendLocalListReq(
        listVersion: 9,
        updateType: UpdateType.full,
        localAuthorizationList: [
          AuthorizationData(
              idTag: 'A',
              idTagInfo: IdTagInfo(
                  status: AuthorizationStatus.expired,
                  expiryDate: t1,
                  parentIdTag: 'P')),
          AuthorizationData(idTag: 'B'),
        ],
      );
      final v2r = V16ToV201Translator.sendLocalList(req);
      expect(v2r.versionNumber, 9);
      expect(v2r.updateType, UpdateEnumType.full);
      final a = v2r.localAuthorizationList![0];
      expect(a.idToken.idToken, 'A');
      expect(a.idTokenInfo!.status, AuthorizationStatusEnumType.expired);
      expect(a.idTokenInfo!.cacheExpiryDateTime, t1);
      expect(a.idTokenInfo!.groupIdToken!.idToken, 'P');
      expect(v2r.localAuthorizationList![1].idTokenInfo, isNull);

      final back = V201ToV16Translator.sendLocalList(v2r);
      expect(back.listVersion, 9);
      expect(back.localAuthorizationList![0].idTagInfo!.parentIdTag, 'P');

      final lossy = V201ToV16Translator.idTagInfo(IdTokenInfoType(
          status: AuthorizationStatusEnumType.notAtThisTime,
          chargingPriority: 3));
      expect(lossy.status, AuthorizationStatus.invalid);

      expect(
          V16ToV201Translator.sendLocalListResponse(
                  SendLocalListConf(status: UpdateStatus.notSupported))
              .status,
          SendLocalListStatusEnumType.failed);
      expect(
          V16ToV201Translator.sendLocalListResponse(
                  SendLocalListConf(status: UpdateStatus.versionMismatch))
              .status,
          SendLocalListStatusEnumType.versionMismatch);
      expect(
          V201ToV16Translator.sendLocalListResponse(SendLocalListResponse(
                  status: SendLocalListStatusEnumType.accepted))
              .status,
          UpdateStatus.accepted);
    });

    test('getLocalListVersion both directions', () {
      V16ToV201Translator.getLocalListVersion(const GetLocalListVersionReq());
      V201ToV16Translator.getLocalListVersion(
          const GetLocalListVersionRequest());
      expect(
          V16ToV201Translator.getLocalListVersionResponse(
                  GetLocalListVersionConf(listVersion: 12))
              .versionNumber,
          12);
      expect(
          V201ToV16Translator.getLocalListVersionResponse(
                  GetLocalListVersionResponse(versionNumber: 13))
              .listVersion,
          13);
    });
  });

  group('typed handlers', () {
    late _Transport transport;

    OcppClient make(OcppVersion v) {
      transport = _Transport();
      return OcppClient(
          url: 'ws://x', version: v, chargePointId: 'CP', transport: transport);
    }

    test('v2.0.1 handler answers and does not reach incoming', () async {
      final client = make(OcppVersion.v201);
      await client.connect();
      final raw = <OcppMessage>[];
      client.incoming.listen(raw.add);
      client.on<ReserveNowRequest>((req) async {
        expect(req.id, 11);
        return ReserveNowResponse(status: ReserveNowStatusEnumType.accepted);
      });
      transport.push(OcppCall(uniqueId: 'u1', action: 'ReserveNow', payload: {
        'id': 11,
        'expiryDateTime': t1.toIso8601String(),
        'idToken': {'idToken': 'A', 'type': 'ISO14443'},
      }));
      final reply = await transport.replies.first;
      expect(reply, isA<OcppCallResult>());
      expect(reply.uniqueId, 'u1');
      expect((reply as OcppCallResult).payload, {'status': 'Accepted'});
      expect(raw.whereType<OcppCall>(), isEmpty);
    });

    test('v1.6 handler, unmatched falls through, errors mapped', () async {
      final client = make(OcppVersion.v16);
      await client.connect();
      final raw = <OcppCall>[];
      client.incoming
          .where((m) => m is OcppCall)
          .cast<OcppCall>()
          .listen(raw.add);
      client.on<GetLocalListVersionReq>(
          (_) => GetLocalListVersionConf(listVersion: 5));
      client.on<CancelReservationReq>((_) => throw OcppCallException(
          const OcppCallError(
              uniqueId: 'x',
              errorCode: 'NotSupported',
              errorDescription: 'no')));
      client.on<SendLocalListReq>((_) => throw StateError('boom'));

      transport
          .push(const OcppCall(uniqueId: 'a', action: 'GetLocalListVersion'));
      transport.push(OcppCall(
          uniqueId: 'b',
          action: 'CancelReservation',
          payload: {'reservationId': 1}));
      transport.push(OcppCall(
          uniqueId: 'c',
          action: 'SendLocalList',
          payload: {'listVersion': 1, 'updateType': 'Full'}));
      transport.push(OcppCall(
          uniqueId: 'd', action: 'SetChargingProfile', payload: {'bad': 1}));
      transport.push(const OcppCall(uniqueId: 'e', action: 'Reset'));
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final byId = {for (final r in transport.sentReplies) r.uniqueId: r};
      expect((byId['a'] as OcppCallResult).payload, {'listVersion': 5});
      expect((byId['b'] as OcppCallError).errorCode, 'NotSupported');
      expect((byId['c'] as OcppCallError).errorCode, 'InternalError');
      expect(byId.containsKey('d'), isFalse); // no handler -> raw
      expect(byId.containsKey('e'), isFalse);
      expect(raw.map((c) => c.action), ['SetChargingProfile', 'Reset']);
    });

    test('malformed payload yields format violation', () async {
      final client = make(OcppVersion.v16);
      await client.connect();
      client.on<ReserveNowReq>(
          (_) => ReserveNowConf(status: ReservationStatus.accepted));
      transport.push(const OcppCall(
          uniqueId: 'm', action: 'ReserveNow', payload: {'x': 1}));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect((transport.sentReplies.single as OcppCallError).errorCode,
          'FormationViolation');
    });

    test('on<T> validates type and version; off removes', () async {
      final v16c = make(OcppVersion.v16);
      expect(() => v16c.on<ReserveNowRequest>((_) => throw 0),
          throwsArgumentError);
      expect(() => v16c.on<String>((_) => throw 0), throwsArgumentError);
      v16c.on<ReserveNowReq>(
          (_) => ReserveNowConf(status: ReservationStatus.accepted));
      v16c.off<ReserveNowReq>();
      await v16c.connect();
      final raw = <OcppCall>[];
      v16c.incoming
          .where((m) => m is OcppCall)
          .cast<OcppCall>()
          .listen(raw.add);
      transport
          .push(OcppCall(uniqueId: 'z', action: 'ReserveNow', payload: {}));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(raw, hasLength(1));
    });
  });
}

class _Transport implements OcppTransport {
  final _in = StreamController<String>.broadcast();
  final _replies = StreamController<OcppMessage>.broadcast();
  final sentReplies = <OcppMessage>[];
  bool _open = false;

  Stream<OcppMessage> get replies => _replies.stream;

  @override
  Stream<String> get frames => _in.stream;
  @override
  bool get isConnected => _open;
  @override
  Future<void> connect() async => _open = true;
  @override
  Future<void> close() async => _open = false;
  @override
  void send(String frame) {
    final m = const JsonOcppCodec().decode(frame);
    sentReplies.add(m);
    _replies.add(m);
  }

  void push(OcppMessage m) => _in.add(const JsonOcppCodec().encode(m));
}
