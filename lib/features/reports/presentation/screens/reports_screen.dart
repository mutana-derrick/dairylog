import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../common/widgets/bottom_nav_bar.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../milk_records/providers/milk_provider.dart';
import '../../../milk_records/data/models/milk_record_model.dart';
import '../widgets/period_record_card.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  String _selectedPeriod = 'Daily';
  final int _currentIndex = 3;

  void _onNavTap(BuildContext context, int index) {
    if (_currentIndex == index) return;

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/milk-records');
        break;
      case 2:
        context.go('/farmers');
        break;
      case 3:
        // Already on reports
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final milkState = ref.watch(milkProvider);
    final groupedRecords = _groupRecordsByPeriod(milkState.records);

    // Calculate totals
    final totalLiters = milkState.records.fold<double>(
      0,
      (sum, record) => sum + record.quantity,
    );
    final totalRevenue = milkState.records.fold<double>(
      0,
      (sum, record) => sum + (record.quantity * record.price),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reports'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header with period selector
          _buildHeader(totalLiters, totalRevenue),

          // Records list
          Expanded(
            child: milkState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : groupedRecords.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        itemCount: groupedRecords.length,
                        itemBuilder: (context, index) {
                          final entry = groupedRecords[index];
                          return PeriodRecordCard(
                            period: entry['period'] as String,
                            records: entry['records'] as List<MilkRecord>,
                            selectedPeriodType: _selectedPeriod,
                          );
                        },
                      ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => _onNavTap(context, index),
      ),
    );
  }

  Widget _buildHeader(double totalLiters, double totalRevenue) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and period selector
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reports',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'View collections by period',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedPeriod,
                      dropdownColor: AppColors.primary,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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
              const SizedBox(height: AppSpacing.lg),

              // Summary stats
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Liters',
                      totalLiters.toStringAsFixed(1),
                      Icons.water_drop,
                      Colors.blue.shade300,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _buildStatCard(
                      'Total Revenue',
                      'RWF ${NumberFormat('#,###').format(totalRevenue)}',
                      Icons.payments,
                      Colors.green.shade300,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _groupRecordsByPeriod(List<MilkRecord> records) {
    if (records.isEmpty) return [];

    final Map<String, List<MilkRecord>> grouped = {};

    for (var record in records) {
      String periodKey;

      switch (_selectedPeriod) {
        case 'Daily':
          periodKey = DateFormat('EEEE, MMM d, yyyy').format(record.date);
          break;
        case 'Weekly':
          final weekStart = record.date.subtract(Duration(days: record.date.weekday - 1));
          final weekEnd = weekStart.add(const Duration(days: 6));
          periodKey = '${DateFormat('MMM d').format(weekStart)} - ${DateFormat('MMM d, yyyy').format(weekEnd)}';
          break;
        case 'Monthly':
          periodKey = DateFormat('MMMM yyyy').format(record.date);
          break;
        default:
          periodKey = DateFormat('MMM d, yyyy').format(record.date);
      }

      if (!grouped.containsKey(periodKey)) {
        grouped[periodKey] = [];
      }
      grouped[periodKey]!.add(record);
    }

    // Sort by date (most recent first)
    final sortedEntries = grouped.entries.toList()
      ..sort((a, b) => b.value.first.date.compareTo(a.value.first.date));

    return sortedEntries.map((entry) {
      return {
        'period': entry.key,
        'records': entry.value,
      };
    }).toList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.cream,
                shape: BoxShape.circle,
                boxShadow: AppTheme.subtleShadow,
              ),
              child: const Icon(
                Icons.insert_chart_outlined,
                size: 64,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'No Reports Available',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Start collecting milk records to\ngenerate reports',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}