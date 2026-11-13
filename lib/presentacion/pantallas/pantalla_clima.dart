import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dominio/modelos/clima.dart';
import '../viewmodels/clima_viewmodel.dart';
import '../viewmodels/estado_vista.dart';
import '../widgets/vistas_estado.dart';

/// Reto 3: App del clima minimalista (OpenWeatherMap + geolocator).
class PantallaClima extends StatefulWidget {
  const PantallaClima({super.key});

  @override
  State<PantallaClima> createState() => _PantallaClimaState();
}

class _PantallaClimaState extends State<PantallaClima> {
  final _controladorCiudad = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<ClimaViewModel>();
      if (vm.estado == EstadoVista.inicial) vm.buscarCiudad();
    });
  }

  @override
  void dispose() {
    _controladorCiudad.dispose();
    super.dispose();
  }

  void _buscar() {
    FocusScope.of(context).unfocus();
    context.read<ClimaViewModel>().buscarCiudad(_controladorCiudad.text);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ClimaViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('🌦️ Clima'),
        actions: [
          IconButton(
            tooltip: 'Usar mi ubicación',
            onPressed:
                vm.estado == EstadoVista.cargando ? null : vm.usarMiUbicacion,
            icon: Icon(vm.usandoUbicacion
                ? Icons.my_location
                : Icons.location_searching),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _controladorCiudad,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _buscar(),
              decoration: InputDecoration(
                hintText: 'Buscar ciudad (ej. León, Querétaro, Madrid)',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: _buscar,
                ),
              ),
            ),
          ),
          Expanded(child: _contenido(vm)),
        ],
      ),
    );
  }

  Widget _contenido(ClimaViewModel vm) {
    switch (vm.estado) {
      case EstadoVista.inicial:
      case EstadoVista.cargando:
        return VistaCargando(
          mensaje: vm.usandoUbicacion
              ? 'Buscando tu ubicación...'
              : 'Consultando el clima...',
        );
      case EstadoVista.error:
        return VistaError(
            mensaje: vm.mensajeError ?? 'Error', alReintentar: vm.recargar);
      case EstadoVista.listo:
        return RefreshIndicator(
          onRefresh: vm.recargar,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [_DatosClima(clima: vm.clima!)],
          ),
        );
    }
  }
}

/// Diseño minimalista: ciudad, ícono, temperatura grande y 3 datos.
class _DatosClima extends StatelessWidget {
  final Clima clima;
  const _DatosClima({required this.clima});

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;
    final colores = Theme.of(context).colorScheme;
    final hora = TimeOfDay.fromDateTime(clima.actualizado).format(context);

    return Column(
      children: [
        Text(
          clima.pais.isEmpty ? clima.ciudad : '${clima.ciudad}, ${clima.pais}',
          style: texto.headlineSmall,
          textAlign: TextAlign.center,
        ),
        Text('Actualizado $hora', style: texto.bodySmall),
        Image.network(
          clima.urlIcono,
          width: 160,
          height: 160,
          errorBuilder: (context, error, pila) => Icon(
            clima.esDeNoche ? Icons.nightlight_round : Icons.wb_sunny_outlined,
            size: 120,
          ),
        ),
        Text(
          '${clima.temperatura.round()}°',
          style: texto.displayLarge
              ?.copyWith(fontWeight: FontWeight.w300, fontSize: 96),
        ),
        Text(clima.descripcion, style: texto.titleLarge),
        const SizedBox(height: 4),
        Text('Máx ${clima.maxima.round()}°  ·  Mín ${clima.minima.round()}°'),
        const SizedBox(height: 32),
        Card(
          color: colores.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _Dato(
                    icono: Icons.thermostat,
                    etiqueta: 'Sensación',
                    valor: '${clima.sensacion.round()}°'),
                _Dato(
                    icono: Icons.water_drop_outlined,
                    etiqueta: 'Humedad',
                    valor: '${clima.humedad}%'),
                _Dato(
                    icono: Icons.air,
                    etiqueta: 'Viento',
                    valor: '${clima.vientoKmh.toStringAsFixed(0)} km/h'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Dato extends StatelessWidget {
  final IconData icono;
  final String etiqueta;
  final String valor;
  const _Dato({required this.icono, required this.etiqueta, required this.valor});

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;
    return Column(
      children: [
        Icon(icono),
        const SizedBox(height: 4),
        Text(valor, style: texto.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        Text(etiqueta, style: texto.bodySmall),
      ],
    );
  }
}
