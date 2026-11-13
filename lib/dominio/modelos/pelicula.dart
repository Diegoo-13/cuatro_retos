/// Entidad pura: no sabe nada de JSON ni de TMDB.
class Pelicula {
  final int id;
  final String titulo;
  final String sinopsis;
  final String? urlPoster;
  final double calificacion;
  final String fechaEstreno;

  const Pelicula({
    required this.id,
    required this.titulo,
    required this.sinopsis,
    required this.urlPoster,
    required this.calificacion,
    required this.fechaEstreno,
  });

  String get anio =>
      fechaEstreno.length >= 4 ? fechaEstreno.substring(0, 4) : '—';
}

/// Estados de ánimo y los géneros de TMDB que les corresponden.
/// IDs de géneros: https://developer.themoviedb.org/reference/genre-movie-list
enum EstadoAnimo {
  tendencias('Tendencias', '🔥', []),
  feliz('Feliz', '😄', [35]), // Comedia
  aventurero('Aventurero', '🤠', [28, 12]), // Acción, Aventura
  romantico('Romántico', '😍', [10749]), // Romance
  miedo('Con ganas de miedo', '😱', [27]), // Terror
  reflexivo('Reflexivo', '🤔', [18]), // Drama
  nostalgico('Nostálgico', '🥹', [16, 10751]), // Animación, Familia
  curioso('Curioso', '🚀', [878]); // Ciencia ficción

  final String nombre;
  final String emoji;
  final List<int> generos;

  const EstadoAnimo(this.nombre, this.emoji, this.generos);

  bool get esTendencias => generos.isEmpty;
}
