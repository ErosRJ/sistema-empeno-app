class Validators {
  static String? required(String? v) => (v == null || v.trim().isEmpty) ? 'Campo obligatorio' : null;

  static String? email(String? v) {
    if (v == null || v.isEmpty) return 'Correo obligatorio';
    final re = RegExp(r'^\S+@\S+\.\S+$');
    return re.hasMatch(v) ? null : 'Correo no válido';
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Contraseña obligatoria';
    if (v.length < 6) return 'Al menos 6 caracteres';
    return null;
  }

  static String? telephone(String? v) {
    if (v == null || v.isEmpty) return 'Teléfono obligatorio';
    final re = RegExp(r'^\+?[0-9]{7,15}$');
    return re.hasMatch(v) ? null : 'Teléfono no válido';
  }
}
