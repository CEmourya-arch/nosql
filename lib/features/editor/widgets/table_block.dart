import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../models/block.dart';
import '../../../core/app_colors.dart';

class TableBlock extends StatelessWidget {
  final Block block;
  final Function(Block) onChanged;

  const TableBlock({
    super.key,
    required this.block,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.zinc800 : AppColors.mist300;

    final List<dynamic> rows = block.metadata['rows'] ?? [
      ['Item', 'Status', 'Date'],
      ['Feature A', 'Done', '2024-05-20'],
      ['Bug Fix', 'In Progress', '2024-05-21'],
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.zinc900.withOpacity(0.3) : Colors.white,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTableToolbar(context, isDark, rows),
          ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
            child: Table(
              border: TableBorder.all(color: borderColor, width: 0.5),
              children: rows.asMap().entries.map((entry) {
                return _buildRow(entry.value, isHeader: entry.key == 0, context: context);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableToolbar(BuildContext context, bool isDark, List<dynamic> rows) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          const Icon(LucideIcons.table, size: 16, color: AppColors.amber500),
          const SizedBox(width: 8),
          const Text('Database', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const Spacer(),
          IconButton(
            icon: const Icon(LucideIcons.plus, size: 14),
            onPressed: () => _addRow(rows),
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(4),
          ),
        ],
      ),
    );
  }

  TableRow _buildRow(List<dynamic> cells, {bool isHeader = false, required BuildContext context}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader 
          ? (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02))
          : null,
      ),
      children: cells.map((cell) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          cell.toString(),
          style: TextStyle(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
            color: isHeader 
              ? (isDark ? AppColors.zinc100 : AppColors.mist950)
              : (isDark ? AppColors.zinc400 : AppColors.mist700),
          ),
        ),
      )).toList(),
    );
  }

  void _addRow(List<dynamic> rows) {
    final newRows = List<dynamic>.from(rows);
    final rowLength = rows.isNotEmpty ? rows[0].length : 3;
    newRows.add(List.generate(rowLength, (_) => ''));
    
    final newMetadata = Map<String, dynamic>.from(block.metadata);
    newMetadata['rows'] = newRows;
    onChanged(block.copyWith(metadata: newMetadata));
  }
}
