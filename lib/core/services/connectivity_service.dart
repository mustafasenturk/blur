import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/logger.dart';

/// Provider for connectivity status
final connectivityProvider = StreamProvider<ConnectivityResult>((ref) {
  return Connectivity().onConnectivityChanged.map(
    (results) => results.isNotEmpty ? results.first : ConnectivityResult.none,
  );
});

/// Provider for checking if device is online
final isOnlineProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return connectivity.when(
    data: (result) => result != ConnectivityResult.none,
    loading: () => true,
    error: (_, __) => true,
  );
});

/// Service for monitoring network connectivity
class ConnectivityService {
  ConnectivityService._();
  static final ConnectivityService instance = ConnectivityService._();

  final _log = AppLogger.forClass(ConnectivityService);
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  final _controller = StreamController<bool>.broadcast();
  Stream<bool> get onConnectivityChanged => _controller.stream;

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  /// Initialize connectivity monitoring
  Future<void> initialize() async {
    // Check initial status
    final results = await _connectivity.checkConnectivity();
    _updateStatus(results.isNotEmpty ? results.first : ConnectivityResult.none);

    // Listen for changes
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      _updateStatus(
        results.isNotEmpty ? results.first : ConnectivityResult.none,
      );
    });
  }

  void _updateStatus(ConnectivityResult result) {
    final wasOnline = _isOnline;
    _isOnline = result != ConnectivityResult.none;

    if (wasOnline != _isOnline) {
      _log.i('Connectivity changed: ${_isOnline ? 'Online' : 'Offline'}');
      _controller.add(_isOnline);
    }
  }

  /// Check current connectivity status
  Future<bool> checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    _updateStatus(results.isNotEmpty ? results.first : ConnectivityResult.none);
    return _isOnline;
  }

  /// Dispose the service
  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
