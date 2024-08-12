import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/livro.dart';
import 'package:http/http.dart' as http;

class ListaLivros extends StatefulWidget {
  @override
  _ListaLivrosState createState() => _ListaLivrosState();
}

class _ListaLivrosState extends State<ListaLivros> {
  late Future<List<Livro>> futureLivros;

  @override
  void initState() {
    super.initState();
    futureLivros = fetchLivros();
  }

  Future<List<Livro>> fetchLivros() async {
    // Substitua a URL abaixo pela URL do seu backend
    var url = Uri.parse('http://localhost:8080/livros/listar');
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
        title: Text('Lista de Livros'),
      ),
      body: FutureBuilder<List<Livro>>(
        future: futureLivros,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // ...
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Widget leadingWidget;
                try {
                  leadingWidget = _getImage('http://localhost:8080' +
                      snapshot.data![index].imagem_capa);
                } catch (e) {
                  leadingWidget = const Icon(Icons.error);
                }
                return ListTile(
                  leading: Container(
                    width: 50, // Defina a largura que você deseja
                    height: 50, // Defina a altura que você deseja
                    child: leadingWidget,
                  ),
                  title: Text(snapshot.data![index].titulo),
                  subtitle: Text(snapshot.data![index].autor),
                );
              },
            );

// ...
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          // Por padrão, mostra um loading spinner.
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  dynamic _getImage(String url) {
    try {
      return Image.network(
        url,
        height: 30.0,
        width: 30.0,
        fit: BoxFit.cover,
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          return const Text('Falha ao carregar a imagem');
        },
      );
    } catch (e) {
      return const Icon(Icons.error);
    }
  }
}
