import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/page_node.dart';
import '../../../models/block.dart';
import '../../../services/api_service.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final editorProvider = StateNotifierProvider.family<EditorNotifier, PageNode, String>((ref, id) {
  final apiService = ref.read(apiServiceProvider);
  return EditorNotifier(apiService, id);
});

class EditorNotifier extends StateNotifier<PageNode> {
  final ApiService _apiService;
  final String id;

  EditorNotifier(this._apiService, this.id) : super(PageNode(title: '', blocks: [])) {
    // Initial empty page or fetch from API
  }

  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  void addBlock(BlockType type, {int? index}) {
    final newBlock = Block(type: type);
    final List<Block> newBlocks = List.from(state.blocks);
    if (index != null) {
      newBlocks.insert(index, newBlock);
    } else {
      newBlocks.add(newBlock);
    }
    state = state.copyWith(blocks: newBlocks);
  }

  void updateBlock(Block updatedBlock) {
    final index = state.blocks.indexWhere((b) => b.id == updatedBlock.id);
    if (index != -1) {
      final List<Block> newBlocks = List.from(state.blocks);
      newBlocks[index] = updatedBlock;
      state = state.copyWith(blocks: newBlocks);
    }
  }

  void removeBlock(String blockId) {
    state = state.copyWith(
      blocks: state.blocks.where((b) => b.id != blockId).toList(),
    );
  }

  void reorderBlocks(int oldIndex, int newIndex) {
    final List<Block> newBlocks = List.from(state.blocks);
    final element = newBlocks.removeAt(oldIndex);
    newBlocks.insert(newIndex, element);
    state = state.copyWith(blocks: newBlocks);
  }

  Future<void> save() async {
    // In a real app, call API
    // await _apiService.updatePage(state);
  }
}

extension PageNodeExtension on PageNode {
  PageNode copyWith({
    String? title,
    List<Block>? blocks,
    String? icon,
    String? coverImage,
  }) {
    return PageNode(
      id: id,
      title: title ?? this.title,
      blocks: blocks ?? this.blocks,
      icon: icon ?? this.icon,
      coverImage: coverImage ?? this.coverImage,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
