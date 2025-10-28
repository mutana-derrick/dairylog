import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/farmer_form.dart';
import '../../providers/farmers_provider.dart';

class AddFarmerScreen extends ConsumerWidget {
  const AddFarmerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(farmersNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Farmer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FarmerForm(
          onSubmit: (farmerData) async {
            // ignore: unnecessary_null_comparison
            if (farmerData == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invalid farmer data')),
              );
              return;
            }
            // Pass through dynamic to bypass static type mismatch (ensure farmerData is the expected model at runtime)
            await notifier.addFarmer(farmerData as dynamic);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Farmer added successfully')),
            );
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
