import '../dominio/excepciones.dart';
import '../dominio/resultado.dart';
import 'cliente_http.dart';

/// Ejecuta [llamada] y convierte cualquier excepción de la capa de datos
/// en un [Fallo] con un mensaje que el usuario entienda.
///
/// Cada repositorio puede personalizar los mensajes (por ejemplo, el del
/// clima explica que la key de OpenWeatherMap tarda en activarse).
Future<Resultado<T>> protegerLlamada<T>(
  Future<T> Function() llamada, {
  String mensaje401 = 'La API key no es válida.',
  String mensaje404 = 'No se encontró lo que buscabas.',
}) async {
  try {
    return Exito<T>(await llamada());
  } on ExcepcionFaltaClave catch (e) {
    return Fracaso<T>(FalloConfiguracion(
      'Falta la API key de ${e.api}.\n\nPégala en secrets.json y ejecuta con:\n'
      'flutter run --dart-define-from-file=secrets.json',
    ));
  } on ExcepcionServidor catch (e) {
    return Fracaso<T>(switch (e.codigo) {
      401 => FalloAutenticacion(mensaje401),
      404 => FalloNoEncontrado(mensaje404),
      429 => const FalloLimitePeticiones(
          'Demasiadas peticiones. Espera un minuto y vuelve a intentar.'),
      _ => FalloServidor(
          'Error del servidor (${e.codigo}). ${e.mensaje ?? ''}'.trim()),
    });
  } on ExcepcionRed catch (e) {
    return Fracaso<T>(FalloRed(e.mensaje));
  } on ExcepcionUbicacion catch (e) {
    return Fracaso<T>(FalloUbicacion(e.mensaje));
  } on ExcepcionFormato catch (e) {
    return Fracaso<T>(FalloInesperado(e.mensaje));
  } catch (e) {
    return Fracaso<T>(FalloInesperado('Algo salió mal: $e'));
  }
}
