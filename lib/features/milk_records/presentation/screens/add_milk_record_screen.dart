import 'package:dairylog/features/farmers/providers/farmers_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/milk_provider.dart';
import '../widgets/milk_input_form.dart';
import '../../data/models/milk_record_model.dart';

class AddMilkRecordScreen extends ConsumerWidget {
  const AddMilkRecordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farmersState = ref.watch(farmersNotifierProvider);
    final farmers = farmersState.farmers;

    void handleAddRecord(MilkRecord record) {
      ref.read(milkProvider.notifier).addMilkRecord(record);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Milk record added successfully!')),
      );
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Milk Record'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: farmers.isEmpty
            ? const Center(child: Text('No farmers found. Please add farmers first.'))
            : MilkInputForm(
                onSubmit: handleAddRecord,
                farmers: farmers,
              ),
      ),
    );
  }
}
