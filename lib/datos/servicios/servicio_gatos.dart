import '../../dominio/modelos/gato.dart';
import '../cliente_http.dart';
import '../config_claves.dart';
import '../modelos/modelos_json.dart';

/// Reto 2: API de Cataas (Cats as a Service).
class ServicioGatos {
  final ClienteHttp cliente;
  ServicioGatos(this.cliente);

  Future<GatoModelo> obtenerGatoAleatorio() async {
    // ?json=true hace que en vez de la imagen nos regrese los datos del gato.
    // El parámetro t evita que el navegador nos dé el mismo gato por caché.
    final uri = Uri.parse('${ConfigClaves.urlCataas}/cat').replace(
      queryParameters: {
        'json': 'true',
        't': DateTime.now().millisecondsSinceEpoch.toString(),
      },
    );
    final json = await cliente.obtenerJson(uri) as Map<String, dynamic>;
    return GatoModelo.desdeJson(json);
  }

  /// ⭐ La parte central del reto: la URL cambia según lo que escribe el usuario.
  ///
  /// Sin texto:  https://cataas.com/cat/{id}?filter=mono
  /// Con texto:  https://cataas.com/cat/{id}/says/Hola%20mundo?fontSize=40&fontColor=white&filter=mono
  String construirUrlMeme(Gato gato, OpcionesMeme opciones) {
    final base = '${ConfigClaves.urlCataas}/cat/${gato.id}';
    final tieneTexto = opciones.texto.isNotEmpty;

    // encodeComponent convierte espacios en %20 y protege acentos, "?" y "/".
    final ruta =
        tieneTexto ? '$base/says/${Uri.encodeComponent(opciones.texto)}' : base;

    final parametros = <String, String>{
      if (tieneTexto) 'fontSize': '${opciones.tamanoLetra}',
      if (tieneTexto) 'fontColor': opciones.color.valorApi,
      if (opciones.filtro.valorApi != null) 'filter': opciones.filtro.valorApi!,
    };

    if (parametros.isEmpty) return ruta;
    final consulta = parametros.entries
        .map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
    return '$ruta?$consulta';
  }
}
