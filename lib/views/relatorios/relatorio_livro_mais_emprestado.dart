import 'package:flutter/material.dart';
import 'package:flutter_application_1/config.dart';
import 'package:flutter_application_1/model/livro.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RelatorioLivrosMaisEmprestados extends StatefulWidget {
  @override
  _RelatorioLivrosMaisEmprestadosState createState() =>
      _RelatorioLivrosMaisEmprestadosState();
}

class _RelatorioLivrosMaisEmprestadosState
    extends State<RelatorioLivrosMaisEmprestados> {
  late Future<List<Map<String, dynamic>>> futureLivrosMaisEmprestados;

  @override
  void initState() {
    super.initState();
    futureLivrosMaisEmprestados = fetchLivrosMaisEmprestados();
  }

  Future<List<Map<String, dynamic>>> fetchLivrosMaisEmprestados() async {
    var url = Uri.parse('${Config.baseUrl}/emprestimos/maisEmprestados');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      Iterable lista = json.decode(response.body);
      List<Map<String, dynamic>> livrosMaisEmprestados =
          List<Map<String, dynamic>>.from(lista);
      return livrosMaisEmprestados;
    } else {
      throw Exception('Falha ao carregar livros mais emprestados');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatório de Livros Mais Emprestados'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureLivrosMaisEmprestados,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro: ${snapshot.error}'),
            );
          } else {
            List<Map<String, dynamic>> livrosMaisEmprestados =
                snapshot.data ?? [];
            return ListView.builder(
              itemCount: livrosMaisEmprestados.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text(
                        'Título: ${livrosMaisEmprestados[index]['titulo']}'),
                    subtitle: Text(
                        'Empréstimos: ${livrosMaisEmprestados[index]['quantidade']}'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
