import 'package:flutter/material.dart';
import '../../data/models/farmer_model.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/utils/toast_utils.dart';

typedef OnFarmerTap = void Function(Farmer farmer);

class FarmerCard extends StatelessWidget {
  final Farmer farmer;
  final OnFarmerTap? onTap;

  const FarmerCard({super.key, required this.farmer, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: ListTile(
        onTap: () {
          if (onTap != null) onTap!(farmer);
        },
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: const CircleAvatar(
          radius: 24,
          child: Icon(Icons.person),
        ),
        title: Text(farmer.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phone: ${farmer.phoneNumber}'),
            Text('Sector: ${farmer.sector}, Cell: ${farmer.cell}'),
            Text('Village: ${farmer.village}'),
          ],
        ),
        trailing: CustomButton(
          text: 'Message',
          onPressed: () {
            ToastUtils.showSuccess('Send SMS to ${farmer.phoneNumber}');
          },
          height: 36,
          width: 80,
        ),
      ),
    );
  }
}
