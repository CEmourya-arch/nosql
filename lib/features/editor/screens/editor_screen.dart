import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../models/page_node.dart';
import '../../../models/block.dart';
import '../widgets/block_list_view.dart';
import '../../../core/app_colors.dart';
import '../providers/editor_provider.dart';
import '../../../services/export_service.dart';

class EditorScreen extends ConsumerWidget {
  final String pageId;
  const EditorScreen({super.key, this.pageId = 'new_page'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(editorProvider(pageId));
    final notifier = ref.read(editorProvider(pageId).notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: TextEditingController(text: page.title),
          onChanged: (val) => notifier.updateTitle(val),
          decoration: const InputDecoration(
            hintText: 'Untitled',
            border: InputBorder.none,
          ),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.sparkles, color: AppColors.rose500),
            onPressed: () {
              // TODO: AI Assistant integration
            },
          ),
          IconButton(
            icon: const Icon(LucideIcons.share),
            onPressed: () async {
              final path = await ExportService().exportPageAsJson(page);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Exported to $path')),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(LucideIcons.moreVertical),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
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
              blocks: page.blocks,
              onBlocksChanged: (newBlocks) {
                // Since BlockListView handles reordering internally via onReorder, 
                // we can just update the whole list if needed, but the provider handles it.
              },
              onReorder: (oldIndex, newIndex) => notifier.reorderBlocks(oldIndex, newIndex),
              onBlockChanged: (block) => notifier.updateBlock(block),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBlockPicker(context, notifier),
        backgroundColor: AppColors.rose500,
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
      default: return const Icon(LucideIcons.box);
    }
  }
}
