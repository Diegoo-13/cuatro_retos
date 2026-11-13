import '../../dominio/modelos/clima.dart';
import '../cliente_http.dart';
import '../config_claves.dart';
import '../modelos/modelos_json.dart';

/// Reto 3: API de OpenWeatherMap (clima actual).
class ServicioClima {
  final ClienteHttp cliente;
  ServicioClima(this.cliente);

  Future<ClimaModelo> porCiudad(String ciudad) => _consultar({'q': ciudad});

  Future<ClimaModelo> porCoordenadas(Coordenadas c) =>
      _consultar({'lat': '${c.latitud}', 'lon': '${c.longitud}'});

  Future<ClimaModelo> _consultar(Map<String, String> parametros) async {
    if (ConfigClaves.faltaClave(ConfigClaves.claveClima)) {
      throw const ExcepcionFaltaClave('OpenWeatherMap');
    }
    final uri = Uri.parse('${ConfigClaves.urlClima}/weather').replace(
      queryParameters: {
        ...parametros,
        'appid': ConfigClaves.claveClima,
        'units': 'metric', // grados °C
        'lang': 'es', // descripción en español
      },
    );
    final json = await cliente.obtenerJson(uri) as Map<String, dynamic>;
    return ClimaModelo.desdeJson(json);
  }
}
