import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../data/models/farmer_model.dart';
import '../../providers/farmers_provider.dart';
import '../../../milk_records/providers/milk_provider.dart';
import '../widgets/delivery_history_card.dart';

class FarmerDetailsScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const FarmerDetailsScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  ConsumerState<FarmerDetailsScreen> createState() =>
      _FarmerDetailsScreenState();
}

class _FarmerDetailsScreenState extends ConsumerState<FarmerDetailsScreen> {
  bool _isLoadingFarmer = true;
  bool _isLoadingHistory = true;
  Farmer? _farmer;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // ✅ FIXED: Complete rewrite with proper mounted checks
  Future<void> _loadData() async {
    print('=====================================');
  print('🔍 _loadData called');
  print('🔍 mounted: $mounted');
  print('🔍 Stack trace:');
  print(StackTrace.current);
  print('=====================================');
    // Early return if widget is already unmounted
    if (!mounted) return;

    setState(() {
      _isLoadingFarmer = true;
      _isLoadingHistory = true;
      _error = null;
    });

    try {
      print('🔍 Loading farmer: ${widget.phoneNumber}');

      // Load farmer details
      final farmer = await ref
          .read(farmersNotifierProvider.notifier)
          .lookupFarmer(widget.phoneNumber);

      // Check if still mounted after async operation
      if (!mounted) return;

      if (farmer == null) {
        throw Exception('Farmer not found');
      }

      print('✅ Farmer loaded: ${farmer.name}');

      setState(() {
        _farmer = farmer;
        _isLoadingFarmer = false;
      });

      // Load milk history
      print('🔍 Loading history for: ${widget.phoneNumber}');

      await ref
          .read(milkRecordsNotifierProvider.notifier)
          .loadFarmerHistory(widget.phoneNumber);

      // Check if still mounted after async operation
      if (!mounted) return;

      final historyState = ref.read(milkRecordsNotifierProvider);
      print('✅ History loaded: ${historyState.farmerHistory.length} records');
      print('✅ Total liters: ${historyState.totalLitersDeliveredByFarmer}');
      print('✅ Total revenue: ${historyState.totalRevenueByFarmer}');

      setState(() => _isLoadingHistory = false);
    } catch (e) {
      print('❌ Error loading data: $e');

      // Check if still mounted before updating UI
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isLoadingFarmer = false;
        _isLoadingHistory = false;
      });

      // ✅ FIX: Use WidgetsBinding to show toast after frame is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ToastUtils.showError('Failed to load farmer details');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(milkRecordsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Farmer Details'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoadingFarmer || _isLoadingHistory ? null : _loadData,
          ),
        ],
      ),
      body: _isLoadingFarmer
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorState()
              : _farmer == null
                  ? _buildNotFoundState()
                  : RefreshIndicator(
                      onRefresh: _loadData,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFarmerHeader(),
                            const SizedBox(height: AppSpacing.md),
                            _buildFarmerInfoCard(),
                            const SizedBox(height: AppSpacing.lg),
                            _buildDeliveryHistorySection(historyState),
                            const SizedBox(height: AppSpacing.xl),
                          ],
                        ),
                      ),
                    ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Failed to load farmer',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              _error ?? 'Unknown error',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotFoundState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_off,
                size: 64, color: AppColors.textSecondary),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Farmer Not Found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'No farmer found with phone ${widget.phoneNumber}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFarmerHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                _farmer!.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                _farmer!.phoneNumber,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFarmerInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
            icon: Icons.location_on,
            label: 'Sector',
            value: _farmer!.sector,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow(
            icon: Icons.location_city,
            label: 'Cell',
            value: _farmer!.cell,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow(
            icon: Icons.home,
            label: 'Village',
            value: _farmer!.village,
          ),
          if (_farmer!.createdAt != null) ...[
            const SizedBox(height: AppSpacing.md),
            _buildInfoRow(
              icon: Icons.calendar_today,
              label: 'Registered',
              value: DateFormat('MMM dd, yyyy').format(_farmer!.createdAt!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryHistorySection(MilkRecordsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Delivery History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              if (!_isLoadingHistory && state.totalLitersDeliveredByFarmer > 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.water_drop,
                            size: 14,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${state.totalLitersDeliveredByFarmer.toStringAsFixed(1)} L',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.payments,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'RWF ${NumberFormat('#,###').format(state.totalRevenueByFarmer)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (_isLoadingHistory)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: CircularProgressIndicator(),
            ),
          )
        else if (state.farmerHistory.isEmpty)
          _buildEmptyHistory()
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            itemCount: state.farmerHistory.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final record = state.farmerHistory[index];
              return DeliveryHistoryCard(record: record);
            },
          ),
      ],
    );
  }

  Widget _buildEmptyHistory() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Icon(
            Icons.history,
            size: 48,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'No Delivery History',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'This farmer hasn\'t made any deliveries yet',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
