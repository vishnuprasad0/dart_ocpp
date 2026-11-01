import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'reservation.g.dart';

/// OCPP 1.6 `ReserveNow.req` (Central System -> Charge Point).
/// [connectorId] 0 means any connector.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ReserveNowReq {
  ReserveNowReq(
      {required this.connectorId,
      required this.expiryDate,
      required this.idTag,
      this.parentIdTag,
      required this.reservationId});

  factory ReserveNowReq.fromJson(Map<String, dynamic> json) =>
      _$ReserveNowReqFromJson(json);

  final int connectorId;
  final DateTime expiryDate;
  final String idTag;
  final String? parentIdTag;
  final int reservationId;

  Map<String, dynamic> toJson() => _$ReserveNowReqToJson(this);
}

/// OCPP 1.6 `ReserveNow.conf`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ReserveNowConf {
  ReserveNowConf({required this.status});

  factory ReserveNowConf.fromJson(Map<String, dynamic> json) =>
      _$ReserveNowConfFromJson(json);

  final ReservationStatus status;

  Map<String, dynamic> toJson() => _$ReserveNowConfToJson(this);
}

/// OCPP 1.6 `CancelReservation.req` (Central System -> Charge Point).
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class CancelReservationReq {
  CancelReservationReq({required this.reservationId});

  factory CancelReservationReq.fromJson(Map<String, dynamic> json) =>
      _$CancelReservationReqFromJson(json);

  final int reservationId;

  Map<String, dynamic> toJson() => _$CancelReservationReqToJson(this);
}

/// OCPP 1.6 `CancelReservation.conf`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class CancelReservationConf {
  CancelReservationConf({required this.status});

  factory CancelReservationConf.fromJson(Map<String, dynamic> json) =>
      _$CancelReservationConfFromJson(json);

  final CancelReservationStatus status;

  Map<String, dynamic> toJson() => _$CancelReservationConfToJson(this);
}
