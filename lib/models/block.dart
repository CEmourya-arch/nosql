import 'package:uuid/uuid.dart';

enum BlockType {
  text,
  heading1,
  heading2,
  heading3,
  bulletedList,
  numberedList,
  todo,
  image,
  code,
  calendar,
  kanban,
  table,
  link,
  file,
}

class Block {
  final String id;
  final BlockType type;
  final String content;
  final Map<String, dynamic> metadata;
  final List<Block> nestedBlocks;

  Block({
    String? id,
    required this.type,
    this.content = '',
    this.metadata = const {},
    this.nestedBlocks = const [],
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'content': content,
      'metadata': metadata,
      'nestedBlocks': nestedBlocks.map((b) => b.toJson()).toList(),
    };
  }

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
      id: json['id'],
      type: BlockType.values.byName(json['type']),
      content: json['content'] ?? '',
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      nestedBlocks: (json['nestedBlocks'] as List? ?? [])
          .map((b) => Block.fromJson(b))
          .toList(),
    );
  }

  Block copyWith({
    BlockType? type,
    String? content,
    Map<String, dynamic>? metadata,
    List<Block>? nestedBlocks,
  }) {
    return Block(
      id: id,
      type: type ?? this.type,
      content: content ?? this.content,
      metadata: metadata ?? this.metadata,
      nestedBlocks: nestedBlocks ?? this.nestedBlocks,
    );
  }
}
