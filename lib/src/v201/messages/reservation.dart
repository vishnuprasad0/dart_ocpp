import 'package:json_annotation/json_annotation.dart';

import 'common.dart';
import 'enums.dart';

part 'reservation.g.dart';

/// OCPP 2.0.1 `ReserveNowRequest` (CSMS -> Charge Station). [id] is the
/// reservation id. [evseId] null means any EVSE.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ReserveNowRequest {
  ReserveNowRequest(
      {required this.id,
      required this.expiryDateTime,
      this.connectorType,
      this.evseId,
      required this.idToken,
      this.groupIdToken});

  factory ReserveNowRequest.fromJson(Map<String, dynamic> json) =>
      _$ReserveNowRequestFromJson(json);

  final int id;
  final DateTime expiryDateTime;
  final ConnectorEnumType? connectorType;
  final int? evseId;
  final IdTokenType idToken;
  final IdTokenType? groupIdToken;

  Map<String, dynamic> toJson() => _$ReserveNowRequestToJson(this);
}

/// OCPP 2.0.1 `ReserveNowResponse`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ReserveNowResponse {
  ReserveNowResponse({required this.status, this.statusInfo});

  factory ReserveNowResponse.fromJson(Map<String, dynamic> json) =>
      _$ReserveNowResponseFromJson(json);

  final ReserveNowStatusEnumType status;
  final StatusInfoType? statusInfo;

  Map<String, dynamic> toJson() => _$ReserveNowResponseToJson(this);
}

/// OCPP 2.0.1 `CancelReservationRequest` (CSMS -> Charge Station).
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class CancelReservationRequest {
  CancelReservationRequest({required this.reservationId});

  factory CancelReservationRequest.fromJson(Map<String, dynamic> json) =>
      _$CancelReservationRequestFromJson(json);

  final int reservationId;

  Map<String, dynamic> toJson() => _$CancelReservationRequestToJson(this);
}

/// OCPP 2.0.1 `CancelReservationResponse`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class CancelReservationResponse {
  CancelReservationResponse({required this.status, this.statusInfo});

  factory CancelReservationResponse.fromJson(Map<String, dynamic> json) =>
      _$CancelReservationResponseFromJson(json);

  final CancelReservationStatusEnumType status;
  final StatusInfoType? statusInfo;

  Map<String, dynamic> toJson() => _$CancelReservationResponseToJson(this);
}
