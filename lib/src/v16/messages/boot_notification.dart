import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'boot_notification.g.dart';

/// OCPP 1.6 `BootNotification.req`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class BootNotificationReq {
  BootNotificationReq(
      {required this.chargePointVendor,
      required this.chargePointModel,
      this.chargePointSerialNumber,
      this.chargeBoxSerialNumber,
      this.firmwareVersion,
      this.iccid,
      this.imsi,
      this.meterType,
      this.meterSerialNumber});

  factory BootNotificationReq.fromJson(Map<String, dynamic> json) =>
      _$BootNotificationReqFromJson(json);

  final String chargePointVendor;
  final String chargePointModel;
  final String? chargePointSerialNumber;
  final String? chargeBoxSerialNumber;
  final String? firmwareVersion;
  final String? iccid;
  final String? imsi;
  final String? meterType;
  final String? meterSerialNumber;

  Map<String, dynamic> toJson() => _$BootNotificationReqToJson(this);
}

/// OCPP 1.6 `BootNotification.conf`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class BootNotificationConf {
  BootNotificationConf(
      {required this.status,
      required this.currentTime,
      required this.interval});

  factory BootNotificationConf.fromJson(Map<String, dynamic> json) =>
      _$BootNotificationConfFromJson(json);

  final RegistrationStatus status;
  final DateTime currentTime;
  final int interval;

  Map<String, dynamic> toJson() => _$BootNotificationConfToJson(this);
}
