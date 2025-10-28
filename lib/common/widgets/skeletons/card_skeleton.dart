import 'package:dairylog/app/theme/app_colors.dart';
import 'package:flutter/material.dart';


/// Skeleton loader for cards (e.g., dashboard stats)
class CardSkeleton extends StatelessWidget {
  final double width;
  final double height;

  const CardSkeleton({Key? key, this.width = double.infinity, this.height = 100}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      decoration: BoxDecoration(
        color: AppColors.skeletonBase,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: FractionallySizedBox(
              alignment: Alignment.topLeft,
              widthFactor: 0.6,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.skeletonHighlight.withOpacity(0.5),
                      AppColors.skeletonBase,
                      AppColors.skeletonHighlight.withOpacity(0.5),
                    ],
                    begin: Alignment(-1.0, -0.3),
                    end: Alignment(1.0, 0.3),
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
