import 'package:flutter/material.dart';
import 'package:flutter_application_1/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'dart:html' as html;
import 'package:http_parser/http_parser.dart'; // Importe a biblioteca correta
// Importe o serviço de seleção de arquivos

void createLivro(
    String autor,
    String titulo,
    String genero,
    bool disponibilidade,
    String sinopse,
    String isbn,
    html.File imagemCapa, // Adicione a imagem como parâmetro
    BuildContext context) async {
  try {
    final reader = html.FileReader();
    reader.readAsArrayBuffer(imagemCapa);
    await reader.onLoad.first;

    final bytes = reader.result as Uint8List;
    final formData = FormData.fromMap({
      'autor': autor,
      'titulo': titulo,
      'genero': genero,
      'disponibilidade': disponibilidade.toString(),
      'sinopse': sinopse,
      'isbn': isbn,
      'imagem_capa': MultipartFile.fromBytes(bytes,
          filename: imagemCapa.name, contentType: MediaType('image', 'jpeg')),
    });

    var dio = Dio();
    var response = await dio.post(
      '${Config.baseUrl}/livros/salvar',
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Livro inserido com sucesso!')));
      Navigator.pop(context); // Volta para a tela anterior
    } else {
      throw Exception('Falha ao inserir o livro');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao selecionar o arquivo: $e')));
  }
}
