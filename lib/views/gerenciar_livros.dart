import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/atualizar_livro.dart';
import 'package:flutter_application_1/views/deletar_livro.dart';
import 'package:flutter_application_1/views/listar_livro.dart';
import 'package:flutter_application_1/views/criar_livro.dart';

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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListaLivrosPut()),
                );
              },
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
