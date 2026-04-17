import 'package:dio/dio.dart';
import '../models/page_node.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8000'));

  Future<List<PageNode>> getPages() async {
    try {
      final response = await _dio.get('/pages/');
      return (response.data as List).map((p) => PageNode.fromJson(p)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<PageNode> createPage(PageNode page) async {
    try {
      final response = await _dio.post('/pages/', data: page.toJson());
      return PageNode.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<PageNode> updatePage(PageNode page) async {
    try {
      final response = await _dio.put('/pages/${page.id}', data: page.toJson());
      return PageNode.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePage(String id) async {
    try {
      await _dio.delete('/pages/$id');
    } catch (e) {
      rethrow;
    }
  }
}
