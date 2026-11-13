import '../../dominio/modelos/clima.dart';
import '../../dominio/modelos/criptomoneda.dart';
import '../../dominio/modelos/gato.dart';
import '../../dominio/modelos/pelicula.dart';
import '../cliente_http.dart';
import '../config_claves.dart';

// Modelo de datos = Entidad del dominio + saber leerse desde el JSON de la API.

// ---------------------------------------------------------------- TMDB
class PeliculaModelo extends Pelicula {
  const PeliculaModelo({
    required super.id,
    required super.titulo,
    required super.sinopsis,
    required super.urlPoster,
    required super.calificacion,
    required super.fechaEstreno,
  });

  factory PeliculaModelo.desdeJson(Map<String, dynamic> json) {
    final poster = json['poster_path'] as String?;
    final sinopsis = (json['overview'] as String?)?.trim() ?? '';
    return PeliculaModelo(
      id: json['id'] as int,
      titulo: (json['title'] ?? json['name'] ?? 'Sin título') as String,
      sinopsis: sinopsis.isEmpty ? 'Sin sinopsis disponible.' : sinopsis,
      urlPoster: poster == null ? null : '${ConfigClaves.urlImagenesTmdb}$poster',
      calificacion: (json['vote_average'] as num?)?.toDouble() ?? 0,
      fechaEstreno: (json['release_date'] as String?) ?? '',
    );
  }
}

// ---------------------------------------------------------------- Cataas
class GatoModelo extends Gato {
  const GatoModelo({required super.id, super.etiquetas});

  /// Cataas responde algo como:
  /// { "id": "abc123", "tags": ["cute"], "mimetype": "image/jpeg", ... }
  /// (versiones viejas usaban "_id", por eso revisamos los dos)
  factory GatoModelo.desdeJson(Map<String, dynamic> json) {
    final id = (json['id'] ?? json['_id'])?.toString();
    if (id == null || id.isEmpty) {
      throw const ExcepcionFormato('Cataas no mandó el id del gato');
    }
    return GatoModelo(
      id: id,
      etiquetas: ((json['tags'] as List?) ?? []).map((e) => e.toString()).toList(),
    );
  }
}

// ---------------------------------------------------------------- OpenWeatherMap
class ClimaModelo extends Clima {
  const ClimaModelo({
    required super.ciudad,
    required super.pais,
    required super.temperatura,
    required super.sensacion,
    required super.minima,
    required super.maxima,
    required super.humedad,
    required super.viento,
    required super.descripcion,
    required super.codigoIcono,
    required super.actualizado,
  });

  /// JSON de /data/2.5/weather:
  /// {
  ///   "weather": [{"description": "cielo claro", "icon": "01d"}],
  ///   "main": {"temp": 24.3, "feels_like": 23.9, "temp_min": 22, "temp_max": 26, "humidity": 40},
  ///   "wind": {"speed": 3.1}, "sys": {"country": "MX"}, "name": "Dolores Hidalgo", "dt": 1731500000
  /// }
  factory ClimaModelo.desdeJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>;
    final lista = (json['weather'] as List?) ?? [];
    final w = lista.isNotEmpty ? lista.first as Map<String, dynamic> : <String, dynamic>{};
    double d(dynamic v) => (v as num?)?.toDouble() ?? 0;

    final descripcion = (w['description'] as String?) ?? '';
    return ClimaModelo(
      ciudad: (json['name'] as String?) ?? 'Ubicación actual',
      pais: ((json['sys'] as Map?)?['country'] as String?) ?? '',
      temperatura: d(main['temp']),
      sensacion: d(main['feels_like']),
      minima: d(main['temp_min']),
      maxima: d(main['temp_max']),
      humedad: (main['humidity'] as num?)?.toInt() ?? 0,
      viento: d((json['wind'] as Map?)?['speed']),
      // "cielo claro" -> "Cielo claro"
      descripcion: descripcion.isEmpty
          ? ''
          : descripcion[0].toUpperCase() + descripcion.substring(1),
      codigoIcono: (w['icon'] as String?) ?? '01d',
      actualizado: DateTime.fromMillisecondsSinceEpoch(
          ((json['dt'] as num?)?.toInt() ?? 0) * 1000),
    );
  }
}

// ---------------------------------------------------------------- CoinGecko
class CriptomonedaModelo extends Criptomoneda {
  const CriptomonedaModelo({
    required super.id,
    required super.nombre,
    required super.simbolo,
    required super.precioUsd,
    required super.cambio24h,
  });

  /// CoinGecko /simple/price responde:
  /// { "bitcoin": { "usd": 97000.12, "usd_24h_change": -1.23 }, ... }
  /// Aquí recibimos solo la parte de UNA moneda.
  factory CriptomonedaModelo.desdeJson(
      MonedaSoportada moneda, Map<String, dynamic> json) {
    return CriptomonedaModelo(
      id: moneda.id,
      nombre: moneda.nombre,
      simbolo: moneda.simbolo,
      precioUsd: (json['usd'] as num?)?.toDouble() ?? 0,
      cambio24h: (json['usd_24h_change'] as num?)?.toDouble() ?? 0,
    );
  }
}
