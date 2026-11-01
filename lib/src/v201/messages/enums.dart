import 'package:json_annotation/json_annotation.dart';

/// OCPP 2.0.1 `RegistrationStatusEnumType`: Boot registration result.
enum RegistrationStatusEnumType {
  @JsonValue('Accepted')
  accepted,
  @JsonValue('Pending')
  pending,
  @JsonValue('Rejected')
  rejected,
}

/// OCPP 2.0.1 `BootReasonEnumType`: Why the station booted.
enum BootReasonEnumType {
  @JsonValue('ApplicationReset')
  applicationReset,
  @JsonValue('FirmwareUpdate')
  firmwareUpdate,
  @JsonValue('LocalReset')
  localReset,
  @JsonValue('PowerUp')
  powerUp,
  @JsonValue('RemoteReset')
  remoteReset,
  @JsonValue('ScheduledReset')
  scheduledReset,
  @JsonValue('Triggered')
  triggered,
  @JsonValue('Unknown')
  unknown,
  @JsonValue('Watchdog')
  watchdog,
}

/// OCPP 2.0.1 `AuthorizationStatusEnumType`: Authorization outcome.
enum AuthorizationStatusEnumType {
  @JsonValue('Accepted')
  accepted,
  @JsonValue('Blocked')
  blocked,
  @JsonValue('ConcurrentTx')
  concurrentTx,
  @JsonValue('Expired')
  expired,
  @JsonValue('Invalid')
  invalid,
  @JsonValue('NoCredit')
  noCredit,
  @JsonValue('NotAllowedTypeEVSE')
  notAllowedTypeEVSE,
  @JsonValue('NotAtThisLocation')
  notAtThisLocation,
  @JsonValue('NotAtThisTime')
  notAtThisTime,
  @JsonValue('Unknown')
  unknown,
}

/// OCPP 2.0.1 `IdTokenEnumType`: Kind of identifier carried by an IdToken.
enum IdTokenEnumType {
  @JsonValue('Central')
  central,
  @JsonValue('eMAID')
  eMAID,
  @JsonValue('ISO14443')
  iso14443,
  @JsonValue('ISO15693')
  iso15693,
  @JsonValue('KeyCode')
  keyCode,
  @JsonValue('Local')
  local,
  @JsonValue('MacAddress')
  macAddress,
  @JsonValue('NoAuthorization')
  noAuthorization,
}

/// OCPP 2.0.1 `TransactionEventEnumType`: Position of a TransactionEvent in the transaction.
enum TransactionEventEnumType {
  @JsonValue('Ended')
  ended,
  @JsonValue('Started')
  started,
  @JsonValue('Updated')
  updated,
}

/// OCPP 2.0.1 `TriggerReasonEnumType`: What caused a TransactionEvent.
enum TriggerReasonEnumType {
  @JsonValue('AbnormalCondition')
  abnormalCondition,
  @JsonValue('Authorized')
  authorized,
  @JsonValue('CablePluggedIn')
  cablePluggedIn,
  @JsonValue('ChargingRateChanged')
  chargingRateChanged,
  @JsonValue('ChargingStateChanged')
  chargingStateChanged,
  @JsonValue('Deauthorized')
  deauthorized,
  @JsonValue('EnergyLimitReached')
  energyLimitReached,
  @JsonValue('EVCommunicationLost')
  evCommunicationLost,
  @JsonValue('EVConnectTimeout')
  evConnectTimeout,
  @JsonValue('MeterValueClock')
  meterValueClock,
  @JsonValue('MeterValuePeriodic')
  meterValuePeriodic,
  @JsonValue('TimeLimitReached')
  timeLimitReached,
  @JsonValue('Trigger')
  trigger,
  @JsonValue('UnlockCommand')
  unlockCommand,
  @JsonValue('StopAuthorized')
  stopAuthorized,
  @JsonValue('EVDeparted')
  evDeparted,
  @JsonValue('EVDetected')
  evDetected,
  @JsonValue('RemoteStop')
  remoteStop,
  @JsonValue('RemoteStart')
  remoteStart,
  @JsonValue('ResetCommand')
  resetCommand,
  @JsonValue('SignedDataReceived')
  signedDataReceived,
}

/// OCPP 2.0.1 `ChargingStateEnumType`: Charging state inside a transaction.
enum ChargingStateEnumType {
  @JsonValue('Charging')
  charging,
  @JsonValue('EVConnected')
  evConnected,
  @JsonValue('SuspendedEV')
  suspendedEV,
  @JsonValue('SuspendedEVSE')
  suspendedEVSE,
  @JsonValue('Idle')
  idle,
}

/// OCPP 2.0.1 `ReasonEnumType`: Why a transaction stopped (v1.6 `Reason`).
enum ReasonEnumType {
  @JsonValue('DeAuthorized')
  deAuthorized,
  @JsonValue('EmergencyStop')
  emergencyStop,
  @JsonValue('EnergyLimitReached')
  energyLimitReached,
  @JsonValue('EVDisconnected')
  evDisconnected,
  @JsonValue('GroundFault')
  groundFault,
  @JsonValue('ImmediateReset')
  immediateReset,
  @JsonValue('Local')
  local,
  @JsonValue('LocalOutOfCredit')
  localOutOfCredit,
  @JsonValue('MasterPass')
  masterPass,
  @JsonValue('Other')
  other,
  @JsonValue('OvercurrentFault')
  overcurrentFault,
  @JsonValue('PowerLoss')
  powerLoss,
  @JsonValue('PowerQuality')
  powerQuality,
  @JsonValue('Reboot')
  reboot,
  @JsonValue('Remote')
  remote,
  @JsonValue('SOCLimitReached')
  socLimitReached,
  @JsonValue('StoppedByEV')
  stoppedByEV,
  @JsonValue('TimeLimitReached')
  timeLimitReached,
  @JsonValue('Timeout')
  timeout,
}

/// OCPP 2.0.1 `ReadingContextEnumType`: Why a meter reading was taken.
enum ReadingContextEnumType {
  @JsonValue('Interruption.Begin')
  interruptionBegin,
  @JsonValue('Interruption.End')
  interruptionEnd,
  @JsonValue('Other')
  other,
  @JsonValue('Sample.Clock')
  sampleClock,
  @JsonValue('Sample.Periodic')
  samplePeriodic,
  @JsonValue('Transaction.Begin')
  transactionBegin,
  @JsonValue('Transaction.End')
  transactionEnd,
  @JsonValue('Trigger')
  trigger,
}

/// OCPP 2.0.1 `LocationEnumType`: Where a measurement was taken.
enum LocationEnumType {
  @JsonValue('Body')
  body,
  @JsonValue('Cable')
  cable,
  @JsonValue('EV')
  ev,
  @JsonValue('Inlet')
  inlet,
  @JsonValue('Outlet')
  outlet,
}

/// OCPP 2.0.1 `ConnectorStatusEnumType`: Per-connector status (replaces v1.6 ChargePointStatus).
enum ConnectorStatusEnumType {
  @JsonValue('Available')
  available,
  @JsonValue('Occupied')
  occupied,
  @JsonValue('Reserved')
  reserved,
  @JsonValue('Unavailable')
  unavailable,
  @JsonValue('Faulted')
  faulted,
}

/// OCPP 2.0.1 `DataTransferStatusEnumType`: DataTransfer outcome.
enum DataTransferStatusEnumType {
  @JsonValue('Accepted')
  accepted,
  @JsonValue('Rejected')
  rejected,
  @JsonValue('UnknownMessageId')
  unknownMessageId,
  @JsonValue('UnknownVendorId')
  unknownVendorId,
}

/// OCPP 2.0.1 `FirmwareStatusEnumType`: Firmware update progress.
enum FirmwareStatusEnumType {
  @JsonValue('Downloaded')
  downloaded,
  @JsonValue('DownloadFailed')
  downloadFailed,
  @JsonValue('Downloading')
  downloading,
  @JsonValue('DownloadScheduled')
  downloadScheduled,
  @JsonValue('DownloadPaused')
  downloadPaused,
  @JsonValue('Idle')
  idle,
  @JsonValue('InstallationFailed')
  installationFailed,
  @JsonValue('Installing')
  installing,
  @JsonValue('Installed')
  installed,
  @JsonValue('InstallRebooting')
  installRebooting,
  @JsonValue('InstallScheduled')
  installScheduled,
  @JsonValue('InstallVerificationFailed')
  installVerificationFailed,
  @JsonValue('InvalidSignature')
  invalidSignature,
  @JsonValue('SignatureVerified')
  signatureVerified,
}

/// OCPP 2.0.1 `UploadLogStatusEnumType`: Log upload progress.
enum UploadLogStatusEnumType {
  @JsonValue('BadMessage')
  badMessage,
  @JsonValue('Idle')
  idle,
  @JsonValue('NotSupportedOperation')
  notSupportedOperation,
  @JsonValue('PermissionDenied')
  permissionDenied,
  @JsonValue('Uploaded')
  uploaded,
  @JsonValue('UploadFailure')
  uploadFailure,
  @JsonValue('Uploading')
  uploading,
  @JsonValue('AcceptedCanceled')
  acceptedCanceled,
}

/// OCPP 2.0.1 `ReserveNowStatusEnumType`.
enum ReserveNowStatusEnumType {
  @JsonValue('Accepted')
  accepted,
  @JsonValue('Faulted')
  faulted,
  @JsonValue('Occupied')
  occupied,
  @JsonValue('Rejected')
  rejected,
  @JsonValue('Unavailable')
  unavailable,
}

/// OCPP 2.0.1 `CancelReservationStatusEnumType`.
enum CancelReservationStatusEnumType {
  @JsonValue('Accepted')
  accepted,
  @JsonValue('Rejected')
  rejected,
}

/// OCPP 2.0.1 `ConnectorEnumType`: connector kind that may be reserved.
enum ConnectorEnumType {
  @JsonValue('cCCS1')
  cCCS1,
  @JsonValue('cCCS2')
  cCCS2,
  @JsonValue('cG105')
  cG105,
  @JsonValue('cTesla')
  cTesla,
  @JsonValue('cType1')
  cType1,
  @JsonValue('cType2')
  cType2,
  @JsonValue('s309-1P-16A')
  s309_1P_16A,
  @JsonValue('s309-1P-32A')
  s309_1P_32A,
  @JsonValue('s309-3P-16A')
  s309_3P_16A,
  @JsonValue('s309-3P-32A')
  s309_3P_32A,
  @JsonValue('sBS1361')
  sBS1361,
  @JsonValue('sCEE-7-7')
  sCEE_7_7,
  @JsonValue('sType2')
  sType2,
  @JsonValue('sType3')
  sType3,
  @JsonValue('Other1PhMax16A')
  other1PhMax16A,
  @JsonValue('Other1PhOver16A')
  other1PhOver16A,
  @JsonValue('Other3Ph')
  other3Ph,
  @JsonValue('Pan')
  pan,
  @JsonValue('wInductive')
  wInductive,
  @JsonValue('wResonant')
  wResonant,
  @JsonValue('Undetermined')
  undetermined,
  @JsonValue('Unknown')
  unknown,
}

/// OCPP 2.0.1 `ChargingProfilePurposeEnumType`.
enum ChargingProfilePurposeEnumType {
  @JsonValue('ChargingStationExternalConstraints')
  chargingStationExternalConstraints,
  @JsonValue('ChargingStationMaxProfile')
  chargingStationMaxProfile,
  @JsonValue('TxDefaultProfile')
  txDefaultProfile,
  @JsonValue('TxProfile')
  txProfile,
}

/// OCPP 2.0.1 `ChargingProfileKindEnumType`.
enum ChargingProfileKindEnumType {
  @JsonValue('Absolute')
  absolute,
  @JsonValue('Recurring')
  recurring,
  @JsonValue('Relative')
  relative,
}

/// OCPP 2.0.1 `RecurrencyKindEnumType`.
enum RecurrencyKindEnumType {
  @JsonValue('Daily')
  daily,
  @JsonValue('Weekly')
  weekly,
}

/// OCPP 2.0.1 `ChargingRateUnitEnumType`.
enum ChargingRateUnitEnumType {
  @JsonValue('W')
  watts,
  @JsonValue('A')
  amperes,
}

/// OCPP 2.0.1 `ChargingLimitSourceEnumType`: who imposed a charging limit.
enum ChargingLimitSourceEnumType {
  @JsonValue('EMS')
  ems,
  @JsonValue('Other')
  other,
  @JsonValue('SO')
  so,
  @JsonValue('CSO')
  cso,
}

/// OCPP 2.0.1 `ChargingProfileStatusEnumType` (SetChargingProfile).
enum ChargingProfileStatusEnumType {
  @JsonValue('Accepted')
  accepted,
  @JsonValue('Rejected')
  rejected,
}

/// OCPP 2.0.1 `ClearChargingProfileStatusEnumType`.
enum ClearChargingProfileStatusEnumType {
  @JsonValue('Accepted')
  accepted,
  @JsonValue('Unknown')
  unknown,
}

/// OCPP 2.0.1 `GenericStatusEnumType` (GetCompositeSchedule).
enum GenericStatusEnumType {
  @JsonValue('Accepted')
  accepted,
  @JsonValue('Rejected')
  rejected,
}

/// OCPP 2.0.1 `CostKindEnumType` (SalesTariff).
enum CostKindEnumType {
  @JsonValue('CarbonDioxideEmission')
  carbonDioxideEmission,
  @JsonValue('RelativePricePercentage')
  relativePricePercentage,
  @JsonValue('RenewableGenerationPercentage')
  renewableGenerationPercentage,
}

/// OCPP 2.0.1 `UpdateEnumType` for `SendLocalList`.
enum UpdateEnumType {
  @JsonValue('Differential')
  differential,
  @JsonValue('Full')
  full,
}

/// OCPP 2.0.1 `SendLocalListStatusEnumType`.
enum SendLocalListStatusEnumType {
  @JsonValue('Accepted')
  accepted,
  @JsonValue('Failed')
  failed,
  @JsonValue('VersionMismatch')
  versionMismatch,
}
