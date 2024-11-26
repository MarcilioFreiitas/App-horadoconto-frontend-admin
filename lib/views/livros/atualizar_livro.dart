import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/livro.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/service/file_picker_service.dart';

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
  late Genero _generoSelecionado;
  late TextEditingController _sinopseController;
  late TextEditingController _isbnController;
  html.File? _imagemCapa;
  Uint8List? _imagemCapaBytes;
  String? _imagemCapaUrl;
  late bool _disponibilidade;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.livro.titulo);
    _autorController = TextEditingController(text: widget.livro.autor);
    _generoSelecionado = Genero.values.firstWhere(
        (g) => g.toString().split('.').last == widget.livro.genero.toString(),
        orElse: () => Genero.FICCAO);
    _sinopseController = TextEditingController(text: widget.livro.sinopse);
    _isbnController = TextEditingController(text: widget.livro.isbn);
    _imagemCapaUrl = 'http://localhost:8080${widget.livro.imagem_capa}';
    _disponibilidade = widget.livro.disponibilidade;
  }

  Future<void> pickImage() async {
    final selectedImage = await pickFile(); // Use a função do serviço
    setState(() {
      if (selectedImage != null) {
        _imagemCapa = selectedImage; // Armazene o arquivo selecionado
        final reader = html.FileReader();
        reader.readAsArrayBuffer(_imagemCapa!);
        reader.onLoadEnd.listen((e) {
          setState(() {
            _imagemCapaBytes = reader.result as Uint8List?;
            _imagemCapaUrl = html.Url.createObjectUrlFromBlob(_imagemCapa!);
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    _sinopseController.dispose();
    _isbnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Atualizar Livro'),
        backgroundColor: Colors.black,
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
                        primary: Colors.black,
                        minimumSize: Size(double.infinity, 50), // Botão maior
                      ),
                      child: Text('Selecionar nova imagem da capa'),
                      onPressed: pickImage,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        minimumSize: Size(double.infinity, 50), // Botão maior
                      ),
                      child: Text('Atualizar livro'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await atualizarLivro();
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (_imagemCapaUrl != null)
                Container(
                  height: 150,
                  child: Image.network(
                    _imagemCapaUrl!,
                    fit: BoxFit.contain,
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

  Future<void> atualizarLivro() async {
    var url =
        Uri.parse('http://localhost:8080/livros/alterar/${widget.livro.id}');

    var request = http.MultipartRequest('PUT', url)
      ..fields['titulo'] = _tituloController.text
      ..fields['autor'] = _autorController.text
      ..fields['genero'] = _generoSelecionado.toString().split('.').last
      ..fields['sinopse'] = _sinopseController.text
      ..fields['isbn'] = _isbnController.text
      ..fields['disponibilidade'] = _disponibilidade.toString();

    if (_imagemCapaBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'imagem_capa',
        _imagemCapaBytes!,
        filename: _imagemCapa!.name,
      ));
    }

    var response = await request.send();

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
