// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionType _$TransactionTypeFromJson(Map<String, dynamic> json) =>
    TransactionType(
      transactionId: json['transactionId'] as String,
      chargingState: $enumDecodeNullable(
          _$ChargingStateEnumTypeEnumMap, json['chargingState']),
      timeSpentCharging: (json['timeSpentCharging'] as num?)?.toInt(),
      stoppedReason:
          $enumDecodeNullable(_$ReasonEnumTypeEnumMap, json['stoppedReason']),
      remoteStartId: (json['remoteStartId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TransactionTypeToJson(TransactionType instance) =>
    <String, dynamic>{
      'transactionId': instance.transactionId,
      if (_$ChargingStateEnumTypeEnumMap[instance.chargingState]
          case final value?)
        'chargingState': value,
      if (instance.timeSpentCharging case final value?)
        'timeSpentCharging': value,
      if (_$ReasonEnumTypeEnumMap[instance.stoppedReason] case final value?)
        'stoppedReason': value,
      if (instance.remoteStartId case final value?) 'remoteStartId': value,
    };

const _$ChargingStateEnumTypeEnumMap = {
  ChargingStateEnumType.charging: 'Charging',
  ChargingStateEnumType.evConnected: 'EVConnected',
  ChargingStateEnumType.suspendedEV: 'SuspendedEV',
  ChargingStateEnumType.suspendedEVSE: 'SuspendedEVSE',
  ChargingStateEnumType.idle: 'Idle',
};

const _$ReasonEnumTypeEnumMap = {
  ReasonEnumType.deAuthorized: 'DeAuthorized',
  ReasonEnumType.emergencyStop: 'EmergencyStop',
  ReasonEnumType.energyLimitReached: 'EnergyLimitReached',
  ReasonEnumType.evDisconnected: 'EVDisconnected',
  ReasonEnumType.groundFault: 'GroundFault',
  ReasonEnumType.immediateReset: 'ImmediateReset',
  ReasonEnumType.local: 'Local',
  ReasonEnumType.localOutOfCredit: 'LocalOutOfCredit',
  ReasonEnumType.masterPass: 'MasterPass',
  ReasonEnumType.other: 'Other',
  ReasonEnumType.overcurrentFault: 'OvercurrentFault',
  ReasonEnumType.powerLoss: 'PowerLoss',
  ReasonEnumType.powerQuality: 'PowerQuality',
  ReasonEnumType.reboot: 'Reboot',
  ReasonEnumType.remote: 'Remote',
  ReasonEnumType.socLimitReached: 'SOCLimitReached',
  ReasonEnumType.stoppedByEV: 'StoppedByEV',
  ReasonEnumType.timeLimitReached: 'TimeLimitReached',
  ReasonEnumType.timeout: 'Timeout',
};

TransactionEventRequest _$TransactionEventRequestFromJson(
        Map<String, dynamic> json) =>
    TransactionEventRequest(
      eventType:
          $enumDecode(_$TransactionEventEnumTypeEnumMap, json['eventType']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      triggerReason:
          $enumDecode(_$TriggerReasonEnumTypeEnumMap, json['triggerReason']),
      seqNo: (json['seqNo'] as num).toInt(),
      transactionInfo: TransactionType.fromJson(
          json['transactionInfo'] as Map<String, dynamic>),
      meterValue: (json['meterValue'] as List<dynamic>?)
          ?.map((e) => MeterValueType.fromJson(e as Map<String, dynamic>))
          .toList(),
      offline: json['offline'] as bool?,
      numberOfPhasesUsed: (json['numberOfPhasesUsed'] as num?)?.toInt(),
      cableMaxCurrent: (json['cableMaxCurrent'] as num?)?.toDouble(),
      reservationId: (json['reservationId'] as num?)?.toInt(),
      evse: json['evse'] == null
          ? null
          : EVSEType.fromJson(json['evse'] as Map<String, dynamic>),
      idToken: json['idToken'] == null
          ? null
          : IdTokenType.fromJson(json['idToken'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionEventRequestToJson(
        TransactionEventRequest instance) =>
    <String, dynamic>{
      'eventType': _$TransactionEventEnumTypeEnumMap[instance.eventType]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'triggerReason': _$TriggerReasonEnumTypeEnumMap[instance.triggerReason]!,
      'seqNo': instance.seqNo,
      'transactionInfo': instance.transactionInfo.toJson(),
      if (instance.meterValue?.map((e) => e.toJson()).toList()
          case final value?)
        'meterValue': value,
      if (instance.offline case final value?) 'offline': value,
      if (instance.numberOfPhasesUsed case final value?)
        'numberOfPhasesUsed': value,
      if (instance.cableMaxCurrent case final value?) 'cableMaxCurrent': value,
      if (instance.reservationId case final value?) 'reservationId': value,
      if (instance.evse?.toJson() case final value?) 'evse': value,
      if (instance.idToken?.toJson() case final value?) 'idToken': value,
    };

const _$TransactionEventEnumTypeEnumMap = {
  TransactionEventEnumType.ended: 'Ended',
  TransactionEventEnumType.started: 'Started',
  TransactionEventEnumType.updated: 'Updated',
};

const _$TriggerReasonEnumTypeEnumMap = {
  TriggerReasonEnumType.abnormalCondition: 'AbnormalCondition',
  TriggerReasonEnumType.authorized: 'Authorized',
  TriggerReasonEnumType.cablePluggedIn: 'CablePluggedIn',
  TriggerReasonEnumType.chargingRateChanged: 'ChargingRateChanged',
  TriggerReasonEnumType.chargingStateChanged: 'ChargingStateChanged',
  TriggerReasonEnumType.deauthorized: 'Deauthorized',
  TriggerReasonEnumType.energyLimitReached: 'EnergyLimitReached',
  TriggerReasonEnumType.evCommunicationLost: 'EVCommunicationLost',
  TriggerReasonEnumType.evConnectTimeout: 'EVConnectTimeout',
  TriggerReasonEnumType.meterValueClock: 'MeterValueClock',
  TriggerReasonEnumType.meterValuePeriodic: 'MeterValuePeriodic',
  TriggerReasonEnumType.timeLimitReached: 'TimeLimitReached',
  TriggerReasonEnumType.trigger: 'Trigger',
  TriggerReasonEnumType.unlockCommand: 'UnlockCommand',
  TriggerReasonEnumType.stopAuthorized: 'StopAuthorized',
  TriggerReasonEnumType.evDeparted: 'EVDeparted',
  TriggerReasonEnumType.evDetected: 'EVDetected',
  TriggerReasonEnumType.remoteStop: 'RemoteStop',
  TriggerReasonEnumType.remoteStart: 'RemoteStart',
  TriggerReasonEnumType.resetCommand: 'ResetCommand',
  TriggerReasonEnumType.signedDataReceived: 'SignedDataReceived',
};

TransactionEventResponse _$TransactionEventResponseFromJson(
        Map<String, dynamic> json) =>
    TransactionEventResponse(
      totalCost: (json['totalCost'] as num?)?.toDouble(),
      chargingPriority: (json['chargingPriority'] as num?)?.toInt(),
      idTokenInfo: json['idTokenInfo'] == null
          ? null
          : IdTokenInfoType.fromJson(
              json['idTokenInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionEventResponseToJson(
        TransactionEventResponse instance) =>
    <String, dynamic>{
      if (instance.totalCost case final value?) 'totalCost': value,
      if (instance.chargingPriority case final value?)
        'chargingPriority': value,
      if (instance.idTokenInfo?.toJson() case final value?)
        'idTokenInfo': value,
    };
