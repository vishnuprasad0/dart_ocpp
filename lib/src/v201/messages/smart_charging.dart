import 'package:json_annotation/json_annotation.dart';

import 'common.dart';
import 'enums.dart';

part 'smart_charging.g.dart';

/// OCPP 2.0.1 `ChargingSchedulePeriodType`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ChargingSchedulePeriodType {
  ChargingSchedulePeriodType(
      {required this.startPeriod,
      required this.limit,
      this.numberPhases,
      this.phaseToUse});

  factory ChargingSchedulePeriodType.fromJson(Map<String, dynamic> json) =>
      _$ChargingSchedulePeriodTypeFromJson(json);

  final int startPeriod;
  final double limit;
  final int? numberPhases;

  /// Phase (1..3) to use for single-phase charging on a 3-phase station.
  final int? phaseToUse;

  Map<String, dynamic> toJson() => _$ChargingSchedulePeriodTypeToJson(this);
}

/// OCPP 2.0.1 `RelativeTimeIntervalType`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RelativeTimeIntervalType {
  RelativeTimeIntervalType({required this.start, this.duration});

  factory RelativeTimeIntervalType.fromJson(Map<String, dynamic> json) =>
      _$RelativeTimeIntervalTypeFromJson(json);

  final int start;
  final int? duration;

  Map<String, dynamic> toJson() => _$RelativeTimeIntervalTypeToJson(this);
}

/// OCPP 2.0.1 `CostType`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class CostType {
  CostType(
      {required this.costKind, required this.amount, this.amountMultiplier});

  factory CostType.fromJson(Map<String, dynamic> json) =>
      _$CostTypeFromJson(json);

  final CostKindEnumType costKind;
  final int amount;
  final int? amountMultiplier;

  Map<String, dynamic> toJson() => _$CostTypeToJson(this);
}

/// OCPP 2.0.1 `ConsumptionCostType`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ConsumptionCostType {
  ConsumptionCostType({required this.startValue, required this.cost});

  factory ConsumptionCostType.fromJson(Map<String, dynamic> json) =>
      _$ConsumptionCostTypeFromJson(json);

  final double startValue;
  final List<CostType> cost;

  Map<String, dynamic> toJson() => _$ConsumptionCostTypeToJson(this);
}

/// OCPP 2.0.1 `SalesTariffEntryType`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class SalesTariffEntryType {
  SalesTariffEntryType(
      {required this.relativeTimeInterval,
      this.ePriceLevel,
      this.consumptionCost});

  factory SalesTariffEntryType.fromJson(Map<String, dynamic> json) =>
      _$SalesTariffEntryTypeFromJson(json);

  final RelativeTimeIntervalType relativeTimeInterval;
  final int? ePriceLevel;
  final List<ConsumptionCostType>? consumptionCost;

  Map<String, dynamic> toJson() => _$SalesTariffEntryTypeToJson(this);
}

/// OCPP 2.0.1 `SalesTariffType` (ISO 15118 price information). No OCPP 1.6
/// equivalent.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class SalesTariffType {
  SalesTariffType(
      {required this.id,
      this.salesTariffDescription,
      this.numEPriceLevels,
      required this.salesTariffEntry});

  factory SalesTariffType.fromJson(Map<String, dynamic> json) =>
      _$SalesTariffTypeFromJson(json);

  final int id;
  final String? salesTariffDescription;
  final int? numEPriceLevels;
  final List<SalesTariffEntryType> salesTariffEntry;

  Map<String, dynamic> toJson() => _$SalesTariffTypeToJson(this);
}

/// OCPP 2.0.1 `ChargingScheduleType`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ChargingScheduleType {
  ChargingScheduleType(
      {required this.id,
      this.startSchedule,
      this.duration,
      required this.chargingRateUnit,
      required this.chargingSchedulePeriod,
      this.minChargingRate,
      this.salesTariff});

  factory ChargingScheduleType.fromJson(Map<String, dynamic> json) =>
      _$ChargingScheduleTypeFromJson(json);

  final int id;
  final DateTime? startSchedule;
  final int? duration;
  final ChargingRateUnitEnumType chargingRateUnit;
  final List<ChargingSchedulePeriodType> chargingSchedulePeriod;
  final double? minChargingRate;
  final SalesTariffType? salesTariff;

  Map<String, dynamic> toJson() => _$ChargingScheduleTypeToJson(this);
}

/// OCPP 2.0.1 `ChargingProfileType`. [transactionId] is a string here (an
/// integer in v1.6). [chargingSchedule] holds 1 to 3 schedules.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ChargingProfileType {
  ChargingProfileType(
      {required this.id,
      required this.stackLevel,
      required this.chargingProfilePurpose,
      required this.chargingProfileKind,
      this.recurrencyKind,
      this.validFrom,
      this.validTo,
      this.transactionId,
      required this.chargingSchedule});

  factory ChargingProfileType.fromJson(Map<String, dynamic> json) =>
      _$ChargingProfileTypeFromJson(json);

  final int id;
  final int stackLevel;
  final ChargingProfilePurposeEnumType chargingProfilePurpose;
  final ChargingProfileKindEnumType chargingProfileKind;
  final RecurrencyKindEnumType? recurrencyKind;
  final DateTime? validFrom;
  final DateTime? validTo;
  final String? transactionId;
  final List<ChargingScheduleType> chargingSchedule;

  Map<String, dynamic> toJson() => _$ChargingProfileTypeToJson(this);
}

/// OCPP 2.0.1 `ChargingLimitType`: reports who limits charging
/// ([chargingLimitSource]); used by NotifyChargingLimit / ReportChargingProfiles
/// rather than by the three messages in this file.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ChargingLimitType {
  ChargingLimitType({required this.chargingLimitSource, this.isGridCritical});

  factory ChargingLimitType.fromJson(Map<String, dynamic> json) =>
      _$ChargingLimitTypeFromJson(json);

  final ChargingLimitSourceEnumType chargingLimitSource;
  final bool? isGridCritical;

  Map<String, dynamic> toJson() => _$ChargingLimitTypeToJson(this);
}

/// OCPP 2.0.1 `SetChargingProfileRequest` (CSMS -> Charge Station).
/// [evseId] 0 targets the whole station.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class SetChargingProfileRequest {
  SetChargingProfileRequest(
      {required this.evseId, required this.chargingProfile});

  factory SetChargingProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$SetChargingProfileRequestFromJson(json);

  final int evseId;
  final ChargingProfileType chargingProfile;

  Map<String, dynamic> toJson() => _$SetChargingProfileRequestToJson(this);
}

/// OCPP 2.0.1 `SetChargingProfileResponse`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class SetChargingProfileResponse {
  SetChargingProfileResponse({required this.status, this.statusInfo});

  factory SetChargingProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$SetChargingProfileResponseFromJson(json);

  final ChargingProfileStatusEnumType status;
  final StatusInfoType? statusInfo;

  Map<String, dynamic> toJson() => _$SetChargingProfileResponseToJson(this);
}

/// OCPP 2.0.1 `ClearChargingProfileType` (the `chargingProfileCriteria`).
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ClearChargingProfileType {
  ClearChargingProfileType(
      {this.evseId, this.chargingProfilePurpose, this.stackLevel});

  factory ClearChargingProfileType.fromJson(Map<String, dynamic> json) =>
      _$ClearChargingProfileTypeFromJson(json);

  final int? evseId;
  final ChargingProfilePurposeEnumType? chargingProfilePurpose;
  final int? stackLevel;

  Map<String, dynamic> toJson() => _$ClearChargingProfileTypeToJson(this);
}

/// OCPP 2.0.1 `ClearChargingProfileRequest` (CSMS -> Charge Station).
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ClearChargingProfileRequest {
  ClearChargingProfileRequest(
      {this.chargingProfileId, this.chargingProfileCriteria});

  factory ClearChargingProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$ClearChargingProfileRequestFromJson(json);

  final int? chargingProfileId;
  final ClearChargingProfileType? chargingProfileCriteria;

  Map<String, dynamic> toJson() => _$ClearChargingProfileRequestToJson(this);
}

/// OCPP 2.0.1 `ClearChargingProfileResponse`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ClearChargingProfileResponse {
  ClearChargingProfileResponse({required this.status, this.statusInfo});

  factory ClearChargingProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ClearChargingProfileResponseFromJson(json);

  final ClearChargingProfileStatusEnumType status;
  final StatusInfoType? statusInfo;

  Map<String, dynamic> toJson() => _$ClearChargingProfileResponseToJson(this);
}

/// OCPP 2.0.1 `GetCompositeScheduleRequest` (CSMS -> Charge Station).
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class GetCompositeScheduleRequest {
  GetCompositeScheduleRequest(
      {required this.duration, this.chargingRateUnit, required this.evseId});

  factory GetCompositeScheduleRequest.fromJson(Map<String, dynamic> json) =>
      _$GetCompositeScheduleRequestFromJson(json);

  final int duration;
  final ChargingRateUnitEnumType? chargingRateUnit;
  final int evseId;

  Map<String, dynamic> toJson() => _$GetCompositeScheduleRequestToJson(this);
}

/// OCPP 2.0.1 `CompositeScheduleType`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class CompositeScheduleType {
  CompositeScheduleType(
      {required this.chargingSchedulePeriod,
      required this.evseId,
      required this.duration,
      required this.scheduleStart,
      required this.chargingRateUnit});

  factory CompositeScheduleType.fromJson(Map<String, dynamic> json) =>
      _$CompositeScheduleTypeFromJson(json);

  final List<ChargingSchedulePeriodType> chargingSchedulePeriod;
  final int evseId;
  final int duration;
  final DateTime scheduleStart;
  final ChargingRateUnitEnumType chargingRateUnit;

  Map<String, dynamic> toJson() => _$CompositeScheduleTypeToJson(this);
}

/// OCPP 2.0.1 `GetCompositeScheduleResponse`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class GetCompositeScheduleResponse {
  GetCompositeScheduleResponse(
      {required this.status, this.statusInfo, this.schedule});

  factory GetCompositeScheduleResponse.fromJson(Map<String, dynamic> json) =>
      _$GetCompositeScheduleResponseFromJson(json);

  final GenericStatusEnumType status;
  final StatusInfoType? statusInfo;
  final CompositeScheduleType? schedule;

  Map<String, dynamic> toJson() => _$GetCompositeScheduleResponseToJson(this);
}
