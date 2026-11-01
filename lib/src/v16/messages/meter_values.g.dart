// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meter_values.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeterValuesReq _$MeterValuesReqFromJson(Map<String, dynamic> json) =>
    MeterValuesReq(
      connectorId: (json['connectorId'] as num).toInt(),
      transactionId: (json['transactionId'] as num?)?.toInt(),
      meterValue: (json['meterValue'] as List<dynamic>)
          .map((e) => MeterValue.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MeterValuesReqToJson(MeterValuesReq instance) =>
    <String, dynamic>{
      'connectorId': instance.connectorId,
      if (instance.transactionId case final value?) 'transactionId': value,
      'meterValue': instance.meterValue.map((e) => e.toJson()).toList(),
    };

MeterValuesConf _$MeterValuesConfFromJson(Map<String, dynamic> json) =>
    MeterValuesConf();

Map<String, dynamic> _$MeterValuesConfToJson(MeterValuesConf instance) =>
    <String, dynamic>{};
