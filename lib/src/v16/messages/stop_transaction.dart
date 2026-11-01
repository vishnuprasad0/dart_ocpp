import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';
import 'common.dart';

part 'stop_transaction.g.dart';

/// OCPP 1.6 `StopTransaction.req`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class StopTransactionReq {
  StopTransactionReq(
      {this.idTag,
      required this.meterStop,
      required this.timestamp,
      required this.transactionId,
      this.reason,
      this.transactionData});

  factory StopTransactionReq.fromJson(Map<String, dynamic> json) =>
      _$StopTransactionReqFromJson(json);

  final String? idTag;
  final int meterStop;
  final DateTime timestamp;
  final int transactionId;
  final Reason? reason;
  final List<MeterValue>? transactionData;

  Map<String, dynamic> toJson() => _$StopTransactionReqToJson(this);
}

/// OCPP 1.6 `StopTransaction.conf`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class StopTransactionConf {
  StopTransactionConf({this.idTagInfo});

  factory StopTransactionConf.fromJson(Map<String, dynamic> json) =>
      _$StopTransactionConfFromJson(json);

  final IdTagInfo? idTagInfo;

  Map<String, dynamic> toJson() => _$StopTransactionConfToJson(this);
}
