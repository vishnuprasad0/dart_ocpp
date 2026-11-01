import 'package:json_annotation/json_annotation.dart';

import 'common.dart';

part 'meter_values.g.dart';

/// OCPP 1.6 `MeterValues.req`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class MeterValuesReq {
  MeterValuesReq(
      {required this.connectorId,
      this.transactionId,
      required this.meterValue});

  factory MeterValuesReq.fromJson(Map<String, dynamic> json) =>
      _$MeterValuesReqFromJson(json);

  final int connectorId;
  final int? transactionId;
  final List<MeterValue> meterValue;

  Map<String, dynamic> toJson() => _$MeterValuesReqToJson(this);
}

/// OCPP 1.6 `MeterValues.conf` (empty payload).
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class MeterValuesConf {
  const MeterValuesConf();

  factory MeterValuesConf.fromJson(Map<String, dynamic> json) =>
      _$MeterValuesConfFromJson(json);

  Map<String, dynamic> toJson() => _$MeterValuesConfToJson(this);
}
