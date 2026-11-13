# Cuatro Retos — Flutter + Arquitectura Limpia

Los 4 retos en una sola app, con una barra inferior para cambiar entre ellos:

| Pestaña | Reto | API | ¿Necesita key? |
|---|---|---|---|
| 🎬 Películas | Recomendador por estado de ánimo + botón "Sorpréndeme" | TMDB | **Sí** (gratis, se da al instante) |
| 🐱 Gatos | Meme con texto, filtro, color y tamaño de letra | Cataas | No |
| 🌦️ Clima | Clima actual por ciudad o con tu ubicación (geolocator) | OpenWeatherMap | **Sí** (gratis, **tarda hasta ~2 h en activarse**) |
| 🪙 Cripto | Precio de BTC, ETH y SOL, y cuánto compras con X dólares | CoinGecko | No |

## 1. Cómo ejecutarlo

```bash
flutter pub get
flutter run --dart-define-from-file=secrets.json
```

Para web: `flutter run -d chrome --dart-define-from-file=secrets.json`

En **VS Code** ya está configurado en `.vscode/launch.json`, así que basta con darle **F5**.

> Si te marca un error de Gradle en Android (por ser otra versión de Flutter),
> borra la carpeta `android` y ejecuta `flutter create --platforms=android .`.
> Después vuelve a poner los permisos en `android/app/src/main/AndroidManifest.xml`
> (están al final de este README).

## 2. API keys (secrets.json)

Copia tus keys en `secrets.json` (tienes `secrets.json.example` de guía).
`secrets.json` está en el `.gitignore` para que no se suba a GitHub.

```json
{
  "TMDB_API_KEY": "tu_key_de_tmdb",
  "OWM_API_KEY": "tu_key_de_openweathermap",
  "COINGECKO_DEMO_KEY": ""
}
```

### 🌦️ OpenWeatherMap: SÁCALA PRIMERO (es la que tarda)
1. Crea tu cuenta en https://home.openweathermap.org/users/sign_up y confirma tu correo.
2. Entra a tu usuario → **My API keys**. Ya trae una "Default" (o genera otra).
3. Cópiala. **Una key nueva puede tardar hasta ~2 horas en funcionar.** Mientras tanto,
   la API responde 401 y la app te avisa que la key todavía no se activa.

Para saber si ya funciona, abre esto en el navegador:
`https://api.openweathermap.org/data/2.5/weather?q=Leon,MX&appid=TU_KEY&units=metric`
- Si ves JSON con `"temp"`, ya está lista.
- Si ves `"cod":401`, todavía no se activa.

### 🎬 TMDB
1. Crea tu cuenta en https://www.themoviedb.org/signup y **verifica tu correo**.
2. Ve a tu perfil → **Settings → API → Request an API Key** → elige **Developer**.
3. Copia la **API Key (v3 auth)**, la de 32 caracteres. **No** copies el token largo
   que empieza con `eyJ...`.

### 🐱 Cataas y 🪙 CoinGecko
No necesitan key. Si CoinGecko te marca "Demasiadas peticiones" (error 429), espera un minuto.

## 3. Arquitectura limpia

```
lib/
├── main.dart                      # Conecta todas las capas (inyección de dependencias)
├── dominio/                       # 🧠 Reglas de negocio (Dart puro, sin http ni Flutter)
│   ├── excepciones.dart           #   Fallos que llegan a la pantalla
│   ├── resultado.dart             #   Resultado<T> = Exito | Fracaso
│   ├── modelos/                   #   Pelicula, Gato, Clima, Criptomoneda
│   ├── repositorios/              #   Contratos (abstract class)
│   └── casos_uso/                 #   ObtenerPeliculaAleatoria, ConvertirDolaresACripto…
├── datos/                         # 🔌 De dónde salen los datos
│   ├── config_claves.dart         #   URLs y API keys (de secrets.json)
│   ├── cliente_http.dart          #   GET + revisar código de estado + leer JSON
│   ├── manejo_errores.dart        #   Convierte excepciones en Fallos
│   ├── modelos/modelos_json.dart  #   desdeJson de cada API
│   ├── servicios/                 #   Una clase por API (TMDB, Cataas, OWM, CoinGecko, GPS)
│   └── repositorios/              #   Implementan los contratos del dominio
└── presentacion/                  # 🎨 Lo que ve el usuario
    ├── pantallas/                 #   pantalla_inicio, pantalla_peliculas, pantalla_gatos…
    ├── viewmodels/                #   Estado de cada pantalla (ChangeNotifier + Provider)
    └── widgets/                   #   tarjeta_pelicula, tarjeta_cripto, vistas_estado
```

Así viaja una petición (ejemplo del clima):

```
PantallaClima → ClimaViewModel → ObtenerClimaPorCiudad (caso de uso)
  → RepositorioClima (contrato) ← RepositorioClimaImpl
  → ServicioClima → ClienteHttp → OpenWeatherMap
```

**La regla de oro:** el `dominio` no importa nada de `datos` ni de `presentacion`.

## 4. Notas de cada reto

- **Películas:** cada estado de ánimo usa géneros de TMDB (`/discover/movie?with_genres=`).
  "Tendencias" usa `/trending/movie/week`. El botón "Sorpréndeme" pide una página al azar
  y de ahí escoge una película.
- **Gatos:** primero se pide `/cat?json=true` para sacar el `id` de un gato. Después la URL
  se arma así: `/cat/{id}/says/{texto}?fontSize=..&fontColor=..&filter=..`, para que al cambiar
  el texto se quede el mismo gato. Abajo de la imagen se ve la URL que se va generando.
- **Clima:** puedes buscar por ciudad o usar el botón 📍 para tomar tu ubicación.
  En el emulador de Android, la ubicación se pone en *Extended controls (…) → Location*.
- **Cripto:** usa `/simple/price?ids=bitcoin,ethereum,solana&vs_currencies=usd&include_24hr_change=true`.
  Los precios se actualizan solos cada 60 s mientras estás en esa pestaña.

### Permisos de Android (ya incluidos)
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```
