import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'firmware_status_notification.g.dart';

/// OCPP 2.0.1 `FirmwareStatusNotificationRequest`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class FirmwareStatusNotificationRequest {
  FirmwareStatusNotificationRequest({required this.status, this.requestId});

  factory FirmwareStatusNotificationRequest.fromJson(
          Map<String, dynamic> json) =>
      _$FirmwareStatusNotificationRequestFromJson(json);

  final FirmwareStatusEnumType status;
  final int? requestId;

  Map<String, dynamic> toJson() =>
      _$FirmwareStatusNotificationRequestToJson(this);
}

/// OCPP 2.0.1 `FirmwareStatusNotificationResponse` (empty payload).
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class FirmwareStatusNotificationResponse {
  const FirmwareStatusNotificationResponse();

  factory FirmwareStatusNotificationResponse.fromJson(
          Map<String, dynamic> json) =>
      _$FirmwareStatusNotificationResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FirmwareStatusNotificationResponseToJson(this);
}
