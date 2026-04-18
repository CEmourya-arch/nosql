import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/block.dart';
import '../providers/editor_provider.dart';
import 'block_widget.dart';

class BlockListView extends ConsumerWidget {
  final String pageId;
  final List<Block> blocks;
  final Function(List<Block>) onBlocksChanged;
  final Function(int, int) onReorder;
  final Function(Block) onBlockChanged;

  const BlockListView({
    super.key,
    required this.pageId,
    required this.blocks,
    required this.onBlocksChanged,
    required this.onReorder,
    required this.onBlockChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(editorProvider(pageId).notifier);

    if (blocks.isEmpty) {
      return GestureDetector(
        onTap: () => notifier.addBlock(BlockType.text),
        child: Container(
          color: Colors.transparent,
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(32),
          child: const Text(
            'Click to start writing...',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      );
    }

    return ReorderableColumn(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      onReorder: onReorder,
      children: blocks.map((block) {
        return BlockWidget(
          key: ValueKey(block.id),
          block: block,
          onChanged: onBlockChanged,
          onEnterPressed: () {
            final index = blocks.indexOf(block);
            notifier.addBlock(BlockType.text, index: index + 1);
          },
          onDeletePressed: () {
            notifier.removeBlock(block.id);
          },
        );
      }).toList(),
    );
  }
}
