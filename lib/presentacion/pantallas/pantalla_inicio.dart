import 'package:flutter/material.dart';

import 'pantalla_clima.dart';
import 'pantalla_cripto.dart';
import 'pantalla_gatos.dart';
import 'pantalla_peliculas.dart';

/// Pantalla principal con la barra inferior para cambiar entre los 4 retos.
/// El estado de cada reto vive en su ViewModel, así que al cambiar de
/// pestaña no se pierde lo que ya se cargó.
class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  int _indice = 0;

  static const _pantallas = <Widget>[
    PantallaPeliculas(),
    PantallaGatos(),
    PantallaClima(),
    PantallaCripto(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pantallas[_indice],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: (i) => setState(() => _indice = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.movie_outlined),
              selectedIcon: Icon(Icons.movie),
              label: 'Películas'),
          NavigationDestination(
              icon: Icon(Icons.pets_outlined),
              selectedIcon: Icon(Icons.pets),
              label: 'Gatos'),
          NavigationDestination(
              icon: Icon(Icons.wb_cloudy_outlined),
              selectedIcon: Icon(Icons.wb_cloudy),
              label: 'Clima'),
          NavigationDestination(
              icon: Icon(Icons.currency_bitcoin_outlined),
              selectedIcon: Icon(Icons.currency_bitcoin),
              label: 'Cripto'),
        ],
      ),
    );
  }
}
