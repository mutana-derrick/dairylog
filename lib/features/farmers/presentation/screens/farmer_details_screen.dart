import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../data/models/farmer_model.dart';
import '../../../milk_records/data/models/milk_record_model.dart';
import '../../../milk_records/providers/milk_provider.dart';
import '../widgets/delivery_history_card.dart';

class FarmerDetailsScreen extends ConsumerWidget {
  final Farmer farmer;

  const FarmerDetailsScreen({
    super.key,
    required this.farmer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final milkState = ref.watch(milkProvider);

    // Filter records for this specific farmer
    final farmerRecords = milkState.records
        .where((record) => record.farmerPhoneNumber == farmer.phoneNumber)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Most recent first

    // Calculate statistics
    final totalDeliveries = farmerRecords.length;
    final totalLiters = farmerRecords.fold<double>(
      0,
      (sum, record) => sum + record.quantity,
    );
    final totalRevenue = farmerRecords.fold<double>(
      0,
      (sum, record) => sum + (record.quantity * record.price),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFarmerInfoCard(context),
                const SizedBox(height: AppSpacing.md),
                _buildStatisticsCards(
                  context,
                  totalDeliveries,
                  totalLiters,
                  totalRevenue,
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildSectionHeader(
                    context, 'Delivery History', farmerRecords.length),
                const SizedBox(height: AppSpacing.sm),
              ],
            ),
          ),
          _buildDeliveryHistory(context, farmerRecords),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      actions: const [
        // IconButton(
        //   icon: const Icon(Icons.edit_outlined),
        //   onPressed: () {
        //     // TODO: Navigate to edit farmer screen
        //     ToastUtils.showInfo('Edit farmer');
        //   },
        // ),
        // IconButton(
        //   icon: const Icon(Icons.more_vert),
        //   onPressed: () {
        //     // TODO: Show more options
        //   },
        // ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary,
                AppColors.primaryLight,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
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
                  farmer.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  farmer.phoneNumber,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFarmerInfoCard(BuildContext context) {
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
          _buildSectionTitle('Location Details'),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow(Icons.location_city_outlined, 'Sector', farmer.sector),
          const SizedBox(height: AppSpacing.sm),
          _buildInfoRow(Icons.location_on_outlined, 'Cell', farmer.cell),
          const SizedBox(height: AppSpacing.sm),
          _buildInfoRow(Icons.home_outlined, 'Village', farmer.village),
          const SizedBox(height: AppSpacing.lg),
          // Row(
          //   children: [
          //     Expanded(
          //       child: OutlinedButton.icon(
          //         onPressed: () {
          //           // TODO: Call farmer
          //           ToastUtils.showInfo('Calling ${farmer.phoneNumber}');
          //         },
          //         icon: const Icon(Icons.phone, size: 18),
          //         label: const Text('Call'),
          //       ),
          //     ),
          //     const SizedBox(width: AppSpacing.sm),
          //     Expanded(
          //       child: ElevatedButton.icon(
          //         onPressed: () {
          //           // TODO: Send SMS
          //           ToastUtils.showInfo('Sending SMS to ${farmer.phoneNumber}');
          //         },
          //         icon: const Icon(Icons.message, size: 18),
          //         label: const Text('Message'),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCards(
    BuildContext context,
    int totalDeliveries,
    double totalLiters,
    double totalRevenue,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Deliveries',
              totalDeliveries.toString(),
              Icons.local_shipping_outlined,
              Colors.blue,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _buildStatCard(
              'Total Liters',
              totalLiters.toStringAsFixed(1),
              Icons.water_drop_outlined,
              Colors.cyan,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _buildStatCard(
              'Revenue',
              '${NumberFormat.compact().format(totalRevenue)} RWF',
              Icons.payments_outlined,
              AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryHistory(BuildContext context, List<MilkRecord> records) {
    if (records.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history,
                size: 64,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'No Delivery History',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'This farmer hasn\'t made any deliveries yet',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textTertiary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final record = records[index];
            return DeliveryHistoryCard(
              record: record,
              onTap: () {
                // TODO: Show record details in bottom sheet or navigate
                ToastUtils.showInfo('View record details');
              },
            );
          },
          childCount: records.length,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.sm),
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
