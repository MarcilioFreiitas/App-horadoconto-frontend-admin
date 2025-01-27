import 'package:flutter/material.dart';
import 'package:flutter_application_1/config.dart';
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
        '${Config.baseUrl}/emprestimo/devolverEmprestimo/${emprestimo.id}'; // Substitua pela URL correta do seu backend

    final response = await http.put(Uri.parse(url));
    if (response.statusCode == 200) {
      // Exibe a mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Devolução realizada com sucesso.'),
        ),
      );

      // Volta à tela anterior e indica que a devolução foi realizada
      Navigator.of(context).pop(true);
    } else {
      print('Erro ao confirmar devolução: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao realizar devolução.'),
        ),
      );
    }
  }

  String formatStatus(String status) {
    return status.split('.').last;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Livro'),
        backgroundColor: Colors.black, // Deixando o AppBar preto
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: Offset(0, 10),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Nome do usuário: ${emprestimo.nomeUsuario}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Título do livro: ${emprestimo.tituloLivro}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Data de retirada: ${emprestimo.dataRetirada}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Data de devolução: ${emprestimo.dataDevolucao}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Status: ${formatStatus(emprestimo.statusEmprestimo.toString())}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _confirmarDevolucao(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Botão preto
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      shadowColor: Colors.black,
                    ),
                    child: Text('Confirmar Devolução'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[850], // Cor do rodapé igual às outras telas
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
