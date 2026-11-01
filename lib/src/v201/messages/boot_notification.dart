import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';
import 'common.dart';

part 'boot_notification.g.dart';

/// OCPP 2.0.1 `ModemType`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ModemType {
  ModemType({this.iccid, this.imsi});

  factory ModemType.fromJson(Map<String, dynamic> json) =>
      _$ModemTypeFromJson(json);

  final String? iccid;
  final String? imsi;

  Map<String, dynamic> toJson() => _$ModemTypeToJson(this);
}

/// OCPP 2.0.1 `ChargingStationType`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ChargingStationType {
  ChargingStationType(
      {this.serialNumber,
      required this.model,
      required this.vendorName,
      this.firmwareVersion,
      this.modem});

  factory ChargingStationType.fromJson(Map<String, dynamic> json) =>
      _$ChargingStationTypeFromJson(json);

  final String? serialNumber;
  final String model;
  final String vendorName;
  final String? firmwareVersion;
  final ModemType? modem;

  Map<String, dynamic> toJson() => _$ChargingStationTypeToJson(this);
}

/// OCPP 2.0.1 `BootNotificationRequest`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class BootNotificationRequest {
  BootNotificationRequest(
      {required this.reason, required this.chargingStation});

  factory BootNotificationRequest.fromJson(Map<String, dynamic> json) =>
      _$BootNotificationRequestFromJson(json);

  final BootReasonEnumType reason;
  final ChargingStationType chargingStation;

  Map<String, dynamic> toJson() => _$BootNotificationRequestToJson(this);
}

/// OCPP 2.0.1 `BootNotificationResponse`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class BootNotificationResponse {
  BootNotificationResponse(
      {required this.currentTime,
      required this.interval,
      required this.status,
      this.statusInfo});

  factory BootNotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$BootNotificationResponseFromJson(json);

  final DateTime currentTime;
  final int interval;
  final RegistrationStatusEnumType status;
  final StatusInfoType? statusInfo;

  Map<String, dynamic> toJson() => _$BootNotificationResponseToJson(this);
}
