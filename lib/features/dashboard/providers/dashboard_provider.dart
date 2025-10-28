import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A simple state class for the dashboard metrics
class DashboardState {
  final int todayMilkRecords;
  final int farmersDeliveredToday;
  final int totalFarmers;

  const DashboardState({
    required this.todayMilkRecords,
    required this.farmersDeliveredToday,
    required this.totalFarmers,
  });
}

/// A simple provider that holds the dashboard data
final dashboardProvider = StateNotifierProvider<DashboardNotifier, DashboardState>(
  (ref) => DashboardNotifier(),
);

class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier()
      : super(const DashboardState(
          todayMilkRecords: 120,
          farmersDeliveredToday: 15,
          totalFarmers: 50,
        ));

  /// Later, this can fetch real data from APIs
  void updateDashboard({
    int? todayMilkRecords,
    int? farmersDeliveredToday,
    int? totalFarmers,
  }) {
    state = DashboardState(
      todayMilkRecords: todayMilkRecords ?? state.todayMilkRecords,
      farmersDeliveredToday: farmersDeliveredToday ?? state.farmersDeliveredToday,
      totalFarmers: totalFarmers ?? state.totalFarmers,
    );
  }
}
