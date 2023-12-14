import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:proyectoapi/models/favorito_model.dart';

class AuthService extends ChangeNotifier {
  final String _baseUrl =
      'LoginTest.somee.com'; // Reemplaza con tu URL de backend
  final storage = FlutterSecureStorage();

  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };

    final url = Uri.http(_baseUrl, '/api/Cuentas/registrar');

    final resp = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(authData),
    );

    try {
      final dynamic decodedResp = json.decode(resp.body);

      if (decodedResp is Map<String, dynamic>) {
        if (decodedResp.containsKey('token')) {
          await storage.write(key: 'token', value: decodedResp['token']);
          await storage.write(key: 'email', value: email);

          return null;
        } else {
          return decodedResp['error'] ?? 'Error desconocido';
        }
      } else {
        return 'Error desconocido: La respuesta del servidor no es válida';
      }
    } catch (e) {
      print('Error decoding JSON: $e');
      return 'Error al procesar la respuesta del servidor';
    }
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };
    final url = Uri.http(_baseUrl, '/api/Cuentas/login');

    final resp = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(authData),
    );

    try {
      final Map<String, dynamic> decodedResp = json.decode(resp.body);

      if (decodedResp.containsKey('token')) {
        await storage.write(key: 'token', value: decodedResp['token']);
        await storage.write(key: 'email', value: email);

        return null;
      } else {
        return decodedResp['error'] ?? 'Inicio de sesión incorrecto';
      }
    } catch (e) {
      print('Error decoding JSON: $e');
      return 'Error al iniciar sesión';
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  Future<void> agregarFavorito(
      BuildContext context, String imageUrl, String userId) async {
    try {
      final String token = await readToken();

      final Favorito favorito = Favorito(
        userId: userId,
        urls: imageUrl,
      );

      final url = Uri.http(_baseUrl, '/api/Cuentas/Favoritos');

      await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(favorito.toJson()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Imagen agregada a favoritos con éxito'),
        ),
      );
    } catch (error) {
      print('Error al agregar favorito: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al agregar favorito'),
        ),
      );
    }
  }

  Future<List<Favorito>> obtenerFavoritos() async {
    try {
      final String token = await readToken();

      final String userId =
          await obtenerUserId(); // Agrega esta línea para obtener el userId

      final url = Uri.http(_baseUrl, '/api/Cuentas/Favoritos/$userId');

      final resp = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      if (resp.statusCode == 200) {
        final List<dynamic> decodedData = json.decode(resp.body);
        final List<Favorito> favoritos =
            decodedData.map((json) => Favorito.fromJson(json)).toList();
        return favoritos;
      } else {
        print('Error al obtener favoritos: ${resp.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error al obtener favoritos: $error');
      return [];
    }
  }

  Future<String> obtenerUserId() async {
    try {
      final String email = await storage.read(key: 'email') ?? '';
      final url = Uri.http(_baseUrl, '/api/Cuentas/ObtenerUserId/$email');
      final resp = await http.get(url);

      if (resp.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(resp.body);
        return decodedData['userId'] ?? '';
      } else {
        print('Error al obtener userId: ${resp.statusCode}');
        return '';
      }
    } catch (error) {
      print('Error al obtener userId: $error');
      return '';
    }
  }
}
