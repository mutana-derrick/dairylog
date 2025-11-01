import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../common/widgets/bottom_nav_bar.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../auth/providers/auth_provider.dart'; 

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  final int _currentIndex = 4; // 4 = profile tab

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
        context.go('/reports');
        break;
      case 4:
        // Already on profile
        break;
    }
  }

  // ✅ Real logout implementation
  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Logout',
          style: AppTextStyles.headlineMedium,
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        // Show loading
        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Call logout API
        await ref.read(authProvider.notifier).logout();

        // Close loading dialog
        if (context.mounted) Navigator.pop(context);

        // Navigate to login
        if (context.mounted) {
          context.go('/login');
          ToastUtils.showSuccess('Logged out successfully');
        }
      } catch (e) {
        // Close loading dialog
        if (context.mounted) Navigator.pop(context);

        // Show error
        if (context.mounted) {
          ToastUtils.showError('Logout failed: ${e.toString()}');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Watch real auth state
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final theme = Theme.of(context);

    // ✅ Fallback if no user data
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(
          child: Text('No user data available'),
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) => _onNavTap(context, index),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.8),
                  ],
                ),
              ),
              padding: const EdgeInsets.only(
                top: AppSpacing.lg + 12,
                bottom: AppSpacing.lg,
                left: AppSpacing.md,
                right: AppSpacing.md,
              ),
              child: Column(
                children: [
                  // Profile Avatar with Status Indicator
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                          boxShadow: AppTheme.elevatedShadow,
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: AppColors.accent,
                          child: Text(
                            user.username[0].toUpperCase(), // ✅ Real username
                            style: AppTextStyles.displayLarge.copyWith(
                              color: Colors.white,
                              fontSize: 48,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    user.username, // ✅ Real username
                    style: AppTextStyles.headlineLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  if (user.collectionName != null) // ✅ Show collection if exists
                    Text(
                      user.collectionName!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                ],
              ),
            ),

            // Contact Information Section
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Information',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // ✅ Real user data
                  _buildInfoCard(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: user.email,
                    theme: theme,
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  _buildInfoCard(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: user.phoneNumber,
                    theme: theme,
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  if (user.location != null)
                    _buildInfoCard(
                      icon: Icons.location_on_outlined,
                      label: 'Location',
                      value: user.location!,
                      theme: theme,
                    ),

                  if (user.location != null)
                    const SizedBox(height: AppSpacing.sm),

                  if (user.createdAt != null)
                    _buildInfoCard(
                      icon: Icons.calendar_today_outlined,
                      label: 'Active Since',
                      value:
                          '${user.createdAt!.day}/${user.createdAt!.month}/${user.createdAt!.year}',
                      theme: theme,
                    ),

                  const SizedBox(height: AppSpacing.lg),

                  // ✅ Working logout button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: authState.isLoading
                          ? null
                          : () => _handleLogout(context, ref),
                      icon: authState.isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.logout, color: AppColors.error),
                      label: Text(
                        authState.isLoading ? 'Logging out...' : 'Logout',
                        style: AppTextStyles.buttonMedium.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors.error,
                          width: 1.5,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => _onNavTap(context, index),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String? value,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value ?? 'N/A',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}