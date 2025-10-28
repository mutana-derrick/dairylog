import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/report_model.dart';
import '../data/repositories/report_repository.dart';

/// State class for reports
class ReportsState {
  final List<Report> dailyReports;
  final List<Report> monthlyReports;
  final bool isLoading;
  final String? errorMessage;

  ReportsState({
    this.dailyReports = const [],
    this.monthlyReports = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ReportsState copyWith({
    List<Report>? dailyReports,
    List<Report>? monthlyReports,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ReportsState(
      dailyReports: dailyReports ?? this.dailyReports,
      monthlyReports: monthlyReports ?? this.monthlyReports,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Provider to hold ReportsState
final reportsProvider =
    StateNotifierProvider<ReportsNotifier, ReportsState>((ref) {
  final reportRepository = ref.watch(reportRepositoryProvider);
  return ReportsNotifier(reportRepository);
});

/// StateNotifier to manage fetching reports
class ReportsNotifier extends StateNotifier<ReportsState> {
  final ReportRepository _repository;

  ReportsNotifier(this._repository) : super(ReportsState());

  /// Fetch daily reports
  Future<void> fetchDailyReports() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final daily = await _repository.getDailyReports();
      state = state.copyWith(dailyReports: daily, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load daily reports',
      );
    }
  }

  /// Fetch monthly reports
  Future<void> fetchMonthlyReports() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final monthly = await _repository.getMonthlyReports();
      state = state.copyWith(monthlyReports: monthly, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load monthly reports',
      );
    }
  }
}

/// Temporary provider for the ReportRepository (can be replaced by API)
final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  // Here we should inject MilkRepository later
  throw UnimplementedError('Provide a proper ReportRepository implementation');
});
