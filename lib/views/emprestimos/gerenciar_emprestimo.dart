import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/emprestimo.dart';
import 'package:flutter_application_1/views/emprestimos/detalhes_emprestimo.dart';
import 'package:flutter_application_1/views/emprestimos/detalhes_livro.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GerenciarEmprestimo extends StatefulWidget {
  @override
  _GerenciarEmprestimoState createState() => _GerenciarEmprestimoState();
}

class _GerenciarEmprestimoState extends State<GerenciarEmprestimo> {
  List<Emprestimo> emprestimos = [];
  TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  String _filterStatus = "Todos";

  @override
  void initState() {
    super.initState();
    fetchEmprestimos();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  Future<void> fetchEmprestimos() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:8080/emprestimo/listarEmprestimo'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data != null && data.isNotEmpty) {
          setState(() {
            emprestimos =
                data.map((item) => Emprestimo.fromJson(item)).toList();
          });
        } else {
          throw Exception('Dados nulos ou vazios recebidos do servidor');
        }
      } else {
        throw Exception('Falha ao carregar empréstimos');
      }
    } catch (e) {
      print('Erro ao fazer a requisição: $e');
    }
  }

  Future<void> aprovarEmprestimo(String id) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:8080/emprestimo/aprovar/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        print('Empréstimo aprovado com sucesso');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GerenciarEmprestimo()),
        );
      } else {
        throw Exception('Falha ao aprovar empréstimo');
      }
    } catch (e) {
      print('Erro ao fazer a requisição: $e');
    }
  }

  Future<void> rejeitarEmprestimo(String id) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:8080/emprestimo/rejeitar/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        print('Empréstimo rejeitado com sucesso');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GerenciarEmprestimo()),
        );
      } else {
        throw Exception('Falha ao rejeitar empréstimo');
      }
    } catch (e) {
      print('Erro ao fazer a requisição: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredEmprestimos = emprestimos.where((emprestimo) {
      final livroNome = emprestimo.tituloLivro.toLowerCase();
      final status = emprestimo.statusEmprestimo.toString().split('.').last;
      return livroNome.contains(_searchText) &&
          (_filterStatus == "Todos" || status == _filterStatus);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Empréstimos'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _filterStatus = "Todos";
              });
            },
            child: Text(
              'Todos',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _filterStatus = "EMPRESTADO";
              });
            },
            child: Text(
              'Emprestado',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _filterStatus = "PENDENTE";
              });
            },
            child: Text(
              'Pendente',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _filterStatus = "DEVOLVIDO";
              });
            },
            child: Text(
              'Devolvido',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Pesquisar por nome do livro',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredEmprestimos.length,
              itemBuilder: (context, index) {
                final emprestimo = filteredEmprestimos[index];
                return ListTile(
                  title: Text('Empréstimo ${emprestimo.id}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Usuário: ${emprestimo.nomeUsuario}'),
                      Text('Livro: ${emprestimo.tituloLivro}'),
                      Text('Data de Retirada: ${emprestimo.dataRetirada}'),
                      Text('Data de Devolução: ${emprestimo.dataDevolucao}'),
                      Text(
                          'Status: ${emprestimo.statusEmprestimo.toString().split('.').last}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (emprestimo.statusEmprestimo
                              .toString()
                              .split('.')
                              .last ==
                          'EMPRESTADO')
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetalhesLivroScreen(emprestimo: emprestimo),
                              ),
                            );
                          },
                          child: Text('Devolução'),
                        ),
                      if (emprestimo.statusEmprestimo
                              .toString()
                              .split('.')
                              .last ==
                          'PENDENTE') ...[
                        IconButton(
                          icon: Icon(Icons.check_circle_sharp),
                          onPressed: () => aprovarEmprestimo(emprestimo.id),
                        ),
                        IconButton(
                          icon: Icon(Icons.backspace_outlined),
                          onPressed: () => rejeitarEmprestimo(emprestimo.id),
                        ),
                      ],
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetalhesEmprestimoScreen(emprestimo: emprestimo),
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
