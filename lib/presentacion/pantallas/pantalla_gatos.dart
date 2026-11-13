import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../dominio/modelos/gato.dart';
import '../viewmodels/estado_vista.dart';
import '../viewmodels/gatos_viewmodel.dart';
import '../widgets/vistas_estado.dart';

/// Reto 2: Generador de memes de gatos con filtros (Cataas).
class PantallaGatos extends StatefulWidget {
  const PantallaGatos({super.key});

  @override
  State<PantallaGatos> createState() => _PantallaGatosState();
}

class _PantallaGatosState extends State<PantallaGatos> {
  late final TextEditingController _controladorTexto;

  @override
  void initState() {
    super.initState();
    // Si regresas a la pestaña se conserva la frase que tenías.
    _controladorTexto = TextEditingController(
        text: context.read<GatosViewModel>().opciones.texto);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<GatosViewModel>();
      if (vm.estado == EstadoVista.inicial) vm.otroGato();
    });
  }

  @override
  void dispose() {
    _controladorTexto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GatosViewModel>();
    final titulos = Theme.of(context).textTheme.titleSmall;

    return Scaffold(
      appBar: AppBar(title: const Text('🐱 Memes de Gatos')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AspectRatio(aspectRatio: 1, child: _imagen(vm)),
          const SizedBox(height: 16),
          TextField(
            controller: _controladorTexto,
            maxLength: 60,
            decoration: const InputDecoration(
              labelText: 'Escribe tu frase',
              hintText: 'Ej. Cuando es lunes...',
              prefixIcon: Icon(Icons.edit_outlined),
              border: OutlineInputBorder(),
            ),
            onChanged: vm.cambiarTexto,
          ),
          Text('Filtro', style: titulos),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final f in FiltroGato.values)
                ChoiceChip(
                  label: Text(f.nombre),
                  selected: vm.opciones.filtro == f,
                  onSelected: (_) => vm.cambiarFiltro(f),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Color de letra', style: titulos),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final c in ColorLetra.values)
                ChoiceChip(
                  avatar: CircleAvatar(backgroundColor: Color(c.argb), radius: 8),
                  label: Text(c.nombre),
                  selected: vm.opciones.color == c,
                  onSelected: (_) => vm.cambiarColor(c),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Tamaño de letra: ${vm.opciones.tamanoLetra}', style: titulos),
          Slider(
            min: 20,
            max: 80,
            divisions: 12,
            value: vm.opciones.tamanoLetra.toDouble(),
            label: '${vm.opciones.tamanoLetra}',
            onChanged: vm.cambiarTamano,
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: vm.estado == EstadoVista.cargando ? null : vm.otroGato,
            icon: const Icon(Icons.pets),
            label: const Text('Otro gato'),
          ),
          if (vm.urlImagen != null) ...[
            const SizedBox(height: 16),
            Text('URL generada:', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 4),
            SelectableText(
              vm.urlImagen!,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: vm.urlImagen!));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('URL copiada 📋')),
                  );
                },
                icon: const Icon(Icons.copy, size: 16),
                label: const Text('Copiar'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _imagen(GatosViewModel vm) {
    final Widget hijo;
    if (vm.estado == EstadoVista.error) {
      hijo = VistaError(
          mensaje: vm.mensajeError ?? 'Error', alReintentar: vm.otroGato);
    } else if (vm.urlImagen == null) {
      hijo = const VistaCargando(mensaje: 'Buscando un gato...');
    } else {
      hijo = Image.network(
        vm.urlImagen!,
        key: ValueKey(vm.urlImagen), // recarga cuando cambia la URL
        fit: BoxFit.cover,
        gaplessPlayback: true,
        loadingBuilder: (context, img, progreso) => progreso == null
            ? img
            : const VistaCargando(mensaje: 'Dibujando tu meme...'),
        errorBuilder: (context, error, pila) => VistaError(
          mensaje: 'No se pudo cargar la imagen del gato',
          alReintentar: vm.otroGato,
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: hijo,
      ),
    );
  }
}
