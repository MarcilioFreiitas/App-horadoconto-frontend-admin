import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/livro.dart';
import 'package:flutter_application_1/views/livros/atualizar_livro.dart';
import 'package:flutter_application_1/views/livros/criar_livro.dart';
import 'package:http/http.dart' as http;

class ListaLivros extends StatefulWidget {
  @override
  _ListaLivrosState createState() => _ListaLivrosState();
}

class _ListaLivrosState extends State<ListaLivros> {
  late Future<List<Livro>> futureLivros;
  List<Livro> livros = [];
  List<Livro> livrosFiltrados = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    carregarLivros();
  }

  void carregarLivros() {
    setState(() {
      futureLivros = fetchLivros();
      futureLivros.then((data) {
        livros = data;
        livrosFiltrados = data;
      });
    });
  }

  Future<List<Livro>> fetchLivros() async {
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

  void filterLivros(String query) {
    List<Livro> filteredList = livros
        .where((livro) =>
            livro.titulo.toLowerCase().contains(query.toLowerCase()) ||
            livro.autor.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      livrosFiltrados = filteredList;
    });
  }

  Future<void> deleteLivro(BuildContext context, Livro livro) async {
    var url = Uri.parse('http://localhost:8080/livros/apagar/${livro.id}');
    var response = await http.delete(url);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Livro apagado com sucesso.'),
          duration: Duration(seconds: 2),
        ),
      );
      carregarLivros(); // Atualize a lista de livros após a exclusão
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
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Pesquisar livros...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white),
          ),
          style: TextStyle(color: Colors.white),
          onChanged: (query) {
            filterLivros(query);
          },
        ),
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
              child: Text('${snapshot.error}'),
            );
          } else {
            return ListView.builder(
              itemCount: livrosFiltrados.length,
              itemBuilder: (context, index) {
                String urlImagem = 'http://localhost:8080' +
                    livrosFiltrados[index].imagem_capa;
                return Card(
                  margin: EdgeInsets.all(10.0),
                  child: Container(
                    height: 150.0, // Aumentando a altura do Card
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10.0),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          urlImagem,
                          width: 80,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error, color: Colors.red);
                          },
                        ),
                      ),
                      title: Text(livrosFiltrados[index].titulo),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Autor: ${livrosFiltrados[index].autor}'),
                          Text('ISBN: ${livrosFiltrados[index].isbn}'),
                          Text(
                            livrosFiltrados[index].disponibilidade
                                ? 'Disponível'
                                : 'Indisponível',
                            style: TextStyle(
                              color: livrosFiltrados[index].disponibilidade
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          Text(
                            'Sinopse: ${utf8.decode(livrosFiltrados[index].sinopse.runes.toList())}',
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AtualizarLivro(
                                    livro: livrosFiltrados[index],
                                  ),
                                ),
                              );
                              if (result == true) {
                                carregarLivros();
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Confirmar Exclusão'),
                                    content: Text(
                                        'Tem certeza de que deseja apagar este livro?'),
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
                                          Navigator.of(context).pop();
                                          deleteLivro(
                                              context, livrosFiltrados[index]);
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
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CriarLivro()),
          );
          if (result == true) {
            carregarLivros();
          }
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
      ),
    );
  }
}
