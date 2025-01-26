import 'package:flutter/material.dart';
import 'package:flutter_application_1/config.dart';
import 'package:flutter_application_1/views/home_admin.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class AdminLoginScreen extends StatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? errorMessage;

  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${Config.baseUrl}/auth/loginadmin'),
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeAdmin()),
      );
    } else {
      setState(() {
        errorMessage = 'Falha ao fazer login. Verifique seu email e senha.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // AppBar preto
        title: Image.asset('assets/images/ifpe2.png',
            height: 40), // Logo no AppBar
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width *
              0.3, // Largura reduzida para 70%
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset('assets/images/ifpe2.png',
                  height: 100), // Logo dentro do container
              SizedBox(height: 20), // Espaço entre o logo e os campos de texto
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String email = emailController.text;
                  String password = passwordController.text;
                  login(email, password);
                },
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black, // Cor do botão
                  onPrimary: Colors.white, // Cor do texto do botão
                ),
              ),
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[850], // Cor do rodapé
        child: Container(
          height: 50.0,
          alignment: Alignment.center,
          child: Text(
            'Hora do conto © 2024 IFPE - Palmares. Todos os direitos reservados.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
