// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_auth_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorizationData _$AuthorizationDataFromJson(Map<String, dynamic> json) =>
    AuthorizationData(
      idTag: json['idTag'] as String,
      idTagInfo: json['idTagInfo'] == null
          ? null
          : IdTagInfo.fromJson(json['idTagInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthorizationDataToJson(AuthorizationData instance) =>
    <String, dynamic>{
      'idTag': instance.idTag,
      if (instance.idTagInfo?.toJson() case final value?) 'idTagInfo': value,
    };

SendLocalListReq _$SendLocalListReqFromJson(Map<String, dynamic> json) =>
    SendLocalListReq(
      listVersion: (json['listVersion'] as num).toInt(),
      localAuthorizationList: (json['localAuthorizationList'] as List<dynamic>?)
          ?.map((e) => AuthorizationData.fromJson(e as Map<String, dynamic>))
          .toList(),
      updateType: $enumDecode(_$UpdateTypeEnumMap, json['updateType']),
    );

Map<String, dynamic> _$SendLocalListReqToJson(SendLocalListReq instance) =>
    <String, dynamic>{
      'listVersion': instance.listVersion,
      if (instance.localAuthorizationList?.map((e) => e.toJson()).toList()
          case final value?)
        'localAuthorizationList': value,
      'updateType': _$UpdateTypeEnumMap[instance.updateType]!,
    };

const _$UpdateTypeEnumMap = {
  UpdateType.differential: 'Differential',
  UpdateType.full: 'Full',
};

SendLocalListConf _$SendLocalListConfFromJson(Map<String, dynamic> json) =>
    SendLocalListConf(
      status: $enumDecode(_$UpdateStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$SendLocalListConfToJson(SendLocalListConf instance) =>
    <String, dynamic>{
      'status': _$UpdateStatusEnumMap[instance.status]!,
    };

const _$UpdateStatusEnumMap = {
  UpdateStatus.accepted: 'Accepted',
  UpdateStatus.failed: 'Failed',
  UpdateStatus.notSupported: 'NotSupported',
  UpdateStatus.versionMismatch: 'VersionMismatch',
};

GetLocalListVersionReq _$GetLocalListVersionReqFromJson(
        Map<String, dynamic> json) =>
    GetLocalListVersionReq();

Map<String, dynamic> _$GetLocalListVersionReqToJson(
        GetLocalListVersionReq instance) =>
    <String, dynamic>{};

GetLocalListVersionConf _$GetLocalListVersionConfFromJson(
        Map<String, dynamic> json) =>
    GetLocalListVersionConf(
      listVersion: (json['listVersion'] as num).toInt(),
    );

Map<String, dynamic> _$GetLocalListVersionConfToJson(
        GetLocalListVersionConf instance) =>
    <String, dynamic>{
      'listVersion': instance.listVersion,
    };
