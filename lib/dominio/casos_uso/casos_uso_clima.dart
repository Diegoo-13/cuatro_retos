import '../excepciones.dart';
import '../modelos/clima.dart';
import '../repositorios/repositorios.dart';
import '../resultado.dart';

class ObtenerClimaPorCiudad {
  final RepositorioClima repositorio;
  ObtenerClimaPorCiudad(this.repositorio);

  Future<Resultado<Clima>> call(String ciudad) async {
    final limpia = ciudad.trim();
    if (limpia.isEmpty) {
      return const Fracaso<Clima>(
          FalloNoEncontrado('Escribe el nombre de una ciudad'));
    }
    return repositorio.obtenerPorCiudad(limpia);
  }
}

/// Combina dos repositorios: primero la ubicación y luego el clima.
class ObtenerClimaDeMiUbicacion {
  final RepositorioUbicacion repositorioUbicacion;
  final RepositorioClima repositorioClima;

  ObtenerClimaDeMiUbicacion(this.repositorioUbicacion, this.repositorioClima);

  Future<Resultado<Clima>> call() async {
    final ubicacion = await repositorioUbicacion.obtenerUbicacionActual();
    switch (ubicacion) {
      case Exito<Coordenadas>(dato: final coordenadas):
        return repositorioClima.obtenerPorCoordenadas(coordenadas);
      case Fracaso<Coordenadas>(fallo: final f):
        return Fracaso<Clima>(f);
    }
  }
}
