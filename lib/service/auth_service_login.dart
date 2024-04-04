import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/home_admin.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

void login(String email, String password, BuildContext context) async {
  final response = await http.post(
    Uri.parse('http://10.0.0.106:8080/auth/loginadmin'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'email': email, 'senha': password}),
  );

  if (response.statusCode == 200) {
    print('Login bem-sucedido');
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    String token = responseBody['token'];
    print('Token: $token');

    final storage = new FlutterSecureStorage();
    await storage.write(key: 'token', value: token);

    // Buscar a lista de livros após o login bem-sucedido

    // Navegar para a TelaInicial com a lista de livros
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeAdmin()),
    );
  } else {
    throw Exception('Falha ao fazer login');
  }
}
