// Pruebas de la lógica (no necesitan internet).
// Ejecuta: flutter test
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:cuatro_retos/datos/cliente_http.dart';
import 'package:cuatro_retos/datos/servicios/servicio_gatos.dart';
import 'package:cuatro_retos/dominio/casos_uso/casos_uso_cripto.dart';
import 'package:cuatro_retos/dominio/modelos/criptomoneda.dart';
import 'package:cuatro_retos/dominio/modelos/gato.dart';

void main() {
  group('Convertir dólares a cripto', () {
    final convertir = ConvertirDolaresACripto();
    const btc = Criptomoneda(
        id: 'bitcoin', nombre: 'Bitcoin', simbolo: 'BTC', precioUsd: 50000, cambio24h: 1);

    test('100 USD con BTC a 50,000 = 0.002 BTC', () {
      expect(convertir(100, btc), closeTo(0.002, 1e-9));
    });

    test('lee distintos formatos de número', () {
      expect(convertir.leerDolares('1500'), 1500);
      expect(convertir.leerDolares('1,500.50'), 1500.5);
      expect(convertir.leerDolares('1500,5'), 1500.5);
      expect(convertir.leerDolares(r'$ 20'), 20);
      expect(convertir.leerDolares('abc'), isNull);
    });
  });

  group('URL del meme de Cataas', () {
    final servicio = ServicioGatos(ClienteHttp(http.Client()));
    const gato = Gato(id: 'abc123');

    test('sin texto ni filtro', () {
      expect(servicio.construirUrlMeme(gato, const OpcionesMeme()),
          'https://cataas.com/cat/abc123');
    });

    test('con texto, color y filtro', () {
      final url = servicio.construirUrlMeme(
        gato,
        const OpcionesMeme(
          texto: 'Hola mundo',
          filtro: FiltroGato.blancoNegro,
          color: ColorLetra.amarillo,
          tamanoLetra: 50,
        ),
      );
      expect(url,
          'https://cataas.com/cat/abc123/says/Hola%20mundo?fontSize=50&fontColor=yellow&filter=mono');
    });
  });
}
