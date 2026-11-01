import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'diagnostics_status_notification.g.dart';

/// OCPP 1.6 `DiagnosticsStatusNotification.req`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class DiagnosticsStatusNotificationReq {
  DiagnosticsStatusNotificationReq({required this.status});

  factory DiagnosticsStatusNotificationReq.fromJson(
          Map<String, dynamic> json) =>
      _$DiagnosticsStatusNotificationReqFromJson(json);

  final DiagnosticsStatus status;

  Map<String, dynamic> toJson() =>
      _$DiagnosticsStatusNotificationReqToJson(this);
}

/// OCPP 1.6 `DiagnosticsStatusNotification.conf` (empty payload).
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class DiagnosticsStatusNotificationConf {
  const DiagnosticsStatusNotificationConf();

  factory DiagnosticsStatusNotificationConf.fromJson(
          Map<String, dynamic> json) =>
      _$DiagnosticsStatusNotificationConfFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DiagnosticsStatusNotificationConfToJson(this);
}
