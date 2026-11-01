import 'package:json_annotation/json_annotation.dart';

/// OCPP 1.6 `RegistrationStatus`.
enum RegistrationStatus {
  @JsonValue('Accepted')
  accepted,
  @JsonValue('Pending')
  pending,
  @JsonValue('Rejected')
  rejected,
}

/// OCPP 1.6 `AuthorizationStatus`.
enum AuthorizationStatus {
  @JsonValue('Accepted')
  accepted,
  @JsonValue('Blocked')
  blocked,
  @JsonValue('Expired')
  expired,
  @JsonValue('Invalid')
  invalid,
  @JsonValue('ConcurrentTx')
  concurrentTx,
}

/// OCPP 1.6 `ChargePointStatus` (v2.0.1 collapses this to ConnectorStatus).
enum ChargePointStatus {
  @JsonValue('Available')
  available,
  @JsonValue('Preparing')
  preparing,
  @JsonValue('Charging')
  charging,
  @JsonValue('SuspendedEVSE')
  suspendedEVSE,
  @JsonValue('SuspendedEV')
  suspendedEV,
  @JsonValue('Finishing')
  finishing,
  @JsonValue('Reserved')
  reserved,
  @JsonValue('Unavailable')
  unavailable,
  @JsonValue('Faulted')
  faulted,
}

/// OCPP 1.6 `ChargePointErrorCode` (no equivalent in 2.0.1 StatusNotification).
enum ChargePointErrorCode {
  @JsonValue('ConnectorLockFailure')
  connectorLockFailure,
  @JsonValue('EVCommunicationError')
  evCommunicationError,
  @JsonValue('GroundFailure')
  groundFailure,
  @JsonValue('HighTemperature')
  highTemperature,
  @JsonValue('InternalError')
  internalError,
  @JsonValue('LocalListConflict')
  localListConflict,
  @JsonValue('NoError')
  noError,
  @JsonValue('OtherError')
  otherError,
  @JsonValue('OverCurrentFailure')
  overCurrentFailure,
  @JsonValue('PowerMeterFailure')
  powerMeterFailure,
  @JsonValue('PowerSwitchFailure')
  powerSwitchFailure,
  @JsonValue('ReaderFailure')
  readerFailure,
  @JsonValue('ResetFailure')
  resetFailure,
  @JsonValue('UnderVoltage')
  underVoltage,
  @JsonValue('OverVoltage')
  overVoltage,
  @JsonValue('WeakSignal')
  weakSignal,
}

/// OCPP 1.6 StopTransaction `Reason`.
enum Reason {
  @JsonValue('EmergencyStop')
  emergencyStop,
  @JsonValue('EVDisconnected')
  evDisconnected,
  @JsonValue('HardReset')
  hardReset,
  @JsonValue('Local')
  local,
  @JsonValue('Other')
  other,
  @JsonValue('PowerLoss')
  powerLoss,
  @JsonValue('Reboot')
  reboot,
  @JsonValue('Remote')
  remote,
  @JsonValue('SoftReset')
  softReset,
  @JsonValue('UnlockCommand')
  unlockCommand,
  @JsonValue('DeAuthorized')
  deAuthorized,
}

/// OCPP 1.6 `ReadingContext`.
enum ReadingContext {
  @JsonValue('Interruption.Begin')
  interruptionBegin,
  @JsonValue('Interruption.End')
  interruptionEnd,
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
  @JsonValue('Other')
  other,
}

/// OCPP 1.6 `ValueFormat`.
enum ValueFormat {
  @JsonValue('Raw')
  raw,
  @JsonValue('SignedData')
  signedData,
}

/// OCPP 1.6 `Location` of a measurement.
enum Location {
  @JsonValue('Cable')
  cable,
  @JsonValue('EV')
  ev,
  @JsonValue('Inlet')
  inlet,
  @JsonValue('Outlet')
  outlet,
  @JsonValue('Body')
  body,
}

/// OCPP 1.6 DataTransfer `Status`.
enum DataTransferStatus {
  @JsonValue('Accepted')
  accepted,
  @JsonValue('Rejected')
  rejected,
  @JsonValue('UnknownMessageId')
  unknownMessageId,
  @JsonValue('UnknownVendorId')
  unknownVendorId,
}

/// OCPP 1.6 `FirmwareStatus`.
enum FirmwareStatus {
  @JsonValue('Downloaded')
  downloaded,
  @JsonValue('DownloadFailed')
  downloadFailed,
  @JsonValue('Downloading')
  downloading,
  @JsonValue('Idle')
  idle,
  @JsonValue('InstallationFailed')
  installationFailed,
  @JsonValue('Installing')
  installing,
  @JsonValue('Installed')
  installed,
}

/// OCPP 1.6 `DiagnosticsStatus`.
enum DiagnosticsStatus {
  @JsonValue('Idle')
  idle,
  @JsonValue('Uploaded')
  uploaded,
  @JsonValue('UploadFailed')
  uploadFailed,
  @JsonValue('Uploading')
  uploading,
}

/// OCPP 1.6 `ReserveNow` response `ReservationStatus`.
enum ReservationStatus {
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

/// OCPP 1.6 `CancelReservation` response `CancelReservationStatus`.
enum CancelReservationStatus {
  @JsonValue('Accepted')
  accepted,
  @JsonValue('Rejected')
  rejected,
}

/// OCPP 1.6 `ChargingProfilePurposeType`.
enum ChargingProfilePurpose {
  @JsonValue('ChargePointMaxProfile')
  chargePointMaxProfile,
  @JsonValue('TxDefaultProfile')
  txDefaultProfile,
  @JsonValue('TxProfile')
  txProfile,
}

/// OCPP 1.6 `ChargingProfileKindType`.
enum ChargingProfileKind {
  @JsonValue('Absolute')
  absolute,
  @JsonValue('Recurring')
  recurring,
  @JsonValue('Relative')
  relative,
}

/// OCPP 1.6 `RecurrencyKindType`.
enum RecurrencyKind {
  @JsonValue('Daily')
  daily,
  @JsonValue('Weekly')
  weekly,
}

/// OCPP 1.6 `ChargingRateUnitType`.
enum ChargingRateUnit {
  @JsonValue('A')
  amperes,
  @JsonValue('W')
  watts,
}

/// OCPP 1.6 `SetChargingProfile` response `ChargingProfileStatus`.
enum ChargingProfileStatus {
  @JsonValue('Accepted')
  accepted,
  @JsonValue('Rejected')
  rejected,
  @JsonValue('NotSupported')
  notSupported,
}

/// OCPP 1.6 `ClearChargingProfile` response `ClearChargingProfileStatus`.
enum ClearChargingProfileStatus {
  @JsonValue('Accepted')
  accepted,
  @JsonValue('Unknown')
  unknown,
}

/// OCPP 1.6 `GetCompositeSchedule` response `GetCompositeScheduleStatus`.
enum GetCompositeScheduleStatus {
  @JsonValue('Accepted')
  accepted,
  @JsonValue('Rejected')
  rejected,
}

/// OCPP 1.6 `UpdateType` for `SendLocalList`.
enum UpdateType {
  @JsonValue('Differential')
  differential,
  @JsonValue('Full')
  full,
}

/// OCPP 1.6 `SendLocalList` response `UpdateStatus`.
enum UpdateStatus {
  @JsonValue('Accepted')
  accepted,
  @JsonValue('Failed')
  failed,
  @JsonValue('NotSupported')
  notSupported,
  @JsonValue('VersionMismatch')
  versionMismatch,
}
