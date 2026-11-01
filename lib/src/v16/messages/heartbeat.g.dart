// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heartbeat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HeartbeatReq _$HeartbeatReqFromJson(Map<String, dynamic> json) =>
    HeartbeatReq();

Map<String, dynamic> _$HeartbeatReqToJson(HeartbeatReq instance) =>
    <String, dynamic>{};

HeartbeatConf _$HeartbeatConfFromJson(Map<String, dynamic> json) =>
    HeartbeatConf(
      currentTime: DateTime.parse(json['currentTime'] as String),
    );

Map<String, dynamic> _$HeartbeatConfToJson(HeartbeatConf instance) =>
    <String, dynamic>{
      'currentTime': instance.currentTime.toIso8601String(),
    };
