/// Errores que entiende el DOMINIO y que llegan hasta la pantalla.
/// La interfaz nunca ve errores de http, solo un [Fallo] con un mensaje claro.
sealed class Fallo {
  final String mensaje;
  const Fallo(this.mensaje);
}

class FalloServidor extends Fallo {
  const FalloServidor(super.mensaje);
}

class FalloRed extends Fallo {
  const FalloRed(super.mensaje);
}

/// 401: la API key es incorrecta o (en OpenWeatherMap) todavía no se activa.
class FalloAutenticacion extends Fallo {
  const FalloAutenticacion(super.mensaje);
}

/// 429: demasiadas peticiones (pasa con CoinGecko en el plan gratis).
class FalloLimitePeticiones extends Fallo {
  const FalloLimitePeticiones(super.mensaje);
}

class FalloNoEncontrado extends Fallo {
  const FalloNoEncontrado(super.mensaje);
}

class FalloUbicacion extends Fallo {
  const FalloUbicacion(super.mensaje);
}

/// Falta una API key en secrets.json.
class FalloConfiguracion extends Fallo {
  const FalloConfiguracion(super.mensaje);
}

class FalloInesperado extends Fallo {
  const FalloInesperado(super.mensaje);
}
