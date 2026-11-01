import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'smart_charging.g.dart';

/// OCPP 1.6 `ChargingSchedulePeriod`. [limit] is in the schedule's
/// [ChargingRateUnit].
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ChargingSchedulePeriod {
  ChargingSchedulePeriod(
      {required this.startPeriod, required this.limit, this.numberPhases});

  factory ChargingSchedulePeriod.fromJson(Map<String, dynamic> json) =>
      _$ChargingSchedulePeriodFromJson(json);

  /// Seconds from the start of the schedule.
  final int startPeriod;
  final double limit;
  final int? numberPhases;

  Map<String, dynamic> toJson() => _$ChargingSchedulePeriodToJson(this);
}

/// OCPP 1.6 `ChargingSchedule`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ChargingSchedule {
  ChargingSchedule(
      {this.duration,
      this.startSchedule,
      required this.chargingRateUnit,
      required this.chargingSchedulePeriod,
      this.minChargingRate});

  factory ChargingSchedule.fromJson(Map<String, dynamic> json) =>
      _$ChargingScheduleFromJson(json);

  final int? duration;
  final DateTime? startSchedule;
  final ChargingRateUnit chargingRateUnit;
  final List<ChargingSchedulePeriod> chargingSchedulePeriod;
  final double? minChargingRate;

  Map<String, dynamic> toJson() => _$ChargingScheduleToJson(this);
}

/// OCPP 1.6 `ChargingProfile` (`csChargingProfiles`).
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ChargingProfile {
  ChargingProfile(
      {required this.chargingProfileId,
      this.transactionId,
      required this.stackLevel,
      required this.chargingProfilePurpose,
      required this.chargingProfileKind,
      this.recurrencyKind,
      this.validFrom,
      this.validTo,
      required this.chargingSchedule});

  factory ChargingProfile.fromJson(Map<String, dynamic> json) =>
      _$ChargingProfileFromJson(json);

  final int chargingProfileId;
  final int? transactionId;
  final int stackLevel;
  final ChargingProfilePurpose chargingProfilePurpose;
  final ChargingProfileKind chargingProfileKind;
  final RecurrencyKind? recurrencyKind;
  final DateTime? validFrom;
  final DateTime? validTo;
  final ChargingSchedule chargingSchedule;

  Map<String, dynamic> toJson() => _$ChargingProfileToJson(this);
}

/// OCPP 1.6 `SetChargingProfile.req` (Central System -> Charge Point).
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class SetChargingProfileReq {
  SetChargingProfileReq(
      {required this.connectorId, required this.csChargingProfiles});

  factory SetChargingProfileReq.fromJson(Map<String, dynamic> json) =>
      _$SetChargingProfileReqFromJson(json);

  final int connectorId;
  final ChargingProfile csChargingProfiles;

  Map<String, dynamic> toJson() => _$SetChargingProfileReqToJson(this);
}

/// OCPP 1.6 `SetChargingProfile.conf`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class SetChargingProfileConf {
  SetChargingProfileConf({required this.status});

  factory SetChargingProfileConf.fromJson(Map<String, dynamic> json) =>
      _$SetChargingProfileConfFromJson(json);

  final ChargingProfileStatus status;

  Map<String, dynamic> toJson() => _$SetChargingProfileConfToJson(this);
}

/// OCPP 1.6 `ClearChargingProfile.req` (Central System -> Charge Point).
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ClearChargingProfileReq {
  ClearChargingProfileReq(
      {this.id,
      this.connectorId,
      this.chargingProfilePurpose,
      this.stackLevel});

  factory ClearChargingProfileReq.fromJson(Map<String, dynamic> json) =>
      _$ClearChargingProfileReqFromJson(json);

  final int? id;
  final int? connectorId;
  final ChargingProfilePurpose? chargingProfilePurpose;
  final int? stackLevel;

  Map<String, dynamic> toJson() => _$ClearChargingProfileReqToJson(this);
}

/// OCPP 1.6 `ClearChargingProfile.conf`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ClearChargingProfileConf {
  ClearChargingProfileConf({required this.status});

  factory ClearChargingProfileConf.fromJson(Map<String, dynamic> json) =>
      _$ClearChargingProfileConfFromJson(json);

  final ClearChargingProfileStatus status;

  Map<String, dynamic> toJson() => _$ClearChargingProfileConfToJson(this);
}

/// OCPP 1.6 `GetCompositeSchedule.req` (Central System -> Charge Point).
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class GetCompositeScheduleReq {
  GetCompositeScheduleReq(
      {required this.connectorId,
      required this.duration,
      this.chargingRateUnit});

  factory GetCompositeScheduleReq.fromJson(Map<String, dynamic> json) =>
      _$GetCompositeScheduleReqFromJson(json);

  final int connectorId;

  /// Length of the requested schedule in seconds.
  final int duration;
  final ChargingRateUnit? chargingRateUnit;

  Map<String, dynamic> toJson() => _$GetCompositeScheduleReqToJson(this);
}

/// OCPP 1.6 `GetCompositeSchedule.conf`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class GetCompositeScheduleConf {
  GetCompositeScheduleConf(
      {required this.status,
      this.connectorId,
      this.scheduleStart,
      this.chargingSchedule});

  factory GetCompositeScheduleConf.fromJson(Map<String, dynamic> json) =>
      _$GetCompositeScheduleConfFromJson(json);

  final GetCompositeScheduleStatus status;
  final int? connectorId;
  final DateTime? scheduleStart;
  final ChargingSchedule? chargingSchedule;

  Map<String, dynamic> toJson() => _$GetCompositeScheduleConfToJson(this);
}
