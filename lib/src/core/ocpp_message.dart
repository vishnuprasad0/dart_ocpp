/// OCPP-J message type identifiers (first element of the frame array).
enum OcppMessageType {
  /// A request: `[2, uniqueId, action, payload]`.
  call(2),

  /// A successful response: `[3, uniqueId, payload]`.
  callResult(3),

  /// An error response: `[4, uniqueId, errorCode, errorDescription, details]`.
  callError(4);

  const OcppMessageType(this.code);

  /// Integer code used on the wire.
  final int code;

  /// Resolves a wire code, or `null` when unknown.
  static OcppMessageType? fromCode(Object? code) {
    for (final t in values) {
      if (t.code == code) return t;
    }
    return null;
  }
}

/// Base type for the three OCPP-J frame kinds.
sealed class OcppMessage {
  const OcppMessage(this.uniqueId);

  /// Correlates a response with its request (max 36 chars per the spec).
  final String uniqueId;

  /// The frame kind.
  OcppMessageType get type;
}

/// A request sent by either party.
final class OcppCall extends OcppMessage {
  const OcppCall({
    required String uniqueId,
    required this.action,
    this.payload = const {},
  }) : super(uniqueId);

  /// Action name, e.g. `BootNotification`.
  final String action;

  /// JSON payload.
  final Map<String, dynamic> payload;

  @override
  OcppMessageType get type => OcppMessageType.call;

  @override
  String toString() => 'OcppCall($uniqueId, $action, $payload)';
}

/// A successful response to an [OcppCall].
final class OcppCallResult extends OcppMessage {
  const OcppCallResult({
    required String uniqueId,
    this.payload = const {},
    this.action,
  }) : super(uniqueId);

  /// JSON payload.
  final Map<String, dynamic> payload;

  /// The action of the originating call. The wire format does not carry it;
  /// it is filled in locally by the client when known.
  final String? action;

  @override
  OcppMessageType get type => OcppMessageType.callResult;

  @override
  String toString() => 'OcppCallResult($uniqueId, $payload)';
}

/// An error response to an [OcppCall].
final class OcppCallError extends OcppMessage {
  const OcppCallError({
    required String uniqueId,
    required this.errorCode,
    this.errorDescription = '',
    this.errorDetails = const {},
  }) : super(uniqueId);

  /// One of the OCPP-J error codes (e.g. `NotImplemented`, `InternalError`).
  final String errorCode;

  /// Human readable description.
  final String errorDescription;

  /// Free-form details object.
  final Map<String, dynamic> errorDetails;

  @override
  OcppMessageType get type => OcppMessageType.callError;

  @override
  String toString() =>
      'OcppCallError($uniqueId, $errorCode, $errorDescription)';
}

/// Thrown by the codec when a frame is not valid OCPP-J.
class OcppFormatException implements Exception {
  OcppFormatException(this.message);
  final String message;
  @override
  String toString() => 'OcppFormatException: $message';
}

/// Thrown by the client when the peer answers a call with a CALLERROR.
class OcppCallException implements Exception {
  OcppCallException(this.error);
  final OcppCallError error;
  @override
  String toString() =>
      'OcppCallException(${error.errorCode}: ${error.errorDescription})';
}
