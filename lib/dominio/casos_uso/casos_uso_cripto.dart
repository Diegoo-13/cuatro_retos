import '../modelos/criptomoneda.dart';
import '../repositorios/repositorios.dart';
import '../resultado.dart';

class ObtenerPreciosCripto {
  final RepositorioCripto repositorio;
  ObtenerPreciosCripto(this.repositorio);

  Future<Resultado<List<Criptomoneda>>> call() =>
      repositorio.obtenerPrecios(MonedaSoportada.todas);
}

/// Lógica pura (no usa APIs): ¿cuánta cripto compro con X dólares?
class ConvertirDolaresACripto {
  /// Convierte el texto del TextField a double.
  /// Acepta "1,500.50", "1500,5", "1500.5" o "$ 20".
  double? leerDolares(String entrada) {
    var limpio = entrada.trim().replaceAll(' ', '').replaceAll(r'$', '');
    if (limpio.contains(',') && limpio.contains('.')) {
      limpio = limpio.replaceAll(',', ''); // 1,500.50 -> 1500.50
    } else {
      limpio = limpio.replaceAll(',', '.'); // 1500,5 -> 1500.5
    }
    final valor = double.tryParse(limpio);
    if (valor == null || valor < 0) return null;
    return valor;
  }

  double call(double dolares, Criptomoneda moneda) =>
      moneda.precioUsd <= 0 ? 0 : dolares / moneda.precioUsd;
}
