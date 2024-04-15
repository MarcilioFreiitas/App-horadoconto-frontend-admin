import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/usuario.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeletarUsuario extends StatefulWidget {
  @override
  _DeletarUsuarioState createState() => _DeletarUsuarioState();
}

class _DeletarUsuarioState extends State<DeletarUsuario> {
  List<Usuario> usuarios = [];

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
      List<dynamic> listaUsuarios = jsonDecode(response.body);
      setState(() {
        usuarios = listaUsuarios.map((json) => Usuario.fromJson(json)).toList();
      });
    } else {
      throw Exception('Falha ao carregar usuários');
    }
  }

  Future<void> deletarUsuario(String id) async {
    final response = await http.delete(
      Uri.parse(
          'http://10.0.0.106:8080/usuarios/apagar/$id'), // Substitua pelo endereço da sua API
    );

    if (response.statusCode == 204) {
      print('Usuário deletado com sucesso');
      carregarUsuarios();
    } else {
      throw Exception('Falha ao deletar usuário');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deletar Usuário'),
      ),
      body: ListView.builder(
        itemCount: usuarios.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(usuarios[index].nome),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirmação'),
                      content: Text(
                          'Tem certeza de que deseja deletar este usuário?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancelar'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Deletar'),
                          onPressed: () {
                            deletarUsuario(usuarios[index].id);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
