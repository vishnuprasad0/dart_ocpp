import 'package:json_annotation/json_annotation.dart';

part 'heartbeat.g.dart';

/// OCPP 2.0.1 `HeartbeatRequest` (empty payload).
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class HeartbeatRequest {
  const HeartbeatRequest();

  factory HeartbeatRequest.fromJson(Map<String, dynamic> json) =>
      _$HeartbeatRequestFromJson(json);

  Map<String, dynamic> toJson() => _$HeartbeatRequestToJson(this);
}

/// OCPP 2.0.1 `HeartbeatResponse`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class HeartbeatResponse {
  HeartbeatResponse({required this.currentTime});

  factory HeartbeatResponse.fromJson(Map<String, dynamic> json) =>
      _$HeartbeatResponseFromJson(json);

  final DateTime currentTime;

  Map<String, dynamic> toJson() => _$HeartbeatResponseToJson(this);
}
