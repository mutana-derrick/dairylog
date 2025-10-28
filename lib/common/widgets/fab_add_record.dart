import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

/// A reusable Floating Action Button for adding new records.
class FabAddRecord extends StatelessWidget {
  final VoidCallback onPressed;
  final String tooltip;

  const FabAddRecord({
    super.key,
    required this.onPressed,
    this.tooltip = 'Add',
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: AppColors.primary,
      tooltip: tooltip,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
