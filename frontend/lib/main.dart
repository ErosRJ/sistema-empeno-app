import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/articulo_list_screen.dart';
import 'screens/deuda_list_screen.dart';
import 'screens/pago_deuda_screen.dart';
import 'screens/calculo_extension_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Casa de Empeño',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (_) => LoginScreen(),
        '/register': (_) => RegisterScreen(),
        '/home': (_) => HomeScreen(),
        '/articulos': (_) => ArticuloListScreen(),
        '/deudas': (_) => DeudaListScreen(),
        '/pago_deuda': (_) => PagoDeudaScreen(),
        '/calculo_extension': (_) => ExtensionScreen(), // 👈 NUEVA
      },
    );
  }
}
