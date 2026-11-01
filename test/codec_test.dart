import 'dart:convert';

import 'package:dart_ocpp/dart_ocpp.dart';
import 'package:test/test.dart';

void main() {
  const codec = JsonOcppCodec();

  test('CALL roundtrip', () {
    const call =
        OcppCall(uniqueId: 'abc', action: 'Heartbeat', payload: {'a': 1});
    final frame = codec.encode(call);
    expect(jsonDecode(frame), [
      2,
      'abc',
      'Heartbeat',
      {'a': 1}
    ]);
    final back = codec.decode(frame) as OcppCall;
    expect(back.uniqueId, 'abc');
    expect(back.action, 'Heartbeat');
    expect(back.payload, {'a': 1});
  });

  test('CALLRESULT roundtrip', () {
    const res = OcppCallResult(uniqueId: 'x', payload: {'status': 'Accepted'});
    final back = codec.decode(codec.encode(res)) as OcppCallResult;
    expect(back.uniqueId, 'x');
    expect(back.payload, {'status': 'Accepted'});
  });

  test('CALLERROR roundtrip', () {
    const err = OcppCallError(
        uniqueId: 'y',
        errorCode: 'NotImplemented',
        errorDescription: 'nope',
        errorDetails: {'k': 'v'});
    final back = codec.decode(codec.encode(err)) as OcppCallError;
    expect(back.errorCode, 'NotImplemented');
    expect(back.errorDescription, 'nope');
    expect(back.errorDetails, {'k': 'v'});
  });

  test('type codes are 2/3/4', () {
    expect(OcppMessageType.values.map((e) => e.code), [2, 3, 4]);
  });

  test('malformed frames are rejected', () {
    for (final bad in [
      'nope',
      '{}',
      '[2,"id"]',
      '[9,"id",{}]',
      '[2,1,"A",{}]'
    ]) {
      expect(() => codec.decode(bad), throwsA(isA<OcppFormatException>()),
          reason: bad);
    }
  });

  test('message JSON roundtrip (v1.6 + v2.0.1)', () {
    final req = BootNotificationReq(
        chargePointVendor: 'V', chargePointModel: 'M', firmwareVersion: '1');
    final j = BootNotificationReq.fromJson(
        jsonDecode(jsonEncode(req.toJson())) as Map<String, dynamic>);
    expect(j.chargePointModel, 'M');
    expect(req.toJson().containsKey('imsi'), isFalse);

    final r2 = BootNotificationRequest(
        reason: BootReasonEnumType.powerUp,
        chargingStation: ChargingStationType(model: 'M', vendorName: 'V'));
    expect(r2.toJson()['reason'], 'PowerUp');
    final t = IdTokenType(idToken: 'a', type: IdTokenEnumType.iso14443);
    expect(t.toJson()['type'], 'ISO14443');
  });
}
