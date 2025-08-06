class Stock {
  final String symbol;
  final String companyName;
  final double currentPrice;
  final double change;
  final double changePercent;
  final double marketCap;
  final double volume;
  final int rank;
  final String aiAnalysis;
  final String recommendation;
  final double targetPrice;
  final String sector;
  final double peRatio;
  final double dividendYield;

  Stock({
    required this.symbol,
    required this.companyName,
    required this.currentPrice,
    required this.change,
    required this.changePercent,
    required this.marketCap,
    required this.volume,
    required this.rank,
    required this.aiAnalysis,
    required this.recommendation,
    required this.targetPrice,
    required this.sector,
    required this.peRatio,
    required this.dividendYield,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      symbol: json['symbol'] ?? '',
      companyName: json['companyName'] ?? '',
      currentPrice: (json['currentPrice'] ?? 0.0).toDouble(),
      change: (json['change'] ?? 0.0).toDouble(),
      changePercent: (json['changePercent'] ?? 0.0).toDouble(),
      marketCap: (json['marketCap'] ?? 0.0).toDouble(),
      volume: (json['volume'] ?? 0.0).toDouble(),
      rank: json['rank'] ?? 0,
      aiAnalysis: json['aiAnalysis'] ?? '',
      recommendation: json['recommendation'] ?? '',
      targetPrice: (json['targetPrice'] ?? 0.0).toDouble(),
      sector: json['sector'] ?? '',
      peRatio: (json['peRatio'] ?? 0.0).toDouble(),
      dividendYield: (json['dividendYield'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'companyName': companyName,
      'currentPrice': currentPrice,
      'change': change,
      'changePercent': changePercent,
      'marketCap': marketCap,
      'volume': volume,
      'rank': rank,
      'aiAnalysis': aiAnalysis,
      'recommendation': recommendation,
      'targetPrice': targetPrice,
      'sector': sector,
      'peRatio': peRatio,
      'dividendYield': dividendYield,
    };
  }
}
