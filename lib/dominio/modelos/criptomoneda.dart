class Criptomoneda {
  final String id; // id de CoinGecko: "bitcoin"
  final String nombre; // "Bitcoin"
  final String simbolo; // "BTC"
  final double precioUsd;
  final double cambio24h; // % de cambio en 24 h

  const Criptomoneda({
    required this.id,
    required this.nombre,
    required this.simbolo,
    required this.precioUsd,
    required this.cambio24h,
  });

  bool get subio => cambio24h >= 0;
}

/// Las tres monedas que pide el reto.
class MonedaSoportada {
  final String id;
  final String nombre;
  final String simbolo;
  final String emoji;
  const MonedaSoportada(this.id, this.nombre, this.simbolo, this.emoji);

  static const todas = [
    MonedaSoportada('bitcoin', 'Bitcoin', 'BTC', '₿'),
    MonedaSoportada('ethereum', 'Ethereum', 'ETH', 'Ξ'),
    MonedaSoportada('solana', 'Solana', 'SOL', '◎'),
  ];
}
