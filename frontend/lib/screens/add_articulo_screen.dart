import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/articulo.dart';

class AddArticuloScreen extends StatefulWidget {
  @override
  State<AddArticuloScreen> createState() => _AddArticuloScreenState();
}

class _AddArticuloScreenState extends State<AddArticuloScreen> {
  final _form = GlobalKey<FormState>();
  final _tipo = TextEditingController();
  final _estado = TextEditingController();
  final _valor = TextEditingController();
  bool _loading = false;
  final ApiService api = ApiService();

  void _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    final clienteId = await api.getStoredClienteId();
    if (clienteId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: no identificado')));
      setState(() => _loading = false);
      return;
    }

    final articulo = Articulo(
      idCliente: clienteId,
      tipoArticulo: _tipo.text.trim(),
      estado: _estado.text.trim(),
      valorEstimado: double.tryParse(_valor.text) ?? 0.0,
    );

    final ok = await api.addArticulo(articulo);
    setState(() => _loading = false);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Artículo agregado')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al agregar')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Artículo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(controller: _tipo, decoration: InputDecoration(labelText: 'Tipo de artículo'), validator: (v) => v == null || v.isEmpty ? 'Obligatorio' : null),
              const SizedBox(height: 10),
              TextFormField(controller: _estado, decoration: InputDecoration(labelText: 'Estado'), validator: (v) => v == null || v.isEmpty ? 'Obligatorio' : null),
              const SizedBox(height: 10),
              TextFormField(controller: _valor, decoration: InputDecoration(labelText: 'Valor estimado'), keyboardType: TextInputType.number, validator: (v) {
                if (v == null || v.isEmpty) return 'Obligatorio';
                if (double.tryParse(v) == null) return 'Número inválido';
                return null;
              }),
              const SizedBox(height: 20),
              _loading ? CircularProgressIndicator() : ElevatedButton(onPressed: _submit, child: Text('Guardar')),
            ],
          ),
        ),
      ),
    );
  }
}
