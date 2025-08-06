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
    'BRK.A',
    'UNH',
    'JNJ',
    'JPM',
    'V',
    'PG',
    'HD',
    'MA',
    'DIS',
    'PYPL',
    'BAC',
    'ADBE',
    'CRM',
    'NFLX',
    'INTC',
    'VZ',
    'CMCSA',
    'PFE',
    'TMO',
    'ABT',
    'KO',
    'PEP',
    'AVGO',
    'COST',
    'DHR',
    'MRK',
    'ACN',
    'WMT',
    'TXN',
    'QCOM',
    'HON',
    'ORCL',
    'LLY',
    'UNP',
    'PM',
    'LOW',
    'IBM',
    'SPY',
    'QQQ',
    'VTI',
    'VOO',
    'IVV',
    'DIA'
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
    'BRK.A': 'berkshirehathaway.com',
    'UNH': 'unitedhealthgroup.com',
    'JNJ': 'jnj.com',
    'JPM': 'jpmorganchase.com',
    'V': 'visa.com',
    'PG': 'pg.com',
    'HD': 'homedepot.com',
    'MA': 'mastercard.com',
    'DIS': 'thewaltdisneycompany.com',
    'PYPL': 'paypal.com',
    'BAC': 'bankofamerica.com',
    'ADBE': 'adobe.com',
    'CRM': 'salesforce.com',
    'NFLX': 'netflix.com',
    'INTC': 'intel.com',
    'VZ': 'verizon.com',
    'CMCSA': 'comcast.com',
    'PFE': 'pfizer.com',
    'TMO': 'thermofisher.com',
    'ABT': 'abbott.com',
    'KO': 'coca-cola.com',
    'PEP': 'pepsico.com',
    'AVGO': 'broadcom.com',
    'COST': 'costco.com',
    'DHR': 'danaher.com',
    'MRK': 'merck.com',
    'ACN': 'accenture.com',
    'WMT': 'walmart.com',
    'TXN': 'ti.com',
    'QCOM': 'qualcomm.com',
    'HON': 'honeywell.com',
    'ORCL': 'oracle.com',
    'LLY': 'lilly.com',
    'UNP': 'up.com',
    'PM': 'altria.com',
    'LOW': 'lowes.com',
    'IBM': 'ibm.com',
    'SPY': 'ssga.com',
    'QQQ': 'invesco.com',
    'VTI': 'vanguard.com',
    'VOO': 'vanguard.com',
    'IVV': 'ishares.com',
    'DIA': 'spdrs.com',
  };
}
