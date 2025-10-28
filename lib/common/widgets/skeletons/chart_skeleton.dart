import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';


/// Skeleton loader for charts (e.g., reports or dashboard charts)
class ChartSkeleton extends StatelessWidget {
  final double height;
  final double width;

  const ChartSkeleton({Key? key, this.height = 200, this.width = double.infinity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.skeletonBase,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: FractionallySizedBox(
              alignment: Alignment.topLeft,
              widthFactor: 0.7,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.skeletonHighlight.withOpacity(0.5),
                      AppColors.skeletonBase,
                      AppColors.skeletonHighlight.withOpacity(0.5),
                    ],
                    begin: const Alignment(-1.0, -0.3),
                    end: const Alignment(1.0, 0.3),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
