// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heartbeat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HeartbeatRequest _$HeartbeatRequestFromJson(Map<String, dynamic> json) =>
    HeartbeatRequest();

Map<String, dynamic> _$HeartbeatRequestToJson(HeartbeatRequest instance) =>
    <String, dynamic>{};

HeartbeatResponse _$HeartbeatResponseFromJson(Map<String, dynamic> json) =>
    HeartbeatResponse(
      currentTime: DateTime.parse(json['currentTime'] as String),
    );

Map<String, dynamic> _$HeartbeatResponseToJson(HeartbeatResponse instance) =>
    <String, dynamic>{
      'currentTime': instance.currentTime.toIso8601String(),
    };
