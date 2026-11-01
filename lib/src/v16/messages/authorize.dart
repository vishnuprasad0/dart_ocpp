import 'package:json_annotation/json_annotation.dart';

import 'common.dart';

part 'authorize.g.dart';

/// OCPP 1.6 `Authorize.req`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class AuthorizeReq {
  AuthorizeReq({required this.idTag});

  factory AuthorizeReq.fromJson(Map<String, dynamic> json) =>
      _$AuthorizeReqFromJson(json);

  final String idTag;

  Map<String, dynamic> toJson() => _$AuthorizeReqToJson(this);
}

/// OCPP 1.6 `Authorize.conf`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class AuthorizeConf {
  AuthorizeConf({required this.idTagInfo});

  factory AuthorizeConf.fromJson(Map<String, dynamic> json) =>
      _$AuthorizeConfFromJson(json);

  final IdTagInfo idTagInfo;

  Map<String, dynamic> toJson() => _$AuthorizeConfToJson(this);
}
