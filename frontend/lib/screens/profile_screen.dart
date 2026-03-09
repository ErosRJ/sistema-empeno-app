import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/cliente.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Cliente? cliente;
  final ApiService api = ApiService();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final id = await api.getStoredClienteId();
    if (id != null) {
      final c = await api.getClienteById(id);
      setState(() {
        cliente = c;
        loading = false;
      });
    } else {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Center(child: CircularProgressIndicator());
    if (cliente == null) return Center(child: Text('No hay usuario'));
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ListTile(title: Text('Nombre'), subtitle: Text(cliente!.nombreCompleto)),
          ListTile(title: Text('Correo'), subtitle: Text(cliente!.correo)),
          ListTile(title: Text('Teléfono'), subtitle: Text(cliente!.telefono ?? '')),
          ListTile(title: Text('Estado financiero'), subtitle: Text(cliente!.estadoFinanciero ?? '')),
        ],
      ),
    );
  }
}
