import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../farmers/providers/farmers_provider.dart';
import '../../providers/milk_provider.dart';
import '../widgets/milk_input_form.dart';

class AddMilkRecordScreen extends ConsumerStatefulWidget {
  const AddMilkRecordScreen({super.key});

  @override
  ConsumerState<AddMilkRecordScreen> createState() =>
      _AddMilkRecordScreenState();
}

class _AddMilkRecordScreenState extends ConsumerState<AddMilkRecordScreen> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final farmersState = ref.watch(farmersNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add Milk Record'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
        ),
      ),
      body: farmersState.farmers.isEmpty
          ? _buildEmptyState(context)
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: AppSpacing.md),
                  _buildFormCard(context),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
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
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.water_drop,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Record Milk Collection',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Enter farmer details and milk quantity',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: MilkInputForm(
          isLoading: _isSubmitting,
          onSubmit: ({
            required int farmerId,
            required String farmerName,
            required String farmerPhone,
            required double liters,
            required double pricePerLiter,
          }) async {
            if (_isSubmitting) return;

            setState(() => _isSubmitting = true);

            try {
              await ref.read(milkRecordsNotifierProvider.notifier).addMilkRecord(
                    farmerId: farmerId,
                    farmerName: farmerName,
                    farmerPhone: farmerPhone,
                    liters: liters,
                    pricePerLiter: pricePerLiter,
                  );

              if (mounted) {
                ToastUtils.showSuccess('Milk record added successfully!');
                context.pop();
              }
            } catch (e) {
              if (mounted) {
                String errorMessage = 'Failed to add milk record';

                final errorString = e.toString().toLowerCase();

                if (errorString.contains('409') ||
                    errorString.contains('conflict') ||
                    errorString.contains('already delivered')) {
                  errorMessage = 'This farmer already delivered milk today';
                } else if (errorString.contains('404') ||
                    errorString.contains('not found')) {
                  errorMessage = 'Farmer not found or not in your center';
                } else if (errorString.contains('validation')) {
                  errorMessage = 'Please check your input values';
                } else if (errorString.contains('network')) {
                  errorMessage = 'Network error. Check your connection';
                }

                ToastUtils.showError(errorMessage);
              }
            } finally {
              if (mounted) {
                setState(() => _isSubmitting = false);
              }
            }
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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
                Icons.person_off_outlined,
                size: 64,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'No Farmers Registered',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Please add farmers first before recording milk collection',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: () {
                context.go('/farmers');
              },
              icon: const Icon(Icons.person_add),
              label: const Text('Go to Farmers'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}