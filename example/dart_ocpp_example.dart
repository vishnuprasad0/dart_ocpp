// A minimal OCPP 2.0.1 charge point: connect, boot, report a connector as
// available, answer a Reset from the Central System, then heartbeat.
//
// Run with:  dart run example/dart_ocpp_example.dart
//
// Point `url` at your own Central System. The "/CP01" path segment is
// appended automatically for 1.6; for 2.0.1 give the full path.

import 'package:dart_ocpp/dart_ocpp.dart';

Future<void> main() async {
  final client = OcppClient(
    url: 'wss://cs.example.com/ocpp/CP01',
    version: OcppVersion.v201,
    chargePointId: 'CP01',
    // Reconnect with exponential backoff if the socket drops.
    reconnect: ReconnectPolicy(),
  );

  await client.connect();

  // 1. Boot. The Central System decides whether we may proceed.
  final boot = await client.sendBootNotification(vendor: 'Acme', model: 'X1');
  if (!boot.accepted) {
    print('Boot rejected; retry after ${boot.interval}s');
    await client.disconnect();
    return;
  }

  // 2. Tell the Central System connector 1 is free.
  await client.sendStatusNotification(
    connectorId: 1,
    status: ConnectorStatusEnumType.available,
  );

  // 3. Answer Central-System-initiated calls we care about. Anything we do
  //    not handle still arrives on `client.incoming` as a raw OcppCall.
  client.incoming.listen((msg) {
    if (msg is OcppCall && msg.action == 'Reset') {
      client.respond(msg.uniqueId, {'status': 'Accepted'});
    }
  });

  // 4. Keep the session alive. `sendHeartbeat` returns the CS clock, which is
  //    the usual way a charge point disciplines its own time.
  final centralSystemTime = await client.sendHeartbeat();
  print('Central System time: $centralSystemTime');

  await client.disconnect();
}
