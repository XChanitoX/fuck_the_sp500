class CryptoAsset {
  final String id;
  final String symbol;
  final String name;
  final double currentPrice;
  final double marketCap;
  final double volume24h;
  final double changePercent24h;
  final int rank;
  final String imageUrl;

  const CryptoAsset({
    required this.id,
    required this.symbol,
    required this.name,
    required this.currentPrice,
    required this.marketCap,
    required this.volume24h,
    required this.changePercent24h,
    required this.rank,
    required this.imageUrl,
  });

  factory CryptoAsset.fromJson(Map<String, dynamic> json) {
    return CryptoAsset(
      id: json['id'] as String? ?? '',
      symbol: (json['symbol'] as String? ?? '').toUpperCase(),
      name: json['name'] as String? ?? '',
      currentPrice: (json['current_price'] as num?)?.toDouble() ?? 0.0,
      marketCap: (json['market_cap'] as num?)?.toDouble() ?? 0.0,
      volume24h: (json['total_volume'] as num?)?.toDouble() ?? 0.0,
      changePercent24h:
          (json['price_change_percentage_24h'] as num?)?.toDouble() ?? 0.0,
      rank: json['market_cap_rank'] as int? ?? 0,
      imageUrl: json['image'] as String? ?? '',
    );
  }
}
