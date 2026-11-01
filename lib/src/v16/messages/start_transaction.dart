import 'package:json_annotation/json_annotation.dart';

import 'common.dart';

part 'start_transaction.g.dart';

/// OCPP 1.6 `StartTransaction.req`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class StartTransactionReq {
  StartTransactionReq(
      {required this.connectorId,
      required this.idTag,
      required this.meterStart,
      required this.timestamp,
      this.reservationId});

  factory StartTransactionReq.fromJson(Map<String, dynamic> json) =>
      _$StartTransactionReqFromJson(json);

  final int connectorId;
  final String idTag;
  final int meterStart;
  final DateTime timestamp;
  final int? reservationId;

  Map<String, dynamic> toJson() => _$StartTransactionReqToJson(this);
}

/// OCPP 1.6 `StartTransaction.conf`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class StartTransactionConf {
  StartTransactionConf({required this.transactionId, required this.idTagInfo});

  factory StartTransactionConf.fromJson(Map<String, dynamic> json) =>
      _$StartTransactionConfFromJson(json);

  final int transactionId;
  final IdTagInfo idTagInfo;

  Map<String, dynamic> toJson() => _$StartTransactionConfToJson(this);
}
