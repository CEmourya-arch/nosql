import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/app_colors.dart';

class ClockWidget extends StatelessWidget {
  final DateTime dateTime;

  const ClockWidget({super.key, required this.dateTime});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timeStr = DateFormat('HH:mm').format(dateTime);
    final secondsStr = DateFormat('ss').format(dateTime);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          timeStr,
          style: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.zinc100 : AppColors.mist950,
            letterSpacing: -2,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          secondsStr,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w300,
            color: AppColors.rose500,
          ),
        ),
      ],
    );
  }
}
