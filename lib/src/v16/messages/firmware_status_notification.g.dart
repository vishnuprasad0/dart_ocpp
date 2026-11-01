// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firmware_status_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirmwareStatusNotificationReq _$FirmwareStatusNotificationReqFromJson(
        Map<String, dynamic> json) =>
    FirmwareStatusNotificationReq(
      status: $enumDecode(_$FirmwareStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$FirmwareStatusNotificationReqToJson(
        FirmwareStatusNotificationReq instance) =>
    <String, dynamic>{
      'status': _$FirmwareStatusEnumMap[instance.status]!,
    };

const _$FirmwareStatusEnumMap = {
  FirmwareStatus.downloaded: 'Downloaded',
  FirmwareStatus.downloadFailed: 'DownloadFailed',
  FirmwareStatus.downloading: 'Downloading',
  FirmwareStatus.idle: 'Idle',
  FirmwareStatus.installationFailed: 'InstallationFailed',
  FirmwareStatus.installing: 'Installing',
  FirmwareStatus.installed: 'Installed',
};

FirmwareStatusNotificationConf _$FirmwareStatusNotificationConfFromJson(
        Map<String, dynamic> json) =>
    FirmwareStatusNotificationConf();

Map<String, dynamic> _$FirmwareStatusNotificationConfToJson(
        FirmwareStatusNotificationConf instance) =>
    <String, dynamic>{};
