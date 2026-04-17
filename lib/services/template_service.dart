import '../models/block.dart';
import '../models/page_node.dart';

class TemplateService {
  static List<PageNode> getTemplates() {
    return [
      PageNode(
        title: 'Project Roadmap',
        icon: '🚀',
        blocks: [
          Block(type: BlockType.heading1, content: 'Project Roadmap'),
          Block(type: BlockType.text, content: 'Plan and track your project milestones.'),
          Block(type: BlockType.heading2, content: 'Milestones'),
          Block(type: BlockType.kanban, content: 'Roadmap Board'),
          Block(type: BlockType.heading2, content: 'Timeline'),
          Block(type: BlockType.table, content: 'Task Details'),
        ],
      ),
      PageNode(
        title: 'Meeting Notes',
        icon: '📝',
        blocks: [
          Block(type: BlockType.heading1, content: 'Meeting: [Title]'),
          Block(type: BlockType.text, content: 'Date: ${DateTime.now().toString().split(' ')[0]}'),
          Block(type: BlockType.heading2, content: 'Attendees'),
          Block(type: BlockType.bulletedList, content: 'Name 1'),
          Block(type: BlockType.heading2, content: 'Agenda'),
          Block(type: BlockType.todo, content: 'Action Item 1'),
        ],
      ),
      PageNode(
        title: 'Developer Journal',
        icon: '💻',
        blocks: [
          Block(type: BlockType.heading1, content: 'Dev Log'),
          Block(type: BlockType.code, content: '// Log your thoughts or code snippets'),
          Block(type: BlockType.heading2, content: 'Daily Tasks'),
          Block(type: BlockType.todo, content: 'Fix critical bug #123'),
        ],
      ),
    ];
  }
}
