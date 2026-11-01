// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_transfer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataTransferRequest _$DataTransferRequestFromJson(Map<String, dynamic> json) =>
    DataTransferRequest(
      vendorId: json['vendorId'] as String,
      messageId: json['messageId'] as String?,
      data: json['data'],
    );

Map<String, dynamic> _$DataTransferRequestToJson(
        DataTransferRequest instance) =>
    <String, dynamic>{
      'vendorId': instance.vendorId,
      if (instance.messageId case final value?) 'messageId': value,
      if (instance.data case final value?) 'data': value,
    };

DataTransferResponse _$DataTransferResponseFromJson(
        Map<String, dynamic> json) =>
    DataTransferResponse(
      status: $enumDecode(_$DataTransferStatusEnumTypeEnumMap, json['status']),
      statusInfo: json['statusInfo'] == null
          ? null
          : StatusInfoType.fromJson(json['statusInfo'] as Map<String, dynamic>),
      data: json['data'],
    );

Map<String, dynamic> _$DataTransferResponseToJson(
        DataTransferResponse instance) =>
    <String, dynamic>{
      'status': _$DataTransferStatusEnumTypeEnumMap[instance.status]!,
      if (instance.statusInfo?.toJson() case final value?) 'statusInfo': value,
      if (instance.data case final value?) 'data': value,
    };

const _$DataTransferStatusEnumTypeEnumMap = {
  DataTransferStatusEnumType.accepted: 'Accepted',
  DataTransferStatusEnumType.rejected: 'Rejected',
  DataTransferStatusEnumType.unknownMessageId: 'UnknownMessageId',
  DataTransferStatusEnumType.unknownVendorId: 'UnknownVendorId',
};
