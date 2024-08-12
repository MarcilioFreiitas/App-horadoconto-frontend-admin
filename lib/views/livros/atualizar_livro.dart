import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/livro.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ListaLivrosPut extends StatelessWidget {
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
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AtualizarLivro(livro: livro)),
          );
        },
        tooltip: 'Atualizar',
        child: Icon(Icons.update),
      ),
    );
  }
}

class AtualizarLivro extends StatefulWidget {
  final Livro livro;

  AtualizarLivro({Key? key, required this.livro}) : super(key: key);

  @override
  _AtualizarLivroState createState() => _AtualizarLivroState();
}

class _AtualizarLivroState extends State<AtualizarLivro> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _autorController;
  late TextEditingController _generoController;
  late bool _disponibilidade;
  late TextEditingController _sinopseController;
  late TextEditingController _imagemController;
  late TextEditingController _isbnController;
  // Adicione mais controladores para os outros campos

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.livro.titulo);
    _autorController = TextEditingController(text: widget.livro.autor);
    _generoController = TextEditingController(text: widget.livro.genero);
    _disponibilidade = widget.livro.disponibilidade;
    _sinopseController = TextEditingController(text: widget.livro.sinopse);
    _imagemController = TextEditingController(text: widget.livro.imagem_capa);
    _isbnController = TextEditingController(text: widget.livro.isbn);

    // Inicialize os outros controladores com os valores atuais do livro
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Atualizar Livro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(
                  labelText: 'Título',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o título';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _autorController,
                decoration: InputDecoration(
                  labelText: 'Autor',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o autor';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _generoController,
                decoration: InputDecoration(
                  labelText: 'Gênero',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o Gênero';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _sinopseController,
                decoration: InputDecoration(
                  labelText: 'Sinopse',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a sinopse';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _isbnController,
                decoration: InputDecoration(
                  labelText: 'ISBN',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a ISBN';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imagemController,
                decoration: InputDecoration(
                  labelText: 'Imagem',
                ),
              ),
              SwitchListTile(
                title: const Text('Disponibilidade'),
                value: _disponibilidade,
                onChanged: (bool value) {
                  setState(() {
                    _disponibilidade = value;
                  });
                },
                secondary: const Icon(Icons.book),
              ),
              // Adicione mais campos de texto para os outros campos
              ElevatedButton(
                child: Text('Atualizar Livro'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    String titulo = _tituloController.text;
                    String autor = _autorController.text;
                    String genero = _generoController.text;
                    String sinopse = _sinopseController.text;
                    bool disponibilidade = _disponibilidade;
                    String isbn = _isbnController.text;
                    String imagem = _imagemController.text;
                    // Obtenha os valores dos outros campos

                    atualizarLivro(widget.livro.id, titulo, autor, genero,
                        sinopse, disponibilidade, isbn, imagem, context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void atualizarLivro(
    int id,
    String titulo,
    String autor,
    String genero,
    String sinopse,
    bool disponibilidade,
    String isbn,
    String imagem,
    BuildContext context) async {
  var url = Uri.parse('http://10.0.0.106:8080/livros/alterar/$id');
  var response = await http.put(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Access-Control-Allow-Origin": "*"
    },
    body: jsonEncode(<String, dynamic>{
      'titulo': titulo,
      'autor': autor,
      'genero': genero,
      'sinopse': sinopse,
      'isbn': isbn,
      'disponibilidade': disponibilidade,
      'imagem_capa': imagem,
      // Adicione os outros campos aqui
    }),
  );

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Livro atualizado com sucesso.')));
  } else {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Falha ao atualizar o livro.')));
  }
}
