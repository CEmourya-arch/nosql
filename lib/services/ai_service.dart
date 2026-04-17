import 'package:dio/dio.dart';

class AiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:11434/api'));

  Future<String> generateContent(String prompt) async {
    try {
      final response = await _dio.post('/generate', data: {
        'model': 'llama3', // or any local model user has
        'prompt': prompt,
        'stream': false,
      });
      return response.data['response'];
    } catch (e) {
      return "AI Assistant unavailable. Make sure Ollama is running locally.";
    }
  }

  Future<String> suggestBlocks(String pageContent) async {
    final prompt = "Given the following page content, suggest the next 3 logical blocks to add for productivity: $pageContent";
    return await generateContent(prompt);
  }
}
