import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/emprestimos/gerenciar_emprestimo.dart';
import 'package:flutter_application_1/views/livros/gerenciar_livros.dart';
import 'package:flutter_application_1/views/livros/listar_livro.dart';
import 'package:flutter_application_1/views/usuario/gerenciar_usuario.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_application_1/views/admin_login_screen.dart';

class HomeAdmin extends StatelessWidget {
  final storage = FlutterSecureStorage();

  Future<void> logout(BuildContext context) async {
    await storage.delete(key: 'token'); // Deleta o token de autenticação
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              AdminLoginScreen()), // Redireciona para a tela de login
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // AppBar na cor preta
        automaticallyImplyLeading: true, // Drawer no canto superior esquerdo
        title: Image.asset('assets/images/ifpe2.png',
            height: 35), // Logo no lugar do texto
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              logout(context); // Chama a lógica de logout
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Relatório de empréstimos'),
          onTap: () {
            logout(context); // Chama a lógica de logout
          },
        ),
      ),
      body: Container(
        color: Colors.grey[200], // Cor de fundo em um tom de cinza claro
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black, // Botão na cor preta
                    minimumSize: Size(500, 300), // Tamanho maior dos botões
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Botões arredondados
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListaLivros()),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.book,
                          color: Colors.white, size: 80), // Ícone grande
                      Text('Gerenciar Livros',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24)), // Texto grande
                    ],
                  ),
                ),
                SizedBox(width: 40), // Espaçamento entre os botões
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    minimumSize: Size(500, 300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GerenciarEmprestimo()),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.assignment, color: Colors.white, size: 80),
                      Text('Gerenciar Empréstimos',
                          style: TextStyle(color: Colors.white, fontSize: 24)),
                    ],
                  ),
                ),
                SizedBox(width: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    minimumSize: Size(500, 300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GerenciarUsuario()),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person, color: Colors.white, size: 80),
                      Text('Gerenciar Usuários',
                          style: TextStyle(color: Colors.white, fontSize: 24)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[850], // Cor do rodapé
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
