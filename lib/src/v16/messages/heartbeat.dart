import 'package:json_annotation/json_annotation.dart';

part 'heartbeat.g.dart';

/// OCPP 1.6 `Heartbeat.req` (empty payload).
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class HeartbeatReq {
  const HeartbeatReq();

  factory HeartbeatReq.fromJson(Map<String, dynamic> json) =>
      _$HeartbeatReqFromJson(json);

  Map<String, dynamic> toJson() => _$HeartbeatReqToJson(this);
}

/// OCPP 1.6 `Heartbeat.conf`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class HeartbeatConf {
  HeartbeatConf({required this.currentTime});

  factory HeartbeatConf.fromJson(Map<String, dynamic> json) =>
      _$HeartbeatConfFromJson(json);

  final DateTime currentTime;

  Map<String, dynamic> toJson() => _$HeartbeatConfToJson(this);
}
