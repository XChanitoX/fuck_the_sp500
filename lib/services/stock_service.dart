import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/stock.dart';

class StockService {
  static const String baseUrl = 'https://api.example.com'; // Cambiar por tu backend real
  
  // Datos de ejemplo para desarrollo
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
        aiAnalysis: 'Apple muestra fortaleza en innovación tecnológica con sólidos fundamentos financieros. El lanzamiento del iPhone 15 y servicios en la nube impulsan el crecimiento.',
        recommendation: 'COMPRAR',
        targetPrice: 185.00,
        sector: 'Tecnología',
        peRatio: 28.5,
        dividendYield: 0.5,
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
        aiAnalysis: 'Microsoft lidera en IA y computación en la nube. Azure y Office 365 mantienen crecimiento constante con excelente rentabilidad.',
        recommendation: 'COMPRAR',
        targetPrice: 350.00,
        sector: 'Tecnología',
        peRatio: 32.1,
        dividendYield: 0.8,
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
        aiAnalysis: 'Google domina la publicidad digital y avanza en IA. YouTube y Google Cloud son motores de crecimiento principales.',
        recommendation: 'COMPRAR',
        targetPrice: 155.00,
        sector: 'Tecnología',
        peRatio: 25.8,
        dividendYield: 0.0,
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
        aiAnalysis: 'Amazon mantiene liderazgo en e-commerce y AWS. La eficiencia operativa y expansión internacional son catalizadores.',
        recommendation: 'COMPRAR',
        targetPrice: 160.00,
        sector: 'Consumo Discrecional',
        peRatio: 45.2,
        dividendYield: 0.0,
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
        aiAnalysis: 'NVIDIA es líder en GPUs para IA y gaming. La demanda de chips para machine learning impulsa el crecimiento exponencial.',
        recommendation: 'COMPRAR',
        targetPrice: 520.00,
        sector: 'Tecnología',
        peRatio: 65.3,
        dividendYield: 0.1,
      ),
      Stock(
        symbol: 'TSLA',
        companyName: 'Tesla Inc.',
        currentPrice: 248.42,
        change: -5.67,
        changePercent: -2.23,
        marketCap: 789000000000,
        volume: 78901200,
        rank: 6,
        aiAnalysis: 'Tesla innova en vehículos eléctricos y energía renovable. La expansión global y nuevos modelos sostienen el crecimiento.',
        recommendation: 'MANTENER',
        targetPrice: 260.00,
        sector: 'Consumo Discrecional',
        peRatio: 78.9,
        dividendYield: 0.0,
      ),
      Stock(
        symbol: 'META',
        companyName: 'Meta Platforms Inc.',
        currentPrice: 334.92,
        change: 4.56,
        changePercent: 1.38,
        marketCap: 848000000000,
        volume: 45678900,
        rank: 7,
        aiAnalysis: 'Meta revoluciona con realidad virtual y metaverso. Instagram y WhatsApp mantienen dominio en redes sociales.',
        recommendation: 'COMPRAR',
        targetPrice: 360.00,
        sector: 'Tecnología',
        peRatio: 22.4,
        dividendYield: 0.0,
      ),
      Stock(
        symbol: 'BRK.A',
        companyName: 'Berkshire Hathaway Inc.',
        currentPrice: 523000.00,
        change: 1250.00,
        changePercent: 0.24,
        marketCap: 745000000000,
        volume: 1234,
        rank: 8,
        aiAnalysis: 'Berkshire Hathaway diversifica inversiones con gestión legendaria. Portfolio sólido con empresas de calidad.',
        recommendation: 'COMPRAR',
        targetPrice: 540000.00,
        sector: 'Finanzas',
        peRatio: 8.9,
        dividendYield: 0.0,
      ),
    ];
  }

  // Método para obtener datos del backend
  static Future<List<Stock>> fetchStocks() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/stocks'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Stock.fromJson(json)).toList();
      } else {
        // En caso de error, devolver datos mock
        return getMockStocks();
      }
    } catch (e) {
      // En caso de error de conexión, devolver datos mock
      return getMockStocks();
    }
  }

  // Método para obtener análisis detallado de una acción
  static Future<Map<String, dynamic>> fetchStockAnalysis(String symbol) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/stocks/$symbol/analysis'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'technical': 'Análisis técnico no disponible',
          'fundamental': 'Análisis fundamental no disponible',
          'sentiment': 'Análisis de sentimiento no disponible',
        };
      }
    } catch (e) {
      return {
        'technical': 'Error de conexión',
        'fundamental': 'Error de conexión',
        'sentiment': 'Error de conexión',
      };
    }
  }
}
