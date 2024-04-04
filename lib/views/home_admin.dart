import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/gerenciar_livros.dart';

class HomeAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Adicionado aqui
        title: Text('Home Admin'),
      ),
      drawer: Drawer(
        child: ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Logout'),
          onTap: () {
            // Adicione sua lógica de logout aqui
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              child: Text('Gerenciar Livros'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GerenciarLivros()),
                );
              },
            ),
            ElevatedButton(
              child: Text('Gerenciar Empréstimos'),
              onPressed: () {
                // Adicione sua lógica de gerenciamento de empréstimos aqui
              },
            ),
            ElevatedButton(
              child: Text('Gerenciar Usuários'),
              onPressed: () {
                // Adicione sua lógica de gerenciamento de usuários aqui
              },
            ),
          ],
        ),
      ),
    );
  }
}
