import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/usuario.dart';
import 'package:flutter_application_1/views/usuario/atualizar_usuario.dart';
import 'package:flutter_application_1/views/usuario/criar_usuario.dart';
import 'package:http/http.dart' as http;

class ListarUsuarios extends StatefulWidget {
  @override
  _ListarUsuariosState createState() => _ListarUsuariosState();
}

class _ListarUsuariosState extends State<ListarUsuarios> {
  List<Usuario> usuarios = [];
  List<Usuario> usuariosFiltrados = [];
  TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    carregarEAtualizarUsuarios();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
        _filtrarUsuarios(_searchText);
      });
    });
  }

  Future<void> carregarEAtualizarUsuarios() async {
    try {
      List<Usuario> listaUsuarios = await carregarUsuarios();
      setState(() {
        usuarios = listaUsuarios;
        usuariosFiltrados = usuarios;
      });
      print(usuarios); // Verificação dos dados carregados
    } catch (e) {
      print('Erro ao carregar usuários: $e');
    }
  }

  Future<List<Usuario>> carregarUsuarios() async {
    var url = Uri.parse(
        'http://localhost:8080/usuarios/listar'); // Substitua pelo endereço da sua API
    var response = await http.get(url);
    if (response.statusCode == 200) {
      Iterable lista = json.decode(response.body);
      List<Usuario> usuarios =
          List<Usuario>.from(lista.map((model) => Usuario.fromJson(model)));
      return usuarios;
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
      print(usuariosFiltrados); // Verificação dos dados filtrados
    });
  }

  Future<void> deletarUsuario(String id) async {
    final response = await http.delete(
      Uri.parse(
          'http://localhost:8080/usuarios/apagar/$id'), // Substitua pelo endereço da sua API
    );

    if (response.statusCode == 204) {
      print('Usuário deletado com sucesso');
      carregarEAtualizarUsuarios();
    } else if (response.statusCode == 400) {
      final responseBody = response.body;
      if (responseBody
          .contains('O usuário tem um empréstimo ativo ligado a ele')) {
        print('Erro: O usuário tem um empréstimo ativo ligado a ele');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('O usuário tem um empréstimo ativo ligado a ele')),
        );
      } else {
        throw Exception('Falha ao deletar usuário: ${responseBody}');
      }
    } else {
      throw Exception('Falha ao deletar usuário: ${response.reasonPhrase}');
    }
  }

  Future<void> _atualizarUsuario(BuildContext context, Usuario usuario) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AtualizarUsuario(usuario: usuario)),
    );

    if (resultado == true) {
      carregarEAtualizarUsuarios(); // Recarregar a lista de usuários se houver uma atualização
    }
  }

  Future<void> _criarUsuario(BuildContext context) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CriarUsuario()),
    );

    if (resultado == true) {
      carregarEAtualizarUsuarios(); // Recarregar a lista de usuários se um novo usuário for cadastrado
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Pesquisar por nome',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                // Ação opcional para o botão de busca
              },
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: usuariosFiltrados.length,
              itemBuilder: (context, index) {
                final usuario = usuariosFiltrados[index];
                return Card(
                  margin: EdgeInsets.all(10.0),
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    height: 150.0, // Definindo a altura do Card
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10.0),
                      title: Text(
                        '${usuario.nome} ${usuario.sobreNome}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email: ${usuario.email}'),
                          Text('CPF: ${usuario.cpf}'),
                          Text(
                              'Role: ${usuario.role.toString().split('.').last}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _atualizarUsuario(context, usuario);
                            },
                          ),
                          IconButton(
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
                                          deletarUsuario(usuario.id);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetalhesUsuario(usuario),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _criarUsuario(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
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

class DetalhesUsuario extends StatelessWidget {
  final Usuario usuario;
  DetalhesUsuario(this.usuario);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Usuário'),
        backgroundColor: Colors.black,
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
            SizedBox(height: 16.0),
            Text('Empréstimos:', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: usuario.emprestimos.length,
                itemBuilder: (context, index) {
                  final emprestimo = usuario.emprestimos[index];
                  return ListTile(
                    title: Text(emprestimo.tituloLivro),
                    subtitle: Text(
                        'Retirada: ${emprestimo.dataRetirada} | Devolução: ${emprestimo.dataDevolucao}'),
                    trailing: Text(
                        'Status: ${emprestimo.statusEmprestimo.toString().split('.').last}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
