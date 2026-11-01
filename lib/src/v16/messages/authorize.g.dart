// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authorize.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorizeReq _$AuthorizeReqFromJson(Map<String, dynamic> json) => AuthorizeReq(
      idTag: json['idTag'] as String,
    );

Map<String, dynamic> _$AuthorizeReqToJson(AuthorizeReq instance) =>
    <String, dynamic>{
      'idTag': instance.idTag,
    };

AuthorizeConf _$AuthorizeConfFromJson(Map<String, dynamic> json) =>
    AuthorizeConf(
      idTagInfo: IdTagInfo.fromJson(json['idTagInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthorizeConfToJson(AuthorizeConf instance) =>
    <String, dynamic>{
      'idTagInfo': instance.idTagInfo.toJson(),
    };
