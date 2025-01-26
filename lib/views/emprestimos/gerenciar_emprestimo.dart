import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/config.dart';
import 'package:flutter_application_1/model/emprestimo.dart';
import 'package:flutter_application_1/views/emprestimos/detalhes_emprestimo.dart';
import 'package:flutter_application_1/views/emprestimos/detalhes_livro.dart';
import 'package:http/http.dart' as http;

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
          .get(Uri.parse('${Config.baseUrl}/emprestimo/listarEmprestimo'));
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Por favor, aguarde...'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Enviando e-mail de confirmação...'),
            ],
          ),
        );
      },
    );

    try {
      final response = await http.put(
        Uri.parse('${Config.baseUrl}/emprestimo/aprovar/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      Navigator.of(context).pop(); // Fecha o diálogo de espera
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
      Navigator.of(context).pop(); // Fecha o diálogo de espera
      print('Erro ao fazer a requisição: $e');
    }
  }

  Future<void> rejeitarEmprestimo(String id) async {
    try {
      final response = await http.put(
        Uri.parse('${Config.baseUrl}/emprestimo/rejeitar/$id'),
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
      final status =
          emprestimo.statusEmprestimo.toString().split('.').last.toLowerCase();
      return livroNome.contains(_searchText) &&
          (_filterStatus == "Todos" || status == _filterStatus.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Pesquisar por nome do livro',
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
          Expanded(
            child: ListView.builder(
              itemCount: filteredEmprestimos.length,
              itemBuilder: (context, index) {
                final emprestimo = filteredEmprestimos[index];
                Color statusColor;
                switch (
                    emprestimo.statusEmprestimo.toString().split('.').last) {
                  case 'DEVOLVIDO':
                    statusColor = Colors.grey;
                    break;
                  case 'PENDENTE':
                    statusColor = const Color.fromARGB(255, 158, 143, 10);
                    break;
                  case 'EMPRESTADO':
                    statusColor = Colors.green;
                    break;
                  case 'REJEITADO':
                    statusColor = Colors.red;
                    break;
                  default:
                    statusColor = Colors.black;
                }
                return Card(
                  margin: EdgeInsets.all(10.0),
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    height: 150.0, // Definindo a altura do Card
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10.0),
                      title: Text(
                        'Empréstimo ${emprestimo.id}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Usuário: ${emprestimo.nomeUsuario}'),
                          Text('Livro: ${emprestimo.tituloLivro}'),
                          Text('Data de Retirada: ${emprestimo.dataRetirada}'),
                          Text(
                              'Data de Devolução: ${emprestimo.dataDevolucao}'),
                          Text(
                            'Status: ${emprestimo.statusEmprestimo.toString().split('.').last}',
                            style: TextStyle(color: statusColor),
                          ),
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
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetalhesLivroScreen(
                                        emprestimo: emprestimo),
                                  ),
                                );

                                if (result == true) {
                                  fetchEmprestimos(); // Recarrega a lista de empréstimos
                                }
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
                              onPressed: () =>
                                  rejeitarEmprestimo(emprestimo.id),
                            ),
                          ],
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetalhesEmprestimoScreen(
                                emprestimo: emprestimo),
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
    );
  }
}
