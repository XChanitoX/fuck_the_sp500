class PositionItem {
  final String portfolioId;
  final String symbol;
  final double quantity; // number of shares/units
  final double avgPrice; // average acquisition price

  PositionItem({
    required this.portfolioId,
    required this.symbol,
    required this.quantity,
    required this.avgPrice,
  });

  factory PositionItem.fromJson(Map<String, dynamic> json) {
    return PositionItem(
      portfolioId: json['portfolioId'] as String,
      symbol: json['symbol'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      avgPrice: (json['avgPrice'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'portfolioId': portfolioId,
        'symbol': symbol,
        'quantity': quantity,
        'avgPrice': avgPrice,
      };
}
