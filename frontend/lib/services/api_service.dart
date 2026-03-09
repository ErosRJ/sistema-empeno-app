import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cliente.dart';
import '../models/articulo.dart';
import '../models/deuda.dart';

class ApiService {
  static const String baseUrl = "http://192.168.1.71:8080/api";

  // ====================================================
  //                    AUTH
  // ====================================================

  Future<Map<String, dynamic>?> login(String correo, String contrasena) async {
    try {
      final url = Uri.parse('$baseUrl/clientes/login');

      final resp = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'correo': correo, 'contrasena': contrasena}),
      );

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('clienteId', data['id']);
        await prefs.setString('clienteNombre', data['nombreCompleto']);
        await prefs.setString('clienteCorreo', data['correo']);

        return data;
      } else {
        print("Login failed: ${resp.body}");
      }
    } catch (e) {
      print("Login exception: $e");
    }
    return null;
  }

  Future<bool> registerCliente(Cliente cliente) async {
    try {
      final url = Uri.parse('$baseUrl/clientes/register');

      final clienteJson = cliente.toJson();
      clienteJson['telefono'] = clienteJson['telefono'].toString();

      final resp = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(clienteJson),
      );

      return resp.statusCode == 200 || resp.statusCode == 201;
    } catch (e) {
      print("Register exception: $e");
      return false;
    }
  }

  Future<int?> getStoredClienteId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('clienteId');
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // ====================================================
  //                    CLIENTE
  // ====================================================

  Future<Cliente?> getClienteById(int id) async {
    try {
      final url = Uri.parse('$baseUrl/clientes/$id');
      final resp = await http.get(url);

      if (resp.statusCode == 200) {
        return Cliente.fromJson(jsonDecode(resp.body));
      }
    } catch (e) {
      print("GetCliente error: $e");
    }
    return null;
  }

  // ====================================================
  //                 ARTICULOS (CRUD)
  // ====================================================

  Future<bool> addArticulo(Articulo articulo) async {
    try {
      if (articulo.idCliente == null) {
        print("Error: idCliente es null.");
        return false;
      }

      final url = Uri.parse('$baseUrl/articulos/add');
      final body = jsonEncode(articulo.toJsonWithCliente());

      final resp = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      return resp.statusCode == 200 || resp.statusCode == 201;
    } catch (e) {
      print("AddArticulo exception: $e");
      return false;
    }
  }

  Future<List<Articulo>> fetchArticulosByCliente(int clienteId) async {
    try {
      final url = Uri.parse('$baseUrl/articulos/cliente/$clienteId');
      final resp = await http.get(url);

      if (resp.statusCode == 200) {
        List<dynamic> data = jsonDecode(resp.body);
        return data.map((e) => Articulo.fromJson(e)).toList();
      }
    } catch (e) {
      print("FetchArticulos error: $e");
    }
    return [];
  }

  Future<bool> updateArticulo(Articulo articulo) async {
    try {
      if (articulo.id == null) {
        print("Error: id null.");
        return false;
      }

      final url = Uri.parse('$baseUrl/articulos/update/${articulo.id}');
      final resp = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(articulo.toJsonWithCliente()),
      );

      return resp.statusCode == 200;
    } catch (e) {
      print("UpdateArticulo error: $e");
      return false;
    }
  }

  Future<bool> deleteArticulo(int articuloId) async {
    try {
      final url = Uri.parse('$baseUrl/articulos/delete/$articuloId');
      final resp = await http.delete(url);

      return resp.statusCode == 200 || resp.statusCode == 204;
    } catch (e) {
      print("DeleteArticulo error: $e");
      return false;
    }
  }

  // ====================================================
  //                 DEUDAS (CRUD)
  // ====================================================

  Future<bool> addDeuda(Deuda deuda) async {
    try {
      if (deuda.idCliente == null) {
        print("Error: cliente null");
        return false;
      }

      final url = Uri.parse('$baseUrl/deudas/add');
      final body = jsonEncode(deuda.toJsonWithRefs());

      final resp = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      return resp.statusCode == 200 || resp.statusCode == 201;
    } catch (e) {
      print("AddDeuda exception: $e");
      return false;
    }
  }

  Future<List<Deuda>> fetchDeudasByCliente(int clienteId) async {
    try {
      final url = Uri.parse('$baseUrl/deudas/cliente/$clienteId');
      final resp = await http.get(url);

      if (resp.statusCode == 200) {
        List<dynamic> data = jsonDecode(resp.body);
        return data.map((e) => Deuda.fromJson(e)).toList();
      }
    } catch (e) {
      print("FetchDeudas error: $e");
    }
    return [];
  }

  Future<bool> updateDeuda(Deuda deuda) async {
    try {
      if (deuda.id == null) {
        print("Error: id null");
        return false;
      }

      final url = Uri.parse('$baseUrl/deudas/update/${deuda.id}');
      final resp = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(deuda.toJsonWithRefs()),
      );

      return resp.statusCode == 200;
    } catch (e) {
      print("UpdateDeuda error: $e");
      return false;
    }
  }

  Future<bool> deleteDeuda(int deudaId) async {
    try {
      final url = Uri.parse('$baseUrl/deudas/delete/$deudaId');
      final resp = await http.delete(url);

      return resp.statusCode == 200 || resp.statusCode == 204;
    } catch (e) {
      print("DeleteDeuda error: $e");
      return false;
    }
  }

  Future<bool> pagarDeuda(int deudaId, double monto) async {
    try {
      final url = Uri.parse('$baseUrl/deudas/pagar/$deudaId');
      final resp = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"montoPago": monto}),
      );

      return resp.statusCode == 200;
    } catch (e) {
      print("PagarDeuda error: $e");
      return false;
    }
  }
}
