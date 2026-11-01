import 'dart:convert';

import 'ocpp_message.dart';

/// Encodes/decodes OCPP-J frames (JSON arrays).
abstract interface class OcppCodec {
  /// Serializes [message] to a text frame.
  String encode(OcppMessage message);

  /// Parses a text [frame]. Throws [OcppFormatException] when invalid.
  OcppMessage decode(String frame);
}

/// Default OCPP-J codec for both 1.6 and 2.0.1 (the framing is identical).
class JsonOcppCodec implements OcppCodec {
  const JsonOcppCodec();

  @override
  String encode(OcppMessage message) {
    switch (message) {
      case OcppCall():
        return jsonEncode([
          message.type.code,
          message.uniqueId,
          message.action,
          message.payload
        ]);
      case OcppCallResult():
        return jsonEncode(
            [message.type.code, message.uniqueId, message.payload]);
      case OcppCallError():
        return jsonEncode([
          message.type.code,
          message.uniqueId,
          message.errorCode,
          message.errorDescription,
          message.errorDetails,
        ]);
    }
  }

  @override
  OcppMessage decode(String frame) {
    final Object? raw;
    try {
      raw = jsonDecode(frame);
    } on FormatException catch (e) {
      throw OcppFormatException('Invalid JSON: ${e.message}');
    }
    if (raw is! List || raw.length < 3) {
      throw OcppFormatException('Frame must be a JSON array of 3-5 items');
    }
    final type = OcppMessageType.fromCode(raw[0]);
    final id = raw[1];
    if (type == null) {
      throw OcppFormatException('Unknown message type ${raw[0]}');
    }
    if (id is! String) throw OcppFormatException('uniqueId must be a string');

    Map<String, dynamic> obj(Object? v, String what) {
      if (v is Map) return Map<String, dynamic>.from(v);
      throw OcppFormatException('$what must be a JSON object');
    }

    switch (type) {
      case OcppMessageType.call:
        if (raw.length != 4 || raw[2] is! String) {
          throw OcppFormatException('CALL must be [2, id, action, payload]');
        }
        return OcppCall(
            uniqueId: id,
            action: raw[2] as String,
            payload: obj(raw[3], 'payload'));
      case OcppMessageType.callResult:
        if (raw.length != 3) {
          throw OcppFormatException('CALLRESULT must be [3, id, payload]');
        }
        return OcppCallResult(uniqueId: id, payload: obj(raw[2], 'payload'));
      case OcppMessageType.callError:
        if (raw.length != 5 || raw[2] is! String) {
          throw OcppFormatException(
              'CALLERROR must be [4, id, code, description, details]');
        }
        return OcppCallError(
          uniqueId: id,
          errorCode: raw[2] as String,
          errorDescription: (raw[3] ?? '').toString(),
          errorDetails: obj(raw[4], 'errorDetails'),
        );
    }
  }
}
