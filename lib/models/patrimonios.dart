class Patrimonios {
  final dynamic id;
  final String numeroInventario;
  final String descricao;
  final String local;
  final String responsavel;
  final String? dataRegistro;

  Patrimonios({
    this.id,
    required this.numeroInventario,
    required this.descricao,
    required this.local,
    required this.responsavel,
    this.dataRegistro,
  });

  /// Converte o JSON recebido da API em uma instância de Patrimonios
  factory Patrimonios.fromJson(Map<String, dynamic> json) {
    return Patrimonios(
      id: json['id'],
      numeroInventario: (json['n_do_inventario'] ??
              json['numero_inventario'] ??
              json['numeroInventario'] ??
              json['id'] ??
              '')
          .toString(),
      descricao: (json['descricao'] ?? '').toString(),
      local: (json['local'] ?? '').toString(),
      responsavel: (json['responsavel'] ?? '').toString(),
      dataRegistro: json['data_de_registro']?.toString(),
    );
  }

  /// Converte os dados para o formato esperado pelo backend
  /// Envia tanto n_do_inventario quanto numero_inventario para garantir compatibilidade
  Map<String, dynamic> toJson() {
    final inv = numeroInventario.isNotEmpty
        ? numeroInventario
        : (id?.toString() ?? '');
    return {
      'n_do_inventario': inv,
      'numero_inventario': inv,
      'descricao': descricao,
      'local': local,
      'responsavel': responsavel,
    };
  }

  /// Identificador textual para exibição amigável
  String get idTexto => id != null ? id.toString() : numeroInventario;
}
