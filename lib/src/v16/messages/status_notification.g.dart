// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatusNotificationReq _$StatusNotificationReqFromJson(
        Map<String, dynamic> json) =>
    StatusNotificationReq(
      connectorId: (json['connectorId'] as num).toInt(),
      errorCode: $enumDecode(_$ChargePointErrorCodeEnumMap, json['errorCode']),
      info: json['info'] as String?,
      status: $enumDecode(_$ChargePointStatusEnumMap, json['status']),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      vendorId: json['vendorId'] as String?,
      vendorErrorCode: json['vendorErrorCode'] as String?,
    );

Map<String, dynamic> _$StatusNotificationReqToJson(
        StatusNotificationReq instance) =>
    <String, dynamic>{
      'connectorId': instance.connectorId,
      'errorCode': _$ChargePointErrorCodeEnumMap[instance.errorCode]!,
      if (instance.info case final value?) 'info': value,
      'status': _$ChargePointStatusEnumMap[instance.status]!,
      if (instance.timestamp?.toIso8601String() case final value?)
        'timestamp': value,
      if (instance.vendorId case final value?) 'vendorId': value,
      if (instance.vendorErrorCode case final value?) 'vendorErrorCode': value,
    };

const _$ChargePointErrorCodeEnumMap = {
  ChargePointErrorCode.connectorLockFailure: 'ConnectorLockFailure',
  ChargePointErrorCode.evCommunicationError: 'EVCommunicationError',
  ChargePointErrorCode.groundFailure: 'GroundFailure',
  ChargePointErrorCode.highTemperature: 'HighTemperature',
  ChargePointErrorCode.internalError: 'InternalError',
  ChargePointErrorCode.localListConflict: 'LocalListConflict',
  ChargePointErrorCode.noError: 'NoError',
  ChargePointErrorCode.otherError: 'OtherError',
  ChargePointErrorCode.overCurrentFailure: 'OverCurrentFailure',
  ChargePointErrorCode.powerMeterFailure: 'PowerMeterFailure',
  ChargePointErrorCode.powerSwitchFailure: 'PowerSwitchFailure',
  ChargePointErrorCode.readerFailure: 'ReaderFailure',
  ChargePointErrorCode.resetFailure: 'ResetFailure',
  ChargePointErrorCode.underVoltage: 'UnderVoltage',
  ChargePointErrorCode.overVoltage: 'OverVoltage',
  ChargePointErrorCode.weakSignal: 'WeakSignal',
};

const _$ChargePointStatusEnumMap = {
  ChargePointStatus.available: 'Available',
  ChargePointStatus.preparing: 'Preparing',
  ChargePointStatus.charging: 'Charging',
  ChargePointStatus.suspendedEVSE: 'SuspendedEVSE',
  ChargePointStatus.suspendedEV: 'SuspendedEV',
  ChargePointStatus.finishing: 'Finishing',
  ChargePointStatus.reserved: 'Reserved',
  ChargePointStatus.unavailable: 'Unavailable',
  ChargePointStatus.faulted: 'Faulted',
};

StatusNotificationConf _$StatusNotificationConfFromJson(
        Map<String, dynamic> json) =>
    StatusNotificationConf();

Map<String, dynamic> _$StatusNotificationConfToJson(
        StatusNotificationConf instance) =>
    <String, dynamic>{};
