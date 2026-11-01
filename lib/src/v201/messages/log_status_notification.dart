import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'log_status_notification.g.dart';

/// OCPP 2.0.1 `LogStatusNotificationRequest`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class LogStatusNotificationRequest {
  LogStatusNotificationRequest({required this.status, this.requestId});

  factory LogStatusNotificationRequest.fromJson(Map<String, dynamic> json) =>
      _$LogStatusNotificationRequestFromJson(json);

  final UploadLogStatusEnumType status;
  final int? requestId;

  Map<String, dynamic> toJson() => _$LogStatusNotificationRequestToJson(this);
}

/// OCPP 2.0.1 `LogStatusNotificationResponse` (empty payload).
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class LogStatusNotificationResponse {
  const LogStatusNotificationResponse();

  factory LogStatusNotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$LogStatusNotificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LogStatusNotificationResponseToJson(this);
}
