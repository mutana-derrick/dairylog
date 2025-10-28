import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/widgets/fab_add_record.dart';
import '../../providers/farmers_provider.dart';
import '../widgets/farmer_card.dart';
import 'add_farmer_screen.dart';

class FarmersScreen extends ConsumerWidget {
  const FarmersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(farmersNotifierProvider);
    final notifier = ref.read(farmersNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmers'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => await notifier.loadFarmers(),
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.farmers.isEmpty
                ? const Center(child: Text('No farmers found'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.farmers.length,
                    itemBuilder: (context, index) {
                      final farmer = state.farmers[index];
                      return FarmerCard(farmer: farmer);
                    },
                  ),
      ),
      floatingActionButton: FabAddRecord(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddFarmerScreen(),
            ),
          );
        },
      ),
    );
  }
}
