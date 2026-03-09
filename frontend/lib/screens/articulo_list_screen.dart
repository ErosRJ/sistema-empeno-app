import 'package:flutter/material.dart';
import '../models/articulo.dart';
import '../services/api_service.dart';

class ArticuloListScreen extends StatefulWidget {
  @override
  State<ArticuloListScreen> createState() => _ArticuloListScreenState();
}

class _ArticuloListScreenState extends State<ArticuloListScreen> {
  final ApiService api = ApiService();

  late Future<List<Articulo>> _futureArticulos = Future.value([]);

  final tipoCtrl = TextEditingController();
  final valorCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadArticulos();
  }

  void _loadArticulos() async {
    final clienteId = await api.getStoredClienteId();
    if (clienteId != null) {
      setState(() {
        _futureArticulos = api.fetchArticulosByCliente(clienteId);
      });
    }
  }

  void _agregarArticulo() async {
    final tipo = tipoCtrl.text.trim();
    final valor = double.tryParse(valorCtrl.text.trim());

    if (tipo.isEmpty || valor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    final clienteId = await api.getStoredClienteId();

bool ok = await api.addArticulo(
        Articulo(
        id: null,
        tipoArticulo: tipo,
        valorEstimado: valor,
        estado: "empenado",
        idCliente: clienteId!,
        fechaEmpeno: DateTime.now().toString(),
      ),
    );

    if (ok) {
      tipoCtrl.clear();
      valorCtrl.clear();
      _loadArticulos();
    }
  }

  void _eliminar(Articulo articulo) async {
    bool ok = await api.deleteArticulo(articulo.id!);
    if (ok) _loadArticulos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Agregar / Lista de Artículos")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: tipoCtrl,
              decoration: InputDecoration(labelText: "Tipo de artículo"),
            ),
            TextField(
              controller: valorCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Valor estimado"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _agregarArticulo,
              child: Text("Agregar Artículo"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Articulo>>(
                future: _futureArticulos,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final lista = snapshot.data!;
                  if (lista.isEmpty) {
                    return Center(child: Text("No tienes artículos registrados"));
                  }

                  return ListView(
                    children: lista.map((a) {
                      return Card(
                        child: ListTile(
                          title: Text(a.tipoArticulo),
                          subtitle:
                              Text("Valor: \$${a.valorEstimado.toStringAsFixed(2)}"),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _eliminar(a),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
  