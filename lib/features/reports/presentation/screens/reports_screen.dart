import 'package:flutter/material.dart';
import '../widgets/report_chart.dart';
import '../../data/models/report_model.dart';

/// Reports screen displaying daily, weekly, or monthly milk reports
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedPeriod = 'Daily'; // Default view

  @override
  Widget build(BuildContext context) {
    // Get dummy data based on selected period
    final List<Report> currentReports = _getReportsForPeriod();
    final List<Report> monthlyReports = Report.generateDummyMonthlyReports();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        actions: [
          // Period selector dropdown
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: DropdownButton<String>(
              value: _selectedPeriod,
              dropdownColor: Theme.of(context).appBarTheme.backgroundColor,
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              items: ['Daily', 'Weekly', 'Monthly'].map((String period) {
                return DropdownMenuItem<String>(
                  value: period,
                  child: Text(period),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedPeriod = newValue;
                  });
                }
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            _buildSummaryCard(currentReports),
            const SizedBox(height: 24),
            
            // Current Period Chart
            Text(
              '$_selectedPeriod Milk Report',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ReportChart(
              reports: currentReports,
              title: 'Milk Collected (Liters)',
            ),
            const SizedBox(height: 24),
            
            // Monthly Overview (always shown)
            if (_selectedPeriod != 'Monthly') ...[
              const Text(
                'Monthly Overview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ReportChart(
                reports: monthlyReports,
                title: 'Monthly Milk Total',
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Get reports based on selected period
  List<Report> _getReportsForPeriod() {
    switch (_selectedPeriod) {
      case 'Weekly':
        return Report.generateDummyWeeklyReports();
      case 'Monthly':
        return Report.generateDummyMonthlyReports();
      case 'Daily':
      default:
        return Report.generateDummyDailyReports();
    }
  }

  /// Build summary statistics card
  Widget _buildSummaryCard(List<Report> reports) {
    final totalMilk = reports.fold<double>(
      0,
      (sum, report) => sum + report.totalQuantity,
    );
    final averageMilk = reports.isEmpty ? 0 : totalMilk / reports.length;
    final maxMilk = reports.isEmpty
        ? 0
        : reports.map((r) => r.totalQuantity).reduce((a, b) => a > b ? a : b);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$_selectedPeriod Summary',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Total',
                  '${totalMilk.toStringAsFixed(1)} L',
                  Icons.water_drop,
                  Colors.blue,
                ),
                _buildStatItem(
                  'Average',
                  '${averageMilk.toStringAsFixed(1)} L',
                  Icons.show_chart,
                  Colors.green,
                ),
                _buildStatItem(
                  'Peak',
                  '${maxMilk.toStringAsFixed(1)} L',
                  Icons.trending_up,
                  Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build individual stat item
  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}