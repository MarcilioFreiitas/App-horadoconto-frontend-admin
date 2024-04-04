import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/service_livro/service_livro_post.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class CriarLivro extends StatefulWidget {
  @override
  _CriarLivroState createState() => _CriarLivroState();
}

class _CriarLivroState extends State<CriarLivro> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _autorController = TextEditingController();
  final TextEditingController _generoController = TextEditingController();
  late bool _disponibilidade;
  final TextEditingController _sinopseController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  File? _imagemCapa;
  // Adicione mais controladores para os outros campos
  @override
  void initState() {
    super.initState();
    _disponibilidade = false; // Adicione esta linha
  }

  Future pickImage() async {
    final selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (selectedImage != null) {
        _imagemCapa = File(selectedImage.path);
      }
    });
  }

  Future uploadImage(BuildContext context) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.0.0.106:8080/livros/uploadCapa'));
    request.files.add(
        await http.MultipartFile.fromPath('imagem_capa', _imagemCapa!.path));
    var response = await request.send();
    if (response.statusCode == 200) {
      print('Upload bem-sucedido');
    } else {
      print('Upload falhou');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Livro'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o título';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _autorController,
                decoration: InputDecoration(labelText: 'Autor'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o autor';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _generoController,
                decoration: InputDecoration(labelText: 'Gênero'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o Gênero';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _sinopseController,
                decoration: InputDecoration(labelText: 'Sinopse'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira a sinopse';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _isbnController,
                decoration: InputDecoration(labelText: 'ISBN'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o ISBN';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
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
                child: Text('Selecionar imagem da capa'),
                onPressed: pickImage,
              ),
              SizedBox(height: 20),
              // Adicione mais campos de texto para os outros campos
              ElevatedButton(
                child: Text('Cadastar livro'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    String titulo = _tituloController.text;
                    String autor = _autorController.text;
                    String genero = _generoController.text;
                    String sinopse = _sinopseController.text;
                    bool disponibilidade = _disponibilidade;
                    String isbn = _isbnController.text;
                    String imagem = _imagemCapa!.path;
                    createLivro(autor, titulo, genero, disponibilidade, sinopse,
                        isbn, imagem, context);
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
