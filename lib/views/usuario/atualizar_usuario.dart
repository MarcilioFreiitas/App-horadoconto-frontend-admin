import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/usuario.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AtualizarUsuario extends StatefulWidget {
  @override
  _AtualizarUsuarioState createState() => _AtualizarUsuarioState();
}

class _AtualizarUsuarioState extends State<AtualizarUsuario> {
  List<Usuario> usuarios = [];
  List<Usuario> usuariosFiltrados = [];

  @override
  void initState() {
    super.initState();
    carregarUsuarios();
  }

  Future<void> carregarUsuarios() async {
    final response = await http.get(
      Uri.parse(
          'http://10.0.0.106:8080/usuarios/listar'), // Substitua pelo endereço da sua API
    );

    if (response.statusCode == 200) {
      Iterable lista = json.decode(response.body);
      setState(() {
        usuarios = lista.map((json) => Usuario.fromJson(json)).toList();
        usuariosFiltrados = usuarios;
      });
    } else {
      throw Exception('Falha ao carregar usuários');
    }
  }

  void _filtrarUsuarios(String valor) {
    setState(() {
      usuariosFiltrados = usuarios
          .where((usuario) =>
              usuario.nome.toLowerCase().contains(valor.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Atualizar Usuário'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filtrarUsuarios,
              decoration: InputDecoration(
                labelText: 'Pesquisar',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: usuariosFiltrados.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(usuariosFiltrados[index].nome),
                  subtitle: Text(usuariosFiltrados[index].email),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetalhesUsuario(usuario: usuariosFiltrados[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ... código existente ...

class DetalhesUsuario extends StatelessWidget {
  final Usuario usuario;

  DetalhesUsuario({Key? key, required this.usuario}) : super(key: key);

  Future<void> atualizarUsuario(
      BuildContext context, Usuario usuarioAtualizado) async {
    final response = await http.put(
      Uri.parse(
          'http://10.0.0.106:8080/usuarios/alterar/${usuario.id}'), // Substitua pelo endereço da sua API
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(usuarioAtualizado.toJson()),
    );

    if (response.statusCode == 200) {
      print('Usuário atualizado com sucesso.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Usuário atualizado com sucesso.'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AtualizarUsuario()),
      );
    } else {
      throw Exception('Falha ao atualizar usuário');
    }
  }

  @override
  Widget build(BuildContext context) {
    final nomeController = TextEditingController(text: usuario.nome);
    final sobreNomeController = TextEditingController(text: usuario.sobreNome);
    final cpfController = TextEditingController(text: usuario.cpf);
    final emailController = TextEditingController(text: usuario.email);
    final senhaController = TextEditingController(text: usuario.senha);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: sobreNomeController,
              decoration: InputDecoration(labelText: 'Sobrenome'),
            ),
            TextField(
              controller: cpfController,
              decoration: InputDecoration(labelText: 'CPF'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: senhaController,
              decoration: InputDecoration(labelText: 'Senha'),
            ),
            ElevatedButton(
              onPressed: () {
                Usuario usuarioAtualizado = Usuario(
                  id: usuario.id,
                  nome: nomeController.text,
                  sobreNome: sobreNomeController.text,
                  cpf: cpfController.text,
                  email: emailController.text,
                  senha: senhaController.text,
                  role: usuario.role, // Mantém o mesmo papel
                  emprestimos:
                      usuario.emprestimos, // Mantém os mesmos empréstimos
                );
                atualizarUsuario(context, usuarioAtualizado);
              },
              child: Text('Atualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
