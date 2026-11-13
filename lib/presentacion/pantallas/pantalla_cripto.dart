import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/cripto_viewmodel.dart';
import '../viewmodels/estado_vista.dart';
import '../widgets/tarjeta_cripto.dart';
import '../widgets/vistas_estado.dart';

/// Reto 4: Convertidor de criptomonedas "en tiempo real" (CoinGecko).
class PantallaCripto extends StatefulWidget {
  const PantallaCripto({super.key});

  @override
  State<PantallaCripto> createState() => _PantallaCriptoState();
}

class _PantallaCriptoState extends State<PantallaCripto> {
  late final TextEditingController _controladorDolares;
  late final CriptoViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = context.read<CriptoViewModel>();
    final d = _vm.dolares;
    _controladorDolares = TextEditingController(
      text: d == null ? '' : d.toStringAsFixed(d % 1 == 0 ? 0 : 2),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _vm.iniciar());
  }

  @override
  void dispose() {
    _vm.detener(); // dejamos de pedir precios al salir de la pestaña
    _controladorDolares.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CriptoViewModel>();
    final textoChico = Theme.of(context).textTheme.bodySmall;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🪙 Convertidor Cripto'),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            onPressed: vm.actualizando ? null : vm.cargar,
            icon: vm.actualizando
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _controladorDolares,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: vm.cambiarDolares,
              style: Theme.of(context).textTheme.headlineSmall,
              decoration: InputDecoration(
                labelText: '¿Cuántos dólares quieres invertir?',
                prefixText: r'$ ',
                suffixText: 'USD',
                border: const OutlineInputBorder(),
                errorText:
                    _controladorDolares.text.isNotEmpty && vm.dolares == null
                        ? 'Escribe un número válido'
                        : null,
              ),
            ),
          ),
          if (vm.ultimaActualizacion != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Actualizado: ${TimeOfDay.fromDateTime(vm.ultimaActualizacion!).format(context)}'
                ' · se refresca cada ${CriptoViewModel.cadaCuanto.inSeconds}s',
                style: textoChico,
              ),
            ),
          if (vm.mensajeError != null && vm.monedas.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text('⚠️ ${vm.mensajeError}',
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          Expanded(child: _contenido(vm)),
        ],
      ),
    );
  }

  Widget _contenido(CriptoViewModel vm) {
    switch (vm.estado) {
      case EstadoVista.inicial:
      case EstadoVista.cargando:
        return const VistaCargando(mensaje: 'Consultando precios...');
      case EstadoVista.error:
        return VistaError(
            mensaje: vm.mensajeError ?? 'Error', alReintentar: vm.cargar);
      case EstadoVista.listo:
        return RefreshIndicator(
          onRefresh: vm.cargar,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: vm.monedas.length,
            itemBuilder: (_, i) => TarjetaCripto(
              moneda: vm.monedas[i],
              cantidad: vm.cuantoCompras(vm.monedas[i]),
            ),
          ),
        );
    }
  }
}
