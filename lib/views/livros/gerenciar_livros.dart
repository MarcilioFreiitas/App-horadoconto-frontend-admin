import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/livros/atualizar_livro.dart';
import 'package:flutter_application_1/views/livros/deletar_livro.dart';
import 'package:flutter_application_1/views/livros/listar_livro.dart';
import 'package:flutter_application_1/views/livros/criar_livro.dart';

class GerenciarLivros extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Livros'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Criar Livro'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CriarLivro()),
                );
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Consultar todos os livros'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListaLivros()),
                );
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Atualizar Livro'),
              onPressed: () {},
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Deletar Livro'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListaLivrosDelete()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
