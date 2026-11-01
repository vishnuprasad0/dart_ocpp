// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firmware_status_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirmwareStatusNotificationRequest _$FirmwareStatusNotificationRequestFromJson(
        Map<String, dynamic> json) =>
    FirmwareStatusNotificationRequest(
      status: $enumDecode(_$FirmwareStatusEnumTypeEnumMap, json['status']),
      requestId: (json['requestId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FirmwareStatusNotificationRequestToJson(
        FirmwareStatusNotificationRequest instance) =>
    <String, dynamic>{
      'status': _$FirmwareStatusEnumTypeEnumMap[instance.status]!,
      if (instance.requestId case final value?) 'requestId': value,
    };

const _$FirmwareStatusEnumTypeEnumMap = {
  FirmwareStatusEnumType.downloaded: 'Downloaded',
  FirmwareStatusEnumType.downloadFailed: 'DownloadFailed',
  FirmwareStatusEnumType.downloading: 'Downloading',
  FirmwareStatusEnumType.downloadScheduled: 'DownloadScheduled',
  FirmwareStatusEnumType.downloadPaused: 'DownloadPaused',
  FirmwareStatusEnumType.idle: 'Idle',
  FirmwareStatusEnumType.installationFailed: 'InstallationFailed',
  FirmwareStatusEnumType.installing: 'Installing',
  FirmwareStatusEnumType.installed: 'Installed',
  FirmwareStatusEnumType.installRebooting: 'InstallRebooting',
  FirmwareStatusEnumType.installScheduled: 'InstallScheduled',
  FirmwareStatusEnumType.installVerificationFailed: 'InstallVerificationFailed',
  FirmwareStatusEnumType.invalidSignature: 'InvalidSignature',
  FirmwareStatusEnumType.signatureVerified: 'SignatureVerified',
};

FirmwareStatusNotificationResponse _$FirmwareStatusNotificationResponseFromJson(
        Map<String, dynamic> json) =>
    FirmwareStatusNotificationResponse();

Map<String, dynamic> _$FirmwareStatusNotificationResponseToJson(
        FirmwareStatusNotificationResponse instance) =>
    <String, dynamic>{};
