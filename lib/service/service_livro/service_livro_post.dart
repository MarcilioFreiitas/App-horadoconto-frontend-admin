import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/livros/criar_livro.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';

void createLivro(
    String autor,
    String titulo,
    String genero,
    bool disponibilidade,
    String sinopse,
    String isbn,
    String imagem,
    BuildContext context) async {
  var dio = Dio();
  var formData = FormData.fromMap({
    'autor': autor,
    'titulo': titulo,
    'genero': genero,
    'disponibilidade': disponibilidade.toString(),
    'sinopse': sinopse,
    'isbn': isbn,
    'imagem_capa': await MultipartFile.fromFile(imagem,
        contentType: MediaType('image', 'jpeg')),
  });

  var response = await dio.post(
    'http://10.0.0.106:8080/livros/salvar',
    data: formData,
    options: Options(
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    ),
  );

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Livro inserido com sucesso !')));
  } else {
    throw Exception('Falha ao inserir o livro');
  }
}
