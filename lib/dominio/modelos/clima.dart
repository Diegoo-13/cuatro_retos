class Clima {
  final String ciudad;
  final String pais;
  final double temperatura; // °C
  final double sensacion; // °C
  final double minima;
  final double maxima;
  final int humedad; // %
  final double viento; // m/s
  final String descripcion;
  final String codigoIcono;
  final DateTime actualizado;

  const Clima({
    required this.ciudad,
    required this.pais,
    required this.temperatura,
    required this.sensacion,
    required this.minima,
    required this.maxima,
    required this.humedad,
    required this.viento,
    required this.descripcion,
    required this.codigoIcono,
    required this.actualizado,
  });

  String get urlIcono => 'https://openweathermap.org/img/wn/$codigoIcono@4x.png';

  /// m/s -> km/h
  double get vientoKmh => viento * 3.6;

  /// Los iconos de OpenWeatherMap terminan en "n" cuando es de noche.
  bool get esDeNoche => codigoIcono.endsWith('n');
}

class Coordenadas {
  final double latitud;
  final double longitud;
  const Coordenadas(this.latitud, this.longitud);
}
