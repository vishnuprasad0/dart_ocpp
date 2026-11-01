// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StopTransactionReq _$StopTransactionReqFromJson(Map<String, dynamic> json) =>
    StopTransactionReq(
      idTag: json['idTag'] as String?,
      meterStop: (json['meterStop'] as num).toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      transactionId: (json['transactionId'] as num).toInt(),
      reason: $enumDecodeNullable(_$ReasonEnumMap, json['reason']),
      transactionData: (json['transactionData'] as List<dynamic>?)
          ?.map((e) => MeterValue.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StopTransactionReqToJson(StopTransactionReq instance) =>
    <String, dynamic>{
      if (instance.idTag case final value?) 'idTag': value,
      'meterStop': instance.meterStop,
      'timestamp': instance.timestamp.toIso8601String(),
      'transactionId': instance.transactionId,
      if (_$ReasonEnumMap[instance.reason] case final value?) 'reason': value,
      if (instance.transactionData?.map((e) => e.toJson()).toList()
          case final value?)
        'transactionData': value,
    };

const _$ReasonEnumMap = {
  Reason.emergencyStop: 'EmergencyStop',
  Reason.evDisconnected: 'EVDisconnected',
  Reason.hardReset: 'HardReset',
  Reason.local: 'Local',
  Reason.other: 'Other',
  Reason.powerLoss: 'PowerLoss',
  Reason.reboot: 'Reboot',
  Reason.remote: 'Remote',
  Reason.softReset: 'SoftReset',
  Reason.unlockCommand: 'UnlockCommand',
  Reason.deAuthorized: 'DeAuthorized',
};

StopTransactionConf _$StopTransactionConfFromJson(Map<String, dynamic> json) =>
    StopTransactionConf(
      idTagInfo: json['idTagInfo'] == null
          ? null
          : IdTagInfo.fromJson(json['idTagInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StopTransactionConfToJson(
        StopTransactionConf instance) =>
    <String, dynamic>{
      if (instance.idTagInfo?.toJson() case final value?) 'idTagInfo': value,
    };
