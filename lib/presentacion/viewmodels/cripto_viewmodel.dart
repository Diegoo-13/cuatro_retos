import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../dominio/casos_uso/casos_uso_cripto.dart';
import '../../dominio/modelos/criptomoneda.dart';
import 'estado_vista.dart';

class CriptoViewModel extends ChangeNotifier {
  final ObtenerPreciosCripto _obtenerPrecios;
  final ConvertirDolaresACripto _convertir;

  CriptoViewModel(this._obtenerPrecios, this._convertir);

  /// Cada cuánto se actualizan los precios "en tiempo real".
  /// (El plan gratis de CoinGecko aguanta ~30 peticiones/min; 60 s es seguro.)
  static const cadaCuanto = Duration(seconds: 60);

  EstadoVista estado = EstadoVista.inicial;
  List<Criptomoneda> monedas = [];
  String? mensajeError;
  DateTime? ultimaActualizacion;
  double? dolares = 100;
  bool actualizando = false;

  Timer? _reloj;

  void iniciar() {
    cargar();
    _reloj?.cancel();
    _reloj = Timer.periodic(cadaCuanto, (_) => cargar());
  }

  void detener() => _reloj?.cancel();

  Future<void> cargar() async {
    // Si ya hay precios no mostramos el loader grande, solo el pequeñito.
    if (monedas.isNotEmpty) {
      actualizando = true;
    } else {
      estado = EstadoVista.cargando;
    }
    notifyListeners();

    final resultado = await _obtenerPrecios();
    resultado.cuando(
      exito: (lista) {
        monedas = lista;
        ultimaActualizacion = DateTime.now();
        estado = EstadoVista.listo;
        mensajeError = null;
      },
      fallo: (f) {
        mensajeError = f.mensaje;
        // Si ya teníamos precios los dejamos y solo avisamos.
        if (monedas.isEmpty) estado = EstadoVista.error;
      },
    );
    actualizando = false;
    notifyListeners();
  }

  void cambiarDolares(String texto) {
    dolares = texto.trim().isEmpty ? null : _convertir.leerDolares(texto);
    notifyListeners();
  }

  /// Cuánta cripto compras con los dólares escritos.
  double? cuantoCompras(Criptomoneda moneda) =>
      dolares == null ? null : _convertir(dolares!, moneda);

  @override
  void dispose() {
    _reloj?.cancel();
    super.dispose();
  }
}
