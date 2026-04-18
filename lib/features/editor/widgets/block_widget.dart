import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../models/block.dart';
import '../../../core/app_colors.dart';
import 'kanban_block.dart';
import 'table_block.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../models/block.dart';
import '../../../core/app_colors.dart';
import 'kanban_block.dart';
import 'table_block.dart';

class BlockWidget extends StatefulWidget {
  final Block block;
  final Function(Block) onChanged;
  final VoidCallback? onEnterPressed;
  final VoidCallback? onDeletePressed;

  const BlockWidget({
    super.key,
    required this.block,
    required this.onChanged,
    this.onEnterPressed,
    this.onDeletePressed,
  });

  @override
  State<BlockWidget> createState() => _BlockWidgetState();
}

class _BlockWidgetState extends State<BlockWidget> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.block.content);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _syncChanges();
      }
    });
  }

  @override
  void didUpdateWidget(BlockWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.block.content != _controller.text && !_focusNode.hasFocus) {
      _controller.text = widget.block.content;
    }
  }

  void _syncChanges() {
    if (_controller.text != widget.block.content) {
      widget.onChanged(widget.block.copyWith(content: _controller.text));
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _syncChanges();
    });

    // Markdown-like shortcuts
    if (text == '# ') {
      widget.onChanged(widget.block.copyWith(type: BlockType.heading1, content: ''));
      _controller.text = '';
    } else if (text == '## ') {
      widget.onChanged(widget.block.copyWith(type: BlockType.heading2, content: ''));
      _controller.text = '';
    } else if (text == '- ') {
      widget.onChanged(widget.block.copyWith(type: BlockType.bulletedList, content: ''));
      _controller.text = '';
    } else if (text == '[] ') {
      widget.onChanged(widget.block.copyWith(type: BlockType.todo, content: ''));
      _controller.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: _focusNode.hasFocus ? (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02)) : Colors.transparent,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Drag handle or indicator
            Opacity(
              opacity: _focusNode.hasFocus ? 1.0 : 0.2,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Icon(LucideIcons.gripVertical, size: 14),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                child: _buildBlockContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlockContent() {
    switch (widget.block.type) {
      case BlockType.heading1:
        return _buildTextField(style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold));
      case BlockType.heading2:
        return _buildTextField(style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold));
      case BlockType.heading3:
        return _buildTextField(style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
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
        return KanbanBlock(block: widget.block, onChanged: widget.onChanged);
      case BlockType.table:
        return TableBlock(block: widget.block, onChanged: widget.onChanged);
      default:
        return _buildTextField(style: const TextStyle(fontSize: 16));
    }
  }

  Widget _buildTextField({required TextStyle style}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      style: style.copyWith(
        color: isDark ? Colors.white : Colors.black,
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
        hintText: 'Type / for commands...',
        hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal, fontSize: 14),
      ),
      maxLines: null,
      onChanged: _onChanged,
      onSubmitted: (_) {
        widget.onEnterPressed?.call();
      },
      textInputAction: TextInputAction.newline,
    );
  }
}
