import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/app_colors.dart';

class KanbanBlock extends StatelessWidget {
  const KanbanBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.zinc900 : AppColors.mist100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.zinc800 : AppColors.mist300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Icon(LucideIcons.columns, size: 18, color: AppColors.rose500),
                const SizedBox(width: 8),
                Text(
                  'Board',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildColumn(context, 'To Do', [
                  'Research MongoDB indexing',
                  'Design UI for search',
                ]),
                _buildColumn(context, 'In Progress', [
                  'Implement Ollama API',
                ]),
                _buildColumn(context, 'Done', [
                  'Setup project structure',
                  'Define color palettes',
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumn(BuildContext context, String title, List<String> tasks) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.zinc500 : AppColors.mist700,
                ),
              ),
              Text(
                tasks.length.toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.zinc500 : AppColors.mist700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...tasks.map((task) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.zinc800 : AppColors.mist50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: isDark ? AppColors.zinc700 : AppColors.mist300),
                ),
                child: Text(task, style: const TextStyle(fontSize: 13)),
              )),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(LucideIcons.plus, size: 14),
            label: const Text('New', style: TextStyle(fontSize: 12)),
            style: TextButton.styleFrom(
              foregroundColor: isDark ? AppColors.zinc500 : AppColors.mist700,
            ),
          ),
        ],
      ),
    );
  }
}
