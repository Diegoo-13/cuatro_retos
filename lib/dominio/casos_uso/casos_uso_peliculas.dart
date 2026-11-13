import 'dart:math';

import '../excepciones.dart';
import '../modelos/pelicula.dart';
import '../repositorios/repositorios.dart';
import '../resultado.dart';

class ObtenerPeliculasPorAnimo {
  final RepositorioPeliculas repositorio;
  ObtenerPeliculasPorAnimo(this.repositorio);

  Future<Resultado<List<Pelicula>>> call(EstadoAnimo animo) =>
      repositorio.obtenerPorAnimo(animo);
}

/// Regla de negocio: "recomiéndame UNA película al azar según mi ánimo".
/// Pide una página aleatoria (1-5) y escoge una película al azar de esa página.
class ObtenerPeliculaAleatoria {
  final RepositorioPeliculas repositorio;
  final Random _azar;

  ObtenerPeliculaAleatoria(this.repositorio, {Random? azar})
      : _azar = azar ?? Random();

  Future<Resultado<Pelicula>> call(EstadoAnimo animo) async {
    final pagina = _azar.nextInt(5) + 1;
    final resultado = await repositorio.obtenerPorAnimo(animo, pagina: pagina);

    return resultado.cuando<Resultado<Pelicula>>(
      exito: (peliculas) {
        if (peliculas.isEmpty) {
          return const Fracaso<Pelicula>(
              FalloNoEncontrado('No hubo películas esta vez 😢'));
        }
        return Exito<Pelicula>(peliculas[_azar.nextInt(peliculas.length)]);
      },
      fallo: (f) => Fracaso<Pelicula>(f),
    );
  }
}
