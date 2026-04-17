import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import '../../../models/block.dart';
import 'block_widget.dart';

class BlockListView extends StatelessWidget {
  final List<Block> blocks;
  final Function(List<Block>) onBlocksChanged;
  final Function(int, int) onReorder;
  final Function(Block) onBlockChanged;

  const BlockListView({
    super.key,
    required this.blocks,
    required this.onBlocksChanged,
    required this.onReorder,
    required this.onBlockChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ReorderableColumn(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        onReorder: onReorder,
        children: blocks.map((block) {
          return BlockWidget(
            key: ValueKey(block.id),
            block: block,
            onChanged: onBlockChanged,
          );
        }).toList(),
      ),
    );
  }
}
