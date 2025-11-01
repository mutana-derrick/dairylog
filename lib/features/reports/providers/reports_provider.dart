import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../milk_records/data/models/milk_record_model.dart';
import '../../milk_records/providers/milk_provider.dart';


/// State class for reports
class ReportsState {
  final List<MilkRecord> allRecords;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isLoading;
  final String? error;

  // Computed properties
  double get totalLiters =>
      allRecords.fold(0.0, (sum, record) => sum + record.liters);

  double get totalRevenue => allRecords.fold(
      0.0, (sum, record) => sum + (record.liters * record.pricePerLiter));

  int get totalCollections => allRecords.length;

  double get averagePricePerLiter =>
      totalLiters > 0 ? totalRevenue / totalLiters : 0;

  ReportsState({
    this.allRecords = const [],
    this.startDate,
    this.endDate,
    this.isLoading = false,
    this.error,
  });

  ReportsState copyWith({
    List<MilkRecord>? allRecords,
    DateTime? startDate,
    DateTime? endDate,
    bool? isLoading,
    String? error,
  }) {
    return ReportsState(
      allRecords: allRecords ?? this.allRecords,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Provider for reports
final reportsNotifierProvider =
    StateNotifierProvider<ReportsNotifier, ReportsState>((ref) {
  return ReportsNotifier(ref);
});

/// Notifier for managing reports
class ReportsNotifier extends StateNotifier<ReportsState> {
  final Ref _ref;

  // ✅ FIX: Don't auto-load in constructor
  ReportsNotifier(this._ref) : super(ReportsState());
  
  // ❌ REMOVED: loadReports() call from constructor

  /// Load reports with optional date range
  Future<void> loadReports({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      startDate: startDate,
      endDate: endDate,
    );

    try {
      // Use milk records provider to fetch data
      await _ref.read(milkRecordsNotifierProvider.notifier).loadMilkRecords(
            startDate: startDate?.toIso8601String().split('T').first,
            endDate: endDate?.toIso8601String().split('T').first,
          );

      // Get the loaded records
      final milkState = _ref.read(milkRecordsNotifierProvider);

      state = state.copyWith(
        allRecords: milkState.records,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load today's reports
  Future<void> loadTodayReports() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    await loadReports(startDate: startOfDay, endDate: endOfDay);
  }

  /// Load this week's reports
  Future<void> loadWeekReports() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    await loadReports(
      startDate: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
      endDate: DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59),
    );
  }

  /// Load this month's reports
  Future<void> loadMonthReports() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    await loadReports(startDate: startOfMonth, endDate: endOfMonth);
  }

  /// Load reports for a specific farmer
  Future<void> loadFarmerReports(String phoneNumber) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _ref
          .read(milkRecordsNotifierProvider.notifier)
          .loadFarmerHistory(phoneNumber);

      final milkState = _ref.read(milkRecordsNotifierProvider);

      // Convert farmer history to MilkRecord format
      final records = milkState.farmerHistory
          .map((historyRecord) => MilkRecord(
                id: historyRecord.id,
                farmerId: 0, // Not available in history
                farmerName: '', // Not available in history
                farmerPhone: phoneNumber,
                liters: historyRecord.liters,
                pricePerLiter: historyRecord.pricePerLiter,
                recordedAt: historyRecord.recordedAt,
              ))
          .toList();

      state = state.copyWith(
        allRecords: records,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Group records by day
  Map<String, List<MilkRecord>> groupByDay() {
    final Map<String, List<MilkRecord>> grouped = {};

    for (var record in state.allRecords) {
      final dateKey = _formatDate(record.recordedAt, 'EEEE, MMM d, yyyy');

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(record);
    }

    return grouped;
  }

  /// Group records by week
  Map<String, List<MilkRecord>> groupByWeek() {
    final Map<String, List<MilkRecord>> grouped = {};

    for (var record in state.allRecords) {
      final weekStart =
          record.recordedAt.subtract(Duration(days: record.recordedAt.weekday - 1));
      final weekEnd = weekStart.add(const Duration(days: 6));

      final dateKey =
          '${_formatDate(weekStart, 'MMM d')} - ${_formatDate(weekEnd, 'MMM d, yyyy')}';

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(record);
    }

    return grouped;
  }

  /// Group records by month
  Map<String, List<MilkRecord>> groupByMonth() {
    final Map<String, List<MilkRecord>> grouped = {};

    for (var record in state.allRecords) {
      final dateKey = _formatDate(record.recordedAt, 'MMMM yyyy');

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(record);
    }

    return grouped;
  }

  String _formatDate(DateTime date, String format) {
    // Simple date formatting
    switch (format) {
      case 'EEEE, MMM d, yyyy':
        return '${_getWeekday(date)}, ${_getMonth(date)} ${date.day}, ${date.year}';
      case 'MMM d':
        return '${_getMonth(date)} ${date.day}';
      case 'MMM d, yyyy':
        return '${_getMonth(date)} ${date.day}, ${date.year}';
      case 'MMMM yyyy':
        return '${_getMonthFull(date)} ${date.year}';
      default:
        return date.toIso8601String();
    }
  }

  String _getWeekday(DateTime date) {
    const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return weekdays[date.weekday - 1];
  }

  String _getMonth(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[date.month - 1];
  }

  String _getMonthFull(DateTime date) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return months[date.month - 1];
  }
}