import 'package:flutter/material.dart';
import 'package:flutter_application_1/config.dart';
import 'package:flutter_application_1/model/livro.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RelatorioEstoqueLivros extends StatefulWidget {
  @override
  _RelatorioEstoqueLivrosState createState() => _RelatorioEstoqueLivrosState();
}

class _RelatorioEstoqueLivrosState extends State<RelatorioEstoqueLivros> {
  late Future<List<Livro>> futureLivros;

  @override
  void initState() {
    super.initState();
    futureLivros = fetchLivros();
  }

  Future<List<Livro>> fetchLivros() async {
    var url = Uri.parse('${Config.baseUrl}/livros/listar');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      Iterable lista = json.decode(response.body);
      List<Livro> livros =
          List<Livro>.from(lista.map((model) => Livro.fromJson(model)));
      return livros;
    } else {
      throw Exception('Falha ao carregar livros');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatório de Estoque de Livros'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Livro>>(
        future: futureLivros,
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
            List<Livro> livros = snapshot.data ?? [];
            return ListView.builder(
              itemCount: livros.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text('Título: ${livros[index].titulo}'),
                    subtitle: Text(
                        'Disponível: ${livros[index].disponibilidade ? 'Sim' : 'Não'}'),
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
