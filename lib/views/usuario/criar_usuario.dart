import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CriarUsuario extends StatefulWidget {
  @override
  _CriarUsuarioState createState() => _CriarUsuarioState();
}

class _CriarUsuarioState extends State<CriarUsuario> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController sobreNomeController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  Future<void> cadastrarUsuario() async {
    final response = await http.post(
      Uri.parse(
          'http://localhost:8080/auth/register'), // Substitua pelo endereço da sua API
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nome': nomeController.text,
        'sobreNome': sobreNomeController.text,
        'cpf': cpfController.text,
        'email': emailController.text,
        'senha': senhaController.text,
        'role': 'USER',
      }),
    );

    if (response.statusCode == 200) {
      // Se a chamada da API for bem-sucedida, analise o JSON.
      print('Usuário cadastrado com sucesso');
    } else {
      // Se a chamada da API falhar, lance uma exceção.
      throw Exception('Falha ao cadastrar usuário');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Usuário'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira seu nome';
                }
                return null;
              },
            ),
            TextFormField(
              controller: sobreNomeController,
              decoration: InputDecoration(labelText: 'Sobrenome'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira seu sobrenome';
                }
                return null;
              },
            ),
            TextFormField(
              controller: cpfController,
              decoration: InputDecoration(labelText: 'CPF'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira seu CPF';
                }
                return null;
              },
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira seu email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: senhaController,
              decoration: InputDecoration(labelText: 'Senha'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira sua senha';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  cadastrarUsuario();
                }
              },
              child: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
