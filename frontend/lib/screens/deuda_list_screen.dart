import 'package:flutter/material.dart';
import '../models/articulo.dart';
import '../services/api_service.dart';

class DeudaListScreen extends StatefulWidget {
  const DeudaListScreen({super.key});

  @override
  State<DeudaListScreen> createState() => _DeudaListScreenState();
}

class _DeudaListScreenState extends State<DeudaListScreen> {
  final ApiService api = ApiService();

  // 🔥 Inicialización segura para evitar LateInitializationError
  late Future<List<Articulo>> _futureArticulos = Future.value([]);

  @override
  void initState() {
    super.initState();
    _loadArticulos();
  }

  // 🔵 Cargar artículos del cliente
  void _loadArticulos() async {
    final clienteId = await api.getStoredClienteId();

    if (clienteId != null) {
      final future = api.fetchArticulosByCliente(clienteId);
      setState(() {
        _futureArticulos = future;
      });
    }
  }

  // 🔴 Pagar artículo (eliminar)
  void _pagarArticulo(Articulo articulo) async {
    bool ok = await api.deleteArticulo(articulo.id!);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Artículo #${articulo.id} pagado correctamente'),
          backgroundColor: Colors.green,
        ),
      );
      _loadArticulos();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al pagar el artículo'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Artículos Empeñados'),
      ),
      body: FutureBuilder<List<Articulo>>(
        future: _futureArticulos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar artículos: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final articulos = snapshot.data ?? [];
          if (articulos.isEmpty) {
            return const Center(child: Text('No hay artículos empeñados'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: articulos.length,
            itemBuilder: (ctx, i) {
              final a = articulos[i];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    a.tipoArticulo,
                    style: theme.textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    'Valor: \$${a.valorEstimado.toStringAsFixed(2)}\n'
                    'Estado: ${a.estado}\n'
                    'Fecha empeño: ${a.fechaEmpeno}',
                  ),
                  isThreeLine: true,
                  trailing: ElevatedButton(
                    onPressed: () => _pagarArticulo(a),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Pagar'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
