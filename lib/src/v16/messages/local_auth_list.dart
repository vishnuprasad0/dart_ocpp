import 'package:json_annotation/json_annotation.dart';

import 'common.dart';
import 'enums.dart';

part 'local_auth_list.g.dart';

/// OCPP 1.6 `AuthorizationData`. A missing [idTagInfo] in a Differential
/// update means remove this tag from the list.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class AuthorizationData {
  AuthorizationData({required this.idTag, this.idTagInfo});

  factory AuthorizationData.fromJson(Map<String, dynamic> json) =>
      _$AuthorizationDataFromJson(json);

  final String idTag;
  final IdTagInfo? idTagInfo;

  Map<String, dynamic> toJson() => _$AuthorizationDataToJson(this);
}

/// OCPP 1.6 `SendLocalList.req` (Central System -> Charge Point).
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class SendLocalListReq {
  SendLocalListReq(
      {required this.listVersion,
      this.localAuthorizationList,
      required this.updateType});

  factory SendLocalListReq.fromJson(Map<String, dynamic> json) =>
      _$SendLocalListReqFromJson(json);

  final int listVersion;
  final List<AuthorizationData>? localAuthorizationList;
  final UpdateType updateType;

  Map<String, dynamic> toJson() => _$SendLocalListReqToJson(this);
}

/// OCPP 1.6 `SendLocalList.conf`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class SendLocalListConf {
  SendLocalListConf({required this.status});

  factory SendLocalListConf.fromJson(Map<String, dynamic> json) =>
      _$SendLocalListConfFromJson(json);

  final UpdateStatus status;

  Map<String, dynamic> toJson() => _$SendLocalListConfToJson(this);
}

/// OCPP 1.6 `GetLocalListVersion.req` (empty payload).
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class GetLocalListVersionReq {
  const GetLocalListVersionReq();

  factory GetLocalListVersionReq.fromJson(Map<String, dynamic> json) =>
      _$GetLocalListVersionReqFromJson(json);

  Map<String, dynamic> toJson() => _$GetLocalListVersionReqToJson(this);
}

/// OCPP 1.6 `GetLocalListVersion.conf`. -1 = local list unsupported,
/// 0 = empty list.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class GetLocalListVersionConf {
  GetLocalListVersionConf({required this.listVersion});

  factory GetLocalListVersionConf.fromJson(Map<String, dynamic> json) =>
      _$GetLocalListVersionConfFromJson(json);

  final int listVersion;

  Map<String, dynamic> toJson() => _$GetLocalListVersionConfToJson(this);
}
