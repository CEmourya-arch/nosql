import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/page_node.dart';

class ExportService {
  Future<String> exportPageAsJson(PageNode page) async {
    final jsonString = jsonEncode(page.toJson());
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${page.title.replaceAll(' ', '_')}_${page.id}.json');
    await file.writeAsString(jsonString);
    return file.path;
  }

  Future<PageNode> importPageFromJson(String filePath) async {
    final file = File(filePath);
    final jsonString = await file.readAsString();
    final jsonMap = jsonDecode(jsonString);
    return PageNode.fromJson(jsonMap);
  }
}
