import 'package:json_annotation/json_annotation.dart';

import 'common.dart';
import 'enums.dart';

part 'local_auth_list.g.dart';

/// OCPP 2.0.1 `AuthorizationData` (named with a Type suffix to avoid clashing with v1.6). A missing [idTokenInfo] in a Differential
/// update means remove this token from the list.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class AuthorizationDataType {
  AuthorizationDataType({required this.idToken, this.idTokenInfo});

  factory AuthorizationDataType.fromJson(Map<String, dynamic> json) =>
      _$AuthorizationDataTypeFromJson(json);

  final IdTokenType idToken;
  final IdTokenInfoType? idTokenInfo;

  Map<String, dynamic> toJson() => _$AuthorizationDataTypeToJson(this);
}

/// OCPP 2.0.1 `SendLocalListRequest` (CSMS -> Charge Station).
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class SendLocalListRequest {
  SendLocalListRequest(
      {required this.versionNumber,
      required this.updateType,
      this.localAuthorizationList});

  factory SendLocalListRequest.fromJson(Map<String, dynamic> json) =>
      _$SendLocalListRequestFromJson(json);

  final int versionNumber;
  final UpdateEnumType updateType;
  final List<AuthorizationDataType>? localAuthorizationList;

  Map<String, dynamic> toJson() => _$SendLocalListRequestToJson(this);
}

/// OCPP 2.0.1 `SendLocalListResponse`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class SendLocalListResponse {
  SendLocalListResponse({required this.status, this.statusInfo});

  factory SendLocalListResponse.fromJson(Map<String, dynamic> json) =>
      _$SendLocalListResponseFromJson(json);

  final SendLocalListStatusEnumType status;
  final StatusInfoType? statusInfo;

  Map<String, dynamic> toJson() => _$SendLocalListResponseToJson(this);
}

/// OCPP 2.0.1 `GetLocalListVersionRequest` (empty payload).
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class GetLocalListVersionRequest {
  const GetLocalListVersionRequest();

  factory GetLocalListVersionRequest.fromJson(Map<String, dynamic> json) =>
      _$GetLocalListVersionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetLocalListVersionRequestToJson(this);
}

/// OCPP 2.0.1 `GetLocalListVersionResponse`. 0 = empty list.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class GetLocalListVersionResponse {
  GetLocalListVersionResponse({required this.versionNumber});

  factory GetLocalListVersionResponse.fromJson(Map<String, dynamic> json) =>
      _$GetLocalListVersionResponseFromJson(json);

  final int versionNumber;

  Map<String, dynamic> toJson() => _$GetLocalListVersionResponseToJson(this);
}
