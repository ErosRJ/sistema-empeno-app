import 'package:flutter/material.dart';

class ExtensionScreen extends StatefulWidget {
  @override
  State<ExtensionScreen> createState() => _ExtensionScreenState();
}

class _ExtensionScreenState extends State<ExtensionScreen> {
  final diasCtrl = TextEditingController();
  final montoCtrl = TextEditingController();

  double? resultadoTotal;
  double? resultadoInteres;

  void _calcular() {
    final dias = int.tryParse(diasCtrl.text);
    final monto = double.tryParse(montoCtrl.text);

    if (dias == null || monto == null) return;

    // Interés diario: 3%
    double interes = monto * 0.03 * dias;
    double total = monto + interes;

    setState(() {
      resultadoInteres = interes;
      resultadoTotal = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cálculo de Extensión"),
        centerTitle: true,
        elevation: 4,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ingresa los datos:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),

            SizedBox(height: 20),

            TextField(
              controller: montoCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Monto actual de la deuda",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 15),

            TextField(
              controller: diasCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Días a extender",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calcular,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  "Calcular Extensión",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            SizedBox(height: 30),

            if (resultadoInteres != null)
              Center(
                child: Column(
                  children: [
                    Text(
                      "Interés generado: \$${resultadoInteres!.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Total a pagar: \$${resultadoTotal!.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
