import 'package:flutter/material.dart';
import '../utils/validators.dart';
import '../services/api_service.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  bool _loading = false;
  final ApiService api = ApiService();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  void _checkSession() async {
    int? clienteId = await api.getStoredClienteId();
    if (clienteId != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    }
  }

  void _doLogin() async {
    if (!_form.currentState!.validate()) return;

    setState(() => _loading = true);

    final data = await api.login(
      _email.text.trim(),
      _pass.text.trim(),
    );

    setState(() => _loading = false);

    if (data != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Credenciales incorrectas"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo / Icono
              Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: const Icon(Icons.lock, size: 48, color: Colors.white),
              ),
              const SizedBox(height: 24),

              // Card del formulario
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Iniciar sesión',
                         style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),

                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        // Correo
                        TextFormField(
                          controller: _email,
                          decoration: InputDecoration(
                            labelText: 'Correo',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.email,
                        ),
                        const SizedBox(height: 16),

                        // Contraseña
                        TextFormField(
                          controller: _pass,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          obscureText: true,
                          validator: Validators.password,
                        ),
                        const SizedBox(height: 24),

                        // Botón Login
                        _loading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: _doLogin,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  "Entrar",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),

                        const SizedBox(height: 12),

                        // Botón Registro
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => RegisterScreen()),
                          ),
                          child: const Text(
                            "¿No tienes cuenta? Crear cuenta",
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
