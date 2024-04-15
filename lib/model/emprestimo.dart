import 'package:flutter_application_1/model/livro.dart';
import 'package:flutter_application_1/model/usuario.dart';

// ignore: constant_identifier_names
enum StatusEmprestimo { ATIVO, ATRASADO, PENDENDE, APROVADO, REJEITADO }

class Emprestimo {
  final String id;
  final Usuario usuario;
  final Livro livro;
  final String dataRetirada;
  final String dataDevolucao;
  final StatusEmprestimo statusEmprestimo;

  Emprestimo({
    required this.id,
    required this.usuario,
    required this.livro,
    required this.dataRetirada,
    required this.dataDevolucao,
    required this.statusEmprestimo,
  });

  factory Emprestimo.fromJson(Map<String, dynamic> json) {
    return Emprestimo(
      id: json['id'].toString(),
      usuario: Usuario.fromJson(json['usuario']),
      livro: Livro.fromJson(json['livro']),
      dataRetirada: json['dataRetirada'],
      dataDevolucao: json['dataDevolucao'],
      statusEmprestimo: StatusEmprestimo.values.firstWhere((e) =>
          e.toString() == 'StatusEmprestimo.${json['statusEmprestimo']}'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario': usuario.toJson(),
      'livro': livro.toJson(),
      'dataRetirada': dataRetirada,
      'dataDevolucao': dataDevolucao,
      'statusEmprestimo': statusEmprestimo
          .toString()
          .split('.')
          .last, // Isso irá retornar apenas o valor do enum
    };
  }
}
