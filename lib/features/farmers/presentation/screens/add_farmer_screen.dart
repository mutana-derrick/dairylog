import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/utils/toast_utils.dart';
import '../widgets/farmer_form.dart';
import '../../providers/farmers_provider.dart';

class AddFarmerScreen extends ConsumerStatefulWidget {
  const AddFarmerScreen({super.key});

  @override
  ConsumerState<AddFarmerScreen> createState() => _AddFarmerScreenState();
}

class _AddFarmerScreenState extends ConsumerState<AddFarmerScreen> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(farmersNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add Farmer'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: AppSpacing.md),
            _buildFormCard(context, notifier),
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
                  Icons.person_add,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Register New Farmer',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Add farmer details to your database',
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

  Widget _buildFormCard(BuildContext context, FarmersNotifier notifier) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: FarmerForm(
          isLoading: _isSubmitting, // ✅ Pass loading state
          onSubmit: (farmerData) async {
            if (_isSubmitting) return;

            setState(() => _isSubmitting = true);

            try {
              // ✅ Call API with data from form
              await notifier.addFarmer(
                name: farmerData['name']!,
                phoneNumber: farmerData['phone']!,
                sector: farmerData['sector']!,
                cell: farmerData['cell']!,
                village: farmerData['village']!,
              );

              if (mounted) {
                ToastUtils.showSuccess('Farmer added successfully!');
                context.pop(); // Navigate back
              }
            } catch (e) {
              if (mounted) {
                // ✅ Parse error messages from API
                String errorMessage = 'Failed to add farmer';

                final errorString = e.toString().toLowerCase();

                if (errorString.contains('409') ||
                    errorString.contains('conflict') ||
                    errorString.contains('already registered')) {
                  errorMessage = 'Phone number is already registered';
                } else if (errorString.contains('validation')) {
                  errorMessage = 'Please check your input fields';
                } else if (errorString.contains('network') ||
                    errorString.contains('socket')) {
                  errorMessage = 'Network error. Check your connection';
                } else if (errorString.contains('unauthorized')) {
                  errorMessage = 'Session expired. Please login again';
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
}
