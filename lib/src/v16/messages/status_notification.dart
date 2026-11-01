import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'status_notification.g.dart';

/// OCPP 1.6 `StatusNotification.req`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class StatusNotificationReq {
  StatusNotificationReq(
      {required this.connectorId,
      required this.errorCode,
      this.info,
      required this.status,
      this.timestamp,
      this.vendorId,
      this.vendorErrorCode});

  factory StatusNotificationReq.fromJson(Map<String, dynamic> json) =>
      _$StatusNotificationReqFromJson(json);

  final int connectorId;
  final ChargePointErrorCode errorCode;
  final String? info;
  final ChargePointStatus status;
  final DateTime? timestamp;
  final String? vendorId;
  final String? vendorErrorCode;

  Map<String, dynamic> toJson() => _$StatusNotificationReqToJson(this);
}

/// OCPP 1.6 `StatusNotification.conf` (empty payload).
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class StatusNotificationConf {
  const StatusNotificationConf();

  factory StatusNotificationConf.fromJson(Map<String, dynamic> json) =>
      _$StatusNotificationConfFromJson(json);

  Map<String, dynamic> toJson() => _$StatusNotificationConfToJson(this);
}
