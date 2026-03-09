class Deuda {
  final int? id;
  final int? idCliente;
  final int? idArticulo;
  final double monto;
  final String estado;
  final String fechaPago;

  Deuda({
    this.id,
    this.idCliente,
    this.idArticulo,
    required this.monto,
    required this.estado,
    required this.fechaPago,
  });

  factory Deuda.fromJson(Map<String, dynamic> json) {
    return Deuda(
      id: json['id'],
      idCliente: json['cliente']?['id'] ?? json['idCliente'],
      idArticulo: json['articulo']?['id'] ?? json['idArticulo'],
      monto: (json['monto'] ?? 0).toDouble(),
      estado: json['estado'] ?? '',
      fechaPago: json['fechaPago'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'monto': monto,
      'estado': estado,
      'fechaPago': fechaPago,
      if (idCliente != null) 'idCliente': idCliente,
      if (idArticulo != null) 'idArticulo': idArticulo,
    };
  }

  /// Enviar al backend
  Map<String, dynamic> toJsonWithRefs() {
    return {
      'monto': monto,
      'estado': estado,
      'fechaPago': fechaPago,
      if (idCliente != null) 'cliente': {'id': idCliente},
      if (idArticulo != null) 'articulo': {'id': idArticulo},
    };
  }
}
