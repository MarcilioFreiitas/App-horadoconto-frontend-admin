import 'package:flutter_application_1/model/emprestimo.dart';

enum UserRoles { ADMIN, USER }

class Usuario {
  final String id;
  final String nome;
  final String sobreNome;
  final String cpf;
  final String email;
  final String senha;
  final UserRoles role;
  final List<Emprestimo> emprestimos;

  Usuario({
    required this.id,
    required this.nome,
    required this.sobreNome,
    required this.cpf,
    required this.email,
    required this.senha,
    required this.role,
    required this.emprestimos,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id']?.toString() ?? '',
      nome: json['nome'] ?? 'Nome não informado',
      sobreNome: json['sobreNome'] ?? 'Sobrenome não informado',
      cpf: json['cpf'] ?? 'CPF não informado',
      email: json['email'] ?? 'Email não informado',
      senha: json['senha'] ?? '',
      role: UserRoles.values.firstWhere(
        (e) => e.toString() == 'UserRoles.${json['role']}',
        orElse: () => UserRoles.USER, // Valor padrão caso o papel seja nulo
      ),
      emprestimos: json['emprestimos'] != null
          ? (json['emprestimos'] as List)
              .map((emprestimo) => Emprestimo.fromJson(emprestimo))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'sobreNome': sobreNome,
      'cpf': cpf,
      'email': email,
      'senha': senha,
      'role':
          role.toString().split('.').last, // Retorna apenas 'ADMIN' ou 'USER'
      'emprestimos':
          emprestimos.map((emprestimo) => emprestimo.toJson()).toList(),
    };
  }
}
