import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../dominio/casos_uso/casos_uso_gatos.dart';
import '../../dominio/modelos/gato.dart';
import 'estado_vista.dart';

class GatosViewModel extends ChangeNotifier {
  final ObtenerGatoAleatorio _obtenerGato;
  final ConstruirUrlMeme _construirUrl;

  GatosViewModel(this._obtenerGato, this._construirUrl);

  EstadoVista estado = EstadoVista.inicial;
  String? mensajeError;
  Gato? gato;
  OpcionesMeme opciones = const OpcionesMeme();

  /// URL de la imagen que se muestra (se recalcula con cada cambio).
  String? urlImagen;

  Timer? _espera;

  Future<void> otroGato() async {
    estado = EstadoVista.cargando;
    notifyListeners();

    final resultado = await _obtenerGato();
    resultado.cuando(
      exito: (g) {
        gato = g;
        estado = EstadoVista.listo;
        _recalcularUrl();
      },
      fallo: (f) {
        mensajeError = f.mensaje;
        estado = EstadoVista.error;
      },
    );
    notifyListeners();
  }

  /// Se llama con cada tecla. Esperamos 600 ms a que el usuario deje de
  /// escribir para no pedir una imagen por cada letra ("debounce").
  void cambiarTexto(String texto) {
    _espera?.cancel();
    _espera = Timer(const Duration(milliseconds: 600), () {
      opciones = opciones.copiarCon(texto: texto);
      _recalcularUrl();
      notifyListeners();
    });
  }

  void cambiarFiltro(FiltroGato f) => _actualizar(opciones.copiarCon(filtro: f));
  void cambiarColor(ColorLetra c) => _actualizar(opciones.copiarCon(color: c));
  void cambiarTamano(double t) =>
      _actualizar(opciones.copiarCon(tamanoLetra: t.round()));

  void _actualizar(OpcionesMeme nuevas) {
    opciones = nuevas;
    _recalcularUrl();
    notifyListeners();
  }

  void _recalcularUrl() {
    if (gato != null) urlImagen = _construirUrl(gato!, opciones);
  }

  @override
  void dispose() {
    _espera?.cancel();
    super.dispose();
  }
}
