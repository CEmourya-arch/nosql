import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

class TableBlock extends StatelessWidget {
  const TableBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.zinc800 : AppColors.mist300;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Table(
          border: TableBorder.all(color: borderColor, width: 0.5),
          children: [
            _buildRow(['Property', 'Type', 'Value'], isHeader: true, context: context),
            _buildRow(['Status', 'Select', 'In Progress'], context: context),
            _buildRow(['Priority', 'Select', 'High'], context: context),
            _buildRow(['Due Date', 'Date', 'Oct 24, 2024'], context: context),
          ],
        ),
      ),
    );
  }

  TableRow _buildRow(List<String> cells, {bool isHeader = false, required BuildContext context}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TableRow(
      children: cells.map((cell) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          cell,
          style: TextStyle(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
            color: isHeader 
              ? (isDark ? AppColors.zinc100 : AppColors.mist950)
              : (isDark ? AppColors.zinc300 : AppColors.mist800),
          ),
        ),
      )).toList(),
    );
  }
}
