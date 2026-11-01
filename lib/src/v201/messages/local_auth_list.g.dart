// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_auth_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorizationDataType _$AuthorizationDataTypeFromJson(
        Map<String, dynamic> json) =>
    AuthorizationDataType(
      idToken: IdTokenType.fromJson(json['idToken'] as Map<String, dynamic>),
      idTokenInfo: json['idTokenInfo'] == null
          ? null
          : IdTokenInfoType.fromJson(
              json['idTokenInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthorizationDataTypeToJson(
        AuthorizationDataType instance) =>
    <String, dynamic>{
      'idToken': instance.idToken.toJson(),
      if (instance.idTokenInfo?.toJson() case final value?)
        'idTokenInfo': value,
    };

SendLocalListRequest _$SendLocalListRequestFromJson(
        Map<String, dynamic> json) =>
    SendLocalListRequest(
      versionNumber: (json['versionNumber'] as num).toInt(),
      updateType: $enumDecode(_$UpdateEnumTypeEnumMap, json['updateType']),
      localAuthorizationList: (json['localAuthorizationList'] as List<dynamic>?)
          ?.map(
              (e) => AuthorizationDataType.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SendLocalListRequestToJson(
        SendLocalListRequest instance) =>
    <String, dynamic>{
      'versionNumber': instance.versionNumber,
      'updateType': _$UpdateEnumTypeEnumMap[instance.updateType]!,
      if (instance.localAuthorizationList?.map((e) => e.toJson()).toList()
          case final value?)
        'localAuthorizationList': value,
    };

const _$UpdateEnumTypeEnumMap = {
  UpdateEnumType.differential: 'Differential',
  UpdateEnumType.full: 'Full',
};

SendLocalListResponse _$SendLocalListResponseFromJson(
        Map<String, dynamic> json) =>
    SendLocalListResponse(
      status: $enumDecode(_$SendLocalListStatusEnumTypeEnumMap, json['status']),
      statusInfo: json['statusInfo'] == null
          ? null
          : StatusInfoType.fromJson(json['statusInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SendLocalListResponseToJson(
        SendLocalListResponse instance) =>
    <String, dynamic>{
      'status': _$SendLocalListStatusEnumTypeEnumMap[instance.status]!,
      if (instance.statusInfo?.toJson() case final value?) 'statusInfo': value,
    };

const _$SendLocalListStatusEnumTypeEnumMap = {
  SendLocalListStatusEnumType.accepted: 'Accepted',
  SendLocalListStatusEnumType.failed: 'Failed',
  SendLocalListStatusEnumType.versionMismatch: 'VersionMismatch',
};

GetLocalListVersionRequest _$GetLocalListVersionRequestFromJson(
        Map<String, dynamic> json) =>
    GetLocalListVersionRequest();

Map<String, dynamic> _$GetLocalListVersionRequestToJson(
        GetLocalListVersionRequest instance) =>
    <String, dynamic>{};

GetLocalListVersionResponse _$GetLocalListVersionResponseFromJson(
        Map<String, dynamic> json) =>
    GetLocalListVersionResponse(
      versionNumber: (json['versionNumber'] as num).toInt(),
    );

Map<String, dynamic> _$GetLocalListVersionResponseToJson(
        GetLocalListVersionResponse instance) =>
    <String, dynamic>{
      'versionNumber': instance.versionNumber,
    };
