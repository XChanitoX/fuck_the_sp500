class ApiConfig {
  // Alpha Vantage API Configuration (Opcional - No se usa actualmente)
  // static const String alphaVantageApiKey = 'TU_API_KEY_AQUI';
  // static const String alphaVantageBaseUrl = 'https://www.alphavantage.co/query';

  // Clearbit Logo API Configuration
  static const String clearbitLogoBaseUrl = 'https://logo.clearbit.com';

  // Yahoo Finance API Configuration (Alternativa)
  static const String yahooFinanceBaseUrl =
      'https://query1.finance.yahoo.com/v8/finance/chart';

  // Finnhub API Configuration (Alternativa)
  static const String finnhubApiKey =
      'TU_FINNHUB_API_KEY'; // Reemplaza con tu API key
  static const String finnhubBaseUrl = 'https://finnhub.io/api/v1';

  // IEX Cloud API Configuration (Alternativa)
  static const String iexCloudApiKey =
      'TU_IEX_API_KEY'; // Reemplaza con tu API key
  static const String iexCloudBaseUrl = 'https://cloud.iexapis.com/stable';

  // Rate limiting configuration
  static const int maxRequestsPerMinute = 5; // Para Alpha Vantage free tier
  static const int requestDelayMs = 200; // Delay entre requests

  // Popular stock symbols for the app
  static const List<String> popularSymbols = [
    'AAPL',
    'MSFT',
    'GOOGL',
    'AMZN',
    'NVDA',
    'TSLA',
    'META',
    'IBIT',
    'ETHA',
    'BRK.B',
    'VOO',
    'QQQ'
  ];

  // Mapping for company domains (for logos)
  static const Map<String, String> symbolToDomain = {
    'AAPL': 'apple.com',
    'MSFT': 'microsoft.com',
    'GOOGL': 'google.com',
    'AMZN': 'amazon.com',
    'NVDA': 'nvidia.com',
    'TSLA': 'tesla.com',
    'META': 'meta.com',
    'IBIT': 'blackrock.com',
    'ETHA': 'blackrock.com',
    'BRK.B': 'berkshirehathaway.com',
    'VOO': 'vanguard.com',
    'QQQ': 'invesco.com',
  };
}
