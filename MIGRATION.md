# Migrating OCPP 1.6 to 2.0.1

`V16ToV201Translator` (and the reverse `V201ToV16Translator`) convert message
objects. They are best-effort: 2.0.1 restructured several messages, so some
data has no destination. Items marked **LOST** are dropped; **DEFAULT** means
a value is invented because the target requires it.

## Global assumptions

* **Connector -> EVSE.** v1.6 has flat connector ids; 2.0.1 has
  `evse.id` + `evse.connectorId`. We use `evseId == connectorId` (override
  with the `evseId` parameter).
* **Transaction ids.** v1.6 ids are integers assigned by the Central System in
  `StartTransaction.conf`; 2.0.1 ids are client-generated strings. Translators
  take `transactionId` as input where needed and stringify integers.
* **idTag type.** v1.6 `idTag` is untyped; mapped to `IdTokenEnumType.ISO14443`.
* **seqNo.** 2.0.1 `TransactionEvent.seqNo` must increase per transaction;
  callers pass it (default 0).
* **Timestamps** are passed through as UTC `DateTime`s.

## Per-message mapping

### BootNotification
| v1.6 | v2.0.1 |
|------|--------|
| chargePointVendor | chargingStation.vendorName |
| chargePointModel | chargingStation.model |
| chargePointSerialNumber (else chargeBoxSerialNumber) | chargingStation.serialNumber |
| firmwareVersion | chargingStation.firmwareVersion |
| iccid, imsi | chargingStation.modem.{iccid,imsi} |
| chargeBoxSerialNumber (when a serial exists), meterType, meterSerialNumber | **LOST** |
| - | `reason` **DEFAULT** `PowerUp` (parameter) |

Reverse loses `reason`; `statusInfo` is response-only.

### Authorize
`idTag` -> `idToken.idToken` with type ISO14443 (**DEFAULT**). Reverse drops
the token type and `certificate`. Status reverse mapping: NoCredit,
NotAllowedTypeEVSE, NotAtThisLocation, NotAtThisTime, Unknown collapse to
`Invalid`.

### StartTransaction -> TransactionEvent(Started)
* eventType `Started`, triggerReason `Authorized`.
* `meterStart` becomes a `Transaction.Begin` sampled value
  (`Energy.Active.Import.Register`, unit Wh). Reverse reads it back
  (kWh converted to Wh).
* `reservationId`, `idTag`, `connectorId`, `timestamp` carried over.
* 2.0.1 `idTokenInfo` in the response replaces v1.6 `idTagInfo`;
  `transactionId` is no longer returned by the CS.

### StopTransaction -> TransactionEvent(Ended)
* eventType `Ended`. triggerReason defaults to `EVDeparted`. The brief asked
  for "EVDisconnected", but that is a *stop reason* in 2.0.1, not a trigger
  reason; it is placed in `transactionInfo.stoppedReason` (default when
  `reason` is absent). Refinements: `Remote` -> `RemoteStop`, `DeAuthorized`
  -> `Deauthorized`, `Local` -> `StopAuthorized`.
* Reason mapping is by name, except `HardReset`/`SoftReset` ->
  `ImmediateReset` and `UnlockCommand` -> `Other` (**lossy**).
* `meterStop` -> `Transaction.End` sampled value; `transactionData` ->
  `meterValue`.
* v1.6 `connectorId` is not in StopTransaction, so `evse` is a parameter.
* Reverse **LOSES**: triggerReason, seqNo, chargingState, timeSpentCharging,
  evse, offline, cableMaxCurrent, numberOfPhasesUsed. 2.0.1 stop reasons
  without a v1.6 value (GroundFault, Timeout, ...) become `Other`.

### MeterValues -> TransactionEvent(Updated)
* triggerReason `MeterValuePeriodic` (**DEFAULT**; `MeterValueClock` may be
  more accurate for `Sample.Clock` readings).
* Sample `value` string -> number; non-numeric (SignedData) values become
  0 (**LOST**). `format` is **LOST**. `unit` -> `unitOfMeasure.unit`
  (multiplier unset).
* v1.6 allows MeterValues outside a transaction; 2.0.1 requires a
  transaction id, so the translator throws `ArgumentError` in that case.
* Reverse: `transactionId` parsed to int only when numeric.

### StatusNotification
| v1.6 ChargePointStatus | v2.0.1 ConnectorStatusEnumType |
|---|---|
| Available | Available |
| Preparing, Charging, SuspendedEV, SuspendedEVSE, Finishing | Occupied |
| Reserved | Reserved |
| Unavailable | Unavailable |
| Faulted | Faulted |

**LOST**: `errorCode`, `info`, `vendorId`, `vendorErrorCode` (2.0.1 reports
faults via NotifyEvent). The fine occupied states move to
`TransactionEvent.transactionInfo.chargingState`
(`V16ToV201Translator.chargingState` gives the hint). `timestamp` is
**DEFAULT**ed to now when absent.

Reverse: `Occupied` -> `Preparing` unless `occupiedAs` is given;
`errorCode` is `NoError` (`OtherError` for Faulted); `evseId` dropped.

### DataTransfer
v1.6 `data` is a string; 2.0.1 `data` is any JSON. Forward passes the string
through. Reverse stringifies non-string data with `toString()` (**lossy**).
2.0.1 `statusInfo` has no v1.6 equivalent.

### FirmwareStatusNotification
Names map 1:1 for the seven v1.6 states. 2.0.1 adds states and `requestId`
(no v1.6 source, left null).

### DiagnosticsStatusNotification / LogStatusNotification
v1.6 `DiagnosticsStatusNotification` is replaced in 2.0.1 by
`LogStatusNotification`; no automatic translator is provided because
`requestId` and the log-type semantics differ.

### Heartbeat
Identical shape; no translation needed.

## 0.2.0 additions

All translators below exist in both directions, for the request and for the
response (`xxxResponse` methods). Enum values that share a name map by name.

### Reservation (ReserveNow, CancelReservation)
| v1.6 | v2.0.1 |
|------|--------|
| reservationId | id |
| connectorId (0 = any) | evseId (null = any), otherwise `evseId == connectorId` |
| expiryDate | expiryDateTime |
| idTag | idToken (type **DEFAULT** ISO14443, parameter) |
| parentIdTag | groupIdToken |
| - | connectorType (new; parameter, default null) |

Reverse **LOSES** `connectorType`, token types and `statusInfo`.
`ReservationStatus` <-> `ReserveNowStatusEnumType` and the cancel statuses map
1:1.

### Smart charging (SetChargingProfile, ClearChargingProfile, GetCompositeSchedule)
| v1.6 | v2.0.1 |
|------|--------|
| chargingProfileId | id |
| csChargingProfiles | chargingProfile (`ChargingProfileType`) |
| connectorId | evseId (0 = whole station in both) |
| transactionId (int) | transactionId (string) |
| chargingSchedule (single) | chargingSchedule (list of 1..3) |
| ChargePointMaxProfile | ChargingStationMaxProfile |
| ClearChargingProfile `id` | `chargingProfileId` |
| ClearChargingProfile `connectorId`, `chargingProfilePurpose`, `stackLevel` | `chargingProfileCriteria.{evseId, chargingProfilePurpose, stackLevel}` |

1.6 -> 2.0.1 **DEFAULT**s: the schedule `id` (required in 2.0.1) is set to the
profile id; `SetChargingProfile.conf` `NotSupported` collapses to `Rejected`;
a 1.6 `GetCompositeSchedule.conf` carrying a schedule must also carry
`connectorId` and a start time (`scheduleStart` or `startSchedule`) because
2.0.1's `CompositeScheduleType` requires them (otherwise `ArgumentError`);
`duration` defaults to 0.

2.0.1 -> 1.6 **LOST** / lossy:
* `salesTariff` (ISO 15118 pricing) on a schedule: dropped.
* Only the **first** of the 1..3 `chargingSchedule` entries is kept; schedule
  `id` and period `phaseToUse` are dropped.
* `transactionId` is kept only when it parses as an integer, otherwise null
  (the profile then loses its transaction binding; a `TxProfile` without a
  transaction is likely to be rejected by a 1.6 station).
* `ChargingStationExternalConstraints` has no 1.6 purpose (and a CSMS cannot
  set it): the translator throws `ArgumentError`, including in
  `ClearChargingProfile` criteria, rather than silently widening a clear.
* `statusInfo` on responses. A `CompositeScheduleType` is unpacked into
  `connectorId` + `scheduleStart` + `chargingSchedule`.
* `chargingLimitSource` (`ChargingLimitType`) has no 1.6 counterpart. In
  2.0.1 it is reported via `NotifyChargingLimit` / `ReportChargingProfiles`,
  not in `SetChargingProfile`; the model and enum are provided but not used
  by any translator.
* Periods: `startPeriod`, `limit`, `numberPhases` pass through unchanged.
  `ChargingRateUnit` `A`/`W` map by name; `minChargingRate`, `duration`,
  `startSchedule`, `recurrencyKind`, `validFrom`, `validTo` carry over.

### Local authorization list (SendLocalList, GetLocalListVersion)
| v1.6 | v2.0.1 |
|------|--------|
| listVersion | versionNumber |
| updateType (`UpdateType`) | updateType (`UpdateEnumType`) |
| AuthorizationData.idTag | AuthorizationDataType.idToken (type **DEFAULT** ISO14443) |
| AuthorizationData.idTagInfo | AuthorizationDataType.idTokenInfo |
| IdTagInfo.expiryDate | IdTokenInfoType.cacheExpiryDateTime |
| IdTagInfo.parentIdTag | IdTokenInfoType.groupIdToken |

* `SendLocalList.conf` `NotSupported` -> `Failed` (2.0.1 has no such status).
* Reverse **LOSES** token type, `chargingPriority`, `language1/2`, `evseId`
  and `statusInfo`; the status collapses with the existing Authorize rule
  (NoCredit, NotAllowedTypeEVSE, NotAtThisLocation, NotAtThisTime, Unknown ->
  `Invalid`).
* A missing `idTagInfo` / `idTokenInfo` in a Differential update (meaning
  delete) is preserved as null.
* `GetLocalListVersion` has an empty request; `listVersion` -1 (1.6: list
  unsupported) is passed through unchanged.
