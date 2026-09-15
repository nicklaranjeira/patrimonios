class Patrimonios {
  final String id;
  final String descricao;
  final String local;
  final String responsavel;

  Patrimonios({
    required this.id,
    required this.descricao,
    required this.local,
    required this.responsavel,
  });

  factory Patrimonios.fromJson(Map<String, dynamic> json) {
    return Patrimonios(
      id: json['id'],
      descricao: json['descricao'],
      local: json['local'],
      responsavel: json['responsavel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
      'local': local,
      'responsavel': responsavel,
    };
  }
}


  // Converte os dados recebidos da API
  // em um objeto Equipamentos.

