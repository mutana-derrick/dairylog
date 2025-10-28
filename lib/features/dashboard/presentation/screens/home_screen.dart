import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../common/widgets/bottom_nav_bar.dart';
import '../widgets/stat_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  // Method to handle navigation tap
  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    // TODO: Navigate to different screens based on index
    // For now, just updating the index
    switch (index) {
      case 0:
        // Already on Home
        break;
      case 1:
        // Navigate to Milk Records
         context.go('/milk-records');
        break;
      case 2:
        // Navigate to Farmers
         context.go('/farmers');
        break;
      case 3:
        // Navigate to Reports
        context.go('/reports');
        break;
      case 4:
        // Navigate to Profile
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // For now, using static values; later we will fetch from providers
    const todayMilkRecords = 120; // liters
    const farmersDeliveredToday = 15;
    const totalFarmers = 50;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting + date
            Text(
              'Good Morning!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Today: ${DateTime.now().toLocal().toString().split(' ')[0]}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),

            // Stats cards
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatCard(
                  title: 'Milk Today',
                  value: '$todayMilkRecords L',
                  color: AppColors.primary,
                ),
                StatCard(
                  title: 'Farmers Delivered',
                  value: '$farmersDeliveredToday',
                  color: AppColors.secondary,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const StatCard(
              title: 'Total Farmers Registered',
              value: '$totalFarmers',
              color: AppColors.accent,
            ),

            const SizedBox(height: 24),
            // Placeholder for chart or additional summary
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('Monthly Milk Chart Placeholder'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}