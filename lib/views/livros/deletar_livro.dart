import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/livro.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ListaLivrosDelete extends StatelessWidget {
  Future<List<Livro>> fetchLivros() async {
    var url = Uri.parse('http://10.0.0.106:8080/livros/listar');
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
        future: fetchLivros(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].titulo),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetalhesLivro(livro: snapshot.data![index])),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // Por padrão, mostra um loading spinner.
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class DetalhesLivro extends StatelessWidget {
  final Livro livro;

  DetalhesLivro({Key? key, required this.livro}) : super(key: key);

  Future<void> deleteLivro(BuildContext context) async {
    var url = Uri.parse('http://10.0.0.106:8080/livros/apagar/${livro.id}');
    var response = await http.delete(url);

    if (response.statusCode == 200) {
      print('Livro apagado com sucesso.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Livro apagado com sucesso.'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ListaLivrosDelete()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Falha ao apagar o livro.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(livro.titulo),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Título: ${livro.titulo}'),
            Text('Autor: ${livro.autor}'),
            Text('Imagem da capa: ${livro.imagem_capa}'),
            Text('ISBN: ${livro.isbn}'),
            Text('Sinopse: ${livro.sinopse}'),
            Text('Disponibilidade: ${livro.disponibilidade}'),
            Text('Gênero: ${livro.genero}'),
            // Adicione mais detalhes aqui...
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Apagar Livro'),
                content: Text('Tem certeza de que deseja apagar este livro?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Apagar'),
                    onPressed: () {
                      deleteLivro(context);
                    },
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Apagar Livro',
        child: Icon(Icons.delete),
      ),
    );
  }
}
