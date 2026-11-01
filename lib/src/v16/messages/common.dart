import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'common.g.dart';

/// OCPP 1.6 `IdTagInfo`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class IdTagInfo {
  IdTagInfo({required this.status, this.expiryDate, this.parentIdTag});

  factory IdTagInfo.fromJson(Map<String, dynamic> json) =>
      _$IdTagInfoFromJson(json);

  final AuthorizationStatus status;
  final DateTime? expiryDate;
  final String? parentIdTag;

  Map<String, dynamic> toJson() => _$IdTagInfoToJson(this);
}

/// OCPP 1.6 `SampledValue`. [measurand], [phase] and [unit] are raw strings (long vendor-extensible enumerations).
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class SampledValue {
  SampledValue(
      {required this.value,
      this.context,
      this.format,
      this.measurand,
      this.phase,
      this.location,
      this.unit});

  factory SampledValue.fromJson(Map<String, dynamic> json) =>
      _$SampledValueFromJson(json);

  final String value;
  final ReadingContext? context;
  final ValueFormat? format;
  final String? measurand;
  final String? phase;
  final Location? location;
  final String? unit;

  Map<String, dynamic> toJson() => _$SampledValueToJson(this);
}

/// OCPP 1.6 `MeterValue`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class MeterValue {
  MeterValue({required this.timestamp, required this.sampledValue});

  factory MeterValue.fromJson(Map<String, dynamic> json) =>
      _$MeterValueFromJson(json);

  final DateTime timestamp;
  final List<SampledValue> sampledValue;

  Map<String, dynamic> toJson() => _$MeterValueToJson(this);
}
