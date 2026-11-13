import 'package:flutter/material.dart';

import '../../dominio/modelos/pelicula.dart';

/// Card con el póster, título, calificación y año de la película.
class TarjetaPelicula extends StatelessWidget {
  final Pelicula pelicula;
  final VoidCallback? alTocar;
  const TarjetaPelicula({super.key, required this.pelicula, this.alTocar});

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: alTocar,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: PosterPelicula(url: pelicula.urlPoster)),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pelicula.titulo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: texto.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(pelicula.calificacion.toStringAsFixed(1),
                          style: texto.bodySmall),
                      const Spacer(),
                      Text(pelicula.anio, style: texto.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Imagen del póster con indicador de carga y respaldo si falla.
class PosterPelicula extends StatelessWidget {
  final String? url;
  const PosterPelicula({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final respaldo = Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Center(child: Icon(Icons.movie_outlined, size: 48)),
    );
    if (url == null) return respaldo;
    return Image.network(
      url!,
      fit: BoxFit.cover,
      loadingBuilder: (context, hijo, progreso) => progreso == null
          ? hijo
          : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      errorBuilder: (context, error, pila) => respaldo,
    );
  }
}
