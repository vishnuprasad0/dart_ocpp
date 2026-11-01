import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'status_notification.g.dart';

/// OCPP 2.0.1 `StatusNotificationRequest`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class StatusNotificationRequest {
  StatusNotificationRequest(
      {required this.timestamp,
      required this.connectorStatus,
      required this.evseId,
      required this.connectorId});

  factory StatusNotificationRequest.fromJson(Map<String, dynamic> json) =>
      _$StatusNotificationRequestFromJson(json);

  final DateTime timestamp;
  final ConnectorStatusEnumType connectorStatus;
  final int evseId;
  final int connectorId;

  Map<String, dynamic> toJson() => _$StatusNotificationRequestToJson(this);
}

/// OCPP 2.0.1 `StatusNotificationResponse` (empty payload).
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class StatusNotificationResponse {
  const StatusNotificationResponse();

  factory StatusNotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$StatusNotificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StatusNotificationResponseToJson(this);
}
