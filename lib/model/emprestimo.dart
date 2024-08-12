enum StatusEmprestimo { ATRASADO, REJEITADO, PENDENTE, EMPRESTADO }

class Emprestimo {
  final String id;
  final String nomeUsuario;
  final String tituloLivro;
  final String dataRetirada;
  final String dataDevolucao;
  final StatusEmprestimo statusEmprestimo;

  Emprestimo({
    required this.id,
    required this.nomeUsuario,
    required this.tituloLivro,
    required this.dataRetirada,
    required this.dataDevolucao,
    required this.statusEmprestimo,
  });

  factory Emprestimo.fromJson(Map<String, dynamic> json) {
    return Emprestimo(
      id: json['id'].toString(),
      nomeUsuario: json['nomeUsuario'],
      tituloLivro: json['tituloLivro'],
      dataRetirada: json['dataRetirada'],
      dataDevolucao: json['dataDevolucao'],
      statusEmprestimo: StatusEmprestimo.values.firstWhere(
        (e) => e.toString() == 'StatusEmprestimo.${json['statusEmprestimo']}',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomeUsuario': nomeUsuario,
      'tituloLivro': tituloLivro,
      'dataRetirada': dataRetirada,
      'dataDevolucao': dataDevolucao,
      'statusEmprestimo': statusEmprestimo.toString().split('.').last,
    };
  }
}
