class Articulo {
  final int? id;
  final int? idCliente;
  final String tipoArticulo;
  final String estado;
  final double valorEstimado;
  final String? fechaEmpeno;

  Articulo({
    this.id,
    this.idCliente,
    required this.tipoArticulo,
    required this.estado,
    required this.valorEstimado,
    this.fechaEmpeno,
  });

  factory Articulo.fromJson(Map<String, dynamic> json) {
    return Articulo(
      id: json['id'],
      idCliente: json['cliente']?['id'] ?? json['idCliente'],
      tipoArticulo: json['tipoArticulo'] ?? '',
      estado: json['estado'] ?? '',
      valorEstimado: (json['valorEstimado'] ?? 0).toDouble(),
      fechaEmpeno: json['fechaEmpeno'] ?? json['fechaEmpeño']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'tipoArticulo': tipoArticulo,
      'estado': estado,
      'valorEstimado': valorEstimado,
      if (idCliente != null) 'idCliente': idCliente,
    };
  }

  /// Para enviar al backend correctamente
  Map<String, dynamic> toJsonWithCliente() {
    return {
      'tipoArticulo': tipoArticulo,
      'estado': estado,
      'valorEstimado': valorEstimado,
      'cliente': {'id': idCliente},
    };
  }
}
