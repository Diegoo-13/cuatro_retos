import 'package:flutter/foundation.dart';

import '../../dominio/casos_uso/casos_uso_clima.dart';
import '../../dominio/modelos/clima.dart';
import '../../dominio/resultado.dart';
import 'estado_vista.dart';

class ClimaViewModel extends ChangeNotifier {
  final ObtenerClimaPorCiudad _porCiudad;
  final ObtenerClimaDeMiUbicacion _deMiUbicacion;

  ClimaViewModel(this._porCiudad, this._deMiUbicacion);

  EstadoVista estado = EstadoVista.inicial;
  Clima? clima;
  String? mensajeError;
  /// Ciudad que se muestra al abrir la pestaña.
  static const ciudadInicial = 'Dolores Hidalgo,MX';

  String ultimaCiudad = ciudadInicial;
  bool usandoUbicacion = false;

  Future<void> buscarCiudad([String? ciudad]) async {
    if (ciudad != null) ultimaCiudad = ciudad;
    usandoUbicacion = false;
    await _cargar(() => _porCiudad(ultimaCiudad));
  }

  Future<void> usarMiUbicacion() async {
    usandoUbicacion = true;
    await _cargar(_deMiUbicacion.call);
  }

  Future<void> recargar() => usandoUbicacion ? usarMiUbicacion() : buscarCiudad();

  Future<void> _cargar(Future<Resultado<Clima>> Function() accion) async {
    estado = EstadoVista.cargando;
    notifyListeners();
    final resultado = await accion();
    resultado.cuando(
      exito: (c) {
        clima = c;
        estado = EstadoVista.listo;
      },
      fallo: (f) {
        mensajeError = f.mensaje;
        estado = EstadoVista.error;
      },
    );
    notifyListeners();
  }
}
