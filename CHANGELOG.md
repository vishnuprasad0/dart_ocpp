## 0.2.0 - 2026-11-01
- Reservation: `ReserveNow` and `CancelReservation` for OCPP 1.6 (`ReserveNowReq/Conf`, `CancelReservationReq/Conf`) and 2.0.1 (`ReserveNowRequest/Response`, `CancelReservationRequest/Response`), with `ReservationStatus`, `CancelReservationStatus`, `ReserveNowStatusEnumType`, `CancelReservationStatusEnumType` and `ConnectorEnumType`.
- Smart charging: `SetChargingProfile`, `ClearChargingProfile`, `GetCompositeSchedule` for both versions, with full `ChargingProfile` / `ChargingSchedule` / `ChargingSchedulePeriod` models (2.0.1: `ChargingProfileType`, `ChargingScheduleType`, `ChargingSchedulePeriodType`, `SalesTariffType`, `CompositeScheduleType`, `ChargingLimitType`, `ChargingLimitSourceEnumType`).
- Local authorization list: `SendLocalList` and `GetLocalListVersion` for both versions (`AuthorizationData`, `UpdateType` for 1.6; `AuthorizationDataType` carrying `IdTokenInfoType`, `UpdateEnumType` for 2.0.1).
- Migration: request and response translators in both directions for all of the above, plus `idTagInfo` / `idTokenInfo` helpers. Lossy fields are documented in MIGRATION.md.
- Central-System-initiated typed messages: `OcppClient.on<T>(handler)` and `off<T>()`. Handled calls are decoded and answered (result; `OcppCallException` becomes a CALLERROR; other errors become `InternalError`) and are not emitted on `incoming`. Unmatched calls still arrive as raw `OcppCall`.

## 0.1.0 - 2026-11-01
- Initial release: OCPP 1.6-J and 2.0.1 message models, codec, client, migration helpers.
