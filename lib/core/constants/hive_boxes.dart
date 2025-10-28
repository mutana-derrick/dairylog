/// Defines all Hive box names and commonly used keys.
///
/// Keeping these constants centralized avoids typos and helps
/// when performing migrations or clearing cached data.
class HiveBoxes {
  // Boxes
  static const String userBox = 'user_box';
  static const String farmersBox = 'farmers_box';
  static const String milkRecordsBox = 'milk_records_box';
  static const String reportsBox = 'reports_box';
  static const String syncQueueBox = 'sync_queue_box';

  // Keys inside boxes (if storing simple values)
  static const String userKey = 'user';
  static const String tokenKey = 'token';
  static const String themeModeKey = 'theme_mode';
  static const String lastSyncKey = 'last_sync';
}
