import 'dart:async';
import 'dart:math';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'ocpp_version.dart';

/// Text-frame transport used by [OcppClient]. Implement to plug in a custom
/// socket or an in-memory fake for tests.
abstract interface class OcppTransport {
  /// Inbound text frames. Stays valid across automatic reconnects.
  Stream<String> get frames;

  /// Whether the underlying socket is currently open.
  bool get isConnected;

  /// Opens the connection.
  Future<void> connect();

  /// Sends a text frame. Throws [StateError] when not connected.
  void send(String frame);

  /// Closes the connection and stops any reconnect attempts.
  Future<void> close();
}

/// Reconnect behaviour for [WebSocketOcppTransport].
class ReconnectPolicy {
  const ReconnectPolicy({
    this.initialDelay = const Duration(seconds: 1),
    this.maxDelay = const Duration(seconds: 60),
    this.maxAttempts,
  });

  /// Delay before the first retry; doubled on each failure.
  final Duration initialDelay;

  /// Upper bound for the backoff delay.
  final Duration maxDelay;

  /// Give up after this many consecutive failures (`null` = never).
  final int? maxAttempts;
}

/// Factory used to open a WebSocket; override in tests.
typedef WebSocketChannelFactory = WebSocketChannel Function(
    Uri uri, Iterable<String> protocols, Duration? pingInterval);

WebSocketChannel _defaultFactory(
        Uri uri, Iterable<String> protocols, Duration? pingInterval) =>
    IOWebSocketChannel.connect(uri,
        protocols: protocols, pingInterval: pingInterval);

/// WebSocket transport with OCPP subprotocol negotiation, a keep-alive
/// (WebSocket ping) heartbeat and optional exponential-backoff reconnect.
class WebSocketOcppTransport implements OcppTransport {
  WebSocketOcppTransport({
    required this.uri,
    required this.version,
    this.pingInterval = const Duration(seconds: 30),
    this.reconnect,
    WebSocketChannelFactory? channelFactory,
  }) : _factory = channelFactory ?? _defaultFactory;

  /// Full endpoint, including the charge point id path segment.
  final Uri uri;

  /// Version whose subprotocol is offered to the server.
  final OcppVersion version;

  /// WebSocket-level ping interval (`null` disables).
  final Duration? pingInterval;

  /// Reconnect policy; `null` disables reconnecting.
  final ReconnectPolicy? reconnect;

  final WebSocketChannelFactory _factory;
  final _controller = StreamController<String>.broadcast();
  WebSocketChannel? _channel;
  bool _closedByUser = false;
  bool _connected = false;

  @override
  Stream<String> get frames => _controller.stream;

  @override
  bool get isConnected => _connected;

  /// The subprotocol the server selected, once connected.
  String? get negotiatedProtocol => _channel?.protocol;

  @override
  Future<void> connect() async {
    _closedByUser = false;
    await _open();
  }

  Future<void> _open() async {
    final channel = _factory(uri, [version.subprotocol], pingInterval);
    await channel.ready;
    final selected = channel.protocol;
    if (selected != null && selected != version.subprotocol) {
      await channel.sink.close();
      throw StateError('Server selected unexpected subprotocol "$selected" '
          '(wanted ${version.subprotocol})');
    }
    _channel = channel;
    _connected = true;
    channel.stream.listen(
      (data) {
        if (data is String) _controller.add(data);
      },
      onError: _controller.addError,
      onDone: () {
        _connected = false;
        if (!_closedByUser && reconnect != null) unawaited(_reconnectLoop());
      },
    );
  }

  Future<void> _reconnectLoop() async {
    final policy = reconnect!;
    var delay = policy.initialDelay;
    var attempts = 0;
    while (!_closedByUser) {
      await Future<void>.delayed(delay);
      if (_closedByUser) return;
      try {
        await _open();
        return;
      } catch (_) {
        attempts++;
        if (policy.maxAttempts != null && attempts >= policy.maxAttempts!) {
          return;
        }
        delay = Duration(
            milliseconds:
                min(delay.inMilliseconds * 2, policy.maxDelay.inMilliseconds));
      }
    }
  }

  @override
  void send(String frame) {
    final c = _channel;
    if (c == null || !_connected) throw StateError('Transport not connected');
    c.sink.add(frame);
  }

  @override
  Future<void> close() async {
    _closedByUser = true;
    _connected = false;
    await _channel?.sink.close();
  }
}
