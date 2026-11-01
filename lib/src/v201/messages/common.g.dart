// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IdTokenType _$IdTokenTypeFromJson(Map<String, dynamic> json) => IdTokenType(
      idToken: json['idToken'] as String,
      type: $enumDecode(_$IdTokenEnumTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$IdTokenTypeToJson(IdTokenType instance) =>
    <String, dynamic>{
      'idToken': instance.idToken,
      'type': _$IdTokenEnumTypeEnumMap[instance.type]!,
    };

const _$IdTokenEnumTypeEnumMap = {
  IdTokenEnumType.central: 'Central',
  IdTokenEnumType.eMAID: 'eMAID',
  IdTokenEnumType.iso14443: 'ISO14443',
  IdTokenEnumType.iso15693: 'ISO15693',
  IdTokenEnumType.keyCode: 'KeyCode',
  IdTokenEnumType.local: 'Local',
  IdTokenEnumType.macAddress: 'MacAddress',
  IdTokenEnumType.noAuthorization: 'NoAuthorization',
};

StatusInfoType _$StatusInfoTypeFromJson(Map<String, dynamic> json) =>
    StatusInfoType(
      reasonCode: json['reasonCode'] as String,
      additionalInfo: json['additionalInfo'] as String?,
    );

Map<String, dynamic> _$StatusInfoTypeToJson(StatusInfoType instance) =>
    <String, dynamic>{
      'reasonCode': instance.reasonCode,
      if (instance.additionalInfo case final value?) 'additionalInfo': value,
    };

IdTokenInfoType _$IdTokenInfoTypeFromJson(Map<String, dynamic> json) =>
    IdTokenInfoType(
      status: $enumDecode(_$AuthorizationStatusEnumTypeEnumMap, json['status']),
      cacheExpiryDateTime: json['cacheExpiryDateTime'] == null
          ? null
          : DateTime.parse(json['cacheExpiryDateTime'] as String),
      chargingPriority: (json['chargingPriority'] as num?)?.toInt(),
      language1: json['language1'] as String?,
      evseId: (json['evseId'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      groupIdToken: json['groupIdToken'] == null
          ? null
          : IdTokenType.fromJson(json['groupIdToken'] as Map<String, dynamic>),
      language2: json['language2'] as String?,
    );

Map<String, dynamic> _$IdTokenInfoTypeToJson(IdTokenInfoType instance) =>
    <String, dynamic>{
      'status': _$AuthorizationStatusEnumTypeEnumMap[instance.status]!,
      if (instance.cacheExpiryDateTime?.toIso8601String() case final value?)
        'cacheExpiryDateTime': value,
      if (instance.chargingPriority case final value?)
        'chargingPriority': value,
      if (instance.language1 case final value?) 'language1': value,
      if (instance.evseId case final value?) 'evseId': value,
      if (instance.groupIdToken?.toJson() case final value?)
        'groupIdToken': value,
      if (instance.language2 case final value?) 'language2': value,
    };

const _$AuthorizationStatusEnumTypeEnumMap = {
  AuthorizationStatusEnumType.accepted: 'Accepted',
  AuthorizationStatusEnumType.blocked: 'Blocked',
  AuthorizationStatusEnumType.concurrentTx: 'ConcurrentTx',
  AuthorizationStatusEnumType.expired: 'Expired',
  AuthorizationStatusEnumType.invalid: 'Invalid',
  AuthorizationStatusEnumType.noCredit: 'NoCredit',
  AuthorizationStatusEnumType.notAllowedTypeEVSE: 'NotAllowedTypeEVSE',
  AuthorizationStatusEnumType.notAtThisLocation: 'NotAtThisLocation',
  AuthorizationStatusEnumType.notAtThisTime: 'NotAtThisTime',
  AuthorizationStatusEnumType.unknown: 'Unknown',
};

EVSEType _$EVSETypeFromJson(Map<String, dynamic> json) => EVSEType(
      id: (json['id'] as num).toInt(),
      connectorId: (json['connectorId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EVSETypeToJson(EVSEType instance) => <String, dynamic>{
      'id': instance.id,
      if (instance.connectorId case final value?) 'connectorId': value,
    };

UnitOfMeasureType _$UnitOfMeasureTypeFromJson(Map<String, dynamic> json) =>
    UnitOfMeasureType(
      unit: json['unit'] as String?,
      multiplier: (json['multiplier'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UnitOfMeasureTypeToJson(UnitOfMeasureType instance) =>
    <String, dynamic>{
      if (instance.unit case final value?) 'unit': value,
      if (instance.multiplier case final value?) 'multiplier': value,
    };

SampledValueType _$SampledValueTypeFromJson(Map<String, dynamic> json) =>
    SampledValueType(
      value: (json['value'] as num).toDouble(),
      context:
          $enumDecodeNullable(_$ReadingContextEnumTypeEnumMap, json['context']),
      measurand: json['measurand'] as String?,
      phase: json['phase'] as String?,
      location:
          $enumDecodeNullable(_$LocationEnumTypeEnumMap, json['location']),
      unitOfMeasure: json['unitOfMeasure'] == null
          ? null
          : UnitOfMeasureType.fromJson(
              json['unitOfMeasure'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SampledValueTypeToJson(SampledValueType instance) =>
    <String, dynamic>{
      'value': instance.value,
      if (_$ReadingContextEnumTypeEnumMap[instance.context] case final value?)
        'context': value,
      if (instance.measurand case final value?) 'measurand': value,
      if (instance.phase case final value?) 'phase': value,
      if (_$LocationEnumTypeEnumMap[instance.location] case final value?)
        'location': value,
      if (instance.unitOfMeasure?.toJson() case final value?)
        'unitOfMeasure': value,
    };

const _$ReadingContextEnumTypeEnumMap = {
  ReadingContextEnumType.interruptionBegin: 'Interruption.Begin',
  ReadingContextEnumType.interruptionEnd: 'Interruption.End',
  ReadingContextEnumType.other: 'Other',
  ReadingContextEnumType.sampleClock: 'Sample.Clock',
  ReadingContextEnumType.samplePeriodic: 'Sample.Periodic',
  ReadingContextEnumType.transactionBegin: 'Transaction.Begin',
  ReadingContextEnumType.transactionEnd: 'Transaction.End',
  ReadingContextEnumType.trigger: 'Trigger',
};

const _$LocationEnumTypeEnumMap = {
  LocationEnumType.body: 'Body',
  LocationEnumType.cable: 'Cable',
  LocationEnumType.ev: 'EV',
  LocationEnumType.inlet: 'Inlet',
  LocationEnumType.outlet: 'Outlet',
};

MeterValueType _$MeterValueTypeFromJson(Map<String, dynamic> json) =>
    MeterValueType(
      timestamp: DateTime.parse(json['timestamp'] as String),
      sampledValue: (json['sampledValue'] as List<dynamic>)
          .map((e) => SampledValueType.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MeterValueTypeToJson(MeterValueType instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'sampledValue': instance.sampledValue.map((e) => e.toJson()).toList(),
    };
