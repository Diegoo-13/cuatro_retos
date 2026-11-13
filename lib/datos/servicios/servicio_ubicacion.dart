import 'package:geolocator/geolocator.dart';

import '../../dominio/modelos/clima.dart';
import '../cliente_http.dart';

/// El "plus" del reto del clima: usa el GPS con el paquete geolocator.
class ServicioUbicacion {
  Future<Coordenadas> obtenerPosicion() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const ExcepcionUbicacion('Activa la ubicación (GPS) del dispositivo.');
    }

    var permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }
    if (permiso == LocationPermission.denied) {
      throw const ExcepcionUbicacion('Necesitamos permiso de ubicación 📍');
    }
    if (permiso == LocationPermission.deniedForever) {
      throw const ExcepcionUbicacion(
          'El permiso de ubicación está bloqueado. Actívalo en los ajustes.');
    }

    final posicion = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low, // para el clima no hace falta más
        timeLimit: Duration(seconds: 15),
      ),
    );
    return Coordenadas(posicion.latitude, posicion.longitude);
  }
}
