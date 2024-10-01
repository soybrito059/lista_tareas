import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<dynamic>> fetchTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/todos'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data); // Imprime los datos en la consola para verificar el formato
      return data;
    } else {
      throw Exception('Failed to load tasks');
    }
  }
}
