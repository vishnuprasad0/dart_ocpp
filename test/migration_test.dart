import 'package:dart_ocpp/dart_ocpp.dart';
import 'package:test/test.dart';

void main() {
  final t0 = DateTime.utc(2026, 1, 1, 12);

  test('fromStartTransaction', () {
    final e = V16ToV201Translator.fromStartTransaction(
      StartTransactionReq(
          connectorId: 2, idTag: 'TAG', meterStart: 100, timestamp: t0),
      transactionId: 'tx-1',
    );
    expect(e.eventType, TransactionEventEnumType.started);
    expect(e.triggerReason, TriggerReasonEnumType.authorized);
    expect(e.transactionInfo.transactionId, 'tx-1');
    expect(e.evse!.connectorId, 2);
    expect(e.idToken!.idToken, 'TAG');
    expect(e.meterValue!.single.sampledValue.single.value, 100);
  });

  test('fromStopTransaction', () {
    final e = V16ToV201Translator.fromStopTransaction(StopTransactionReq(
        meterStop: 500, timestamp: t0, transactionId: 7, idTag: 'TAG'));
    expect(e.eventType, TransactionEventEnumType.ended);
    expect(e.triggerReason, TriggerReasonEnumType.evDeparted);
    expect(e.transactionInfo.transactionId, '7');
    expect(e.transactionInfo.stoppedReason, ReasonEnumType.evDisconnected);

    final remote = V16ToV201Translator.fromStopTransaction(StopTransactionReq(
        meterStop: 1, timestamp: t0, transactionId: 7, reason: Reason.remote));
    expect(remote.triggerReason, TriggerReasonEnumType.remoteStop);
    expect(remote.transactionInfo.stoppedReason, ReasonEnumType.remote);
  });

  test('fromMeterValues', () {
    final e = V16ToV201Translator.fromMeterValues(MeterValuesReq(
      connectorId: 1,
      transactionId: 9,
      meterValue: [
        MeterValue(timestamp: t0, sampledValue: [
          SampledValue(
              value: '12.5',
              measurand: 'Energy.Active.Import.Register',
              unit: 'kWh',
              context: ReadingContext.samplePeriodic)
        ])
      ],
    ));
    expect(e.eventType, TransactionEventEnumType.updated);
    expect(e.transactionInfo.transactionId, '9');
    final s = e.meterValue!.single.sampledValue.single;
    expect(s.value, 12.5);
    expect(s.unitOfMeasure!.unit, 'kWh');
    expect(s.context, ReadingContextEnumType.samplePeriodic);

    expect(
        () => V16ToV201Translator.fromMeterValues(
            MeterValuesReq(connectorId: 1, meterValue: [])),
        throwsArgumentError);
  });

  test('statusNotification maps every ChargePointStatus', () {
    final expected = {
      ChargePointStatus.available: ConnectorStatusEnumType.available,
      ChargePointStatus.preparing: ConnectorStatusEnumType.occupied,
      ChargePointStatus.charging: ConnectorStatusEnumType.occupied,
      ChargePointStatus.suspendedEVSE: ConnectorStatusEnumType.occupied,
      ChargePointStatus.suspendedEV: ConnectorStatusEnumType.occupied,
      ChargePointStatus.finishing: ConnectorStatusEnumType.occupied,
      ChargePointStatus.reserved: ConnectorStatusEnumType.reserved,
      ChargePointStatus.unavailable: ConnectorStatusEnumType.unavailable,
      ChargePointStatus.faulted: ConnectorStatusEnumType.faulted,
    };
    expect(expected.length, ChargePointStatus.values.length);
    expected.forEach((from, to) {
      final r = V16ToV201Translator.v201(StatusNotificationReq(
          connectorId: 3,
          errorCode: ChargePointErrorCode.noError,
          status: from,
          timestamp: t0));
      expect(r.connectorStatus, to);
      expect(r.connectorId, 3);
      expect(r.timestamp, t0);
    });
  });

  test('reverse translators', () {
    final start = V16ToV201Translator.fromStartTransaction(
        StartTransactionReq(
            connectorId: 1, idTag: 'T', meterStart: 42, timestamp: t0),
        transactionId: '5');
    final back = V201ToV16Translator.startTransaction(start);
    expect(back.idTag, 'T');
    expect(back.meterStart, 42);

    final stop = V16ToV201Translator.fromStopTransaction(
        StopTransactionReq(meterStop: 99, timestamp: t0, transactionId: 5));
    final stopBack =
        V201ToV16Translator.stopTransaction(stop, transactionId: 5);
    expect(stopBack.meterStop, 99);
    expect(stopBack.reason, Reason.evDisconnected);

    final st = V201ToV16Translator.statusNotification(
        StatusNotificationRequest(
            timestamp: t0,
            connectorStatus: ConnectorStatusEnumType.occupied,
            evseId: 1,
            connectorId: 1),
        occupiedAs: ChargePointStatus.charging);
    expect(st.status, ChargePointStatus.charging);
    expect(
        V201ToV16Translator.authorizationStatus(
            AuthorizationStatusEnumType.noCredit),
        AuthorizationStatus.invalid);
  });
}
