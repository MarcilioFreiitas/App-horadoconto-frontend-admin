import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/usuario.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AtualizarUsuario extends StatefulWidget {
  final Usuario usuario;
  AtualizarUsuario({Key? key, required this.usuario}) : super(key: key);

  @override
  _AtualizarUsuarioState createState() => _AtualizarUsuarioState();
}

class _AtualizarUsuarioState extends State<AtualizarUsuario> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nomeController;
  late TextEditingController sobreNomeController;
  late TextEditingController cpfController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.usuario.nome);
    sobreNomeController = TextEditingController(text: widget.usuario.sobreNome);
    cpfController = TextEditingController(text: widget.usuario.cpf);
    emailController = TextEditingController(text: widget.usuario.email);
  }

  Future<void> atualizarUsuario(
      BuildContext context, Usuario usuarioAtualizado) async {
    if (_formKey.currentState!.validate()) {
      final response = await http.patch(
        Uri.parse(
            'http://localhost:8080/usuarios/alterar/${usuarioAtualizado.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: utf8.encode(jsonEncode({
          'nome': usuarioAtualizado.nome,
          'sobreNome': usuarioAtualizado.sobreNome,
          'cpf': usuarioAtualizado.cpf,
          'email': usuarioAtualizado.email,
        })),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Usuário atualizado com sucesso.'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context, true); // Retorna um resultado verdadeiro
      } else {
        throw Exception('Falha ao atualizar usuário');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Atualizar Usuário'),
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
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Usuario usuarioAtualizado = Usuario(
                    id: widget.usuario.id,
                    nome: nomeController.text,
                    sobreNome: sobreNomeController.text,
                    cpf: cpfController.text,
                    email: emailController.text,
                    senha: widget.usuario.senha, // Mantém a mesma senha
                    role: widget.usuario.role, // Mantém o mesmo papel
                    emprestimos: widget
                        .usuario.emprestimos, // Mantém os mesmos empréstimos
                  );
                  atualizarUsuario(context, usuarioAtualizado);
                },
                child: Text('Atualizar'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black, // Cor do botão
                ),
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
