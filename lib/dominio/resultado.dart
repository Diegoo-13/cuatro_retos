import 'excepciones.dart';

/// Resultado de una operación: o salió bien ([Exito]) o falló ([Fracaso]).
/// Así la pantalla está obligada a manejar los dos casos.
sealed class Resultado<T> {
  const Resultado();

  /// resultado.cuando(exito: (dato) => ..., fallo: (f) => ...)
  R cuando<R>({
    required R Function(T dato) exito,
    required R Function(Fallo fallo) fallo,
  }) {
    return switch (this) {
      Exito<T>(dato: final d) => exito(d),
      Fracaso<T>(fallo: final f) => fallo(f),
    };
  }
}

class Exito<T> extends Resultado<T> {
  final T dato;
  const Exito(this.dato);
}

class Fracaso<T> extends Resultado<T> {
  final Fallo fallo;
  const Fracaso(this.fallo);
}
