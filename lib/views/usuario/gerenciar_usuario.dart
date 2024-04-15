import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/usuario/atualizar_usuario.dart';
import 'package:flutter_application_1/views/usuario/criar_usuario.dart';
import 'package:flutter_application_1/views/usuario/deletar_usuario.dart';
import 'package:flutter_application_1/views/usuario/listar_usuarios.dart';

class GerenciarUsuario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Usuário'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CriarUsuario()),
                );
              },
              child: Text('Criar Usuário'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeletarUsuario()),
                );
              },
              child: Text('Deletar Usuário'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AtualizarUsuario()),
                );
              },
              child: Text('Atualizar Usuário'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListarUsuarios()),
                );
              },
              child: Text('Listar Usuários'),
            ),
          ],
        ),
      ),
    );
  }
}
