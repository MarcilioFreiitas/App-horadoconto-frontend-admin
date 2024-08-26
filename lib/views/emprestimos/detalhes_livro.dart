import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/emprestimo.dart';
import 'package:http/http.dart' as http;

class DetalhesLivroScreen extends StatelessWidget {
  final Emprestimo emprestimo;

  DetalhesLivroScreen({required this.emprestimo});

  Future<void> _confirmarDevolucao(BuildContext context) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Devolução'),
          content: Text('Deseja confirmar a devolução deste livro?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancelar
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirmar
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );

    if (confirmado == true) {
      await _realizarDevolucao(
          context); // Chame o método para realizar a devolução
    }
  }

  Future<void> _realizarDevolucao(BuildContext context) async {
    final url =
        'http://localhost:8080/emprestimo/devolverEmprestimo/${emprestimo.id}'; // Substitua pela URL correta do seu backend

    final response = await http.put(Uri.parse(url));
    if (response.statusCode == 200) {
      // Exibe a mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Devolução realizada com sucesso.'),
        ),
      );

      // Recarrega a página automaticamente
      Navigator.of(context).pop(); // Volta à tela anterior
    } else {
      print('Erro ao confirmar devolução: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Livro'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nome: ${emprestimo.nomeUsuario}'),
            Text('Título: ${emprestimo.tituloLivro}'),
            Text('Data de devolução: ${emprestimo.dataRetirada}'),
            Text('Data de devolução: ${emprestimo.dataDevolucao}'),
            Text('Status: ${emprestimo.statusEmprestimo}'),
            // ... (outras informações relevantes sobre o livro)
            ElevatedButton(
              onPressed: () => _confirmarDevolucao(context),
              child: Text('Confirmar Devolução'),
            ),
          ],
        ),
      ),
    );
  }
}
