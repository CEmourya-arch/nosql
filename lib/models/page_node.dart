import 'block.dart';
import 'package:uuid/uuid.dart';

class PageNode {
  final String id;
  final String title;
  final String? icon;
  final String? coverImage;
  final List<Block> blocks;
  final DateTime createdAt;
  final DateTime updatedAt;

  PageNode({
    String? id,
    required this.title,
    this.icon,
    this.coverImage,
    required this.blocks,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
      'coverImage': coverImage,
      'blocks': blocks.map((b) => b.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory PageNode.fromJson(Map<String, dynamic> json) {
    return PageNode(
      id: json['id'],
      title: json['title'],
      icon: json['icon'],
      coverImage: json['coverImage'],
      blocks: (json['blocks'] as List).map((b) => Block.fromJson(b)).toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
