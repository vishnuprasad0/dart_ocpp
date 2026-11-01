import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'firmware_status_notification.g.dart';

/// OCPP 1.6 `FirmwareStatusNotification.req`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class FirmwareStatusNotificationReq {
  FirmwareStatusNotificationReq({required this.status});

  factory FirmwareStatusNotificationReq.fromJson(Map<String, dynamic> json) =>
      _$FirmwareStatusNotificationReqFromJson(json);

  final FirmwareStatus status;

  Map<String, dynamic> toJson() => _$FirmwareStatusNotificationReqToJson(this);
}

/// OCPP 1.6 `FirmwareStatusNotification.conf` (empty payload).
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class FirmwareStatusNotificationConf {
  const FirmwareStatusNotificationConf();

  factory FirmwareStatusNotificationConf.fromJson(Map<String, dynamic> json) =>
      _$FirmwareStatusNotificationConfFromJson(json);

  Map<String, dynamic> toJson() => _$FirmwareStatusNotificationConfToJson(this);
}
