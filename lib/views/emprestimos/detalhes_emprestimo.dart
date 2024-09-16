import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/emprestimo.dart';

class DetalhesEmprestimoScreen extends StatelessWidget {
  final Emprestimo emprestimo;

  DetalhesEmprestimoScreen({required this.emprestimo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Empréstimo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID do Empréstimo: ${emprestimo.id}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Usuário: ${emprestimo.nomeUsuario}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Livro: ${emprestimo.tituloLivro}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Data de Retirada: ${emprestimo.dataRetirada}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Data de Devolução: ${emprestimo.dataDevolucao}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text(
                'Status: ${emprestimo.statusEmprestimo.toString().split('.').last}',
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
