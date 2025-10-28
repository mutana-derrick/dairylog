import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

/// A small card widget to display a statistic (number + label)
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color backgroundColor;

  const StatCard({
    Key? key,
    required this.label,
    required this.value,
    this.icon,
    this.backgroundColor = AppColors.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          if (icon != null)
            Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          if (icon != null) const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
