# dart_ocpp

OCPP 1.6-J and 2.0.1 client over WebSocket, with typed message models and
1.6 -> 2.0.1 migration helpers.

## Install

```yaml
dependencies:
  dart_ocpp:
    path: ../dart_ocpp   # not yet published (publish_to: none)
```

## Quickstart: OCPP 2.0.1

```dart
import 'package:dart_ocpp/dart_ocpp.dart';

final client = OcppClient(
  url: 'wss://cs.example.com/ocpp/CP01',
  version: OcppVersion.v201,
  chargePointId: 'CP01',
);
await client.connect();
final boot = await client.sendBootNotification(vendor: 'Acme', model: 'X1');
if (boot.accepted) {
  await client.sendStatusNotification(
      connectorId: 1, status: ConnectorStatusEnumType.available);
}
client.incoming.listen((msg) {
  if (msg is OcppCall && msg.action == 'Reset') {
    client.respond(msg.uniqueId, {'status': 'Accepted'});
  }
});
```

## Quickstart: OCPP 1.6-J

```dart
final client = OcppClient(
  url: 'wss://cs.example.com/ocpp',   // "/CP01" is appended automatically
  version: OcppVersion.v16,
  chargePointId: 'CP01',
);
await client.connect();
await client.sendBootNotification(vendor: 'Acme', model: 'X1');
final tx = await client.sendStartTransaction(StartTransactionReq(
    connectorId: 1,
    idTag: 'TAG',
    meterStart: 0,
    timestamp: DateTime.now().toUtc()));
print(tx.transactionId);
```

The same convenience methods (`sendBootNotification`, `sendHeartbeat`,
`sendAuthorize`, `sendStatusNotification`, `sendDataTransfer`) work on both
versions and return version-neutral results. Version-specific messages
(`sendStartTransaction`/`sendStopTransaction`/`sendMeterValues` for 1.6,
`sendTransactionEvent` for 2.0.1) throw `UnsupportedError` on the wrong
version. `client.call(action, payload)` sends any other message.

Connection features: subprotocol negotiation (`ocpp1.6` / `ocpp2.0.1`),
WebSocket ping heartbeat (`pingInterval`, default 30 s), optional
exponential-backoff reconnect (`reconnect: ReconnectPolicy()`), request
timeout (`callTimeout`, default 30 s). Provide your own `OcppTransport` for
testing.

## Migration note

`V16ToV201Translator` and `V201ToV16Translator` convert messages between
versions. Conversions are lossy; see [MIGRATION.md](MIGRATION.md).

```dart
final event = V16ToV201Translator.fromStartTransaction(req, transactionId: 'tx-1');
```

## Supported messages (Charge Point -> Central System)

| Message | OCPP 1.6 | OCPP 2.0.1 |
|---------|----------|------------|
| BootNotification | `BootNotificationReq/Conf` | `BootNotificationRequest/Response` |
| Authorize | `AuthorizeReq/Conf` | `AuthorizeRequest/Response` |
| Heartbeat | `HeartbeatReq/Conf` | `HeartbeatRequest/Response` |
| StartTransaction | `StartTransactionReq/Conf` | (TransactionEvent) |
| StopTransaction | `StopTransactionReq/Conf` | (TransactionEvent) |
| MeterValues | `MeterValuesReq/Conf` | (TransactionEvent) |
| TransactionEvent | - | `TransactionEventRequest/Response` |
| StatusNotification | `StatusNotificationReq/Conf` | `StatusNotificationRequest/Response` |
| DataTransfer | `DataTransferReq/Conf` | `DataTransferRequest/Response` |
| FirmwareStatusNotification | `FirmwareStatusNotificationReq/Conf` | `FirmwareStatusNotificationRequest/Response` |
| DiagnosticsStatusNotification | `DiagnosticsStatusNotificationReq/Conf` | - |
| LogStatusNotification | - | `LogStatusNotificationRequest/Response` |

## Supported messages (Central System -> Charge Point)

Register a typed handler with `client.on<T>(...)`; the handler returns the
matching response object. Calls without a handler still arrive on
`client.incoming` as raw `OcppCall`s.

| Message | OCPP 1.6 | OCPP 2.0.1 |
|---------|----------|------------|
| ReserveNow | `ReserveNowReq/Conf` | `ReserveNowRequest/Response` |
| CancelReservation | `CancelReservationReq/Conf` | `CancelReservationRequest/Response` |
| SetChargingProfile | `SetChargingProfileReq/Conf` | `SetChargingProfileRequest/Response` |
| ClearChargingProfile | `ClearChargingProfileReq/Conf` | `ClearChargingProfileRequest/Response` |
| GetCompositeSchedule | `GetCompositeScheduleReq/Conf` | `GetCompositeScheduleRequest/Response` |
| SendLocalList | `SendLocalListReq/Conf` | `SendLocalListRequest/Response` |
| GetLocalListVersion | `GetLocalListVersionReq/Conf` | `GetLocalListVersionRequest/Response` |

```dart
final client = OcppClient(
    url: url, version: OcppVersion.v201, chargePointId: 'CP01');
client.on<ReserveNowRequest>((req) async =>
    ReserveNowResponse(status: ReserveNowStatusEnumType.accepted));
// v1.6: client.on<ReserveNowReq>((req) =>
//     ReserveNowConf(status: ReservationStatus.accepted));
```

Throw an `OcppCallException` from a handler to send a specific CALLERROR; any
other exception is answered with `InternalError`.

## Design notes and assumptions

* Messages are `json_serializable` classes; null optional fields are omitted
  from JSON. Regenerate with
  `dart run build_runner build --delete-conflicting-outputs`.
* v1.6 types use `Req`/`Conf` suffixes, v2.0.1 types `Request`/`Response`;
  v2.0.1 enums end in `EnumType`. `TransactionEventReq` is an alias.
* `SampledValue.measurand/phase/unit` are plain strings (large,
  vendor-extensible enumerations).
* Central-System-initiated messages other than the seven above (Reset,
  RemoteStartTransaction, ...) arrive as raw `OcppCall` on `client.incoming`.
* Where v1.6 and v2.0.1 spec names collide, the 2.0.1 class gets a `Type`
  suffix (`AuthorizationDataType`).
* No JSON-schema validation of payloads is performed.
* `json_serializable` is capped below 6.10 in dev_dependencies because newer
  releases did not compile against the analyzer pub resolved on Dart 3.10.

## Not yet covered

Planned for 0.3.0 and later:

* ISO 15118 Plug and Charge (certificates, Get15118EVCertificate, ...)
* A server-side (Central System) API and CSMS-side send helpers
* Remaining Central-System-initiated commands: Reset, RemoteStart/Stop,
  ChangeConfiguration, TriggerMessage, UnlockConnector, firmware update/log
  upload
* State handling: the library models and routes reservation, charging
  profile and local list messages but does not store or enforce them
* 2.0.1 charging-profile reporting (GetChargingProfiles,
  ReportChargingProfiles, NotifyChargingLimit, ClearedChargingLimit)
* Security profiles (basic auth / mTLS helpers)
* 2.0.1 device model (GetVariables/SetVariables/NotifyReport)

## License

MIT
