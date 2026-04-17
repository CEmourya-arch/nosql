import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../models/block.dart';
import '../../../core/app_colors.dart';
import 'kanban_block.dart';
import 'table_block.dart';

class BlockWidget extends StatefulWidget {
  final Block block;
  final Function(Block) onChanged;

  const BlockWidget({
    super.key,
    required this.block,
    required this.onChanged,
  });

  @override
  State<BlockWidget> createState() => _BlockWidgetState();
}

class _BlockWidgetState extends State<BlockWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.block.content);
  }

  @override
  void didUpdateWidget(BlockWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.block.content != _controller.text) {
      _controller.text = widget.block.content;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: _buildBlockContent(),
    );
  }

  Widget _buildBlockContent() {
    switch (widget.block.type) {
      case BlockType.heading1:
        return _buildTextField(style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold));
      case BlockType.heading2:
        return _buildTextField(style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
      case BlockType.heading3:
        return _buildTextField(style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
      case BlockType.text:
        return _buildTextField(style: const TextStyle(fontSize: 16));
      case BlockType.todo:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: widget.block.metadata['checked'] ?? false,
                onChanged: (val) {
                  final newMetadata = Map<String, dynamic>.from(widget.block.metadata);
                  newMetadata['checked'] = val;
                  widget.onChanged(widget.block.copyWith(metadata: newMetadata));
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(child: _buildTextField(style: const TextStyle(fontSize: 16))),
          ],
        );
      case BlockType.bulletedList:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8.0, right: 8.0),
              child: Icon(LucideIcons.dot, size: 20),
            ),
            Expanded(child: _buildTextField(style: const TextStyle(fontSize: 16))),
          ],
        );
      case BlockType.code:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _buildTextField(
            style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
          ),
        );
      case BlockType.kanban:
        return const KanbanBlock();
      case BlockType.table:
        return const TableBlock();
      case BlockType.calendar:
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.amber500),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
            children: [
              Icon(LucideIcons.calendar, color: AppColors.amber500),
              SizedBox(height: 8),
              Text('Calendar Block (Full view)'),
            ],
          ),
        );
      default:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('Block type ${widget.block.type.name} coming soon'),
        );
    }
  }

  Widget _buildTextField({required TextStyle style}) {
    return TextField(
      controller: _controller,
      style: style,
      decoration: const InputDecoration(
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
        hintText: 'Type / for commands...',
      ),
      maxLines: null,
      onChanged: (text) {
        widget.onChanged(widget.block.copyWith(content: text));
      },
    );
  }
}
