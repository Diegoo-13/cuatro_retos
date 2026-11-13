import 'package:flutter/material.dart';

/// Círculo de carga con un mensaje opcional.
class VistaCargando extends StatelessWidget {
  final String? mensaje;
  const VistaCargando({super.key, this.mensaje});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (mensaje != null) ...[
            const SizedBox(height: 16),
            Text(mensaje!, textAlign: TextAlign.center),
          ],
        ],
      ),
    );
  }
}

/// Mensaje de error con botón de reintentar.
class VistaError extends StatelessWidget {
  final String mensaje;
  final VoidCallback? alReintentar;
  const VistaError({super.key, required this.mensaje, this.alReintentar});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline,
                size: 56, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 12),
            Text(mensaje, textAlign: TextAlign.center),
            if (alReintentar != null) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: alReintentar,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
