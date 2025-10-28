import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';


/// Skeleton loader for list items (e.g., farmers or milk records)
class ListSkeleton extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const ListSkeleton({super.key, this.itemCount = 5, this.itemHeight = 80});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: const EdgeInsets.all(12),
          height: itemHeight,
          decoration: BoxDecoration(
            color: AppColors.skeletonBase,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }
}
