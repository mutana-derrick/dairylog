import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../milk_records/providers/milk_provider.dart';
import '../../farmers/providers/farmers_provider.dart';

/// Dashboard state with real-time metrics
class DashboardState {
  final double todayMilkLiters;
  final double todayRevenue;
  final int farmersDeliveredToday;
  final int totalFarmers;
  final List<double> weeklyData;
  final List<String> weekDays;
  final double weeklyGrowth;
  final bool isLoading;
  final String? error;

  const DashboardState({
    this.todayMilkLiters = 0.0,
    this.todayRevenue = 0.0,
    this.farmersDeliveredToday = 0,
    this.totalFarmers = 0,
    this.weeklyData = const [],
    this.weekDays = const [],
    this.weeklyGrowth = 0.0,
    this.isLoading = false,
    this.error,
  });

  DashboardState copyWith({
    double? todayMilkLiters,
    double? todayRevenue,
    int? farmersDeliveredToday,
    int? totalFarmers,
    List<double>? weeklyData,
    List<String>? weekDays,
    double? weeklyGrowth,
    bool? isLoading,
    String? error,
  }) {
    return DashboardState(
      todayMilkLiters: todayMilkLiters ?? this.todayMilkLiters,
      todayRevenue: todayRevenue ?? this.todayRevenue,
      farmersDeliveredToday: farmersDeliveredToday ?? this.farmersDeliveredToday,
      totalFarmers: totalFarmers ?? this.totalFarmers,
      weeklyData: weeklyData ?? this.weeklyData,
      weekDays: weekDays ?? this.weekDays,
      weeklyGrowth: weeklyGrowth ?? this.weeklyGrowth,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Provider for dashboard
final dashboardNotifierProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier(ref);
});

/// Notifier for managing dashboard data
class DashboardNotifier extends StateNotifier<DashboardState> {
  final Ref _ref;

  DashboardNotifier(this._ref) : super(const DashboardState());

  /// Load all dashboard data
  Future<void> loadDashboardData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Load farmers first
      await _ref.read(farmersNotifierProvider.notifier).loadFarmers();

      // Load today's milk records
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

      await _ref.read(milkRecordsNotifierProvider.notifier).loadMilkRecords(
            startDate: startOfDay.toIso8601String().split('T').first,
            endDate: endOfDay.toIso8601String().split('T').first,
          );

      // Get loaded data
      final farmersState = _ref.read(farmersNotifierProvider);
      final milkState = _ref.read(milkRecordsNotifierProvider);

      // Calculate today's metrics
      final todayRecords = milkState.records;
      final todayLiters = todayRecords.fold<double>(
        0.0,
        (sum, record) => sum + record.liters,
      );
      final todayRevenue = todayRecords.fold<double>(
        0.0,
        (sum, record) => sum + (record.liters * record.pricePerLiter),
      );

      // Get unique farmers who delivered today
      final uniqueFarmerIds = todayRecords.map((r) => r.farmerId).toSet();
      final farmersDeliveredToday = uniqueFarmerIds.length;

      // Load weekly data for chart
      await _loadWeeklyData();

      state = state.copyWith(
        todayMilkLiters: todayLiters,
        todayRevenue: todayRevenue,
        farmersDeliveredToday: farmersDeliveredToday,
        totalFarmers: farmersState.farmers.length,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load weekly data for chart
  Future<void> _loadWeeklyData() async {
    try {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 6));

      // Load week's data
      await _ref.read(milkRecordsNotifierProvider.notifier).loadMilkRecords(
            startDate: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day)
                .toIso8601String()
                .split('T')
                .first,
            endDate: DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59)
                .toIso8601String()
                .split('T')
                .first,
          );

      final milkState = _ref.read(milkRecordsNotifierProvider);
      final weekRecords = milkState.records;

      // Group by day
      final Map<int, double> dailyTotals = {};
      for (var record in weekRecords) {
        final dayOfWeek = record.recordedAt.weekday;
        dailyTotals[dayOfWeek] = (dailyTotals[dayOfWeek] ?? 0) + record.liters;
      }

      // Create arrays for chart (Monday = 1, Sunday = 7)
      final weeklyData = <double>[];
      final weekDays = <String>[];

      const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      for (int i = 1; i <= 7; i++) {
        weeklyData.add(dailyTotals[i] ?? 0.0);
        weekDays.add(dayNames[i - 1]);
      }

      // Calculate growth (compare this week to last week average)
      final thisWeekAverage = weeklyData.isNotEmpty
          ? weeklyData.reduce((a, b) => a + b) / weeklyData.length
          : 0.0;

      // For now, use today vs week average as growth indicator
      final todayLiters = state.todayMilkLiters;
      final growth = thisWeekAverage > 0
          ? ((todayLiters - thisWeekAverage) / thisWeekAverage) * 100
          : 0.0;

      state = state.copyWith(
        weeklyData: weeklyData,
        weekDays: weekDays,
        weeklyGrowth: growth,
      );
    } catch (e) {
      // If weekly data fails, don't crash - just skip chart
      print('Error loading weekly data: $e');
    }
  }

  /// Refresh dashboard data
  Future<void> refresh() async {
    await loadDashboardData();
  }
}