import 'package:connectivity_plus/connectivity_plus.dart';

/// A simple abstraction for checking network connectivity.
///
/// Usage:
/// ```dart
/// final isConnected = await NetworkInfoImpl().isConnected;
/// if (!isConnected) throw NetworkFailure();
/// ```

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return result == ConnectivityResult.mobile || result == ConnectivityResult.wifi;
  }
}
