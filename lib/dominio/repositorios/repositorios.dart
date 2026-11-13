import '../modelos/clima.dart';
import '../modelos/criptomoneda.dart';
import '../modelos/gato.dart';
import '../modelos/pelicula.dart';
import '../resultado.dart';

// CONTRATOS (interfaces). El dominio dice QUÉ necesita;
// la capa de datos decide CÓMO conseguirlo.

abstract class RepositorioPeliculas {
  Future<Resultado<List<Pelicula>>> obtenerPorAnimo(EstadoAnimo animo,
      {int pagina = 1});
}

abstract class RepositorioGatos {
  /// Pide a la API un gato aleatorio (regresa su id).
  Future<Resultado<Gato>> obtenerGatoAleatorio();

  /// Arma la URL de la imagen con el texto y los filtros.
  String construirUrlMeme(Gato gato, OpcionesMeme opciones);
}

abstract class RepositorioClima {
  Future<Resultado<Clima>> obtenerPorCiudad(String ciudad);
  Future<Resultado<Clima>> obtenerPorCoordenadas(Coordenadas coordenadas);
}

/// Separado del clima: conseguir la ubicación es otra responsabilidad.
abstract class RepositorioUbicacion {
  Future<Resultado<Coordenadas>> obtenerUbicacionActual();
}

abstract class RepositorioCripto {
  Future<Resultado<List<Criptomoneda>>> obtenerPrecios(
      List<MonedaSoportada> monedas);
}
