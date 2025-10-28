import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/models/report_model.dart';
import '../../../../app/theme/app_colors.dart';

/// A reusable chart widget to display reports (daily or monthly)
class ReportChart extends StatelessWidget {
  final List<Report> reports;
  final String title;

  const ReportChart({
    super.key,
    required this.reports,
    this.title = 'Report Chart',
  });

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 1.7,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: const FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _generateSpots(),
                      isCurved: true,
                      barWidth: 3,
                      color: AppColors.primary,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Convert report data to chart spots
  List<FlSpot> _generateSpots() {
    return reports.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final report = entry.value;
      return FlSpot(index, report.totalQuantity.toDouble());
    }).toList();
  }
}
