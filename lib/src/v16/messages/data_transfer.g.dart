// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_transfer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataTransferReq _$DataTransferReqFromJson(Map<String, dynamic> json) =>
    DataTransferReq(
      vendorId: json['vendorId'] as String,
      messageId: json['messageId'] as String?,
      data: json['data'] as String?,
    );

Map<String, dynamic> _$DataTransferReqToJson(DataTransferReq instance) =>
    <String, dynamic>{
      'vendorId': instance.vendorId,
      if (instance.messageId case final value?) 'messageId': value,
      if (instance.data case final value?) 'data': value,
    };

DataTransferConf _$DataTransferConfFromJson(Map<String, dynamic> json) =>
    DataTransferConf(
      status: $enumDecode(_$DataTransferStatusEnumMap, json['status']),
      data: json['data'] as String?,
    );

Map<String, dynamic> _$DataTransferConfToJson(DataTransferConf instance) =>
    <String, dynamic>{
      'status': _$DataTransferStatusEnumMap[instance.status]!,
      if (instance.data case final value?) 'data': value,
    };

const _$DataTransferStatusEnumMap = {
  DataTransferStatus.accepted: 'Accepted',
  DataTransferStatus.rejected: 'Rejected',
  DataTransferStatus.unknownMessageId: 'UnknownMessageId',
  DataTransferStatus.unknownVendorId: 'UnknownVendorId',
};
