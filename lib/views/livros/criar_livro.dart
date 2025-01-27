import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/file_picker_service.dart';
import 'package:flutter_application_1/service/service_livro/service_livro_post.dart';

enum Genero {
  FICCAO,
  NAO_FICCAO,
  ROMANCE,
  FANTASIA,
  TERROR,
  MISTERIO,
  BIOGRAFIA,
  HISTORIA,
  CIENCIA,
  POESIA,
}

class CriarLivro extends StatefulWidget {
  @override
  _CriarLivroState createState() => _CriarLivroState();
}

class _CriarLivroState extends State<CriarLivro> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _autorController = TextEditingController();
  late Genero _generoSelecionado;
  late bool _disponibilidade;
  final TextEditingController _sinopseController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  html.File? _imagemCapa;
  String? _imagemCapaUrl;

  @override
  void initState() {
    super.initState();
    _disponibilidade = false;
    _generoSelecionado = Genero.FICCAO; // Valor padrão
  }

  Future<void> pickImage() async {
    final selectedImage = await pickFile(); // Use a função do serviço
    setState(() {
      if (selectedImage != null) {
        _imagemCapa = selectedImage; // Armazene o arquivo selecionado
        _imagemCapaUrl = html.Url.createObjectUrl(_imagemCapa);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Livro'),
        backgroundColor: Colors.black,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
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
              DropdownButtonFormField<Genero>(
                value: _generoSelecionado,
                decoration: InputDecoration(labelText: 'Gênero'),
                items: Genero.values.map((Genero genero) {
                  return DropdownMenuItem<Genero>(
                    value: genero,
                    child: Text(genero.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (Genero? newValue) {
                  setState(() {
                    _generoSelecionado = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione um gênero';
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: Size(double.infinity, 50), // Botão maior
                      ),
                      child: Text('Selecionar imagem da capa'),
                      onPressed: pickImage,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: Size(double.infinity, 50), // Botão maior
                      ),
                      child: Text('Cadastrar livro'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_imagemCapa != null) {
                            String titulo = _tituloController.text;
                            String autor = _autorController.text;
                            String genero =
                                _generoSelecionado.toString().split('.').last;
                            String sinopse = _sinopseController.text;
                            bool disponibilidade = _disponibilidade;
                            String isbn = _isbnController.text;
                            createLivro(autor, titulo, genero, disponibilidade,
                                sinopse, isbn, _imagemCapa!, context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Por favor, selecione uma imagem da capa')));
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (_imagemCapaUrl != null)
                Center(
                  child: Container(
                    height: 150,
                    child: Image.network(
                      _imagemCapaUrl!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[850],
        child: Container(
          height: 50.0,
          alignment: Alignment.center,
          child: Text(
            'Hora do conto © 2024 IFPE - Palmares. Todos os direitos reservados.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
