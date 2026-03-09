import 'package:flutter/material.dart';
import '../utils/validators.dart';
import '../services/api_service.dart';
import '../models/cliente.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _estado = TextEditingController();
  final _telefono = TextEditingController();
  bool _loading = false;
  final ApiService api = ApiService();

  void _register() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    final cliente = Cliente(
      nombreCompleto: _name.text.trim(),
      correo: _email.text.trim(),
      contrasena: _pass.text,
      estadoFinanciero: _estado.text.trim(),
      telefono: _telefono.text.trim(),
    );
    final ok = await api.registerCliente(cliente);
    setState(() => _loading = false);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registrado')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al registrar')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              children: [
                TextFormField(controller: _name, decoration: InputDecoration(labelText: 'Nombre completo'), validator: Validators.required),
                const SizedBox(height: 10),
                TextFormField(controller: _email, decoration: InputDecoration(labelText: 'Correo'), validator: Validators.email),
                const SizedBox(height: 10),
                TextFormField(controller: _pass, decoration: InputDecoration(labelText: 'Contraseña'), obscureText: true, validator: Validators.password),
                const SizedBox(height: 10),
                TextFormField(controller: _estado, decoration: InputDecoration(labelText: 'Estado financiero'), validator: Validators.required),
                const SizedBox(height: 10),
                TextFormField(controller: _telefono, decoration: InputDecoration(labelText: 'Teléfono'), keyboardType: TextInputType.phone, validator: Validators.telephone),
                const SizedBox(height: 20),
                _loading ? CircularProgressIndicator() : ElevatedButton(onPressed: _register, child: Text('Registrar')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
