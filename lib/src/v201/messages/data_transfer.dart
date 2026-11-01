import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';
import 'common.dart';

part 'data_transfer.g.dart';

/// OCPP 2.0.1 `DataTransferRequest`. [data] is arbitrary JSON.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class DataTransferRequest {
  DataTransferRequest({required this.vendorId, this.messageId, this.data});

  factory DataTransferRequest.fromJson(Map<String, dynamic> json) =>
      _$DataTransferRequestFromJson(json);

  final String vendorId;
  final String? messageId;
  final dynamic data;

  Map<String, dynamic> toJson() => _$DataTransferRequestToJson(this);
}

/// OCPP 2.0.1 `DataTransferResponse`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class DataTransferResponse {
  DataTransferResponse({required this.status, this.statusInfo, this.data});

  factory DataTransferResponse.fromJson(Map<String, dynamic> json) =>
      _$DataTransferResponseFromJson(json);

  final DataTransferStatusEnumType status;
  final StatusInfoType? statusInfo;
  final dynamic data;

  Map<String, dynamic> toJson() => _$DataTransferResponseToJson(this);
}
