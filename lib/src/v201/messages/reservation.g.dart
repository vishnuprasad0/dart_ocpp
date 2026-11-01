// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReserveNowRequest _$ReserveNowRequestFromJson(Map<String, dynamic> json) =>
    ReserveNowRequest(
      id: (json['id'] as num).toInt(),
      expiryDateTime: DateTime.parse(json['expiryDateTime'] as String),
      connectorType: $enumDecodeNullable(
          _$ConnectorEnumTypeEnumMap, json['connectorType']),
      evseId: (json['evseId'] as num?)?.toInt(),
      idToken: IdTokenType.fromJson(json['idToken'] as Map<String, dynamic>),
      groupIdToken: json['groupIdToken'] == null
          ? null
          : IdTokenType.fromJson(json['groupIdToken'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReserveNowRequestToJson(ReserveNowRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'expiryDateTime': instance.expiryDateTime.toIso8601String(),
      if (_$ConnectorEnumTypeEnumMap[instance.connectorType] case final value?)
        'connectorType': value,
      if (instance.evseId case final value?) 'evseId': value,
      'idToken': instance.idToken.toJson(),
      if (instance.groupIdToken?.toJson() case final value?)
        'groupIdToken': value,
    };

const _$ConnectorEnumTypeEnumMap = {
  ConnectorEnumType.cCCS1: 'cCCS1',
  ConnectorEnumType.cCCS2: 'cCCS2',
  ConnectorEnumType.cG105: 'cG105',
  ConnectorEnumType.cTesla: 'cTesla',
  ConnectorEnumType.cType1: 'cType1',
  ConnectorEnumType.cType2: 'cType2',
  ConnectorEnumType.s309_1P_16A: 's309-1P-16A',
  ConnectorEnumType.s309_1P_32A: 's309-1P-32A',
  ConnectorEnumType.s309_3P_16A: 's309-3P-16A',
  ConnectorEnumType.s309_3P_32A: 's309-3P-32A',
  ConnectorEnumType.sBS1361: 'sBS1361',
  ConnectorEnumType.sCEE_7_7: 'sCEE-7-7',
  ConnectorEnumType.sType2: 'sType2',
  ConnectorEnumType.sType3: 'sType3',
  ConnectorEnumType.other1PhMax16A: 'Other1PhMax16A',
  ConnectorEnumType.other1PhOver16A: 'Other1PhOver16A',
  ConnectorEnumType.other3Ph: 'Other3Ph',
  ConnectorEnumType.pan: 'Pan',
  ConnectorEnumType.wInductive: 'wInductive',
  ConnectorEnumType.wResonant: 'wResonant',
  ConnectorEnumType.undetermined: 'Undetermined',
  ConnectorEnumType.unknown: 'Unknown',
};

ReserveNowResponse _$ReserveNowResponseFromJson(Map<String, dynamic> json) =>
    ReserveNowResponse(
      status: $enumDecode(_$ReserveNowStatusEnumTypeEnumMap, json['status']),
      statusInfo: json['statusInfo'] == null
          ? null
          : StatusInfoType.fromJson(json['statusInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReserveNowResponseToJson(ReserveNowResponse instance) =>
    <String, dynamic>{
      'status': _$ReserveNowStatusEnumTypeEnumMap[instance.status]!,
      if (instance.statusInfo?.toJson() case final value?) 'statusInfo': value,
    };

const _$ReserveNowStatusEnumTypeEnumMap = {
  ReserveNowStatusEnumType.accepted: 'Accepted',
  ReserveNowStatusEnumType.faulted: 'Faulted',
  ReserveNowStatusEnumType.occupied: 'Occupied',
  ReserveNowStatusEnumType.rejected: 'Rejected',
  ReserveNowStatusEnumType.unavailable: 'Unavailable',
};

CancelReservationRequest _$CancelReservationRequestFromJson(
        Map<String, dynamic> json) =>
    CancelReservationRequest(
      reservationId: (json['reservationId'] as num).toInt(),
    );

Map<String, dynamic> _$CancelReservationRequestToJson(
        CancelReservationRequest instance) =>
    <String, dynamic>{
      'reservationId': instance.reservationId,
    };

CancelReservationResponse _$CancelReservationResponseFromJson(
        Map<String, dynamic> json) =>
    CancelReservationResponse(
      status:
          $enumDecode(_$CancelReservationStatusEnumTypeEnumMap, json['status']),
      statusInfo: json['statusInfo'] == null
          ? null
          : StatusInfoType.fromJson(json['statusInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CancelReservationResponseToJson(
        CancelReservationResponse instance) =>
    <String, dynamic>{
      'status': _$CancelReservationStatusEnumTypeEnumMap[instance.status]!,
      if (instance.statusInfo?.toJson() case final value?) 'statusInfo': value,
    };

const _$CancelReservationStatusEnumTypeEnumMap = {
  CancelReservationStatusEnumType.accepted: 'Accepted',
  CancelReservationStatusEnumType.rejected: 'Rejected',
};
