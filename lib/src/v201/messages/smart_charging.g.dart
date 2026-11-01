// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_charging.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChargingSchedulePeriodType _$ChargingSchedulePeriodTypeFromJson(
        Map<String, dynamic> json) =>
    ChargingSchedulePeriodType(
      startPeriod: (json['startPeriod'] as num).toInt(),
      limit: (json['limit'] as num).toDouble(),
      numberPhases: (json['numberPhases'] as num?)?.toInt(),
      phaseToUse: (json['phaseToUse'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ChargingSchedulePeriodTypeToJson(
        ChargingSchedulePeriodType instance) =>
    <String, dynamic>{
      'startPeriod': instance.startPeriod,
      'limit': instance.limit,
      if (instance.numberPhases case final value?) 'numberPhases': value,
      if (instance.phaseToUse case final value?) 'phaseToUse': value,
    };

RelativeTimeIntervalType _$RelativeTimeIntervalTypeFromJson(
        Map<String, dynamic> json) =>
    RelativeTimeIntervalType(
      start: (json['start'] as num).toInt(),
      duration: (json['duration'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RelativeTimeIntervalTypeToJson(
        RelativeTimeIntervalType instance) =>
    <String, dynamic>{
      'start': instance.start,
      if (instance.duration case final value?) 'duration': value,
    };

CostType _$CostTypeFromJson(Map<String, dynamic> json) => CostType(
      costKind: $enumDecode(_$CostKindEnumTypeEnumMap, json['costKind']),
      amount: (json['amount'] as num).toInt(),
      amountMultiplier: (json['amountMultiplier'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CostTypeToJson(CostType instance) => <String, dynamic>{
      'costKind': _$CostKindEnumTypeEnumMap[instance.costKind]!,
      'amount': instance.amount,
      if (instance.amountMultiplier case final value?)
        'amountMultiplier': value,
    };

const _$CostKindEnumTypeEnumMap = {
  CostKindEnumType.carbonDioxideEmission: 'CarbonDioxideEmission',
  CostKindEnumType.relativePricePercentage: 'RelativePricePercentage',
  CostKindEnumType.renewableGenerationPercentage:
      'RenewableGenerationPercentage',
};

ConsumptionCostType _$ConsumptionCostTypeFromJson(Map<String, dynamic> json) =>
    ConsumptionCostType(
      startValue: (json['startValue'] as num).toDouble(),
      cost: (json['cost'] as List<dynamic>)
          .map((e) => CostType.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ConsumptionCostTypeToJson(
        ConsumptionCostType instance) =>
    <String, dynamic>{
      'startValue': instance.startValue,
      'cost': instance.cost.map((e) => e.toJson()).toList(),
    };

SalesTariffEntryType _$SalesTariffEntryTypeFromJson(
        Map<String, dynamic> json) =>
    SalesTariffEntryType(
      relativeTimeInterval: RelativeTimeIntervalType.fromJson(
          json['relativeTimeInterval'] as Map<String, dynamic>),
      ePriceLevel: (json['ePriceLevel'] as num?)?.toInt(),
      consumptionCost: (json['consumptionCost'] as List<dynamic>?)
          ?.map((e) => ConsumptionCostType.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SalesTariffEntryTypeToJson(
        SalesTariffEntryType instance) =>
    <String, dynamic>{
      'relativeTimeInterval': instance.relativeTimeInterval.toJson(),
      if (instance.ePriceLevel case final value?) 'ePriceLevel': value,
      if (instance.consumptionCost?.map((e) => e.toJson()).toList()
          case final value?)
        'consumptionCost': value,
    };

SalesTariffType _$SalesTariffTypeFromJson(Map<String, dynamic> json) =>
    SalesTariffType(
      id: (json['id'] as num).toInt(),
      salesTariffDescription: json['salesTariffDescription'] as String?,
      numEPriceLevels: (json['numEPriceLevels'] as num?)?.toInt(),
      salesTariffEntry: (json['salesTariffEntry'] as List<dynamic>)
          .map((e) => SalesTariffEntryType.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SalesTariffTypeToJson(SalesTariffType instance) =>
    <String, dynamic>{
      'id': instance.id,
      if (instance.salesTariffDescription case final value?)
        'salesTariffDescription': value,
      if (instance.numEPriceLevels case final value?) 'numEPriceLevels': value,
      'salesTariffEntry':
          instance.salesTariffEntry.map((e) => e.toJson()).toList(),
    };

ChargingScheduleType _$ChargingScheduleTypeFromJson(
        Map<String, dynamic> json) =>
    ChargingScheduleType(
      id: (json['id'] as num).toInt(),
      startSchedule: json['startSchedule'] == null
          ? null
          : DateTime.parse(json['startSchedule'] as String),
      duration: (json['duration'] as num?)?.toInt(),
      chargingRateUnit: $enumDecode(
          _$ChargingRateUnitEnumTypeEnumMap, json['chargingRateUnit']),
      chargingSchedulePeriod: (json['chargingSchedulePeriod'] as List<dynamic>)
          .map((e) =>
              ChargingSchedulePeriodType.fromJson(e as Map<String, dynamic>))
          .toList(),
      minChargingRate: (json['minChargingRate'] as num?)?.toDouble(),
      salesTariff: json['salesTariff'] == null
          ? null
          : SalesTariffType.fromJson(
              json['salesTariff'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChargingScheduleTypeToJson(
        ChargingScheduleType instance) =>
    <String, dynamic>{
      'id': instance.id,
      if (instance.startSchedule?.toIso8601String() case final value?)
        'startSchedule': value,
      if (instance.duration case final value?) 'duration': value,
      'chargingRateUnit':
          _$ChargingRateUnitEnumTypeEnumMap[instance.chargingRateUnit]!,
      'chargingSchedulePeriod':
          instance.chargingSchedulePeriod.map((e) => e.toJson()).toList(),
      if (instance.minChargingRate case final value?) 'minChargingRate': value,
      if (instance.salesTariff?.toJson() case final value?)
        'salesTariff': value,
    };

const _$ChargingRateUnitEnumTypeEnumMap = {
  ChargingRateUnitEnumType.watts: 'W',
  ChargingRateUnitEnumType.amperes: 'A',
};

ChargingProfileType _$ChargingProfileTypeFromJson(Map<String, dynamic> json) =>
    ChargingProfileType(
      id: (json['id'] as num).toInt(),
      stackLevel: (json['stackLevel'] as num).toInt(),
      chargingProfilePurpose: $enumDecode(
          _$ChargingProfilePurposeEnumTypeEnumMap,
          json['chargingProfilePurpose']),
      chargingProfileKind: $enumDecode(
          _$ChargingProfileKindEnumTypeEnumMap, json['chargingProfileKind']),
      recurrencyKind: $enumDecodeNullable(
          _$RecurrencyKindEnumTypeEnumMap, json['recurrencyKind']),
      validFrom: json['validFrom'] == null
          ? null
          : DateTime.parse(json['validFrom'] as String),
      validTo: json['validTo'] == null
          ? null
          : DateTime.parse(json['validTo'] as String),
      transactionId: json['transactionId'] as String?,
      chargingSchedule: (json['chargingSchedule'] as List<dynamic>)
          .map((e) => ChargingScheduleType.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChargingProfileTypeToJson(
        ChargingProfileType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'stackLevel': instance.stackLevel,
      'chargingProfilePurpose': _$ChargingProfilePurposeEnumTypeEnumMap[
          instance.chargingProfilePurpose]!,
      'chargingProfileKind':
          _$ChargingProfileKindEnumTypeEnumMap[instance.chargingProfileKind]!,
      if (_$RecurrencyKindEnumTypeEnumMap[instance.recurrencyKind]
          case final value?)
        'recurrencyKind': value,
      if (instance.validFrom?.toIso8601String() case final value?)
        'validFrom': value,
      if (instance.validTo?.toIso8601String() case final value?)
        'validTo': value,
      if (instance.transactionId case final value?) 'transactionId': value,
      'chargingSchedule':
          instance.chargingSchedule.map((e) => e.toJson()).toList(),
    };

const _$ChargingProfilePurposeEnumTypeEnumMap = {
  ChargingProfilePurposeEnumType.chargingStationExternalConstraints:
      'ChargingStationExternalConstraints',
  ChargingProfilePurposeEnumType.chargingStationMaxProfile:
      'ChargingStationMaxProfile',
  ChargingProfilePurposeEnumType.txDefaultProfile: 'TxDefaultProfile',
  ChargingProfilePurposeEnumType.txProfile: 'TxProfile',
};

const _$ChargingProfileKindEnumTypeEnumMap = {
  ChargingProfileKindEnumType.absolute: 'Absolute',
  ChargingProfileKindEnumType.recurring: 'Recurring',
  ChargingProfileKindEnumType.relative: 'Relative',
};

const _$RecurrencyKindEnumTypeEnumMap = {
  RecurrencyKindEnumType.daily: 'Daily',
  RecurrencyKindEnumType.weekly: 'Weekly',
};

ChargingLimitType _$ChargingLimitTypeFromJson(Map<String, dynamic> json) =>
    ChargingLimitType(
      chargingLimitSource: $enumDecode(
          _$ChargingLimitSourceEnumTypeEnumMap, json['chargingLimitSource']),
      isGridCritical: json['isGridCritical'] as bool?,
    );

Map<String, dynamic> _$ChargingLimitTypeToJson(ChargingLimitType instance) =>
    <String, dynamic>{
      'chargingLimitSource':
          _$ChargingLimitSourceEnumTypeEnumMap[instance.chargingLimitSource]!,
      if (instance.isGridCritical case final value?) 'isGridCritical': value,
    };

const _$ChargingLimitSourceEnumTypeEnumMap = {
  ChargingLimitSourceEnumType.ems: 'EMS',
  ChargingLimitSourceEnumType.other: 'Other',
  ChargingLimitSourceEnumType.so: 'SO',
  ChargingLimitSourceEnumType.cso: 'CSO',
};

SetChargingProfileRequest _$SetChargingProfileRequestFromJson(
        Map<String, dynamic> json) =>
    SetChargingProfileRequest(
      evseId: (json['evseId'] as num).toInt(),
      chargingProfile: ChargingProfileType.fromJson(
          json['chargingProfile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SetChargingProfileRequestToJson(
        SetChargingProfileRequest instance) =>
    <String, dynamic>{
      'evseId': instance.evseId,
      'chargingProfile': instance.chargingProfile.toJson(),
    };

SetChargingProfileResponse _$SetChargingProfileResponseFromJson(
        Map<String, dynamic> json) =>
    SetChargingProfileResponse(
      status:
          $enumDecode(_$ChargingProfileStatusEnumTypeEnumMap, json['status']),
      statusInfo: json['statusInfo'] == null
          ? null
          : StatusInfoType.fromJson(json['statusInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SetChargingProfileResponseToJson(
        SetChargingProfileResponse instance) =>
    <String, dynamic>{
      'status': _$ChargingProfileStatusEnumTypeEnumMap[instance.status]!,
      if (instance.statusInfo?.toJson() case final value?) 'statusInfo': value,
    };

const _$ChargingProfileStatusEnumTypeEnumMap = {
  ChargingProfileStatusEnumType.accepted: 'Accepted',
  ChargingProfileStatusEnumType.rejected: 'Rejected',
};

ClearChargingProfileType _$ClearChargingProfileTypeFromJson(
        Map<String, dynamic> json) =>
    ClearChargingProfileType(
      evseId: (json['evseId'] as num?)?.toInt(),
      chargingProfilePurpose: $enumDecodeNullable(
          _$ChargingProfilePurposeEnumTypeEnumMap,
          json['chargingProfilePurpose']),
      stackLevel: (json['stackLevel'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ClearChargingProfileTypeToJson(
        ClearChargingProfileType instance) =>
    <String, dynamic>{
      if (instance.evseId case final value?) 'evseId': value,
      if (_$ChargingProfilePurposeEnumTypeEnumMap[
              instance.chargingProfilePurpose]
          case final value?)
        'chargingProfilePurpose': value,
      if (instance.stackLevel case final value?) 'stackLevel': value,
    };

ClearChargingProfileRequest _$ClearChargingProfileRequestFromJson(
        Map<String, dynamic> json) =>
    ClearChargingProfileRequest(
      chargingProfileId: (json['chargingProfileId'] as num?)?.toInt(),
      chargingProfileCriteria: json['chargingProfileCriteria'] == null
          ? null
          : ClearChargingProfileType.fromJson(
              json['chargingProfileCriteria'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ClearChargingProfileRequestToJson(
        ClearChargingProfileRequest instance) =>
    <String, dynamic>{
      if (instance.chargingProfileId case final value?)
        'chargingProfileId': value,
      if (instance.chargingProfileCriteria?.toJson() case final value?)
        'chargingProfileCriteria': value,
    };

ClearChargingProfileResponse _$ClearChargingProfileResponseFromJson(
        Map<String, dynamic> json) =>
    ClearChargingProfileResponse(
      status: $enumDecode(
          _$ClearChargingProfileStatusEnumTypeEnumMap, json['status']),
      statusInfo: json['statusInfo'] == null
          ? null
          : StatusInfoType.fromJson(json['statusInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ClearChargingProfileResponseToJson(
        ClearChargingProfileResponse instance) =>
    <String, dynamic>{
      'status': _$ClearChargingProfileStatusEnumTypeEnumMap[instance.status]!,
      if (instance.statusInfo?.toJson() case final value?) 'statusInfo': value,
    };

const _$ClearChargingProfileStatusEnumTypeEnumMap = {
  ClearChargingProfileStatusEnumType.accepted: 'Accepted',
  ClearChargingProfileStatusEnumType.unknown: 'Unknown',
};

GetCompositeScheduleRequest _$GetCompositeScheduleRequestFromJson(
        Map<String, dynamic> json) =>
    GetCompositeScheduleRequest(
      duration: (json['duration'] as num).toInt(),
      chargingRateUnit: $enumDecodeNullable(
          _$ChargingRateUnitEnumTypeEnumMap, json['chargingRateUnit']),
      evseId: (json['evseId'] as num).toInt(),
    );

Map<String, dynamic> _$GetCompositeScheduleRequestToJson(
        GetCompositeScheduleRequest instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      if (_$ChargingRateUnitEnumTypeEnumMap[instance.chargingRateUnit]
          case final value?)
        'chargingRateUnit': value,
      'evseId': instance.evseId,
    };

CompositeScheduleType _$CompositeScheduleTypeFromJson(
        Map<String, dynamic> json) =>
    CompositeScheduleType(
      chargingSchedulePeriod: (json['chargingSchedulePeriod'] as List<dynamic>)
          .map((e) =>
              ChargingSchedulePeriodType.fromJson(e as Map<String, dynamic>))
          .toList(),
      evseId: (json['evseId'] as num).toInt(),
      duration: (json['duration'] as num).toInt(),
      scheduleStart: DateTime.parse(json['scheduleStart'] as String),
      chargingRateUnit: $enumDecode(
          _$ChargingRateUnitEnumTypeEnumMap, json['chargingRateUnit']),
    );

Map<String, dynamic> _$CompositeScheduleTypeToJson(
        CompositeScheduleType instance) =>
    <String, dynamic>{
      'chargingSchedulePeriod':
          instance.chargingSchedulePeriod.map((e) => e.toJson()).toList(),
      'evseId': instance.evseId,
      'duration': instance.duration,
      'scheduleStart': instance.scheduleStart.toIso8601String(),
      'chargingRateUnit':
          _$ChargingRateUnitEnumTypeEnumMap[instance.chargingRateUnit]!,
    };

GetCompositeScheduleResponse _$GetCompositeScheduleResponseFromJson(
        Map<String, dynamic> json) =>
    GetCompositeScheduleResponse(
      status: $enumDecode(_$GenericStatusEnumTypeEnumMap, json['status']),
      statusInfo: json['statusInfo'] == null
          ? null
          : StatusInfoType.fromJson(json['statusInfo'] as Map<String, dynamic>),
      schedule: json['schedule'] == null
          ? null
          : CompositeScheduleType.fromJson(
              json['schedule'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetCompositeScheduleResponseToJson(
        GetCompositeScheduleResponse instance) =>
    <String, dynamic>{
      'status': _$GenericStatusEnumTypeEnumMap[instance.status]!,
      if (instance.statusInfo?.toJson() case final value?) 'statusInfo': value,
      if (instance.schedule?.toJson() case final value?) 'schedule': value,
    };

const _$GenericStatusEnumTypeEnumMap = {
  GenericStatusEnumType.accepted: 'Accepted',
  GenericStatusEnumType.rejected: 'Rejected',
};
