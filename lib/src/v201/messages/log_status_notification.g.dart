// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_status_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogStatusNotificationRequest _$LogStatusNotificationRequestFromJson(
        Map<String, dynamic> json) =>
    LogStatusNotificationRequest(
      status: $enumDecode(_$UploadLogStatusEnumTypeEnumMap, json['status']),
      requestId: (json['requestId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LogStatusNotificationRequestToJson(
        LogStatusNotificationRequest instance) =>
    <String, dynamic>{
      'status': _$UploadLogStatusEnumTypeEnumMap[instance.status]!,
      if (instance.requestId case final value?) 'requestId': value,
    };

const _$UploadLogStatusEnumTypeEnumMap = {
  UploadLogStatusEnumType.badMessage: 'BadMessage',
  UploadLogStatusEnumType.idle: 'Idle',
  UploadLogStatusEnumType.notSupportedOperation: 'NotSupportedOperation',
  UploadLogStatusEnumType.permissionDenied: 'PermissionDenied',
  UploadLogStatusEnumType.uploaded: 'Uploaded',
  UploadLogStatusEnumType.uploadFailure: 'UploadFailure',
  UploadLogStatusEnumType.uploading: 'Uploading',
  UploadLogStatusEnumType.acceptedCanceled: 'AcceptedCanceled',
};

LogStatusNotificationResponse _$LogStatusNotificationResponseFromJson(
        Map<String, dynamic> json) =>
    LogStatusNotificationResponse();

Map<String, dynamic> _$LogStatusNotificationResponseToJson(
        LogStatusNotificationResponse instance) =>
    <String, dynamic>{};
