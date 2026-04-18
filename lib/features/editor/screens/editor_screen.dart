import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../models/page_node.dart';
import '../../../models/block.dart';
import '../widgets/block_list_view.dart';
import '../../../core/app_colors.dart';
import '../providers/editor_provider.dart';
import '../../../services/export_service.dart';

class EditorScreen extends ConsumerStatefulWidget {
  final String pageId;
  const EditorScreen({super.key, this.pageId = 'new_page'});

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    final page = ref.read(editorProvider(widget.pageId));
    _titleController = TextEditingController(text: page.title);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final page = ref.watch(editorProvider(widget.pageId));
    final notifier = ref.read(editorProvider(widget.pageId).notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Keep title controller in sync if page title changes from elsewhere
    if (_titleController.text != page.title) {
      _titleController.text = page.title;
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.zinc950 : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.chevronLeft, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _titleController,
          onChanged: (val) => notifier.updateTitle(val),
          decoration: const InputDecoration(
            hintText: 'Untitled',
            border: InputBorder.none,
          ),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.sparkles, color: AppColors.rose500),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(LucideIcons.share, color: isDark ? Colors.white70 : Colors.black54),
            onPressed: () async {
              final path = await ExportService().exportPageAsJson(page);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Exported to $path')),
                );
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Canvas background
          if (!isDark)
            Positioned.fill(
              child: CustomPaint(
                painter: GridPainter(gridColor: Colors.grey.withOpacity(0.05)),
              ),
            ),
          Column(
            children: [
              if (page.coverImage != null)
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(page.coverImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Expanded(
                child: BlockListView(
                  pageId: widget.pageId,
                  blocks: page.blocks,
                  onBlocksChanged: (newBlocks) {},
                  onReorder: (oldIndex, newIndex) => notifier.reorderBlocks(oldIndex, newIndex),
                  onBlockChanged: (block) => notifier.updateBlock(block),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBlockPicker(context, notifier),
        backgroundColor: AppColors.rose500,
        elevation: 4,
        child: const Icon(LucideIcons.plus, color: Colors.white),
      ),
    );
  }

  void _showBlockPicker(BuildContext context, EditorNotifier notifier) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Add Block', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 20),
              Flexible(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  children: BlockType.values.map((type) {
                    return InkWell(
                      onTap: () {
                        notifier.addBlock(type);
                        Navigator.pop(context);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _getBlockIcon(type),
                          const SizedBox(height: 4),
                          Text(
                            type.name,
                            style: const TextStyle(fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getBlockIcon(BlockType type) {
    switch (type) {
      case BlockType.text: return const Icon(LucideIcons.type);
      case BlockType.heading1: return const Icon(LucideIcons.heading1);
      case BlockType.heading2: return const Icon(LucideIcons.heading2);
      case BlockType.heading3: return const Icon(LucideIcons.heading3);
      case BlockType.todo: return const Icon(LucideIcons.checkSquare);
      case BlockType.image: return const Icon(LucideIcons.image);
      case BlockType.calendar: return const Icon(LucideIcons.calendar);
      case BlockType.code: return const Icon(LucideIcons.code);
      case BlockType.bulletedList: return const Icon(LucideIcons.list);
      case BlockType.kanban: return const Icon(LucideIcons.columns);
      case BlockType.table: return const Icon(LucideIcons.table);
      default: return const Icon(LucideIcons.box);
    }
  }
}

class GridPainter extends CustomPainter {
  final Color gridColor;
  GridPainter({required this.gridColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
