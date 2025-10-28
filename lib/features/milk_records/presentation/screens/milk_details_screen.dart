import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../data/models/milk_record_model.dart';
import '../../../farmers/data/models/farmer_model.dart';


class MilkDetailsScreen extends StatelessWidget {
  final MilkRecord record;
  final Farmer farmer;

  const MilkDetailsScreen({
    super.key,
    required this.record,
    required this.farmer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Milk Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: AppColors.cardBackground,
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Farmer: ${farmer.name}', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('Phone: ${farmer.phoneNumber}'),
                Text('Sector: ${farmer.sector}'),
                Text('Cell: ${farmer.cell}'),
                Text('Village: ${farmer.village}'),
                const Divider(height: 32),
                Text('Quantity: ${record.quantity} liters', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Price per liter: ${record.price}'),
                Text('Total Amount: ${record.quantity * record.price}'),
                const SizedBox(height: 16),
                Text('Date: ${record.date.toLocal()}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
