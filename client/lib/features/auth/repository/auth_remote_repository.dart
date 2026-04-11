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

    // print(response.body);
    // print(response.statusCode);
    final data = jsonDecode(response.body);
    return data;
  }
}

Future<void> login({required String email, required String password}) async {
  try {
    final url = Uri.parse("http://127.0.0.1:8900/auth/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    print(response.body.toString());
  } catch (e) {
    print(e.toString());
  }
}
