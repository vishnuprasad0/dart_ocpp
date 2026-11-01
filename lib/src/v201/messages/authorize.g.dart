// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authorize.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorizeRequest _$AuthorizeRequestFromJson(Map<String, dynamic> json) =>
    AuthorizeRequest(
      idToken: IdTokenType.fromJson(json['idToken'] as Map<String, dynamic>),
      certificate: json['certificate'] as String?,
    );

Map<String, dynamic> _$AuthorizeRequestToJson(AuthorizeRequest instance) =>
    <String, dynamic>{
      'idToken': instance.idToken.toJson(),
      if (instance.certificate case final value?) 'certificate': value,
    };

AuthorizeResponse _$AuthorizeResponseFromJson(Map<String, dynamic> json) =>
    AuthorizeResponse(
      idTokenInfo:
          IdTokenInfoType.fromJson(json['idTokenInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthorizeResponseToJson(AuthorizeResponse instance) =>
    <String, dynamic>{
      'idTokenInfo': instance.idTokenInfo.toJson(),
    };
