/// Un gato de Cataas. Guardamos su id para que, al cambiar el texto,
/// se quede el mismo gato en la foto.
class Gato {
  final String id;
  final List<String> etiquetas;
  const Gato({required this.id, this.etiquetas = const []});
}

/// Filtros que acepta Cataas con ?filter=
enum FiltroGato {
  ninguno('Original', null),
  blancoNegro('B/N', 'mono'),
  borroso('Borroso', 'blur'),
  negativo('Negativo', 'negate');

  final String nombre;
  final String? valorApi;
  const FiltroGato(this.nombre, this.valorApi);
}

/// Colores de letra (Cataas acepta nombres de color CSS en inglés).
enum ColorLetra {
  blanco('Blanco', 'white', 0xFFFFFFFF),
  amarillo('Amarillo', 'yellow', 0xFFFFEB3B),
  rojo('Rojo', 'red', 0xFFF44336),
  cian('Cian', 'cyan', 0xFF00BCD4),
  negro('Negro', 'black', 0xFF000000);

  final String nombre;
  final String valorApi;
  final int argb;
  const ColorLetra(this.nombre, this.valorApi, this.argb);
}

/// Lo que el usuario eligió para su meme.
class OpcionesMeme {
  final String texto;
  final FiltroGato filtro;
  final ColorLetra color;
  final int tamanoLetra;

  const OpcionesMeme({
    this.texto = '',
    this.filtro = FiltroGato.ninguno,
    this.color = ColorLetra.blanco,
    this.tamanoLetra = 40,
  });

  OpcionesMeme copiarCon({
    String? texto,
    FiltroGato? filtro,
    ColorLetra? color,
    int? tamanoLetra,
  }) =>
      OpcionesMeme(
        texto: texto ?? this.texto,
        filtro: filtro ?? this.filtro,
        color: color ?? this.color,
        tamanoLetra: tamanoLetra ?? this.tamanoLetra,
      );
}
