// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IdTagInfo _$IdTagInfoFromJson(Map<String, dynamic> json) => IdTagInfo(
      status: $enumDecode(_$AuthorizationStatusEnumMap, json['status']),
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      parentIdTag: json['parentIdTag'] as String?,
    );

Map<String, dynamic> _$IdTagInfoToJson(IdTagInfo instance) => <String, dynamic>{
      'status': _$AuthorizationStatusEnumMap[instance.status]!,
      if (instance.expiryDate?.toIso8601String() case final value?)
        'expiryDate': value,
      if (instance.parentIdTag case final value?) 'parentIdTag': value,
    };

const _$AuthorizationStatusEnumMap = {
  AuthorizationStatus.accepted: 'Accepted',
  AuthorizationStatus.blocked: 'Blocked',
  AuthorizationStatus.expired: 'Expired',
  AuthorizationStatus.invalid: 'Invalid',
  AuthorizationStatus.concurrentTx: 'ConcurrentTx',
};

SampledValue _$SampledValueFromJson(Map<String, dynamic> json) => SampledValue(
      value: json['value'] as String,
      context: $enumDecodeNullable(_$ReadingContextEnumMap, json['context']),
      format: $enumDecodeNullable(_$ValueFormatEnumMap, json['format']),
      measurand: json['measurand'] as String?,
      phase: json['phase'] as String?,
      location: $enumDecodeNullable(_$LocationEnumMap, json['location']),
      unit: json['unit'] as String?,
    );

Map<String, dynamic> _$SampledValueToJson(SampledValue instance) =>
    <String, dynamic>{
      'value': instance.value,
      if (_$ReadingContextEnumMap[instance.context] case final value?)
        'context': value,
      if (_$ValueFormatEnumMap[instance.format] case final value?)
        'format': value,
      if (instance.measurand case final value?) 'measurand': value,
      if (instance.phase case final value?) 'phase': value,
      if (_$LocationEnumMap[instance.location] case final value?)
        'location': value,
      if (instance.unit case final value?) 'unit': value,
    };

const _$ReadingContextEnumMap = {
  ReadingContext.interruptionBegin: 'Interruption.Begin',
  ReadingContext.interruptionEnd: 'Interruption.End',
  ReadingContext.sampleClock: 'Sample.Clock',
  ReadingContext.samplePeriodic: 'Sample.Periodic',
  ReadingContext.transactionBegin: 'Transaction.Begin',
  ReadingContext.transactionEnd: 'Transaction.End',
  ReadingContext.trigger: 'Trigger',
  ReadingContext.other: 'Other',
};

const _$ValueFormatEnumMap = {
  ValueFormat.raw: 'Raw',
  ValueFormat.signedData: 'SignedData',
};

const _$LocationEnumMap = {
  Location.cable: 'Cable',
  Location.ev: 'EV',
  Location.inlet: 'Inlet',
  Location.outlet: 'Outlet',
  Location.body: 'Body',
};

MeterValue _$MeterValueFromJson(Map<String, dynamic> json) => MeterValue(
      timestamp: DateTime.parse(json['timestamp'] as String),
      sampledValue: (json['sampledValue'] as List<dynamic>)
          .map((e) => SampledValue.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MeterValueToJson(MeterValue instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'sampledValue': instance.sampledValue.map((e) => e.toJson()).toList(),
    };
