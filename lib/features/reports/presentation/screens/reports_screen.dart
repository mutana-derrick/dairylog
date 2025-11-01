import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../common/widgets/bottom_nav_bar.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';
import '../../providers/reports_provider.dart';
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

  @override
  void initState() {
    super.initState();
    // Load today's data on screen open
    Future.microtask(() {
      _loadDataForPeriod();
    });
  }

  void _loadDataForPeriod() {
    final notifier = ref.read(reportsNotifierProvider.notifier);

    switch (_selectedPeriod) {
      case 'Daily':
        notifier.loadTodayReports();
        break;
      case 'Weekly':
        notifier.loadWeekReports();
        break;
      case 'Monthly':
        notifier.loadMonthReports();
        break;
    }
  }

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
    final reportsState = ref.watch(reportsNotifierProvider);
    final groupedRecords = _groupRecordsByPeriod(reportsState);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reports'),
        elevation: 0,
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: reportsState.isLoading ? null : _loadDataForPeriod,
          ),
        ],
      ),
      body: Column(
        children: [
          // Header with period selector
          _buildHeader(reportsState),

          // Records list
          Expanded(
            child: reportsState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : reportsState.error != null
                    ? _buildErrorState(reportsState.error!)
                    : groupedRecords.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            onRefresh: () async => _loadDataForPeriod(),
                            child: ListView.builder(
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
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => _onNavTap(context, index),
      ),
    );
  }

  Widget _buildHeader(ReportsState state) {
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
                      onChanged: state.isLoading
                          ? null
                          : (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedPeriod = newValue;
                                });
                                _loadDataForPeriod();
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
                      state.totalLiters.toStringAsFixed(1),
                      Icons.water_drop,
                      Colors.blue.shade300,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _buildStatCard(
                      'Total Revenue',
                      'RWF ${NumberFormat('#,###').format(state.totalRevenue)}',
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
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
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

  List<Map<String, dynamic>> _groupRecordsByPeriod(ReportsState state) {
    if (state.allRecords.isEmpty) return [];

    Map<String, List<MilkRecord>> grouped;

    switch (_selectedPeriod) {
      case 'Daily':
        grouped = ref.read(reportsNotifierProvider.notifier).groupByDay();
        break;
      case 'Weekly':
        grouped = ref.read(reportsNotifierProvider.notifier).groupByWeek();
        break;
      case 'Monthly':
        grouped = ref.read(reportsNotifierProvider.notifier).groupByMonth();
        break;
      default:
        grouped = ref.read(reportsNotifierProvider.notifier).groupByDay();
    }

    // Sort by date (most recent first)
    final sortedEntries = grouped.entries.toList()
      ..sort((a, b) =>
          b.value.first.recordedAt.compareTo(a.value.first.recordedAt));

    return sortedEntries.map((entry) {
      return {
        'period': entry.key,
        'records': entry.value,
      };
    }).toList();
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Failed to Load Reports',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              error,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              onPressed: _loadDataForPeriod,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
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
            Text(
              'No milk collections found for ${_selectedPeriod.toLowerCase()} period',
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              onPressed: () => context.push('/addMilkRecord'),
              icon: const Icon(Icons.add),
              label: const Text('Add Record'),
            ),
          ],
        ),
      ),
    );
  }
}