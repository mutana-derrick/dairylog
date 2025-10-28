import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/widgets/fab_add_record.dart';
import '../../../../common/widgets/skeletons/list_skeleton.dart';
import '../../data/models/milk_record_model.dart';
import '../../providers/milk_provider.dart';
import '../widgets/milk_record_card.dart';

class MilkRecordsScreen extends ConsumerWidget {
  const MilkRecordsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final milkState = ref.watch(milkProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Milk Records'),
      ),
      body: milkState.isLoading
          ? const ListSkeleton() // Skeleton while loading
          : milkState.records.isEmpty
              ? const Center(child: Text('No milk records found.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: milkState.records.length,
                  itemBuilder: (context, index) {
                    final MilkRecord record = milkState.records[index];
                    return MilkRecordCard(record: record);
                  },
                ),
      floatingActionButton: FabAddRecord(
        onPressed: () {
          Navigator.pushNamed(context, '/addMilkRecord');
        },
      ),
    );
  }
}
