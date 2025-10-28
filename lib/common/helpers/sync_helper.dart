import 'dart:async';

import '../../core/network/network_info.dart';

/// Helper class to manage offline-to-remote sync
class SyncHelper {
  final NetworkInfo networkInfo;

  SyncHelper(this.networkInfo);

  /// Attempt to sync local data with the remote server
  /// [syncFunction] is the callback that sends local data to the backend
  Future<bool> syncData(Future<void> Function() syncFunction) async {
    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        // No internet, cannot sync now
        return false;
      }

      // Call the provided sync function
      await syncFunction();
      return true;
    } catch (e) {
      // You may log the error here
      return false;
    }
  }

  /// Periodic auto-sync helper
  Stream<void> periodicSync(Duration interval, Future<void> Function() syncFunction) async* {
    while (true) {
      await Future.delayed(interval);
      final success = await syncData(syncFunction);
      if (success) {
        yield null;
      }
    }
  }
}
