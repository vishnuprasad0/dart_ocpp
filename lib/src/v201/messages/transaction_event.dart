import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';
import 'common.dart';

part 'transaction_event.g.dart';

/// OCPP 2.0.1 `TransactionType`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TransactionType {
  TransactionType(
      {required this.transactionId,
      this.chargingState,
      this.timeSpentCharging,
      this.stoppedReason,
      this.remoteStartId});

  factory TransactionType.fromJson(Map<String, dynamic> json) =>
      _$TransactionTypeFromJson(json);

  final String transactionId;
  final ChargingStateEnumType? chargingState;
  final int? timeSpentCharging;
  final ReasonEnumType? stoppedReason;
  final int? remoteStartId;

  Map<String, dynamic> toJson() => _$TransactionTypeToJson(this);
}

/// OCPP 2.0.1 `TransactionEventRequest` (replaces v1.6 StartTransaction, StopTransaction and MeterValues).
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TransactionEventRequest {
  TransactionEventRequest(
      {required this.eventType,
      required this.timestamp,
      required this.triggerReason,
      required this.seqNo,
      required this.transactionInfo,
      this.meterValue,
      this.offline,
      this.numberOfPhasesUsed,
      this.cableMaxCurrent,
      this.reservationId,
      this.evse,
      this.idToken});

  factory TransactionEventRequest.fromJson(Map<String, dynamic> json) =>
      _$TransactionEventRequestFromJson(json);

  final TransactionEventEnumType eventType;
  final DateTime timestamp;
  final TriggerReasonEnumType triggerReason;
  final int seqNo;
  final TransactionType transactionInfo;
  final List<MeterValueType>? meterValue;
  final bool? offline;
  final int? numberOfPhasesUsed;
  final double? cableMaxCurrent;
  final int? reservationId;
  final EVSEType? evse;
  final IdTokenType? idToken;

  Map<String, dynamic> toJson() => _$TransactionEventRequestToJson(this);
}

/// OCPP 2.0.1 `TransactionEventResponse`.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class TransactionEventResponse {
  TransactionEventResponse(
      {this.totalCost, this.chargingPriority, this.idTokenInfo});

  factory TransactionEventResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionEventResponseFromJson(json);

  final double? totalCost;
  final int? chargingPriority;
  final IdTokenInfoType? idTokenInfo;

  Map<String, dynamic> toJson() => _$TransactionEventResponseToJson(this);
}

/// Short alias matching the v1.6 `*Req` naming used by the migration helpers.
typedef TransactionEventReq = TransactionEventRequest;
