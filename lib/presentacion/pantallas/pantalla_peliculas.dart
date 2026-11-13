import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dominio/modelos/pelicula.dart';
import '../viewmodels/estado_vista.dart';
import '../viewmodels/peliculas_viewmodel.dart';
import '../widgets/tarjeta_pelicula.dart';
import '../widgets/vistas_estado.dart';

/// Reto 1: Recomendador de películas del fin de semana (TMDB).
class PantallaPeliculas extends StatefulWidget {
  const PantallaPeliculas({super.key});

  @override
  State<PantallaPeliculas> createState() => _PantallaPeliculasState();
}

class _PantallaPeliculasState extends State<PantallaPeliculas> {
  @override
  void initState() {
    super.initState();
    // Carga inicial después del primer frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<PeliculasViewModel>();
      if (vm.estado == EstadoVista.inicial) vm.cargar();
    });
  }

  Future<void> _sorprendeme() async {
    final res = await context.read<PeliculasViewModel>().sorprendeme();
    if (!mounted) return;
    if (res.pelicula != null) {
      _verDetalle(res.pelicula!, titulo: '🎲 Tu película del fin de semana');
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(res.fallo!.mensaje)));
    }
  }

  void _verDetalle(Pelicula pelicula, {String? titulo}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _HojaDetalle(pelicula: pelicula, titulo: titulo),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PeliculasViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('🎬 Recomendador de Películas')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: vm.buscandoAleatoria ? null : _sorprendeme,
        icon: vm.buscandoAleatoria
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.casino_outlined),
        label: const Text('Sorpréndeme'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('¿Cómo te sientes hoy?',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: EstadoAnimo.values.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final animo = EstadoAnimo.values[i];
                return ChoiceChip(
                  label: Text('${animo.emoji} ${animo.nombre}'),
                  selected: vm.animo == animo,
                  onSelected: (_) => vm.cargar(animo),
                );
              },
            ),
          ),
          Expanded(child: _contenido(vm)),
        ],
      ),
    );
  }

  Widget _contenido(PeliculasViewModel vm) {
    switch (vm.estado) {
      case EstadoVista.inicial:
      case EstadoVista.cargando:
        return const VistaCargando(mensaje: 'Buscando películas...');
      case EstadoVista.error:
        return VistaError(
            mensaje: vm.mensajeError ?? 'Error', alReintentar: () => vm.cargar());
      case EstadoVista.listo:
        if (vm.peliculas.isEmpty) {
          return const Center(child: Text('No encontramos películas 😢'));
        }
        return RefreshIndicator(
          onRefresh: () => vm.cargar(),
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 88),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 0.55,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: vm.peliculas.length,
            itemBuilder: (_, i) => TarjetaPelicula(
              pelicula: vm.peliculas[i],
              alTocar: () => _verDetalle(vm.peliculas[i]),
            ),
          ),
        );
    }
  }
}

class _HojaDetalle extends StatelessWidget {
  final Pelicula pelicula;
  final String? titulo;
  const _HojaDetalle({required this.pelicula, this.titulo});

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (_, controlador) => ListView(
        controller: controlador,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          if (titulo != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(titulo!,
                  style: texto.titleLarge, textAlign: TextAlign.center),
            ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 300,
                width: 200,
                child: PosterPelicula(url: pelicula.urlPoster),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(pelicula.titulo,
              style: texto.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('⭐ ${pelicula.calificacion.toStringAsFixed(1)}  ·  ${pelicula.anio}'),
          const SizedBox(height: 12),
          Text(pelicula.sinopsis, style: texto.bodyLarge),
        ],
      ),
    );
  }
}
