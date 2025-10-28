import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';


/// A reusable loading spinner widget.
class LoadingSpinner extends StatelessWidget {
  final double size;
  final Color? color;

  const LoadingSpinner({Key? key, this.size = 50.0, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.primary),
          strokeWidth: 4.0,
        ),
      ),
    );
  }
}
