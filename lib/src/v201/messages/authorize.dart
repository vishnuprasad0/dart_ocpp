import 'package:json_annotation/json_annotation.dart';

import 'common.dart';

part 'authorize.g.dart';

/// OCPP 2.0.1 `AuthorizeRequest`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class AuthorizeRequest {
  AuthorizeRequest({required this.idToken, this.certificate});

  factory AuthorizeRequest.fromJson(Map<String, dynamic> json) =>
      _$AuthorizeRequestFromJson(json);

  final IdTokenType idToken;
  final String? certificate;

  Map<String, dynamic> toJson() => _$AuthorizeRequestToJson(this);
}

/// OCPP 2.0.1 `AuthorizeResponse`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class AuthorizeResponse {
  AuthorizeResponse({required this.idTokenInfo});

  factory AuthorizeResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthorizeResponseFromJson(json);

  final IdTokenInfoType idTokenInfo;

  Map<String, dynamic> toJson() => _$AuthorizeResponseToJson(this);
}
