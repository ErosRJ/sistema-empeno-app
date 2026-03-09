import 'package:flutter/material.dart';
import '../models/deuda.dart';
import '../services/api_service.dart';
import '../widgets/input_field.dart';

class AddDeudaScreen extends StatefulWidget {
  @override
  State<AddDeudaScreen> createState() => _AddDeudaScreenState();
}

class _AddDeudaScreenState extends State<AddDeudaScreen> {
  final _form = GlobalKey<FormState>();
  final _monto = TextEditingController();
  final _estado = TextEditingController(text: 'pendiente');
  final api = ApiService();
  bool loading = false;

  void _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => loading = true);
    final clienteId = await api.getStoredClienteId();

    final deuda = Deuda(
      idCliente: clienteId,
      idArticulo: null,
      monto: double.tryParse(_monto.text) ?? 0.0,
      estado: _estado.text.trim(),
      fechaPago: DateTime.now().toIso8601String(),
    );

    final ok = await api.addDeuda(deuda);
    setState(() => loading = false);
    if (ok) Navigator.pop(context);
    else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al crear deuda')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Deuda')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            children: [
              InputField(controller: _monto, label: 'Monto', keyboard: TextInputType.number, validator: (v){
                if (v==null||v.isEmpty) return 'Obligatorio';
                if (double.tryParse(v)==null) return 'Número inválido';
                return null;
              }),
              InputField(controller: _estado, label: 'Estado', validator: (v)=>v==null||v.isEmpty?'Obligatorio':null),
              const SizedBox(height: 20),
              loading ? CircularProgressIndicator() : ElevatedButton(onPressed: _save, child: Text('Guardar')),
            ],
          ),
        ),
      ),
    );
  }
}
