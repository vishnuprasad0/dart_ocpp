// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatusNotificationRequest _$StatusNotificationRequestFromJson(
        Map<String, dynamic> json) =>
    StatusNotificationRequest(
      timestamp: DateTime.parse(json['timestamp'] as String),
      connectorStatus: $enumDecode(
          _$ConnectorStatusEnumTypeEnumMap, json['connectorStatus']),
      evseId: (json['evseId'] as num).toInt(),
      connectorId: (json['connectorId'] as num).toInt(),
    );

Map<String, dynamic> _$StatusNotificationRequestToJson(
        StatusNotificationRequest instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'connectorStatus':
          _$ConnectorStatusEnumTypeEnumMap[instance.connectorStatus]!,
      'evseId': instance.evseId,
      'connectorId': instance.connectorId,
    };

const _$ConnectorStatusEnumTypeEnumMap = {
  ConnectorStatusEnumType.available: 'Available',
  ConnectorStatusEnumType.occupied: 'Occupied',
  ConnectorStatusEnumType.reserved: 'Reserved',
  ConnectorStatusEnumType.unavailable: 'Unavailable',
  ConnectorStatusEnumType.faulted: 'Faulted',
};

StatusNotificationResponse _$StatusNotificationResponseFromJson(
        Map<String, dynamic> json) =>
    StatusNotificationResponse();

Map<String, dynamic> _$StatusNotificationResponseToJson(
        StatusNotificationResponse instance) =>
    <String, dynamic>{};
