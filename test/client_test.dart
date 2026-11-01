import 'dart:async';
import 'dart:io';

import 'package:dart_ocpp/dart_ocpp.dart';
import 'package:test/test.dart';

/// In-memory transport that plays the Central System.
class FakeCentralSystemTransport implements OcppTransport {
  FakeCentralSystemTransport(this.respond);

  /// Builds the CALLRESULT payload for a received CALL.
  final Map<String, dynamic> Function(OcppCall) respond;
  final _in = StreamController<String>.broadcast();
  final sent = <OcppCall>[];
  bool _open = false;

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
    final msg = const JsonOcppCodec().decode(frame);
    if (msg is! OcppCall) return;
    sent.add(msg);
    scheduleMicrotask(() => _in.add(const JsonOcppCodec().encode(
        OcppCallResult(uniqueId: msg.uniqueId, payload: respond(msg)))));
  }

  void push(OcppMessage m) => _in.add(const JsonOcppCodec().encode(m));
}

void main() {
  const now = '2026-01-01T12:00:00.000Z';

  test('v1.6 BootNotification handshake', () async {
    final t = FakeCentralSystemTransport((c) {
      expect(c.action, 'BootNotification');
      expect(c.payload['chargePointVendor'], 'Acme');
      return {'status': 'Accepted', 'currentTime': now, 'interval': 300};
    });
    final client = OcppClient(
        url: 'wss://cs.example.com/ocpp/CP01',
        version: OcppVersion.v16,
        chargePointId: 'CP01',
        transport: t);
    await client.connect();
    final r = await client.sendBootNotification(vendor: 'Acme', model: 'X1');
    expect(r.accepted, isTrue);
    expect(r.status, 'Accepted');
    expect(r.interval, 300);
    await client.disconnect();
  });

  test('v2.0.1 BootNotification handshake', () async {
    final t = FakeCentralSystemTransport((c) {
      expect(c.payload['reason'], 'PowerUp');
      expect(
          c.payload['chargingStation'], {'model': 'X1', 'vendorName': 'Acme'});
      return {'status': 'Pending', 'currentTime': now, 'interval': 60};
    });
    final client = OcppClient(
        url: 'wss://cs.example.com/ocpp',
        version: OcppVersion.v201,
        chargePointId: 'CP01',
        transport: t);
    await client.connect();
    final r = await client.sendBootNotification(vendor: 'Acme', model: 'X1');
    expect(r.accepted, isFalse);
    expect(r.status, 'Pending');
    expect(r.interval, 60);
    await client.disconnect();
  });

  test('inbound calls reach the incoming stream; version gating', () async {
    final t = FakeCentralSystemTransport((c) => {});
    final client = OcppClient(
        url: 'ws://x/CP01',
        version: OcppVersion.v16,
        chargePointId: 'CP01',
        transport: t);
    await client.connect();
    final inbound =
        client.incoming.where((m) => m is OcppCall).cast<OcppCall>().first;
    t.push(const OcppCall(
        uniqueId: 'srv1', action: 'Reset', payload: {'type': 'Soft'}));
    expect((await inbound).action, 'Reset');
    expect(
        () => client.sendTransactionEvent(TransactionEventRequest(
            eventType: TransactionEventEnumType.started,
            timestamp: DateTime.utc(2026),
            triggerReason: TriggerReasonEnumType.authorized,
            seqNo: 0,
            transactionInfo: TransactionType(transactionId: '1'))),
        throwsUnsupportedError);
    await client.disconnect();
  });

  test('WebSocket transport negotiates subprotocol (loopback server)',
      () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));
    String? offered;
    server.listen((req) async {
      offered = req.headers.value('sec-websocket-protocol');
      final ws = await WebSocketTransformer.upgrade(req,
          protocolSelector: (p) => p.first);
      ws.listen((data) {
        final call = const JsonOcppCodec().decode(data as String) as OcppCall;
        ws.add(const JsonOcppCodec().encode(OcppCallResult(
            uniqueId: call.uniqueId,
            payload: {
              'status': 'Accepted',
              'currentTime': now,
              'interval': 10
            })));
      });
    });
    for (final v in OcppVersion.values) {
      final client = OcppClient(
          url: 'ws://127.0.0.1:${server.port}/ocpp',
          version: v,
          chargePointId: 'CP01');
      await client.connect();
      final r = await client.sendBootNotification(vendor: 'A', model: 'B');
      expect(r.accepted, isTrue);
      expect(offered, v.subprotocol);
      await client.disconnect();
    }
  });
}
