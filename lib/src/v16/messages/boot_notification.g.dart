// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boot_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BootNotificationReq _$BootNotificationReqFromJson(Map<String, dynamic> json) =>
    BootNotificationReq(
      chargePointVendor: json['chargePointVendor'] as String,
      chargePointModel: json['chargePointModel'] as String,
      chargePointSerialNumber: json['chargePointSerialNumber'] as String?,
      chargeBoxSerialNumber: json['chargeBoxSerialNumber'] as String?,
      firmwareVersion: json['firmwareVersion'] as String?,
      iccid: json['iccid'] as String?,
      imsi: json['imsi'] as String?,
      meterType: json['meterType'] as String?,
      meterSerialNumber: json['meterSerialNumber'] as String?,
    );

Map<String, dynamic> _$BootNotificationReqToJson(
        BootNotificationReq instance) =>
    <String, dynamic>{
      'chargePointVendor': instance.chargePointVendor,
      'chargePointModel': instance.chargePointModel,
      if (instance.chargePointSerialNumber case final value?)
        'chargePointSerialNumber': value,
      if (instance.chargeBoxSerialNumber case final value?)
        'chargeBoxSerialNumber': value,
      if (instance.firmwareVersion case final value?) 'firmwareVersion': value,
      if (instance.iccid case final value?) 'iccid': value,
      if (instance.imsi case final value?) 'imsi': value,
      if (instance.meterType case final value?) 'meterType': value,
      if (instance.meterSerialNumber case final value?)
        'meterSerialNumber': value,
    };

BootNotificationConf _$BootNotificationConfFromJson(
        Map<String, dynamic> json) =>
    BootNotificationConf(
      status: $enumDecode(_$RegistrationStatusEnumMap, json['status']),
      currentTime: DateTime.parse(json['currentTime'] as String),
      interval: (json['interval'] as num).toInt(),
    );

Map<String, dynamic> _$BootNotificationConfToJson(
        BootNotificationConf instance) =>
    <String, dynamic>{
      'status': _$RegistrationStatusEnumMap[instance.status]!,
      'currentTime': instance.currentTime.toIso8601String(),
      'interval': instance.interval,
    };

const _$RegistrationStatusEnumMap = {
  RegistrationStatus.accepted: 'Accepted',
  RegistrationStatus.pending: 'Pending',
  RegistrationStatus.rejected: 'Rejected',
};
