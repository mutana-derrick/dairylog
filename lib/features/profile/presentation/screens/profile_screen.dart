import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../dashboard/presentation/widgets/stat_card.dart';
import '../../providers/profile_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);

    // Temporary static data for demonstration
    final profileData = profileState ?? {
      'name': 'Dairy Manager',
      'email': 'manager@dairy.com',
      'phone': '+250 788 123 456',
      'totalFarmers': 125,
      'monthlyMilkTotal': 3450, // liters
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green[300],
              child: const Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              profileData['name'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(profileData['email'], style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(profileData['phone'], style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StatCard(
                  title: 'Total Farmers',
                  value: profileData['totalFarmers'].toString(),
                  icon: Icons.group,
                  color: Colors.orange,
                ),
                StatCard(
                  title: 'Monthly Milk (L)',
                  value: profileData['monthlyMilkTotal'].toString(),
                  icon: Icons.local_drink,
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: () {
                // Call logout method from profileProvider or authProvider later
              },
            ),
          ],
        ),
      ),
    );
  }
}
