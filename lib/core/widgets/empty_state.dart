import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';


/// A reusable widget for displaying empty states (e.g., no data available).
class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  final double iconSize;
  final Color? iconColor;
  final TextStyle? textStyle;

  const EmptyState({
    Key? key,
    this.message = "Nothing to display",
    this.icon = Icons.inbox,
    this.iconSize = 64.0,
    this.iconColor,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: iconColor ?? AppColors.secondary,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: textStyle ?? TextStyle(fontSize: 16, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
