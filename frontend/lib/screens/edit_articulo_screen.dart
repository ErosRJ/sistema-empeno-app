import 'package:flutter/material.dart';
import '../models/articulo.dart';
import '../services/api_service.dart';
import '../widgets/input_field.dart';

class EditArticuloScreen extends StatefulWidget {
  final Articulo articulo;
  EditArticuloScreen({required this.articulo});
  @override
  State<EditArticuloScreen> createState() => _EditArticuloScreenState();
}

class _EditArticuloScreenState extends State<EditArticuloScreen> {
  final _form = GlobalKey<FormState>();
  late TextEditingController _tipo;
  late TextEditingController _estado;
  late TextEditingController _valor;
  final api = ApiService();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _tipo = TextEditingController(text: widget.articulo.tipoArticulo);
    _estado = TextEditingController(text: widget.articulo.estado);
    _valor = TextEditingController(text: widget.articulo.valorEstimado.toString());
  }

  void _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => loading = true);
    final art = Articulo(
      id: widget.articulo.id,
      idCliente: widget.articulo.idCliente,
      tipoArticulo: _tipo.text.trim(),
      estado: _estado.text.trim(),
      valorEstimado: double.tryParse(_valor.text) ?? 0.0,
    );
    final ok = await api.updateArticulo(art);
    setState(() => loading = false);
    if (ok) Navigator.pop(context);
    else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar artículo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            children: [
              InputField(controller: _tipo, label: 'Tipo de artículo', validator: (v)=>v==null||v.isEmpty?'Obligatorio':null),
              InputField(controller: _estado, label: 'Estado', validator: (v)=>v==null||v.isEmpty?'Obligatorio':null),
              InputField(controller: _valor, label: 'Valor estimado', keyboard: TextInputType.number, validator: (v){
                if (v==null||v.isEmpty) return 'Obligatorio';
                if(double.tryParse(v)==null) return 'Número inválido';
                return null;
              }),
              const SizedBox(height: 20),
              loading ? CircularProgressIndicator() : ElevatedButton(onPressed: _save, child: Text('Guardar')),
            ],
          ),
        ),
      ),
    );
  }
}
