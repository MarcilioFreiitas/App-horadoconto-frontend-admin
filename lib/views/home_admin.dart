// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/emprestimos/gerenciar_emprestimo.dart';
import 'package:flutter_application_1/views/livros/gerenciar_livros.dart';
import 'package:flutter_application_1/views/livros/listar_livro.dart';
import 'package:flutter_application_1/views/relatorios/relatorio_emprestimo.dart';
import 'package:flutter_application_1/views/relatorios/relatorio_estoque.dart';
import 'package:flutter_application_1/views/relatorios/relatorio_livro_mais_emprestado.dart';
import 'package:flutter_application_1/views/usuario/gerenciar_usuario.dart';
import 'package:flutter_application_1/views/usuario/listar_usuarios.dart';
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
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              logout(context); // Chama a lógica de logout
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.insert_chart),
              title: const Text('Relatório de Empréstimos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          RelatorioEmprestimos()), // Navegação para o novo relatório
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text('Relatório de Estoque de Livros'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          RelatorioEstoqueLivros()), // Navegação para o novo relatório
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text('Relatório de livros mais emprestados'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          RelatorioLivrosMaisEmprestados()), // Navegação para o novo relatório
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey[200], // Cor de fundo em um tom de cinza claro
        child: Center(
          child: SingleChildScrollView(
            child: ResponsiveWidget(
              mobile: buildButtonColumn(context, true),
              tablet: buildCenteredRow(context),
              desktop: buildCenteredRow(context),
            ),
          ),
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

  Widget buildButtonColumn(BuildContext context, bool isMobile) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildButton(context,
            icon: Icons.book,
            label: 'Gerenciar Livros',
            destination: ListaLivros()),
        SizedBox(height: 20),
        buildButton(context,
            icon: Icons.assignment,
            label: 'Gerenciar Empréstimos',
            destination: GerenciarEmprestimo()),
        SizedBox(height: 20),
        buildButton(context,
            icon: Icons.person,
            label: 'Gerenciar Usuários',
            destination: ListarUsuarios()),
      ],
    );
  }

  Widget buildCenteredRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: buildButton(context,
                icon: Icons.book,
                label: 'Gerenciar Livros',
                destination: ListaLivros()),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: buildButton(context,
                icon: Icons.assignment,
                label: 'Gerenciar Empréstimos',
                destination: GerenciarEmprestimo()),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: buildButton(context,
                icon: Icons.person,
                label: 'Gerenciar Usuários',
                destination: ListarUsuarios()),
          ),
        ),
      ],
    );
  }

  Widget buildButton(BuildContext context,
      {required IconData icon,
      required String label,
      required Widget destination}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black, // Botão na cor preta
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Botões arredondados
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 80), // Ícone grande
          Text(label,
              style:
                  TextStyle(color: Colors.white, fontSize: 24)), // Texto grande
        ],
      ),
    );
  }
}

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  ResponsiveWidget(
      {required this.mobile, required this.tablet, required this.desktop});

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  @override
  Widget build(BuildContext context) {
    if (isDesktop(context)) {
      return desktop;
    } else if (isTablet(context)) {
      return tablet;
    } else {
      return mobile;
    }
  }
}
