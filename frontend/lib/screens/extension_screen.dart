import 'package:flutter/material.dart';

class ExtensionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cálculo de Extensión")),
      body: const Center(
        child: Text(
          "Aquí va el cálculo de extensión",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
