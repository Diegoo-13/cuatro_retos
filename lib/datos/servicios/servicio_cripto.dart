import '../../dominio/modelos/criptomoneda.dart';
import '../cliente_http.dart';
import '../config_claves.dart';
import '../modelos/modelos_json.dart';

/// Reto 4: API pública de CoinGecko (sin autenticación).
class ServicioCripto {
  final ClienteHttp cliente;
  ServicioCripto(this.cliente);

  Future<List<CriptomonedaModelo>> obtenerPrecios(
      List<MonedaSoportada> monedas) async {
    // https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,solana&vs_currencies=usd&include_24hr_change=true
    final uri = Uri.parse('${ConfigClaves.urlCoinGecko}/simple/price').replace(
      queryParameters: {
        'ids': monedas.map((m) => m.id).join(','),
        'vs_currencies': 'usd',
        'include_24hr_change': 'true',
      },
    );

    final encabezados = ConfigClaves.faltaClave(ConfigClaves.claveCoinGecko)
        ? null
        : {'x-cg-demo-api-key': ConfigClaves.claveCoinGecko};

    final json = await cliente.obtenerJson(uri, encabezados: encabezados)
        as Map<String, dynamic>;

    return [
      for (final moneda in monedas)
        if (json[moneda.id] is Map<String, dynamic>)
          CriptomonedaModelo.desdeJson(
              moneda, json[moneda.id] as Map<String, dynamic>),
    ];
  }
}
