// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diagnostics_status_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiagnosticsStatusNotificationReq _$DiagnosticsStatusNotificationReqFromJson(
        Map<String, dynamic> json) =>
    DiagnosticsStatusNotificationReq(
      status: $enumDecode(_$DiagnosticsStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$DiagnosticsStatusNotificationReqToJson(
        DiagnosticsStatusNotificationReq instance) =>
    <String, dynamic>{
      'status': _$DiagnosticsStatusEnumMap[instance.status]!,
    };

const _$DiagnosticsStatusEnumMap = {
  DiagnosticsStatus.idle: 'Idle',
  DiagnosticsStatus.uploaded: 'Uploaded',
  DiagnosticsStatus.uploadFailed: 'UploadFailed',
  DiagnosticsStatus.uploading: 'Uploading',
};

DiagnosticsStatusNotificationConf _$DiagnosticsStatusNotificationConfFromJson(
        Map<String, dynamic> json) =>
    DiagnosticsStatusNotificationConf();

Map<String, dynamic> _$DiagnosticsStatusNotificationConfToJson(
        DiagnosticsStatusNotificationConf instance) =>
    <String, dynamic>{};
