import '../models/public_portfolio.dart';
import '../config/api_config.dart';

class PublicPortfolioService {
  // Seed three thematic portfolios using popular symbols we already fetch
  static Future<List<PublicPortfolio>> listPortfolios() async {
    const universe = ApiConfig.popularSymbols;
    // Simple picks ensuring they are within the app's ranking symbols
    final tech = _pick(['AAPL', 'MSFT', 'NVDA', 'GOOGL', 'META'], universe);
    final finance = _pick(['JPM', 'BAC', 'V', 'MA'], universe);
    final consumers = _pick(['AMZN', 'TSLA', 'WMT', 'NKE'], universe);

    return [
      PublicPortfolio(
        id: 'pf_tech_growth',
        title: 'Tech Growth',
        description:
            'Tecnología de gran capitalización enfocada en crecimiento.',
        symbols: tech,
        mockReturn30dPct: 4.8,
        mockReturnYtdPct: 21.3,
      ),
      PublicPortfolio(
        id: 'pf_fin_qual',
        title: 'Financieras Calidad',
        description: 'Banca y pagos con fundamentales sólidos.',
        symbols: finance,
        mockReturn30dPct: 2.1,
        mockReturnYtdPct: 9.7,
      ),
      PublicPortfolio(
        id: 'pf_consumer_momentum',
        title: 'Consumo Momentum',
        description: 'Líderes de consumo con momentum reciente.',
        symbols: consumers,
        mockReturn30dPct: 3.5,
        mockReturnYtdPct: 12.6,
      ),
    ];
  }

  static List<String> _pick(List<String> desired, List<String> available) {
    return desired.where((s) => available.contains(s)).toList();
  }
}
