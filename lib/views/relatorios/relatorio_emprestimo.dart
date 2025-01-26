import 'package:flutter/material.dart';
import 'package:flutter_application_1/config.dart';
import 'package:flutter_application_1/model/emprestimo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RelatorioEmprestimos extends StatefulWidget {
  @override
  _RelatorioEmprestimosState createState() => _RelatorioEmprestimosState();
}

class _RelatorioEmprestimosState extends State<RelatorioEmprestimos> {
  late Future<List<Emprestimo>> futureEmprestimos;

  @override
  void initState() {
    super.initState();
    futureEmprestimos = fetchEmprestimos();
  }

  Future<List<Emprestimo>> fetchEmprestimos() async {
    var url = Uri.parse('${Config.baseUrl}/emprestimo/listarEmprestimo');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      Iterable lista = json.decode(response.body);
      List<Emprestimo> emprestimos = List<Emprestimo>.from(
          lista.map((model) => Emprestimo.fromJson(model)));
      return emprestimos;
    } else {
      throw Exception('Falha ao carregar empréstimos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatório de Empréstimos'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Emprestimo>>(
        future: futureEmprestimos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro: ${snapshot.error}'),
            );
          } else {
            List<Emprestimo> emprestimos = snapshot.data ?? [];
            return ListView.builder(
              itemCount: emprestimos.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text('Título: ${emprestimos[index].tituloLivro}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Usuário: ${emprestimos[index].nomeUsuario}'),
                        Text(
                            'Data de Retirada: ${emprestimos[index].dataRetirada}'),
                        Text(
                            'Data de Devolução: ${emprestimos[index].dataDevolucao}'),
                        Text('Status: ${emprestimos[index].statusEmprestimo}'),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
