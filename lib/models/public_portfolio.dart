class PublicPortfolio {
  final String id;
  final String title;
  final String description;
  final List<String> symbols; // tickers
  final double mockReturn30dPct;
  final double mockReturnYtdPct;

  const PublicPortfolio({
    required this.id,
    required this.title,
    required this.description,
    required this.symbols,
    required this.mockReturn30dPct,
    required this.mockReturnYtdPct,
  });
}
