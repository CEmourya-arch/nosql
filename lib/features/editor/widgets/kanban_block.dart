import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../models/block.dart';
import '../../../core/app_colors.dart';

class KanbanBlock extends StatelessWidget {
  final Block block;
  final Function(Block) onChanged;

  const KanbanBlock({
    super.key,
    required this.block,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final List<dynamic> columns = block.metadata['columns'] ?? [
      {'id': 'todo', 'title': 'To Do', 'tasks': []},
      {'id': 'in_progress', 'title': 'In Progress', 'tasks': []},
      {'id': 'done', 'title': 'Done', 'tasks': []},
    ];

    return Container(
      height: 400,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.zinc900.withOpacity(0.5) : AppColors.mist100.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.zinc800 : AppColors.mist300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, isDark),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16),
              itemCount: columns.length,
              itemBuilder: (context, index) {
                final column = columns[index];
                return _buildColumn(context, column, index, columns, isDark);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const Icon(LucideIcons.columns, size: 20, color: AppColors.rose500),
          const SizedBox(width: 12),
          Text(
            block.content.isEmpty ? 'Kanban Board' : block.content,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(LucideIcons.plus, size: 18),
            onPressed: () {
              // Add new column logic
            },
          ),
        ],
      ),
    );
  }

  Widget _buildColumn(BuildContext context, Map<String, dynamic> column, int columnIndex, List<dynamic> allColumns, bool isDark) {
    final List<dynamic> tasks = column['tasks'] ?? [];

    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.black26 : Colors.white24,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.rose500.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    column['title'],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.rose500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  tasks.length.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: tasks.length + 1,
              itemBuilder: (context, index) {
                if (index == tasks.length) {
                  return TextButton.icon(
                    onPressed: () => _addTask(columnIndex, allColumns),
                    icon: const Icon(LucideIcons.plus, size: 16),
                    label: const Text('Add task'),
                    style: TextButton.styleFrom(
                      foregroundColor: isDark ? Colors.white54 : Colors.black54,
                      alignment: Alignment.centerLeft,
                    ),
                  );
                }
                return _buildTaskCard(tasks[index], isDark);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(String task, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.zinc800 : Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        task,
        style: TextStyle(
          fontSize: 14,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  void _addTask(int columnIndex, List<dynamic> allColumns) {
    final newColumns = List<Map<String, dynamic>>.from(allColumns.map((e) => Map<String, dynamic>.from(e)));
    newColumns[columnIndex]['tasks'].add('New Task');
    
    final newMetadata = Map<String, dynamic>.from(block.metadata);
    newMetadata['columns'] = newColumns;
    onChanged(block.copyWith(metadata: newMetadata));
  }
}
