import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../common/widgets/bottom_nav_bar.dart';
import '../../providers/profile_providers.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final theme = Theme.of(context);

    // Temporary static data for demonstration
    final Map<String, dynamic> defaultData = {
      'name': 'Dairy Manager',
      'email': 'manager@dairy.com',
      'phone': '+250 788 123 456',
      'location': 'Nyagatare District',
      'totalFarmers': 125,
      'monthlyMilkTotal': 3450, // liters
      'activeSince': 'Jan 2024',
    };

    final profileData = {...defaultData, ...?profileState};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.edit_outlined),
        //     onPressed: () {
        //       // Navigate to edit profile screen
        //     },
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header Section
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
                top: AppSpacing.lg +
                    12, // a little extra breathing space for AppBar
                bottom:
                    AppSpacing.lg, // reduced bottom padding to avoid overlap
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
                            profileData['name']
                                .toString()
                                .substring(0, 1)
                                .toUpperCase(),
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
                    profileData['name']?.toString() ?? 'Unknown User',
                    style: AppTextStyles.headlineLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                ],
              ),
            ),

// ✅ Stats Cards — removed Transform.translate to fix overlap

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
                  _buildInfoCard(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: profileData['email']?.toString(),
                    theme: theme,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildInfoCard(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: profileData['phone']?.toString(),
                    theme: theme,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildInfoCard(
                    icon: Icons.location_on_outlined,
                    label: 'Location',
                    value: profileData['location']?.toString(),
                    theme: theme,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildInfoCard(
                    icon: Icons.calendar_today_outlined,
                    label: 'Active Since',
                    value: profileData['activeSince']?.toString(),
                    theme: theme,
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Settings Section
                  // Text(
                  //   'Settings',
                  //   style: AppTextStyles.titleMedium.copyWith(
                  //     color: AppColors.textPrimary,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // const SizedBox(height: AppSpacing.sm),
                  // _buildActionCard(
                  //   icon: Icons.lock_outline,
                  //   title: 'Change Password',
                  //   subtitle: 'Update your account password',
                  //   onTap: () {
                  //     // Navigate to change password screen
                  //   },
                  //   theme: theme,
                  // ),
                  // const SizedBox(height: AppSpacing.sm),

                  // _buildActionCard(
                  //   icon: Icons.language_outlined,
                  //   title: 'Language',
                  //   subtitle: 'English',
                  //   onTap: () {
                  //     // Navigate to language settings
                  //   },
                  //   theme: theme,
                  // ),

                  const SizedBox(height: AppSpacing.lg),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                      icon: const Icon(Icons.logout, color: AppColors.error),
                      label: Text(
                        'Logout',
                        style: AppTextStyles.buttonMedium.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: AppColors.error, width: 1.5),
                        padding:
                            const EdgeInsets.symmetric(vertical: AppSpacing.md),
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
    required String? value, // allow null safely
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
          // 👇 Prefix icon container now matches _buildActionCard style
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.cream, // same as in _buildActionCard
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // 👇 Text content
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
                  value ?? 'N/A', // fallback if null
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

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
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
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textTertiary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Call logout method from profileProvider or authProvider
              Navigator.pop(context);
              // Navigate to login screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
