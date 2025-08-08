import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/stock.dart';
import '../config/api_config.dart';

class StockService {
  // Normalizar sectores a español coherente con filtros/UX
  static String normalizeSectorToSpanish(String? sector) {
    switch ((sector ?? '').trim()) {
      case 'Technology':
        return 'Tecnología';
      case 'Consumer Discretionary':
        return 'Consumo Discrecional';
      case 'Financial Services':
      case 'Finance':
      case 'Financials':
        return 'Servicios Financieros';
      case 'Healthcare':
        return 'Salud';
      default:
        return sector == null || sector.isEmpty ? 'N/A' : sector;
    }
  }

  // Obtener URL del logo de una empresa
  static String getLogoUrl(String symbol) {
    final domain = ApiConfig.symbolToDomain[symbol];
    if (domain != null) {
      return '${ApiConfig.clearbitLogoBaseUrl}/$domain';
    }
    // Fallback: intentar con el símbolo como dominio
    return '${ApiConfig.clearbitLogoBaseUrl}/$symbol.com';
  }

  // Obtener datos en tiempo real usando Yahoo Finance (gratuito)
  static Future<Map<String, dynamic>?> getRealTimeQuote(String symbol) async {
    try {
      final yfSymbol = ApiConfig.yahooSymbolOverrides[symbol] ?? symbol;
      final uri = Uri.https(
        'query1.finance.yahoo.com',
        '/v8/finance/chart/$yfSymbol',
        {
          'interval': '1d',
          'range': '1d',
        },
      );
      assert(() {
        // ignore: avoid_print
        debugPrint('🔍 Haciendo request a Yahoo Finance: $uri');
        return true;
      }());

      final response = await http.get(uri);

      assert(() {
        // ignore: avoid_print
        debugPrint('📊 Status code: ${response.statusCode}');
        return true;
      }());

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['chart'] != null &&
            data['chart']['result'] != null &&
            data['chart']['result'].isNotEmpty) {
          final result = data['chart']['result'][0];
          final meta = result['meta'];
          final indicators = result['indicators'];
          final quote = (indicators != null &&
                  indicators['quote'] != null &&
                  indicators['quote'].isNotEmpty)
              ? indicators['quote'][0]
              : <String, dynamic>{};

          double toDoubleSafe(dynamic v) {
            if (v == null) return 0.0;
            if (v is num) return v.toDouble();
            return double.tryParse(v.toString()) ?? 0.0;
          }

          final currentPrice = toDoubleSafe(meta['regularMarketPrice']);
          final previousClose = toDoubleSafe(meta['chartPreviousClose']);
          final change = currentPrice - previousClose;
          final changePercent =
              previousClose > 0 ? (change / previousClose) * 100 : 0.0;

          List<num>? asNumList(dynamic v) {
            if (v is List) {
              try {
                return v.cast<num>();
              } catch (_) {
                return null;
              }
            }
            return null;
          }

          final volumes = asNumList(quote['volume']);
          final opens = asNumList(quote['open']);
          final highs = asNumList(quote['high']);
          final lows = asNumList(quote['low']);

          final resultData = {
            'symbol': symbol,
            'currentPrice': currentPrice,
            'change': change,
            'changePercent': changePercent,
            'volume': (volumes != null && volumes.isNotEmpty)
                ? volumes.last.toDouble()
                : 0.0,
            'previousClose': previousClose,
            'open': (opens != null && opens.isNotEmpty)
                ? opens.last.toDouble()
                : 0.0,
            'high': (highs != null && highs.isNotEmpty)
                ? highs.last.toDouble()
                : 0.0,
            'low':
                (lows != null && lows.isNotEmpty) ? lows.last.toDouble() : 0.0,
            'fiftyTwoWeekHigh': toDoubleSafe(meta['fiftyTwoWeekHigh']),
            'fiftyTwoWeekLow': toDoubleSafe(meta['fiftyTwoWeekLow']),
          };
          assert(() {
            // ignore: avoid_print
            debugPrint(
                '✅ Datos procesados para $symbol: ${resultData['currentPrice']}');
            return true;
          }());
          return resultData;
        } else {
          assert(() {
            // ignore: avoid_print
            debugPrint('❌ No se encontraron datos de quote para $symbol');
            return true;
          }());
        }
      } else {
        assert(() {
          // ignore: avoid_print
          debugPrint('❌ Error HTTP: ${response.statusCode}');
          return true;
        }());
      }
      return null;
    } catch (e) {
      assert(() {
        // ignore: avoid_print
        debugPrint('❌ Error obteniendo datos de $symbol: $e');
        return true;
      }());
      return null;
    }
  }

  // Obtener información fundamental de la empresa (datos mock por ahora)
  static Future<Map<String, dynamic>?> getCompanyOverview(String symbol) async {
    try {
      // Por ahora usamos datos mock para la información fundamental
      // En el futuro podríamos usar Yahoo Finance o otra API
      final companyData = {
        'AAPL': {
          'companyName': 'Apple Inc.',
          'sector': 'Technology',
          'industry': 'Consumer Electronics',
          'marketCap': 2750000000000.0,
          'peRatio': 28.5,
          'dividendYield': 0.5,
        },
        'MSFT': {
          'companyName': 'Microsoft Corporation',
          'sector': 'Technology',
          'industry': 'Software',
          'marketCap': 2510000000000.0,
          'peRatio': 32.1,
          'dividendYield': 0.8,
        },
        'GOOGL': {
          'companyName': 'Alphabet Inc.',
          'sector': 'Technology',
          'industry': 'Internet Content & Information',
          'marketCap': 1780000000000.0,
          'peRatio': 25.8,
          'dividendYield': 0.0,
        },
        'AMZN': {
          'companyName': 'Amazon.com Inc.',
          'sector': 'Consumer Discretionary',
          'industry': 'Internet Retail',
          'marketCap': 1510000000000.0,
          'peRatio': 45.2,
          'dividendYield': 0.0,
        },
        'NVDA': {
          'companyName': 'NVIDIA Corporation',
          'sector': 'Technology',
          'industry': 'Semiconductors',
          'marketCap': 1198000000000.0,
          'peRatio': 65.3,
          'dividendYield': 0.1,
        },
        'IBIT': {
          'companyName': 'iShares Bitcoin Trust',
          'sector': 'Financial Services',
          'industry': 'Asset Management',
          'marketCap': 45000000000.0,
          'peRatio': 0.0,
          'dividendYield': 0.0,
        },
        'ETHA': {
          'companyName': 'iShares Ethereum Trust',
          'sector': 'Financial Services',
          'industry': 'Asset Management',
          'marketCap': 2500000000.0,
          'peRatio': 0.0,
          'dividendYield': 0.0,
        },
        'BRK.B': {
          'companyName': 'Berkshire Hathaway Inc.',
          'sector': 'Financial Services',
          'industry': 'Insurance',
          'marketCap': 850000000000.0,
          'peRatio': 22.5,
          'dividendYield': 0.0,
        },
        'VOO': {
          'companyName': 'Vanguard S&P 500 ETF',
          'sector': 'Financial Services',
          'industry': 'Asset Management',
          'marketCap': 350000000000.0,
          'peRatio': 0.0,
          'dividendYield': 1.4,
        },
        'QQQ': {
          'companyName': 'Invesco QQQ Trust',
          'sector': 'Financial Services',
          'industry': 'Asset Management',
          'marketCap': 250000000000.0,
          'peRatio': 0.0,
          'dividendYield': 0.6,
        },
      };

      final data = companyData[symbol];
      if (data != null) {
        assert(() {
          // ignore: avoid_print
          debugPrint(
              '✅ Overview procesado para $symbol: ${data['companyName']} - ${data['sector']}');
          return true;
        }());
        return data;
      } else {
        assert(() {
          // ignore: avoid_print
          debugPrint('❌ No se encontraron datos de overview para $symbol');
          return true;
        }());
        return {
          'companyName': symbol,
          'sector': 'N/A',
          'industry': 'N/A',
          'marketCap': 0.0,
          'peRatio': 0.0,
          'dividendYield': 0.0,
        };
      }
    } catch (e) {
      assert(() {
        // ignore: avoid_print
        debugPrint('❌ Error obteniendo overview de $symbol: $e');
        return true;
      }());
      return null;
    }
  }

  // Obtener múltiples stocks con datos reales (carga progresiva)
  static Future<List<Stock>> fetchRealTimeStocks() async {
    List<Stock> stocks = [];

    // Obtener todos los símbolos disponibles
    final symbolsToFetch = ApiConfig.popularSymbols.toList();

    assert(() {
      // ignore: avoid_print
      debugPrint(
          '🚀 Iniciando fetch de ${symbolsToFetch.length} símbolos: $symbolsToFetch');
      return true;
    }());

    for (String symbol in symbolsToFetch) {
      try {
        assert(() {
          // ignore: avoid_print
          debugPrint('\n📈 Procesando $symbol...');
          return true;
        }());

        // Obtener datos en tiempo real
        final quoteData = await getRealTimeQuote(symbol);
        if (quoteData == null) {
          assert(() {
            // ignore: avoid_print
            debugPrint(
                '❌ No se pudieron obtener datos de quote para $symbol, saltando...');
            return true;
          }());
          continue;
        }

        // Obtener información fundamental
        final overviewData = await getCompanyOverview(symbol);

        // Crear objeto Stock con datos reales
        final stock = Stock(
          symbol: symbol,
          companyName: overviewData?['companyName'] ?? symbol,
          currentPrice: quoteData['currentPrice'],
          change: quoteData['change'],
          changePercent: quoteData['changePercent'],
          marketCap: overviewData?['marketCap'] ?? 0.0,
          volume: quoteData['volume'],
          rank: stocks.length + 1,
          aiAnalysis: _generateAIAnalysis(symbol, overviewData, quoteData),
          recommendation: _generateRecommendation(
            quoteData['changePercent'],
            quoteData['currentPrice'],
            quoteData['fiftyTwoWeekHigh'],
            quoteData['fiftyTwoWeekLow'],
          ),
          targetPrice: quoteData['currentPrice'] * 1.1, // Estimación simple
          sector: normalizeSectorToSpanish(overviewData?['sector']),
          peRatio: overviewData?['peRatio'] ?? 0.0,
          dividendYield: overviewData?['dividendYield'] ?? 0.0,
          logoUrl: getLogoUrl(symbol), // Agregar URL del logo
        );

        stocks.add(stock);
        assert(() {
          // ignore: avoid_print
          debugPrint(
              '✅ Stock agregado: ${stock.symbol} - \$${stock.currentPrice}');
          return true;
        }());

        // Pausa para no exceder límites de API
        await Future.delayed(
            const Duration(milliseconds: ApiConfig.requestDelayMs));
      } catch (e) {
        assert(() {
          // ignore: avoid_print
          debugPrint('❌ Error procesando $symbol: $e');
          return true;
        }());
      }
    }

    assert(() {
      // ignore: avoid_print
      debugPrint('\n📊 Total de stocks obtenidos: ${stocks.length}');
      return true;
    }());

    // Si no se obtuvieron datos reales, devolver datos mock
    if (stocks.isEmpty) {
      assert(() {
        // ignore: avoid_print
        debugPrint('⚠️ No se obtuvieron datos reales, usando datos mock');
        return true;
      }());
      return getMockStocks();
    }

    return stocks;
  }

  // Obtener stocks con carga progresiva (8 en 8)
  static Stream<List<Stock>> fetchRealTimeStocksStream() async* {
    List<Stock> stocks = [];
    final symbolsToFetch = ApiConfig.popularSymbols.toList();
    const batchSize = 8;

    debugPrint(
        '🚀 Iniciando carga progresiva de ${symbolsToFetch.length} símbolos');

    for (int i = 0; i < symbolsToFetch.length; i += batchSize) {
      final batchSymbols = symbolsToFetch.skip(i).take(batchSize).toList();
      debugPrint('\n📦 Procesando lote ${(i ~/ batchSize) + 1}: $batchSymbols');

      for (String symbol in batchSymbols) {
        try {
          debugPrint('📈 Procesando $symbol...');

          // Obtener datos en tiempo real
          final quoteData = await getRealTimeQuote(symbol);
          if (quoteData == null) {
            debugPrint(
                '❌ No se pudieron obtener datos de quote para $symbol, saltando...');
            continue;
          }

          // Obtener información fundamental
          final overviewData = await getCompanyOverview(symbol);

          // Crear objeto Stock con datos reales
          final stock = Stock(
            symbol: symbol,
            companyName: overviewData?['companyName'] ?? symbol,
            currentPrice: quoteData['currentPrice'],
            change: quoteData['change'],
            changePercent: quoteData['changePercent'],
            marketCap: overviewData?['marketCap'] ?? 0.0,
            volume: quoteData['volume'],
            rank: stocks.length + 1,
            aiAnalysis: _generateAIAnalysis(symbol, overviewData, quoteData),
            recommendation: _generateRecommendation(
              quoteData['changePercent'],
              quoteData['currentPrice'],
              quoteData['fiftyTwoWeekHigh'],
              quoteData['fiftyTwoWeekLow'],
            ),
            targetPrice: quoteData['currentPrice'] * 1.1,
            sector: normalizeSectorToSpanish(overviewData?['sector']),
            peRatio: overviewData?['peRatio'] ?? 0.0,
            dividendYield: overviewData?['dividendYield'] ?? 0.0,
            logoUrl: getLogoUrl(symbol),
          );

          stocks.add(stock);
          debugPrint(
              '✅ Stock agregado: ${stock.symbol} - \$${stock.currentPrice}');

          // Pausa para no exceder límites de API
          await Future.delayed(const Duration(milliseconds: 200));
        } catch (e) {
          debugPrint('❌ Error procesando $symbol: $e');
        }
      }

      // Emitir el lote actual
      debugPrint('📤 Emitiendo lote con ${stocks.length} stocks');
      yield List.from(stocks);
    }

    debugPrint(
        '\n📊 Carga progresiva completada: ${stocks.length} stocks totales');
  }

  // Generar análisis AI basado en datos disponibles
  static String _generateAIAnalysis(String symbol,
      Map<String, dynamic>? overviewData, Map<String, dynamic>? quoteData) {
    final sector = overviewData?['sector'] ?? 'Tecnología';
    final peRatio = overviewData?['peRatio'] ?? 0.0;
    // final marketCap = overviewData?['marketCap'] ?? 0.0; // No usado por ahora

    // Análisis de posición del precio
    String priceAnalysis = '';
    if (quoteData != null) {
      final currentPrice = quoteData['currentPrice'] ?? 0.0;
      final fiftyTwoWeekHigh = quoteData['fiftyTwoWeekHigh'] ?? 0.0;
      final fiftyTwoWeekLow = quoteData['fiftyTwoWeekLow'] ?? 0.0;

      if (fiftyTwoWeekHigh > 0 && fiftyTwoWeekLow > 0) {
        final range = fiftyTwoWeekHigh - fiftyTwoWeekLow;
        final positionFromLow = currentPrice - fiftyTwoWeekLow;
        final relativePosition = range > 0 ? positionFromLow / range : 0.5;

        if (relativePosition < 0.3) {
          priceAnalysis =
              ' El precio actual está cerca del mínimo de 52 semanas, presentando una oportunidad de compra atractiva.';
        } else if (relativePosition > 0.7) {
          priceAnalysis =
              ' El precio actual está cerca del máximo de 52 semanas, sugiriendo precaución en nuevas posiciones.';
        } else {
          priceAnalysis =
              ' El precio actual se encuentra en un rango medio, ofreciendo un balance entre riesgo y oportunidad.';
        }
      }
    }

    if (sector == 'Technology') {
      return '$symbol muestra fortaleza en el sector tecnológico. Con un P/E ratio de ${peRatio.toStringAsFixed(1)}, la empresa mantiene una posición sólida en el mercado.$priceAnalysis';
    } else if (sector == 'Healthcare') {
      return '$symbol opera en el sector de salud, un área de crecimiento constante. La empresa demuestra estabilidad financiera y potencial de crecimiento.$priceAnalysis';
    } else if (sector == 'Financial Services') {
      return '$symbol es una empresa líder en servicios financieros. Con una capitalización de mercado significativa, muestra resistencia en diferentes condiciones económicas.$priceAnalysis';
    } else {
      return '$symbol presenta oportunidades de inversión interesantes en el sector $sector. Se recomienda análisis adicional antes de tomar decisiones de inversión.$priceAnalysis';
    }
  }

  // Generar recomendación basada en posición del precio y cambio porcentual
  static String _generateRecommendation(double changePercent,
      double currentPrice, double fiftyTwoWeekHigh, double fiftyTwoWeekLow) {
    // Calcular la posición relativa del precio actual
    final range = fiftyTwoWeekHigh - fiftyTwoWeekLow;
    final positionFromLow = currentPrice - fiftyTwoWeekLow;
    final relativePosition = range > 0 ? positionFromLow / range : 0.5;

    // Lógica de recomendación mejorada con letras
    if (changePercent > 2.0) {
      return 'B'; // Buy
    } else if (changePercent > 0) {
      return 'H'; // Hold
    } else if (changePercent > -2.0) {
      // Si está más cerca del mínimo de 52 semanas, es oportunidad de compra
      if (relativePosition < 0.4) {
        return 'B'; // Buy
      }
      // Si está más cerca del máximo de 52 semanas, es oportunidad de venta
      else if (relativePosition > 0.6) {
        return 'S'; // Sell
      }
      // Si está en el medio, observar
      else {
        return 'W'; // Watch
      }
    } else {
      return 'S'; // Sell
    }
  }

  // Datos de ejemplo para desarrollo (mantener como fallback)
  static List<Stock> getMockStocks() {
    return [
      Stock(
        symbol: 'AAPL',
        companyName: 'Apple Inc.',
        currentPrice: 175.43,
        change: 2.15,
        changePercent: 1.24,
        marketCap: 2750000000000,
        volume: 45678900,
        rank: 1,
        aiAnalysis:
            'Apple muestra fortaleza en innovación tecnológica con sólidos fundamentos financieros. El lanzamiento del iPhone 15 y servicios en la nube impulsan el crecimiento.',
        recommendation: 'B',
        targetPrice: 185.00,
        sector: 'Tecnología',
        peRatio: 28.5,
        dividendYield: 0.5,
        logoUrl: getLogoUrl('AAPL'),
      ),
      Stock(
        symbol: 'MSFT',
        companyName: 'Microsoft Corporation',
        currentPrice: 338.11,
        change: -1.23,
        changePercent: -0.36,
        marketCap: 2510000000000,
        volume: 23456700,
        rank: 2,
        aiAnalysis:
            'Microsoft lidera en IA y computación en la nube. Azure y Office 365 mantienen crecimiento constante con excelente rentabilidad.',
        recommendation: 'B',
        targetPrice: 350.00,
        sector: 'Tecnología',
        peRatio: 32.1,
        dividendYield: 0.8,
        logoUrl: getLogoUrl('MSFT'),
      ),
      Stock(
        symbol: 'GOOGL',
        companyName: 'Alphabet Inc.',
        currentPrice: 142.56,
        change: 3.45,
        changePercent: 2.48,
        marketCap: 1780000000000,
        volume: 34567800,
        rank: 3,
        aiAnalysis:
            'Google domina la publicidad digital y avanza en IA. YouTube y Google Cloud son motores de crecimiento principales.',
        recommendation: 'B',
        targetPrice: 155.00,
        sector: 'Tecnología',
        peRatio: 25.8,
        dividendYield: 0.0,
        logoUrl: getLogoUrl('GOOGL'),
      ),
      Stock(
        symbol: 'AMZN',
        companyName: 'Amazon.com Inc.',
        currentPrice: 145.24,
        change: 1.67,
        changePercent: 1.16,
        marketCap: 1510000000000,
        volume: 56789000,
        rank: 4,
        aiAnalysis:
            'Amazon mantiene liderazgo en e-commerce y AWS. La eficiencia operativa y expansión internacional son catalizadores.',
        recommendation: 'B',
        targetPrice: 160.00,
        sector: 'Consumo Discrecional',
        peRatio: 45.2,
        dividendYield: 0.0,
        logoUrl: getLogoUrl('AMZN'),
      ),
      Stock(
        symbol: 'NVDA',
        companyName: 'NVIDIA Corporation',
        currentPrice: 485.09,
        change: 12.34,
        changePercent: 2.61,
        marketCap: 1198000000000,
        volume: 67890100,
        rank: 5,
        aiAnalysis:
            'NVIDIA es líder en GPUs para IA y gaming. La demanda de chips para machine learning impulsa el crecimiento exponencial.',
        recommendation: 'B',
        targetPrice: 520.00,
        sector: 'Tecnología',
        peRatio: 65.3,
        dividendYield: 0.1,
        logoUrl: getLogoUrl('NVDA'),
      ),
      Stock(
        symbol: 'IBIT',
        companyName: 'iShares Bitcoin Trust',
        currentPrice: 42.15,
        change: 1.25,
        changePercent: 3.05,
        marketCap: 45000000000,
        volume: 12345600,
        rank: 6,
        aiAnalysis:
            'IBIT es el ETF de Bitcoin más grande del mundo. La adopción institucional de Bitcoin y la demanda de exposición digital impulsan el crecimiento.',
        recommendation: 'B',
        targetPrice: 45.00,
        sector: 'Servicios Financieros',
        peRatio: 0.0,
        dividendYield: 0.0,
        logoUrl: getLogoUrl('IBIT'),
      ),
      Stock(
        symbol: 'ETHA',
        companyName: 'iShares Ethereum Trust',
        currentPrice: 8.75,
        change: 0.45,
        changePercent: 5.42,
        marketCap: 2500000000,
        volume: 5678900,
        rank: 7,
        aiAnalysis:
            'ETHA es el ETF de Ethereum de BlackRock. La adopción institucional de Ethereum y el crecimiento de DeFi son catalizadores principales.',
        recommendation: 'B',
        targetPrice: 9.50,
        sector: 'Servicios Financieros',
        peRatio: 0.0,
        dividendYield: 0.0,
        logoUrl: getLogoUrl('ETHA'),
      ),
      Stock(
        symbol: 'BRK.B',
        companyName: 'Berkshire Hathaway Inc.',
        currentPrice: 415.25,
        change: 3.45,
        changePercent: 0.84,
        marketCap: 850000000000,
        volume: 3456789,
        rank: 8,
        aiAnalysis:
            'Berkshire Hathaway es una empresa de inversión diversificada liderada por Warren Buffett. Su portafolio diversificado y gestión conservadora ofrecen estabilidad a largo plazo.',
        recommendation: 'B',
        targetPrice: 430.00,
        sector: 'Servicios Financieros',
        peRatio: 22.5,
        dividendYield: 0.0,
        logoUrl: getLogoUrl('BRK.B'),
      ),
      Stock(
        symbol: 'VOO',
        companyName: 'Vanguard S&P 500 ETF',
        currentPrice: 485.75,
        change: 2.15,
        changePercent: 0.44,
        marketCap: 350000000000,
        volume: 1234567,
        rank: 9,
        aiAnalysis:
            'VOO es el ETF más popular que replica el S&P 500. Ofrece exposición diversificada a las 500 empresas más grandes de Estados Unidos con bajos costos.',
        recommendation: 'B',
        targetPrice: 495.00,
        sector: 'Servicios Financieros',
        peRatio: 0.0,
        dividendYield: 1.4,
        logoUrl: getLogoUrl('VOO'),
      ),
      Stock(
        symbol: 'QQQ',
        companyName: 'Invesco QQQ Trust',
        currentPrice: 425.50,
        change: 5.25,
        changePercent: 1.25,
        marketCap: 250000000000,
        volume: 2345678,
        rank: 10,
        aiAnalysis:
            'QQQ replica el índice NASDAQ-100, ofreciendo exposición a las empresas tecnológicas más innovadoras. Ideal para inversores que buscan crecimiento tecnológico.',
        recommendation: 'B',
        targetPrice: 435.00,
        sector: 'Servicios Financieros',
        peRatio: 0.0,
        dividendYield: 0.6,
        logoUrl: getLogoUrl('QQQ'),
      ),
    ];
  }

  // Método de prueba para verificar la API
  static Future<void> testApiConnection() async {
    debugPrint('🧪 Iniciando prueba de conexión a Yahoo Finance...');

    try {
      const testSymbol = 'AAPL';
      debugPrint('🔍 Probando con símbolo: $testSymbol');

      final quoteData = await getRealTimeQuote(testSymbol);
      if (quoteData != null) {
        debugPrint('✅ Yahoo Finance funcionando correctamente!');
        debugPrint('📊 Datos obtenidos: $quoteData');
      } else {
        debugPrint('❌ No se pudieron obtener datos de Yahoo Finance');
      }
    } catch (e) {
      debugPrint('❌ Error en prueba de API: $e');
    }
  }

  // Método para obtener análisis detallado de una acción
  static Future<Map<String, dynamic>> fetchStockAnalysis(String symbol) async {
    try {
      // Obtener datos en tiempo real de Yahoo Finance
      final quoteData = await getRealTimeQuote(symbol);
      final overviewData = await getCompanyOverview(symbol);

      return {
        'technical':
            'Análisis técnico: ${quoteData != null ? "Datos disponibles de Yahoo Finance" : "No disponible"}',
        'fundamental':
            'Análisis fundamental: ${overviewData != null ? "Datos disponibles" : "No disponible"}',
        'sentiment':
            'Análisis de sentimiento: Basado en datos de mercado en tiempo real',
        'currentPrice': quoteData?['currentPrice'] ?? 0.0,
        'change': quoteData?['change'] ?? 0.0,
        'changePercent': quoteData?['changePercent'] ?? 0.0,
      };
    } catch (e) {
      return {
        'technical': 'Error de conexión',
        'fundamental': 'Error de conexión',
        'sentiment': 'Error de conexión',
        'currentPrice': 0.0,
        'change': 0.0,
        'changePercent': 0.0,
      };
    }
  }
}
