import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/articulo.dart';

class PagoDeudaScreen extends StatefulWidget {
  @override
  State<PagoDeudaScreen> createState() => _PagoDeudaScreenState();
}

class _PagoDeudaScreenState extends State<PagoDeudaScreen> {
  final ApiService api = ApiService();
  late Future<List<Articulo>> _futureArticulos = Future.value([]);

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final id = await api.getStoredClienteId();
    if (id != null) {
      setState(() {
        _futureArticulos = api.fetchArticulosByCliente(id);
      });
    }
  }

  void _pagar(Articulo a) async {
    await api.deleteArticulo(a.id!);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pago de Deudas")),
      body: FutureBuilder(
        future: _futureArticulos,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final lista = snapshot.data!;
          if (lista.isEmpty) return Center(child: Text("No tienes deudas por pagar"));

          return ListView(
            padding: EdgeInsets.all(16),
            children: lista.map((a) {
              return Card(
                child: ListTile(
                  title: Text(a.tipoArticulo),
                  subtitle: Text("Valor: \$${a.valorEstimado}"),
                  trailing: ElevatedButton(
                    onPressed: () => _pagar(a),
                    child: Text("Pagar"),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
