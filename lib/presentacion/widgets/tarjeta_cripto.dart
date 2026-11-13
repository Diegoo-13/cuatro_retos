import 'package:flutter/material.dart';

import '../../dominio/modelos/criptomoneda.dart';

/// Muestra el precio de una cripto y cuánto compras con los dólares escritos.
class TarjetaCripto extends StatelessWidget {
  final Criptomoneda moneda;
  final double? cantidad;
  const TarjetaCripto({super.key, required this.moneda, required this.cantidad});

  String _formatoDolares(double v) {
    // 97123.4 -> $97,123.40 (sin paquetes extra)
    final partes = v.toStringAsFixed(2).split('.');
    final enteros = partes[0]
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
    return '\$$enteros.${partes[1]}';
  }

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;
    final colores = Theme.of(context).colorScheme;
    final emoji = MonedaSoportada.todas
        .firstWhere((m) => m.id == moneda.id,
            orElse: () => MonedaSoportada.todas.first)
        .emoji;
    final colorCambio = moneda.subio ? Colors.green : colores.error;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: colores.primaryContainer,
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${moneda.nombre} (${moneda.simbolo})',
                      style: texto.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(_formatoDolares(moneda.precioUsd), style: texto.bodyLarge),
                      const SizedBox(width: 8),
                      Icon(moneda.subio ? Icons.arrow_upward : Icons.arrow_downward,
                          size: 14, color: colorCambio),
                      Text('${moneda.cambio24h.abs().toStringAsFixed(2)}%',
                          style: texto.bodySmall?.copyWith(color: colorCambio)),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Compras', style: texto.bodySmall),
                Text(
                  cantidad == null
                      ? '—'
                      : cantidad!.toStringAsFixed(cantidad! < 1 ? 6 : 4),
                  style: texto.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold, color: colores.primary),
                ),
                Text(moneda.simbolo, style: texto.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
