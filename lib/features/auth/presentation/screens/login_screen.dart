import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';
import '../widgets/login_form.dart';



class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.cream,
              Color(0xFFFFFFF5),
              AppColors.background,
            ],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? AppSpacing.md : AppSpacing.xl,
                vertical: AppSpacing.xl,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Enhanced Logo with gradient
                    Center(
                      child: Column(
                        children: [
                          // Multi-layered circular logo
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer circle with gradient
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.primary,
                                      AppColors.primaryDark,
                                    ],
                                  ),
                                  boxShadow: AppTheme.elevatedShadow,
                                ),
                              ),
                              // Inner circle
                              Container(
                                width: 80,
                                height: 80,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                              // Icon
                              const Icon(
                                Icons.local_drink_outlined,
                                size: 50,
                                color: AppColors.primaryDark,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          // App title
                          const Text(
                            'Dairy Manager',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          // Welcome message
                          const Text(
                            'Welcome back! Sign in to continue',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.xl),
                    
                    // Login form card
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        boxShadow: AppTheme.cardShadow,
                      ),
                      padding: EdgeInsets.all(isSmallScreen ? AppSpacing.lg : AppSpacing.xl),
                      child: const LoginForm(),
                    ),
                    
                    const SizedBox(height: AppSpacing.xl),
                    
                    // Feature highlights
                    _buildFeatureHighlights(isSmallScreen),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureHighlights(bool isSmallScreen) {
    return Column(
      children: [
        const Text(
          'Why choose Dairy Manager?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          alignment: WrapAlignment.center,
          children: [
            _buildFeatureChip(
              icon: Icons.cloud_off_outlined,
              label: 'Works Offline',
              color: const Color(0xFF2196F3),
            ),
            _buildFeatureChip(
              icon: Icons.sms_outlined,
              label: 'SMS Alerts',
              color: AppColors.warning,
            ),
            _buildFeatureChip(
              icon: Icons.analytics_outlined,
              label: 'Smart Reports',
              color: const Color(0xFF9C27B0),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: color,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}