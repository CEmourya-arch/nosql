import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/app_colors.dart';

class WhiteboardBlock extends StatelessWidget {
  const WhiteboardBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.zinc900 : AppColors.mist100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.zinc800 : AppColors.mist300),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.pencil, size: 32, color: AppColors.rose500),
            const SizedBox(height: 12),
            Text(
              'Canvas / Whiteboard',
              style: TextStyle(
                color: isDark ? AppColors.zinc400 : AppColors.mist700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap to start drawing',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.zinc600 : AppColors.mist500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
