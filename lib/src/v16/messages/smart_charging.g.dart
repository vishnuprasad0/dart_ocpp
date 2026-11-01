// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_charging.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChargingSchedulePeriod _$ChargingSchedulePeriodFromJson(
        Map<String, dynamic> json) =>
    ChargingSchedulePeriod(
      startPeriod: (json['startPeriod'] as num).toInt(),
      limit: (json['limit'] as num).toDouble(),
      numberPhases: (json['numberPhases'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ChargingSchedulePeriodToJson(
        ChargingSchedulePeriod instance) =>
    <String, dynamic>{
      'startPeriod': instance.startPeriod,
      'limit': instance.limit,
      if (instance.numberPhases case final value?) 'numberPhases': value,
    };

ChargingSchedule _$ChargingScheduleFromJson(Map<String, dynamic> json) =>
    ChargingSchedule(
      duration: (json['duration'] as num?)?.toInt(),
      startSchedule: json['startSchedule'] == null
          ? null
          : DateTime.parse(json['startSchedule'] as String),
      chargingRateUnit:
          $enumDecode(_$ChargingRateUnitEnumMap, json['chargingRateUnit']),
      chargingSchedulePeriod: (json['chargingSchedulePeriod'] as List<dynamic>)
          .map(
              (e) => ChargingSchedulePeriod.fromJson(e as Map<String, dynamic>))
          .toList(),
      minChargingRate: (json['minChargingRate'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ChargingScheduleToJson(ChargingSchedule instance) =>
    <String, dynamic>{
      if (instance.duration case final value?) 'duration': value,
      if (instance.startSchedule?.toIso8601String() case final value?)
        'startSchedule': value,
      'chargingRateUnit': _$ChargingRateUnitEnumMap[instance.chargingRateUnit]!,
      'chargingSchedulePeriod':
          instance.chargingSchedulePeriod.map((e) => e.toJson()).toList(),
      if (instance.minChargingRate case final value?) 'minChargingRate': value,
    };

const _$ChargingRateUnitEnumMap = {
  ChargingRateUnit.amperes: 'A',
  ChargingRateUnit.watts: 'W',
};

ChargingProfile _$ChargingProfileFromJson(Map<String, dynamic> json) =>
    ChargingProfile(
      chargingProfileId: (json['chargingProfileId'] as num).toInt(),
      transactionId: (json['transactionId'] as num?)?.toInt(),
      stackLevel: (json['stackLevel'] as num).toInt(),
      chargingProfilePurpose: $enumDecode(
          _$ChargingProfilePurposeEnumMap, json['chargingProfilePurpose']),
      chargingProfileKind: $enumDecode(
          _$ChargingProfileKindEnumMap, json['chargingProfileKind']),
      recurrencyKind:
          $enumDecodeNullable(_$RecurrencyKindEnumMap, json['recurrencyKind']),
      validFrom: json['validFrom'] == null
          ? null
          : DateTime.parse(json['validFrom'] as String),
      validTo: json['validTo'] == null
          ? null
          : DateTime.parse(json['validTo'] as String),
      chargingSchedule: ChargingSchedule.fromJson(
          json['chargingSchedule'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChargingProfileToJson(ChargingProfile instance) =>
    <String, dynamic>{
      'chargingProfileId': instance.chargingProfileId,
      if (instance.transactionId case final value?) 'transactionId': value,
      'stackLevel': instance.stackLevel,
      'chargingProfilePurpose':
          _$ChargingProfilePurposeEnumMap[instance.chargingProfilePurpose]!,
      'chargingProfileKind':
          _$ChargingProfileKindEnumMap[instance.chargingProfileKind]!,
      if (_$RecurrencyKindEnumMap[instance.recurrencyKind] case final value?)
        'recurrencyKind': value,
      if (instance.validFrom?.toIso8601String() case final value?)
        'validFrom': value,
      if (instance.validTo?.toIso8601String() case final value?)
        'validTo': value,
      'chargingSchedule': instance.chargingSchedule.toJson(),
    };

const _$ChargingProfilePurposeEnumMap = {
  ChargingProfilePurpose.chargePointMaxProfile: 'ChargePointMaxProfile',
  ChargingProfilePurpose.txDefaultProfile: 'TxDefaultProfile',
  ChargingProfilePurpose.txProfile: 'TxProfile',
};

const _$ChargingProfileKindEnumMap = {
  ChargingProfileKind.absolute: 'Absolute',
  ChargingProfileKind.recurring: 'Recurring',
  ChargingProfileKind.relative: 'Relative',
};

const _$RecurrencyKindEnumMap = {
  RecurrencyKind.daily: 'Daily',
  RecurrencyKind.weekly: 'Weekly',
};

SetChargingProfileReq _$SetChargingProfileReqFromJson(
        Map<String, dynamic> json) =>
    SetChargingProfileReq(
      connectorId: (json['connectorId'] as num).toInt(),
      csChargingProfiles: ChargingProfile.fromJson(
          json['csChargingProfiles'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SetChargingProfileReqToJson(
        SetChargingProfileReq instance) =>
    <String, dynamic>{
      'connectorId': instance.connectorId,
      'csChargingProfiles': instance.csChargingProfiles.toJson(),
    };

SetChargingProfileConf _$SetChargingProfileConfFromJson(
        Map<String, dynamic> json) =>
    SetChargingProfileConf(
      status: $enumDecode(_$ChargingProfileStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$SetChargingProfileConfToJson(
        SetChargingProfileConf instance) =>
    <String, dynamic>{
      'status': _$ChargingProfileStatusEnumMap[instance.status]!,
    };

const _$ChargingProfileStatusEnumMap = {
  ChargingProfileStatus.accepted: 'Accepted',
  ChargingProfileStatus.rejected: 'Rejected',
  ChargingProfileStatus.notSupported: 'NotSupported',
};

ClearChargingProfileReq _$ClearChargingProfileReqFromJson(
        Map<String, dynamic> json) =>
    ClearChargingProfileReq(
      id: (json['id'] as num?)?.toInt(),
      connectorId: (json['connectorId'] as num?)?.toInt(),
      chargingProfilePurpose: $enumDecodeNullable(
          _$ChargingProfilePurposeEnumMap, json['chargingProfilePurpose']),
      stackLevel: (json['stackLevel'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ClearChargingProfileReqToJson(
        ClearChargingProfileReq instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.connectorId case final value?) 'connectorId': value,
      if (_$ChargingProfilePurposeEnumMap[instance.chargingProfilePurpose]
          case final value?)
        'chargingProfilePurpose': value,
      if (instance.stackLevel case final value?) 'stackLevel': value,
    };

ClearChargingProfileConf _$ClearChargingProfileConfFromJson(
        Map<String, dynamic> json) =>
    ClearChargingProfileConf(
      status: $enumDecode(_$ClearChargingProfileStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$ClearChargingProfileConfToJson(
        ClearChargingProfileConf instance) =>
    <String, dynamic>{
      'status': _$ClearChargingProfileStatusEnumMap[instance.status]!,
    };

const _$ClearChargingProfileStatusEnumMap = {
  ClearChargingProfileStatus.accepted: 'Accepted',
  ClearChargingProfileStatus.unknown: 'Unknown',
};

GetCompositeScheduleReq _$GetCompositeScheduleReqFromJson(
        Map<String, dynamic> json) =>
    GetCompositeScheduleReq(
      connectorId: (json['connectorId'] as num).toInt(),
      duration: (json['duration'] as num).toInt(),
      chargingRateUnit: $enumDecodeNullable(
          _$ChargingRateUnitEnumMap, json['chargingRateUnit']),
    );

Map<String, dynamic> _$GetCompositeScheduleReqToJson(
        GetCompositeScheduleReq instance) =>
    <String, dynamic>{
      'connectorId': instance.connectorId,
      'duration': instance.duration,
      if (_$ChargingRateUnitEnumMap[instance.chargingRateUnit]
          case final value?)
        'chargingRateUnit': value,
    };

GetCompositeScheduleConf _$GetCompositeScheduleConfFromJson(
        Map<String, dynamic> json) =>
    GetCompositeScheduleConf(
      status: $enumDecode(_$GetCompositeScheduleStatusEnumMap, json['status']),
      connectorId: (json['connectorId'] as num?)?.toInt(),
      scheduleStart: json['scheduleStart'] == null
          ? null
          : DateTime.parse(json['scheduleStart'] as String),
      chargingSchedule: json['chargingSchedule'] == null
          ? null
          : ChargingSchedule.fromJson(
              json['chargingSchedule'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetCompositeScheduleConfToJson(
        GetCompositeScheduleConf instance) =>
    <String, dynamic>{
      'status': _$GetCompositeScheduleStatusEnumMap[instance.status]!,
      if (instance.connectorId case final value?) 'connectorId': value,
      if (instance.scheduleStart?.toIso8601String() case final value?)
        'scheduleStart': value,
      if (instance.chargingSchedule?.toJson() case final value?)
        'chargingSchedule': value,
    };

const _$GetCompositeScheduleStatusEnumMap = {
  GetCompositeScheduleStatus.accepted: 'Accepted',
  GetCompositeScheduleStatus.rejected: 'Rejected',
};
