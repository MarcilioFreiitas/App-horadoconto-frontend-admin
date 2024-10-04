import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/livro.dart';
import 'package:http/http.dart' as http;

class AtualizarLivro extends StatefulWidget {
  final Livro livro;

  AtualizarLivro({required this.livro});

  @override
  _AtualizarLivroState createState() => _AtualizarLivroState();
}

class _AtualizarLivroState extends State<AtualizarLivro> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _autorController;
  late TextEditingController _generoController;
  late TextEditingController _sinopseController;
  late TextEditingController _isbnController;
  late TextEditingController _imagemController;
  late bool _disponibilidade;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.livro.titulo);
    _autorController = TextEditingController(text: widget.livro.autor);
    _generoController = TextEditingController(
        text: widget.livro.genero.toString().split('.').last);
    _sinopseController = TextEditingController(text: widget.livro.sinopse);
    _isbnController = TextEditingController(text: widget.livro.isbn);
    _imagemController = TextEditingController(text: widget.livro.imagem_capa);
    _disponibilidade = widget.livro.disponibilidade;
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
          child: ListView(
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
                    return 'Por favor, insira o gênero';
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
                    return 'Por favor, insira o ISBN';
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
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Atualizar livro'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await atualizarLivro();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> atualizarLivro() async {
    var url =
        Uri.parse('http://localhost:8080/livros/alterar/${widget.livro.id}');
    var response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*"
      },
      body: jsonEncode(<String, dynamic>{
        'titulo': _tituloController.text,
        'autor': _autorController.text,
        'genero': _generoController.text,
        'sinopse': _sinopseController.text,
        'isbn': _isbnController.text,
        'disponibilidade': _disponibilidade,
        'imagem_capa': _imagemController.text,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Livro atualizado com sucesso.')));
      Navigator.pop(context, true); // Retorna um resultado verdadeiro
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Falha ao atualizar o livro.')));
    }
  }
}
