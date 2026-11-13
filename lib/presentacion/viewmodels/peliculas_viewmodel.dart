import 'package:flutter/foundation.dart';

import '../../dominio/casos_uso/casos_uso_peliculas.dart';
import '../../dominio/excepciones.dart';
import '../../dominio/modelos/pelicula.dart';
import 'estado_vista.dart';

class PeliculasViewModel extends ChangeNotifier {
  final ObtenerPeliculasPorAnimo _obtenerPorAnimo;
  final ObtenerPeliculaAleatoria _obtenerAleatoria;

  PeliculasViewModel(this._obtenerPorAnimo, this._obtenerAleatoria);

  EstadoVista estado = EstadoVista.inicial;
  EstadoAnimo animo = EstadoAnimo.tendencias;
  List<Pelicula> peliculas = [];
  String? mensajeError;
  bool buscandoAleatoria = false;

  Future<void> cargar([EstadoAnimo? nuevoAnimo]) async {
    if (nuevoAnimo != null) animo = nuevoAnimo;
    estado = EstadoVista.cargando;
    notifyListeners();

    final resultado = await _obtenerPorAnimo(animo);
    resultado.cuando(
      exito: (lista) {
        peliculas = lista;
        estado = EstadoVista.listo;
      },
      fallo: (f) {
        mensajeError = f.mensaje;
        estado = EstadoVista.error;
      },
    );
    notifyListeners();
  }

  /// Regresa la película o el fallo para que la pantalla muestre
  /// la hoja de detalle o un SnackBar.
  Future<({Pelicula? pelicula, Fallo? fallo})> sorprendeme() async {
    buscandoAleatoria = true;
    notifyListeners();
    final resultado = await _obtenerAleatoria(animo);
    buscandoAleatoria = false;
    notifyListeners();
    return resultado.cuando<({Pelicula? pelicula, Fallo? fallo})>(
      exito: (p) => (pelicula: p, fallo: null),
      fallo: (f) => (pelicula: null, fallo: f),
    );
  }
}
