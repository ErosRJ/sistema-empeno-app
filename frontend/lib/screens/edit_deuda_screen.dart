import 'package:flutter/material.dart';
import '../models/deuda.dart';
import '../services/api_service.dart';
import '../widgets/input_field.dart';

class EditDeudaScreen extends StatefulWidget {
  final Deuda deuda;
  EditDeudaScreen({required this.deuda});
  @override
  State<EditDeudaScreen> createState() => _EditDeudaScreenState();
}

class _EditDeudaScreenState extends State<EditDeudaScreen> {
  final _form = GlobalKey<FormState>();
  late TextEditingController _monto;
  late TextEditingController _estado;
  final api = ApiService();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _monto = TextEditingController(text: widget.deuda.monto.toString());
    _estado = TextEditingController(text: widget.deuda.estado);
  }

  void _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => loading = true);
    final deuda = Deuda(
      id: widget.deuda.id,
      idCliente: widget.deuda.idCliente,
      idArticulo: widget.deuda.idArticulo,
      monto: double.tryParse(_monto.text) ?? 0.0,
      estado: _estado.text.trim(),
      fechaPago: widget.deuda.fechaPago,
    );
    final ok = await api.updateDeuda(deuda);
    setState(() => loading = false);
    if (ok) Navigator.pop(context);
    else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar deuda')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Deuda')),
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
