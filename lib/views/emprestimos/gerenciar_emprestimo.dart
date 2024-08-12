import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/emprestimo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GerenciarEmprestimo extends StatefulWidget {
  @override
  _GerenciarEmprestimoState createState() => _GerenciarEmprestimoState();
}

class _GerenciarEmprestimoState extends State<GerenciarEmprestimo> {
  List<Emprestimo> emprestimos = [];

  @override
  void initState() {
    super.initState();
    fetchEmprestimos();
  }

  Future<void> fetchEmprestimos() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:8080/emprestimo/listarEmprestimo'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data != null && data.isNotEmpty) {
          setState(() {
            emprestimos =
                data.map((item) => Emprestimo.fromJson(item)).toList();
          });
        } else {
          throw Exception('Dados nulos ou vazios recebidos do servidor');
        }
      } else {
        throw Exception('Falha ao carregar empréstimos');
      }
    } catch (e) {
      print('Erro ao fazer a requisição: $e');
    }
  }

  Future<void> aprovarEmprestimo(String id) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:8080/emprestimo/aprovar/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        print('Empréstimo aprovado com sucesso');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GerenciarEmprestimo()),
        );
      } else {
        throw Exception('Falha ao aprovar empréstimo');
      }
    } catch (e) {
      print('Erro ao fazer a requisição: $e');
    }
  }

  Future<void> rejeitarEmprestimo(String id) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:8080/emprestimo/rejeitar/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        print('Empréstimo rejeitado com sucesso');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GerenciarEmprestimo()),
        );
      } else {
        throw Exception('Falha ao rejeitar empréstimo');
      }
    } catch (e) {
      print('Erro ao fazer a requisição: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Empréstimos'),
      ),
      body: ListView.builder(
        itemCount: emprestimos.length,
        itemBuilder: (context, index) {
          final emprestimo = emprestimos[index];
          return ListTile(
            title: Text('Empréstimo ${emprestimo.id}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Usuário: ${emprestimo.nomeUsuario}'),
                Text('Livro: ${emprestimo.tituloLivro}'),
                Text('Data de Retirada: ${emprestimo.dataRetirada}'),
                Text('Data de Devolução: ${emprestimo.dataDevolucao}'),
                Text(
                    'Status: ${emprestimo.statusEmprestimo.toString().split('.').last}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.check_circle_sharp),
                  onPressed: () => aprovarEmprestimo(emprestimo.id),
                ),
                IconButton(
                  icon: Icon(Icons.backspace_outlined),
                  onPressed: () => rejeitarEmprestimo(emprestimo.id),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => rejeitarEmprestimo(emprestimo.id),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
