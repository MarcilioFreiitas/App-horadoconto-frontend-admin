import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cpf_cnpj_validator/cpf_validator.dart'; // Importando a biblioteca de validação de CPF

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
    try {
      final response = await http
          .post(
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
          )
          .timeout(
              const Duration(seconds: 10)); // Adiciona timeout de 10 segundos

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Usuário cadastrado com sucesso.'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context, true); // Retorna um resultado verdadeiro
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Falha ao cadastrar usuário: ${response.body}'),
            duration: Duration(seconds: 2),
          ),
        );
        print(
            'Erro ao cadastrar usuário: ${response.statusCode} - ${response.body}');
        throw Exception('Falha ao cadastrar usuário');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro na requisição: $e'),
          duration: Duration(seconds: 2),
        ),
      );
      print('Erro na requisição: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Usuário'),
        backgroundColor: Colors.black,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                  } else if (!CPFValidator.isValid(value)) {
                    return 'CPF inválido';
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
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua senha';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    cadastrarUsuario();
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black, // Cor do botão
                ),
                child: Text('Cadastrar'),
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
