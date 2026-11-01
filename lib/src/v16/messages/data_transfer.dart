import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'data_transfer.g.dart';

/// OCPP 1.6 `DataTransfer.req`. [data] is a string.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class DataTransferReq {
  DataTransferReq({required this.vendorId, this.messageId, this.data});

  factory DataTransferReq.fromJson(Map<String, dynamic> json) =>
      _$DataTransferReqFromJson(json);

  final String vendorId;
  final String? messageId;
  final String? data;

  Map<String, dynamic> toJson() => _$DataTransferReqToJson(this);
}

/// OCPP 1.6 `DataTransfer.conf`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class DataTransferConf {
  DataTransferConf({required this.status, this.data});

  factory DataTransferConf.fromJson(Map<String, dynamic> json) =>
      _$DataTransferConfFromJson(json);

  final DataTransferStatus status;
  final String? data;

  Map<String, dynamic> toJson() => _$DataTransferConfToJson(this);
}
