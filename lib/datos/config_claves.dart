/// URLs de las APIs y API keys.
///
/// Las keys se leen de secrets.json al ejecutar:
///   flutter run --dart-define-from-file=secrets.json
/// (En VS Code ya está configurado en .vscode/launch.json, solo dale F5.)
class ConfigClaves {
  ConfigClaves._();

  // ---------- Reto 1: TMDB (requiere key gratuita) ----------
  static const String claveTmdb = String.fromEnvironment('TMDB_API_KEY');
  static const String urlTmdb = 'https://api.themoviedb.org/3';
  static const String urlImagenesTmdb = 'https://image.tmdb.org/t/p/w500';

  // ---------- Reto 2: Cataas (sin key) ----------
  static const String urlCataas = 'https://cataas.com';

  // ---------- Reto 3: OpenWeatherMap (requiere key gratuita) ----------
  static const String claveClima = String.fromEnvironment('OWM_API_KEY');
  static const String urlClima = 'https://api.openweathermap.org/data/2.5';

  // ---------- Reto 4: CoinGecko (sin key) ----------
  static const String urlCoinGecko = 'https://api.coingecko.com/api/v3';

  /// Opcional: key "Demo" de CoinGecko por si te marca límite (429).
  static const String claveCoinGecko =
      String.fromEnvironment('COINGECKO_DEMO_KEY');

  static const Duration tiempoEspera = Duration(seconds: 15);

  /// true si la key está vacía o se quedó el texto de ejemplo.
  static bool faltaClave(String clave) =>
      clave.trim().isEmpty || clave.startsWith('pega_aqui');
}
