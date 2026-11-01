import 'dart:async';

import 'package:uuid/uuid.dart';

import '../core/ocpp_codec.dart';
import '../core/ocpp_message.dart';
import '../core/ocpp_transport.dart';
import '../core/ocpp_version.dart';
import '../migration/v201_to_v16.dart';
import 'typed_requests.dart';
import '../v16/messages.dart' as v16;
import '../v201/messages.dart' as v2;

/// Version-neutral BootNotification result.
class BootNotificationResult {
  const BootNotificationResult(
      {required this.accepted,
      required this.status,
      required this.currentTime,
      required this.interval});

  /// True when the Central System answered `Accepted`.
  final bool accepted;

  /// Raw status string (`Accepted`, `Pending`, `Rejected`).
  final String status;
  final DateTime currentTime;

  /// Heartbeat interval (seconds) when accepted; retry interval otherwise.
  final int interval;
}

/// Version-neutral Authorize result.
class AuthorizeResult {
  const AuthorizeResult({required this.accepted, required this.status});
  final bool accepted;

  /// Raw status string from the Central System.
  final String status;
}

/// Version-neutral DataTransfer result.
class DataTransferResult {
  const DataTransferResult({required this.status, this.data});
  final String status;
  final Object? data;
}

/// High-level OCPP charge point client.
///
/// Wraps a transport + codec, correlates requests with responses and exposes
/// convenience methods for the common messages. The same method names work
/// for [OcppVersion.v16] and [OcppVersion.v201]; payloads are built for the
/// configured version. Use [call] for anything not covered.
///
/// Note on [url]: if its path does not already end with [chargePointId], the
/// id is appended as a path segment (the OCPP-J convention).
class OcppClient {
  OcppClient({
    required String url,
    required this.version,
    required this.chargePointId,
    OcppTransport? transport,
    OcppCodec codec = const JsonOcppCodec(),
    this.callTimeout = const Duration(seconds: 30),
    ReconnectPolicy? reconnect,
    Duration? pingInterval = const Duration(seconds: 30),
  })  : _codec = codec,
        _transport = transport ??
            WebSocketOcppTransport(
              uri: _resolveUri(url, chargePointId),
              version: version,
              reconnect: reconnect,
              pingInterval: pingInterval,
            );

  /// Protocol version used for payloads and subprotocol negotiation.
  final OcppVersion version;

  /// Charge point identity.
  final String chargePointId;

  /// How long [call] waits for a response before failing with
  /// [TimeoutException].
  final Duration callTimeout;

  final OcppTransport _transport;
  final OcppCodec _codec;
  final _uuid = const Uuid();
  final _pending = <String, ({String action, Completer<OcppCallResult> c})>{};
  final _incoming = StreamController<OcppMessage>.broadcast();
  final _handlers = <String, _Handler>{};
  StreamSubscription<String>? _sub;

  static Uri _resolveUri(String url, String id) {
    final u = Uri.parse(url);
    if (u.pathSegments.isNotEmpty && u.pathSegments.last == id) return u;
    final segs = [...u.pathSegments.where((s) => s.isNotEmpty), id];
    return u.replace(pathSegments: segs);
  }

  /// Every decoded inbound frame: requests from the Central System (as
  /// [OcppCall], answer them with [respond]/[respondError]) and responses
  /// (also delivered to the matching [call] future). Malformed frames are
  /// delivered as stream errors.
  Stream<OcppMessage> get incoming => _incoming.stream;

  /// Whether the transport is open.
  bool get isConnected => _transport.isConnected;

  /// Opens the connection.
  Future<void> connect() async {
    _sub ??= _transport.frames.listen(_onFrame);
    await _transport.connect();
  }

  /// Closes the connection and fails outstanding calls.
  Future<void> disconnect() async {
    await _transport.close();
    await _sub?.cancel();
    _sub = null;
    for (final p in _pending.values) {
      if (!p.c.isCompleted) p.c.completeError(StateError('Disconnected'));
    }
    _pending.clear();
  }

  void _onFrame(String frame) {
    final OcppMessage msg;
    try {
      msg = _codec.decode(frame);
    } on OcppFormatException catch (e) {
      _incoming.addError(e);
      return;
    }
    switch (msg) {
      case OcppCallResult():
        final p = _pending.remove(msg.uniqueId);
        p?.c.complete(OcppCallResult(
            uniqueId: msg.uniqueId, payload: msg.payload, action: p.action));
      case OcppCallError():
        _pending.remove(msg.uniqueId)?.c.completeError(OcppCallException(msg));
      case OcppCall():
        final h = _handlers[msg.action];
        if (h != null) {
          _dispatch(msg, h);
          return;
        }
    }
    _incoming.add(msg);
  }

  /// Registers a typed handler for a Central-System-initiated request, e.g.
  /// `client.on<ReserveNowRequest>((req) async => ReserveNowResponse(...))`.
  ///
  /// [T] must be one of the supported request types of the client's
  /// protocol version (see the README matrix). The handler's return value
  /// must be the matching response object (anything with `toJson()`). To
  /// answer with a CALLERROR throw an [OcppCallException]; any other
  /// exception becomes an `InternalError`. A payload that fails to decode is
  /// answered with a format-violation error. Calls for actions without a
  /// handler still arrive on [incoming] as raw [OcppCall]s; handled calls do
  /// not. Registering a second handler for the same action replaces the first.
  void on<T extends Object>(FutureOr<Object> Function(T request) handler) {
    final spec = typedRequestSpecs[T];
    if (spec == null) {
      throw ArgumentError('$T is not a supported typed request');
    }
    if (spec.version != version) {
      throw ArgumentError(
          '$T is an ${spec.version.name} type but this client uses '
          '${version.name}');
    }
    _handlers[spec.action] =
        _Handler(spec.decode, (Object r) async => await handler(r as T));
  }

  /// Removes the typed handler for [T], if any.
  void off<T extends Object>() {
    final spec = typedRequestSpecs[T];
    if (spec != null) _handlers.remove(spec.action);
  }

  Future<void> _dispatch(OcppCall call, _Handler h) async {
    final Object request;
    try {
      request = h.decode(call.payload);
    } catch (e) {
      _safeSend(() => respondError(call.uniqueId,
          _is16 ? 'FormationViolation' : 'FormatViolation', '$e'));
      return;
    }
    try {
      final response = await h.handle(request);
      final json = (response as dynamic).toJson();
      _safeSend(() => respond(call.uniqueId, json as Map<String, dynamic>));
    } on OcppCallException catch (e) {
      _safeSend(() => respondError(
          call.uniqueId, e.error.errorCode, e.error.errorDescription));
    } catch (e) {
      _safeSend(() => respondError(call.uniqueId, 'InternalError', '$e'));
    }
  }

  // The transport may have closed while a handler was running.
  void _safeSend(void Function() send) {
    try {
      send();
    } catch (_) {}
  }

  /// Sends a raw CALL and waits for the CALLRESULT. Throws
  /// [OcppCallException] on CALLERROR and [TimeoutException] on timeout.
  Future<OcppCallResult> call(String action, Map<String, dynamic> payload) {
    final id = _uuid.v4();
    final completer = Completer<OcppCallResult>();
    _pending[id] = (action: action, c: completer);
    try {
      _transport.send(_codec
          .encode(OcppCall(uniqueId: id, action: action, payload: payload)));
    } catch (e) {
      _pending.remove(id);
      return Future.error(e);
    }
    return completer.future.timeout(callTimeout, onTimeout: () {
      _pending.remove(id);
      throw TimeoutException('No response to $action', callTimeout);
    });
  }

  /// Answers an inbound call with a result.
  void respond(String uniqueId, Map<String, dynamic> payload) =>
      _transport.send(
          _codec.encode(OcppCallResult(uniqueId: uniqueId, payload: payload)));

  /// Answers an inbound call with an error (e.g. `NotImplemented`).
  void respondError(String uniqueId, String code, [String description = '']) =>
      _transport.send(_codec.encode(OcppCallError(
          uniqueId: uniqueId, errorCode: code, errorDescription: description)));

  bool get _is16 => version == OcppVersion.v16;

  // ---------------------------------------------------------------- helpers

  /// BootNotification. For v2.0.1, [reason] defaults to `PowerUp`.
  Future<BootNotificationResult> sendBootNotification({
    required String vendor,
    required String model,
    String? serialNumber,
    String? firmwareVersion,
    String? iccid,
    String? imsi,
    v2.BootReasonEnumType reason = v2.BootReasonEnumType.powerUp,
  }) async {
    if (_is16) {
      final res = await call(
          'BootNotification',
          v16.BootNotificationReq(
            chargePointVendor: vendor,
            chargePointModel: model,
            chargePointSerialNumber: serialNumber,
            firmwareVersion: firmwareVersion,
            iccid: iccid,
            imsi: imsi,
          ).toJson());
      final c = v16.BootNotificationConf.fromJson(res.payload);
      return BootNotificationResult(
          accepted: c.status == v16.RegistrationStatus.accepted,
          status: c.status.name[0].toUpperCase() + c.status.name.substring(1),
          currentTime: c.currentTime,
          interval: c.interval);
    }
    final res = await call(
        'BootNotification',
        v2.BootNotificationRequest(
          reason: reason,
          chargingStation: v2.ChargingStationType(
            model: model,
            vendorName: vendor,
            serialNumber: serialNumber,
            firmwareVersion: firmwareVersion,
            modem: (iccid != null || imsi != null)
                ? v2.ModemType(iccid: iccid, imsi: imsi)
                : null,
          ),
        ).toJson());
    final c = v2.BootNotificationResponse.fromJson(res.payload);
    return BootNotificationResult(
        accepted: c.status == v2.RegistrationStatusEnumType.accepted,
        status: c.status.name[0].toUpperCase() + c.status.name.substring(1),
        currentTime: c.currentTime,
        interval: c.interval);
  }

  /// Heartbeat; returns the Central System time.
  Future<DateTime> sendHeartbeat() async {
    final res = await call('Heartbeat', const <String, dynamic>{});
    return _is16
        ? v16.HeartbeatConf.fromJson(res.payload).currentTime
        : v2.HeartbeatResponse.fromJson(res.payload).currentTime;
  }

  /// Authorize an RFID/idToken. [tokenType] is only used on v2.0.1.
  Future<AuthorizeResult> sendAuthorize(String idToken,
      {v2.IdTokenEnumType tokenType = v2.IdTokenEnumType.iso14443}) async {
    if (_is16) {
      final res =
          await call('Authorize', v16.AuthorizeReq(idTag: idToken).toJson());
      final s = v16.AuthorizeConf.fromJson(res.payload).idTagInfo.status;
      return AuthorizeResult(
          accepted: s == v16.AuthorizationStatus.accepted,
          status: _cap(s.name));
    }
    final res = await call(
        'Authorize',
        v2.AuthorizeRequest(
                idToken: v2.IdTokenType(idToken: idToken, type: tokenType))
            .toJson());
    final s = v2.AuthorizeResponse.fromJson(res.payload).idTokenInfo.status;
    return AuthorizeResult(
        accepted: s == v2.AuthorizationStatusEnumType.accepted,
        status: _cap(s.name));
  }

  /// StatusNotification using the v2.0.1 [v2.ConnectorStatusEnumType]; on
  /// v1.6 it is mapped through [V201ToV16Translator.statusNotification].
  Future<void> sendStatusNotification({
    required int connectorId,
    int evseId = 1,
    required v2.ConnectorStatusEnumType status,
    DateTime? timestamp,
  }) async {
    final req = v2.StatusNotificationRequest(
      timestamp: timestamp ?? DateTime.now().toUtc(),
      connectorStatus: status,
      evseId: evseId,
      connectorId: connectorId,
    );
    await call(
        'StatusNotification',
        _is16
            ? V201ToV16Translator.statusNotification(req).toJson()
            : req.toJson());
  }

  /// DataTransfer. [data] is a String on v1.6 (non-strings are
  /// stringified) and arbitrary JSON on v2.0.1.
  Future<DataTransferResult> sendDataTransfer({
    required String vendorId,
    String? messageId,
    Object? data,
  }) async {
    if (_is16) {
      final res = await call(
          'DataTransfer',
          v16.DataTransferReq(
                  vendorId: vendorId,
                  messageId: messageId,
                  data: data?.toString())
              .toJson());
      final c = v16.DataTransferConf.fromJson(res.payload);
      return DataTransferResult(status: _cap(c.status.name), data: c.data);
    }
    final res = await call(
        'DataTransfer',
        v2.DataTransferRequest(
                vendorId: vendorId, messageId: messageId, data: data)
            .toJson());
    final c = v2.DataTransferResponse.fromJson(res.payload);
    return DataTransferResult(status: _cap(c.status.name), data: c.data);
  }

  /// v1.6 `StartTransaction` (returns the CS-assigned transaction id).
  /// Throws [UnsupportedError] on v2.0.1 - use [sendTransactionEvent].
  Future<v16.StartTransactionConf> sendStartTransaction(
      v16.StartTransactionReq req) async {
    _require16('StartTransaction');
    final res = await call('StartTransaction', req.toJson());
    return v16.StartTransactionConf.fromJson(res.payload);
  }

  /// v1.6 `StopTransaction`. Throws [UnsupportedError] on v2.0.1.
  Future<v16.StopTransactionConf> sendStopTransaction(
      v16.StopTransactionReq req) async {
    _require16('StopTransaction');
    final res = await call('StopTransaction', req.toJson());
    return v16.StopTransactionConf.fromJson(res.payload);
  }

  /// v1.6 `MeterValues`. Throws [UnsupportedError] on v2.0.1.
  Future<void> sendMeterValues(v16.MeterValuesReq req) async {
    _require16('MeterValues');
    await call('MeterValues', req.toJson());
  }

  /// v2.0.1 `TransactionEvent`. Throws [UnsupportedError] on v1.6.
  Future<v2.TransactionEventResponse> sendTransactionEvent(
      v2.TransactionEventRequest req) async {
    if (_is16) {
      throw UnsupportedError(
          'TransactionEvent is OCPP 2.0.1 only; use sendStartTransaction / '
          'sendStopTransaction / sendMeterValues on 1.6');
    }
    final res = await call('TransactionEvent', req.toJson());
    return v2.TransactionEventResponse.fromJson(res.payload);
  }

  /// FirmwareStatusNotification; [status] is the wire string
  /// (e.g. `Installed`), valid for the configured version.
  Future<void> sendFirmwareStatusNotification(String status,
      {int? requestId}) async {
    await call('FirmwareStatusNotification', {
      'status': status,
      if (!_is16 && requestId != null) 'requestId': requestId,
    });
  }

  /// v1.6 `DiagnosticsStatusNotification`. Throws on v2.0.1.
  Future<void> sendDiagnosticsStatusNotification(
      v16.DiagnosticsStatus status) async {
    _require16('DiagnosticsStatusNotification');
    await call('DiagnosticsStatusNotification',
        v16.DiagnosticsStatusNotificationReq(status: status).toJson());
  }

  /// v2.0.1 `LogStatusNotification`. Throws on v1.6.
  Future<void> sendLogStatusNotification(v2.UploadLogStatusEnumType status,
      {int? requestId}) async {
    if (_is16) {
      throw UnsupportedError('LogStatusNotification is OCPP 2.0.1 only');
    }
    await call(
        'LogStatusNotification',
        v2.LogStatusNotificationRequest(status: status, requestId: requestId)
            .toJson());
  }

  void _require16(String what) {
    if (!_is16) {
      throw UnsupportedError('$what is OCPP 1.6 only; use TransactionEvent');
    }
  }

  static String _cap(String s) => s[0].toUpperCase() + s.substring(1);
}

class _Handler {
  _Handler(this.decode, this.handle);
  final Object Function(Map<String, dynamic>) decode;
  final Future<Object> Function(Object) handle;
}
