// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReserveNowReq _$ReserveNowReqFromJson(Map<String, dynamic> json) =>
    ReserveNowReq(
      connectorId: (json['connectorId'] as num).toInt(),
      expiryDate: DateTime.parse(json['expiryDate'] as String),
      idTag: json['idTag'] as String,
      parentIdTag: json['parentIdTag'] as String?,
      reservationId: (json['reservationId'] as num).toInt(),
    );

Map<String, dynamic> _$ReserveNowReqToJson(ReserveNowReq instance) =>
    <String, dynamic>{
      'connectorId': instance.connectorId,
      'expiryDate': instance.expiryDate.toIso8601String(),
      'idTag': instance.idTag,
      if (instance.parentIdTag case final value?) 'parentIdTag': value,
      'reservationId': instance.reservationId,
    };

ReserveNowConf _$ReserveNowConfFromJson(Map<String, dynamic> json) =>
    ReserveNowConf(
      status: $enumDecode(_$ReservationStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$ReserveNowConfToJson(ReserveNowConf instance) =>
    <String, dynamic>{
      'status': _$ReservationStatusEnumMap[instance.status]!,
    };

const _$ReservationStatusEnumMap = {
  ReservationStatus.accepted: 'Accepted',
  ReservationStatus.faulted: 'Faulted',
  ReservationStatus.occupied: 'Occupied',
  ReservationStatus.rejected: 'Rejected',
  ReservationStatus.unavailable: 'Unavailable',
};

CancelReservationReq _$CancelReservationReqFromJson(
        Map<String, dynamic> json) =>
    CancelReservationReq(
      reservationId: (json['reservationId'] as num).toInt(),
    );

Map<String, dynamic> _$CancelReservationReqToJson(
        CancelReservationReq instance) =>
    <String, dynamic>{
      'reservationId': instance.reservationId,
    };

CancelReservationConf _$CancelReservationConfFromJson(
        Map<String, dynamic> json) =>
    CancelReservationConf(
      status: $enumDecode(_$CancelReservationStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$CancelReservationConfToJson(
        CancelReservationConf instance) =>
    <String, dynamic>{
      'status': _$CancelReservationStatusEnumMap[instance.status]!,
    };

const _$CancelReservationStatusEnumMap = {
  CancelReservationStatus.accepted: 'Accepted',
  CancelReservationStatus.rejected: 'Rejected',
};
