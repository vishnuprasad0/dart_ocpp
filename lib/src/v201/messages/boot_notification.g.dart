// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boot_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModemType _$ModemTypeFromJson(Map<String, dynamic> json) => ModemType(
      iccid: json['iccid'] as String?,
      imsi: json['imsi'] as String?,
    );

Map<String, dynamic> _$ModemTypeToJson(ModemType instance) => <String, dynamic>{
      if (instance.iccid case final value?) 'iccid': value,
      if (instance.imsi case final value?) 'imsi': value,
    };

ChargingStationType _$ChargingStationTypeFromJson(Map<String, dynamic> json) =>
    ChargingStationType(
      serialNumber: json['serialNumber'] as String?,
      model: json['model'] as String,
      vendorName: json['vendorName'] as String,
      firmwareVersion: json['firmwareVersion'] as String?,
      modem: json['modem'] == null
          ? null
          : ModemType.fromJson(json['modem'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChargingStationTypeToJson(
        ChargingStationType instance) =>
    <String, dynamic>{
      if (instance.serialNumber case final value?) 'serialNumber': value,
      'model': instance.model,
      'vendorName': instance.vendorName,
      if (instance.firmwareVersion case final value?) 'firmwareVersion': value,
      if (instance.modem?.toJson() case final value?) 'modem': value,
    };

BootNotificationRequest _$BootNotificationRequestFromJson(
        Map<String, dynamic> json) =>
    BootNotificationRequest(
      reason: $enumDecode(_$BootReasonEnumTypeEnumMap, json['reason']),
      chargingStation: ChargingStationType.fromJson(
          json['chargingStation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BootNotificationRequestToJson(
        BootNotificationRequest instance) =>
    <String, dynamic>{
      'reason': _$BootReasonEnumTypeEnumMap[instance.reason]!,
      'chargingStation': instance.chargingStation.toJson(),
    };

const _$BootReasonEnumTypeEnumMap = {
  BootReasonEnumType.applicationReset: 'ApplicationReset',
  BootReasonEnumType.firmwareUpdate: 'FirmwareUpdate',
  BootReasonEnumType.localReset: 'LocalReset',
  BootReasonEnumType.powerUp: 'PowerUp',
  BootReasonEnumType.remoteReset: 'RemoteReset',
  BootReasonEnumType.scheduledReset: 'ScheduledReset',
  BootReasonEnumType.triggered: 'Triggered',
  BootReasonEnumType.unknown: 'Unknown',
  BootReasonEnumType.watchdog: 'Watchdog',
};

BootNotificationResponse _$BootNotificationResponseFromJson(
        Map<String, dynamic> json) =>
    BootNotificationResponse(
      currentTime: DateTime.parse(json['currentTime'] as String),
      interval: (json['interval'] as num).toInt(),
      status: $enumDecode(_$RegistrationStatusEnumTypeEnumMap, json['status']),
      statusInfo: json['statusInfo'] == null
          ? null
          : StatusInfoType.fromJson(json['statusInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BootNotificationResponseToJson(
        BootNotificationResponse instance) =>
    <String, dynamic>{
      'currentTime': instance.currentTime.toIso8601String(),
      'interval': instance.interval,
      'status': _$RegistrationStatusEnumTypeEnumMap[instance.status]!,
      if (instance.statusInfo?.toJson() case final value?) 'statusInfo': value,
    };

const _$RegistrationStatusEnumTypeEnumMap = {
  RegistrationStatusEnumType.accepted: 'Accepted',
  RegistrationStatusEnumType.pending: 'Pending',
  RegistrationStatusEnumType.rejected: 'Rejected',
};
