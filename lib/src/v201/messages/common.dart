import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'common.g.dart';

/// OCPP 2.0.1 `IdTokenType`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class IdTokenType {
  IdTokenType({required this.idToken, required this.type});

  factory IdTokenType.fromJson(Map<String, dynamic> json) =>
      _$IdTokenTypeFromJson(json);

  final String idToken;
  final IdTokenEnumType type;

  Map<String, dynamic> toJson() => _$IdTokenTypeToJson(this);
}

/// OCPP 2.0.1 `StatusInfoType`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class StatusInfoType {
  StatusInfoType({required this.reasonCode, this.additionalInfo});

  factory StatusInfoType.fromJson(Map<String, dynamic> json) =>
      _$StatusInfoTypeFromJson(json);

  final String reasonCode;
  final String? additionalInfo;

  Map<String, dynamic> toJson() => _$StatusInfoTypeToJson(this);
}

/// OCPP 2.0.1 `IdTokenInfoType`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class IdTokenInfoType {
  IdTokenInfoType(
      {required this.status,
      this.cacheExpiryDateTime,
      this.chargingPriority,
      this.language1,
      this.evseId,
      this.groupIdToken,
      this.language2});

  factory IdTokenInfoType.fromJson(Map<String, dynamic> json) =>
      _$IdTokenInfoTypeFromJson(json);

  final AuthorizationStatusEnumType status;
  final DateTime? cacheExpiryDateTime;
  final int? chargingPriority;
  final String? language1;
  final List<int>? evseId;
  final IdTokenType? groupIdToken;
  final String? language2;

  Map<String, dynamic> toJson() => _$IdTokenInfoTypeToJson(this);
}

/// OCPP 2.0.1 `EVSEType`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class EVSEType {
  EVSEType({required this.id, this.connectorId});

  factory EVSEType.fromJson(Map<String, dynamic> json) =>
      _$EVSETypeFromJson(json);

  final int id;
  final int? connectorId;

  Map<String, dynamic> toJson() => _$EVSETypeToJson(this);
}

/// OCPP 2.0.1 `UnitOfMeasureType`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class UnitOfMeasureType {
  UnitOfMeasureType({this.unit, this.multiplier});

  factory UnitOfMeasureType.fromJson(Map<String, dynamic> json) =>
      _$UnitOfMeasureTypeFromJson(json);

  final String? unit;
  final int? multiplier;

  Map<String, dynamic> toJson() => _$UnitOfMeasureTypeToJson(this);
}

/// OCPP 2.0.1 `SampledValueType`. [value] is numeric (a string in v1.6).
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class SampledValueType {
  SampledValueType(
      {required this.value,
      this.context,
      this.measurand,
      this.phase,
      this.location,
      this.unitOfMeasure});

  factory SampledValueType.fromJson(Map<String, dynamic> json) =>
      _$SampledValueTypeFromJson(json);

  final double value;
  final ReadingContextEnumType? context;
  final String? measurand;
  final String? phase;
  final LocationEnumType? location;
  final UnitOfMeasureType? unitOfMeasure;

  Map<String, dynamic> toJson() => _$SampledValueTypeToJson(this);
}

/// OCPP 2.0.1 `MeterValueType`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class MeterValueType {
  MeterValueType({required this.timestamp, required this.sampledValue});

  factory MeterValueType.fromJson(Map<String, dynamic> json) =>
      _$MeterValueTypeFromJson(json);

  final DateTime timestamp;
  final List<SampledValueType> sampledValue;

  Map<String, dynamic> toJson() => _$MeterValueTypeToJson(this);
}
