import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthRemoteRepository {
  Future<Map<String, dynamic>> signup({required String name, required String email, required String password}) async {
    final url = Uri.parse('http://10.0.2.2:8800/auth/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    print(response.body);
    print(response.statusCode);
    final data = jsonDecode(response.body);
    return data;
  }
}
