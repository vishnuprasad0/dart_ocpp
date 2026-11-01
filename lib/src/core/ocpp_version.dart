/// Supported OCPP protocol versions.
enum OcppVersion {
  /// OCPP 1.6 over JSON (OCPP-J).
  v16('ocpp1.6'),

  /// OCPP 2.0.1 over JSON (OCPP-J).
  v201('ocpp2.0.1');

  const OcppVersion(this.subprotocol);

  /// The WebSocket subprotocol token negotiated during the HTTP upgrade.
  final String subprotocol;

  /// Looks up a version from a negotiated WebSocket subprotocol.
  static OcppVersion? fromSubprotocol(String? value) {
    for (final v in values) {
      if (v.subprotocol == value) return v;
    }
    return null;
  }
}
