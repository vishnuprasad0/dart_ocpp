// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StartTransactionReq _$StartTransactionReqFromJson(Map<String, dynamic> json) =>
    StartTransactionReq(
      connectorId: (json['connectorId'] as num).toInt(),
      idTag: json['idTag'] as String,
      meterStart: (json['meterStart'] as num).toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      reservationId: (json['reservationId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StartTransactionReqToJson(
        StartTransactionReq instance) =>
    <String, dynamic>{
      'connectorId': instance.connectorId,
      'idTag': instance.idTag,
      'meterStart': instance.meterStart,
      'timestamp': instance.timestamp.toIso8601String(),
      if (instance.reservationId case final value?) 'reservationId': value,
    };

StartTransactionConf _$StartTransactionConfFromJson(
        Map<String, dynamic> json) =>
    StartTransactionConf(
      transactionId: (json['transactionId'] as num).toInt(),
      idTagInfo: IdTagInfo.fromJson(json['idTagInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StartTransactionConfToJson(
        StartTransactionConf instance) =>
    <String, dynamic>{
      'transactionId': instance.transactionId,
      'idTagInfo': instance.idTagInfo.toJson(),
    };
