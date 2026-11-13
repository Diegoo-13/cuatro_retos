import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'datos/cliente_http.dart';
import 'datos/repositorios/repositorios_impl.dart';
import 'datos/servicios/servicio_clima.dart';
import 'datos/servicios/servicio_cripto.dart';
import 'datos/servicios/servicio_gatos.dart';
import 'datos/servicios/servicio_peliculas.dart';
import 'datos/servicios/servicio_ubicacion.dart';
import 'dominio/casos_uso/casos_uso_clima.dart';
import 'dominio/casos_uso/casos_uso_cripto.dart';
import 'dominio/casos_uso/casos_uso_gatos.dart';
import 'dominio/casos_uso/casos_uso_peliculas.dart';
import 'presentacion/pantallas/pantalla_inicio.dart';
import 'presentacion/viewmodels/clima_viewmodel.dart';
import 'presentacion/viewmodels/cripto_viewmodel.dart';
import 'presentacion/viewmodels/gatos_viewmodel.dart';
import 'presentacion/viewmodels/peliculas_viewmodel.dart';

void main() {
  // ---------- Inyección de dependencias (a mano) ----------
  // Se arma de abajo hacia arriba:
  // ClienteHttp -> Servicio -> Repositorio -> Caso de uso -> ViewModel
  final cliente = ClienteHttp(http.Client());

  // Reto 1: Películas
  final repoPeliculas = RepositorioPeliculasImpl(ServicioPeliculas(cliente));
  // Reto 2: Gatos
  final repoGatos = RepositorioGatosImpl(ServicioGatos(cliente));
  // Reto 3: Clima
  final repoClima = RepositorioClimaImpl(ServicioClima(cliente));
  final repoUbicacion = RepositorioUbicacionImpl(ServicioUbicacion());
  // Reto 4: Cripto
  final repoCripto = RepositorioCriptoImpl(ServicioCripto(cliente));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PeliculasViewModel(
            ObtenerPeliculasPorAnimo(repoPeliculas),
            ObtenerPeliculaAleatoria(repoPeliculas),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => GatosViewModel(
            ObtenerGatoAleatorio(repoGatos),
            ConstruirUrlMeme(repoGatos),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ClimaViewModel(
            ObtenerClimaPorCiudad(repoClima),
            ObtenerClimaDeMiUbicacion(repoUbicacion, repoClima),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CriptoViewModel(
            ObtenerPreciosCripto(repoCripto),
            ConvertirDolaresACripto(),
          ),
        ),
      ],
      child: const CuatroRetosApp(),
    ),
  );
}

class CuatroRetosApp extends StatelessWidget {
  const CuatroRetosApp({super.key});

  @override
  Widget build(BuildContext context) {
    const semilla = Color(0xFF5B4BDB);
    return MaterialApp(
      title: 'Cuatro Retos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: semilla,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: semilla,
        brightness: Brightness.dark,
      ),
      home: const PantallaInicio(),
    );
  }
}
