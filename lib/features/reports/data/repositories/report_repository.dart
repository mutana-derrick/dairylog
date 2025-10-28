import 'package:flutter/foundation.dart';
import '../../../milk_records/data/repositories/milk_repository.dart';
import '../models/report_model.dart';
// import '../../milk_records/data/models/milk_record_model.dart';
// import '../../milk_records/data/repositories/milk_repository.dart';

/// Repository responsible for generating reports.
class ReportRepository {
  final MilkRepository _milkRepository;

  ReportRepository(this._milkRepository);

  /// Fetch daily milk totals
  Future<List<Report>> getDailyReports() async {
    try {
      final records = await _milkRepository.getAllMilkRecords();
      final Map<String, double> dailyTotals = {};

      for (var record in records) {
        final dateKey = record.date.toIso8601String().split('T').first;
        dailyTotals[dateKey] = (dailyTotals[dateKey] ?? 0) + record.quantity;
      }

      return dailyTotals.entries
          .map((e) => Report(date: e.key, totalQuantity: e.value))
          .toList();
    } catch (e) {
      debugPrint('Error fetching daily reports: $e');
      rethrow;
    }
  }

  /// Fetch monthly milk totals
  Future<List<Report>> getMonthlyReports() async {
    try {
      final records = await _milkRepository.getAllMilkRecords();
      final Map<String, double> monthlyTotals = {};

      for (var record in records) {
        final monthKey = '${record.date.year}-${record.date.month}';
        monthlyTotals[monthKey] =
            (monthlyTotals[monthKey] ?? 0) + record.quantity;
      }

      return monthlyTotals.entries
          .map((e) => Report(date: e.key, totalQuantity: e.value))
          .toList();
    } catch (e) {
      debugPrint('Error fetching monthly reports: $e');
      rethrow;
    }
  }
}


