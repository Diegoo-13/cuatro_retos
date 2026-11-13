import '../modelos/gato.dart';
import '../repositorios/repositorios.dart';
import '../resultado.dart';

class ObtenerGatoAleatorio {
  final RepositorioGatos repositorio;
  ObtenerGatoAleatorio(this.repositorio);

  Future<Resultado<Gato>> call() => repositorio.obtenerGatoAleatorio();
}

class ConstruirUrlMeme {
  final RepositorioGatos repositorio;
  ConstruirUrlMeme(this.repositorio);

  /// Regla de negocio: el texto se limpia y se limita a 60 caracteres
  /// para que quepa en la foto.
  String call(Gato gato, OpcionesMeme opciones) {
    var texto = opciones.texto.trim();
    if (texto.length > 60) texto = texto.substring(0, 60);
    return repositorio.construirUrlMeme(gato, opciones.copiarCon(texto: texto));
  }
}
