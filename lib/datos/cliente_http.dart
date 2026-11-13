import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'config_claves.dart';

// ---------- Excepciones de la capa de DATOS ----------
// Los repositorios las atrapan y las convierten en un Fallo del dominio.

class ExcepcionServidor implements Exception {
  final int codigo;
  final String? mensaje;
  const ExcepcionServidor({required this.codigo, this.mensaje});
}

class ExcepcionRed implements Exception {
  final String mensaje;
  const ExcepcionRed([this.mensaje = 'Sin conexión a internet']);
}

class ExcepcionFaltaClave implements Exception {
  final String api;
  const ExcepcionFaltaClave(this.api);
}

class ExcepcionUbicacion implements Exception {
  final String mensaje;
  const ExcepcionUbicacion(this.mensaje);
}

class ExcepcionFormato implements Exception {
  final String mensaje;
  const ExcepcionFormato([this.mensaje = 'Respuesta inesperada del servidor']);
}

/// Cliente HTTP compartido por los 4 retos.
/// Hace el GET, revisa el código de estado y decodifica el JSON.
class ClienteHttp {
  final http.Client _cliente;

  ClienteHttp(this._cliente);

  Future<dynamic> obtenerJson(Uri uri, {Map<String, String>? encabezados}) async {
    final http.Response respuesta;
    try {
      respuesta = await _cliente
          .get(uri, headers: {'Accept': 'application/json', ...?encabezados})
          .timeout(ConfigClaves.tiempoEspera);
    } on TimeoutException {
      throw const ExcepcionRed('El servidor tardó demasiado en responder');
    } on http.ClientException {
      throw const ExcepcionRed();
    }

    if (respuesta.statusCode != 200) {
      throw ExcepcionServidor(
        codigo: respuesta.statusCode,
        mensaje: _leerMensaje(respuesta.body),
      );
    }

    try {
      // utf8.decode para que se vean bien los acentos y la ñ.
      return jsonDecode(utf8.decode(respuesta.bodyBytes));
    } on FormatException {
      throw const ExcepcionFormato();
    }
  }

  /// Intenta sacar el mensaje de error que mandan las APIs en el JSON.
  String? _leerMensaje(String cuerpo) {
    try {
      final json = jsonDecode(cuerpo);
      if (json is Map) {
        return (json['message'] ?? json['status_message'] ?? json['error'])
            ?.toString();
      }
    } catch (_) {}
    return null;
  }
}
