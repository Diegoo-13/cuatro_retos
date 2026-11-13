import '../../dominio/modelos/clima.dart';
import '../../dominio/modelos/criptomoneda.dart';
import '../../dominio/modelos/gato.dart';
import '../../dominio/modelos/pelicula.dart';
import '../../dominio/repositorios/repositorios.dart';
import '../../dominio/resultado.dart';
import '../manejo_errores.dart';
import '../servicios/servicio_clima.dart';
import '../servicios/servicio_cripto.dart';
import '../servicios/servicio_gatos.dart';
import '../servicios/servicio_peliculas.dart';
import '../servicios/servicio_ubicacion.dart';

// IMPLEMENTACIONES de los contratos del dominio.
// Usan los servicios y convierten los errores en Fallos con protegerLlamada.

class RepositorioPeliculasImpl implements RepositorioPeliculas {
  final ServicioPeliculas servicio;
  RepositorioPeliculasImpl(this.servicio);

  @override
  Future<Resultado<List<Pelicula>>> obtenerPorAnimo(EstadoAnimo animo,
          {int pagina = 1}) =>
      protegerLlamada<List<Pelicula>>(
        () => servicio.obtenerPeliculas(animo, pagina: pagina),
        mensaje401:
            'Tu API key de TMDB no es válida. Usa la "API Key (v3)", no el token largo.',
      );
}

class RepositorioGatosImpl implements RepositorioGatos {
  final ServicioGatos servicio;
  RepositorioGatosImpl(this.servicio);

  @override
  Future<Resultado<Gato>> obtenerGatoAleatorio() =>
      protegerLlamada<Gato>(servicio.obtenerGatoAleatorio);

  @override
  String construirUrlMeme(Gato gato, OpcionesMeme opciones) =>
      servicio.construirUrlMeme(gato, opciones);
}

class RepositorioClimaImpl implements RepositorioClima {
  final ServicioClima servicio;
  RepositorioClimaImpl(this.servicio);

  // OpenWeatherMap responde 401 cuando la key es nueva y aún no se activa.
  static const _mensaje401 = 'OpenWeatherMap rechazó la API key (401).\n\n'
      'Si la acabas de crear es normal: puede tardar hasta 2 horas en activarse. '
      'Si ya pasó ese tiempo, revisa que la copiaste bien en secrets.json.';

  @override
  Future<Resultado<Clima>> obtenerPorCiudad(String ciudad) =>
      protegerLlamada<Clima>(
        () => servicio.porCiudad(ciudad),
        mensaje401: _mensaje401,
        mensaje404: 'No encontré la ciudad "$ciudad" 🤔',
      );

  @override
  Future<Resultado<Clima>> obtenerPorCoordenadas(Coordenadas coordenadas) =>
      protegerLlamada<Clima>(
        () => servicio.porCoordenadas(coordenadas),
        mensaje401: _mensaje401,
      );
}

class RepositorioUbicacionImpl implements RepositorioUbicacion {
  final ServicioUbicacion servicio;
  RepositorioUbicacionImpl(this.servicio);

  @override
  Future<Resultado<Coordenadas>> obtenerUbicacionActual() =>
      protegerLlamada<Coordenadas>(servicio.obtenerPosicion);
}

class RepositorioCriptoImpl implements RepositorioCripto {
  final ServicioCripto servicio;
  RepositorioCriptoImpl(this.servicio);

  @override
  Future<Resultado<List<Criptomoneda>>> obtenerPrecios(
          List<MonedaSoportada> monedas) =>
      protegerLlamada<List<Criptomoneda>>(() => servicio.obtenerPrecios(monedas));
}
