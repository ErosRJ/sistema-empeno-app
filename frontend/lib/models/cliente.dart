class Cliente {
  final int? id;
  final String nombreCompleto;
  final String correo;
  final String contrasena;
  final String estadoFinanciero;
  final String telefono;

  Cliente({
    this.id,
    required this.nombreCompleto,
    required this.correo,
    required this.contrasena,
    required this.estadoFinanciero,
    required this.telefono,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nombreCompleto: json['nombreCompleto'] ?? '',
      correo: json['correo'] ?? '',
      contrasena: json['contrasena'] ?? '',
      estadoFinanciero: json['estadoFinanciero'] ?? '',
      telefono: json['telefono'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombreCompleto': nombreCompleto,
      'correo': correo,
      'contrasena': contrasena,
      'estadoFinanciero': estadoFinanciero,
      'telefono': telefono,
    };
  }
}
