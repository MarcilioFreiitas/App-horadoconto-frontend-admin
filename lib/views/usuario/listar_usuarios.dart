import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/usuario.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListarUsuarios extends StatefulWidget {
  @override
  _ListarUsuariosState createState() => _ListarUsuariosState();
}

class _ListarUsuariosState extends State<ListarUsuarios> {
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
        title: Text('Listar Usuários'),
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
                            DetalhesUsuario(usuariosFiltrados[index]),
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

class DetalhesUsuario extends StatelessWidget {
  final Usuario usuario;

  DetalhesUsuario(this.usuario);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Usuário'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Nome: ${usuario.nome}'),
            Text('Sobrenome: ${usuario.sobreNome}'),
            Text('CPF: ${usuario.cpf}'),
            Text('Email: ${usuario.email}'),
            Text('Role: ${usuario.role.toString().split('.').last}'),
            // Adicione mais campos conforme necessário
          ],
        ),
      ),
    );
  }
}
