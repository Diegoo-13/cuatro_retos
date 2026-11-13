import '../../dominio/modelos/pelicula.dart';
import '../cliente_http.dart';
import '../config_claves.dart';
import '../modelos/modelos_json.dart';

/// Reto 1: habla directamente con la API de TMDB.
class ServicioPeliculas {
  final ClienteHttp cliente;
  ServicioPeliculas(this.cliente);

  Future<List<PeliculaModelo>> obtenerPeliculas(EstadoAnimo animo,
      {int pagina = 1}) async {
    if (ConfigClaves.faltaClave(ConfigClaves.claveTmdb)) {
      throw const ExcepcionFaltaClave('TMDB');
    }

    final comunes = {
      'api_key': ConfigClaves.claveTmdb,
      'language': 'es-MX',
      'page': '$pagina',
    };

    // Tendencias -> /trending/movie/week
    // Ánimo      -> /discover/movie?with_genres=35|...
    // En with_genres el | significa "O" (más resultados) y la coma "Y".
    final uri = animo.esTendencias
        ? Uri.parse('${ConfigClaves.urlTmdb}/trending/movie/week')
            .replace(queryParameters: comunes)
        : Uri.parse('${ConfigClaves.urlTmdb}/discover/movie').replace(
            queryParameters: {
              ...comunes,
              'with_genres': animo.generos.join('|'),
              'sort_by': 'popularity.desc',
              'include_adult': 'false',
              'vote_count.gte': '100',
            },
          );

    final json = await cliente.obtenerJson(uri) as Map<String, dynamic>;
    final resultados = (json['results'] as List?) ?? [];
    return resultados
        .map((e) => PeliculaModelo.desdeJson(e as Map<String, dynamic>))
        .toList();
  }
}
