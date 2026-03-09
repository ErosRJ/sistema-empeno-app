import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService api = ApiService();

  void _logout() async {
    await api.logout();
    Navigator.pushReplacementNamed(context, '/');
  }

  Widget buildCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.blueAccent),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            buildCard(
              icon: Icons.calculate,
              title: "Calcular Extensión",
              onTap: () => Navigator.pushNamed(context, '/calculo_extension'),
            ),
            const SizedBox(height: 16),

            buildCard(
              icon: Icons.inventory_2_outlined,
              title: "Artículos Empeñados",
              onTap: () => Navigator.pushNamed(context, '/deudas'),
            ),
            const SizedBox(height: 16),

            buildCard(
              icon: Icons.list_alt_outlined,
              title: "Lista de Artículos",
              onTap: () => Navigator.pushNamed(context, '/articulos'),
            ),
            const SizedBox(height: 16),

            buildCard(
              icon: Icons.payments_outlined,
              title: "Pago de Deudas",
              onTap: () => Navigator.pushNamed(context, '/pago_deuda'),
            ),
          ],
        ),
      ),
    );
  }
}
