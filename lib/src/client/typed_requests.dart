import '../core/ocpp_version.dart';
import '../v16/messages.dart' as v16;
import '../v201/messages.dart' as v2;

/// Describes how to decode one Central-System-initiated request type.
class TypedRequestSpec {
  const TypedRequestSpec(this.action, this.version, this.decode);

  /// OCPP action name (e.g. `ReserveNow`).
  final String action;

  /// The protocol version the request type belongs to.
  final OcppVersion version;

  /// Decodes a CALL payload into the request object.
  final Object Function(Map<String, dynamic> json) decode;
}

/// Request types that [OcppClient.on] can handle, keyed by Dart type.
final Map<Type, TypedRequestSpec> typedRequestSpecs = {
  // OCPP 1.6
  v16.ReserveNowReq: const TypedRequestSpec(
      'ReserveNow', OcppVersion.v16, v16.ReserveNowReq.fromJson),
  v16.CancelReservationReq: const TypedRequestSpec(
      'CancelReservation', OcppVersion.v16, v16.CancelReservationReq.fromJson),
  v16.SetChargingProfileReq: const TypedRequestSpec('SetChargingProfile',
      OcppVersion.v16, v16.SetChargingProfileReq.fromJson),
  v16.ClearChargingProfileReq: const TypedRequestSpec('ClearChargingProfile',
      OcppVersion.v16, v16.ClearChargingProfileReq.fromJson),
  v16.GetCompositeScheduleReq: const TypedRequestSpec('GetCompositeSchedule',
      OcppVersion.v16, v16.GetCompositeScheduleReq.fromJson),
  v16.SendLocalListReq: const TypedRequestSpec(
      'SendLocalList', OcppVersion.v16, v16.SendLocalListReq.fromJson),
  v16.GetLocalListVersionReq: const TypedRequestSpec('GetLocalListVersion',
      OcppVersion.v16, v16.GetLocalListVersionReq.fromJson),
  // OCPP 2.0.1
  v2.ReserveNowRequest: const TypedRequestSpec(
      'ReserveNow', OcppVersion.v201, v2.ReserveNowRequest.fromJson),
  v2.CancelReservationRequest: const TypedRequestSpec('CancelReservation',
      OcppVersion.v201, v2.CancelReservationRequest.fromJson),
  v2.SetChargingProfileRequest: const TypedRequestSpec('SetChargingProfile',
      OcppVersion.v201, v2.SetChargingProfileRequest.fromJson),
  v2.ClearChargingProfileRequest: const TypedRequestSpec('ClearChargingProfile',
      OcppVersion.v201, v2.ClearChargingProfileRequest.fromJson),
  v2.GetCompositeScheduleRequest: const TypedRequestSpec('GetCompositeSchedule',
      OcppVersion.v201, v2.GetCompositeScheduleRequest.fromJson),
  v2.SendLocalListRequest: const TypedRequestSpec(
      'SendLocalList', OcppVersion.v201, v2.SendLocalListRequest.fromJson),
  v2.GetLocalListVersionRequest: const TypedRequestSpec('GetLocalListVersion',
      OcppVersion.v201, v2.GetLocalListVersionRequest.fromJson),
};
