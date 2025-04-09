import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Map<String, dynamic>>> fetchTarefas() async {
    final response = await http.get(Uri.parse('$_baseUrl/todos'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Falha ao carregar tarefas');
    }
  }
}