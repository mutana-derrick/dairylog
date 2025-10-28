import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../data/models/milk_record_model.dart';


class MilkRecordCard extends StatelessWidget {
  final MilkRecord record;
  final VoidCallback? onTap;

  const MilkRecordCard({
    super.key,
    required this.record,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Text(
          record.farmerPhoneNumber,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Quantity: ${record.quantity} L',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            Text(
              'Price: ${record.price} RWF',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            Text(
              'Date: ${DateFormatter.formatShortDate(record.date)}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
        trailing: CustomButton(
          text: 'Edit',
          onPressed: onTap ?? () {},
          width: 60,
          height: 30,
          //Style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
