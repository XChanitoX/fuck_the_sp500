import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/crypto.dart';

class CryptoService {
  // Back to CoinGecko markets endpoint
  static const String _base = 'https://api.coingecko.com/api/v3';

  // Fixed selection requested: BTC, ETH, SOL, XRP, SEI, DOGE, GRT, LINK
  static const List<String> _targetIds = [
    'bitcoin',
    'ethereum',
    'solana',
    'ripple',
    'sei-network',
    'dogecoin',
    'the-graph',
    'chainlink',
  ];

  static List<CryptoAsset>? _cache;
  static DateTime? _cacheAt;
  static const Duration _cacheTtl = Duration(seconds: 60);

  static Map<String, String> _headers() {
    return const {
      'Accept': 'application/json',
      'User-Agent': 'TopStocksApp/1.0 (https://example.com)',
    };
  }

  // (helpers unused in CoinGecko flow; kept empty to satisfy lints removed)

  static Future<List<CryptoAsset>> fetchTopByMarketCap({
    int perPage = 10,
  }) async {
    // Serve from cache if fresh
    final now = DateTime.now();
    if (_cache != null &&
        _cacheAt != null &&
        now.difference(_cacheAt!) < _cacheTtl) {
      return _cache!;
    }

    final ids = _targetIds.join(',');
    final uri = Uri.parse(
      '$_base/coins/markets?vs_currency=usd&ids=$ids&order=market_cap_desc&sparkline=false&price_change_percentage=24h',
    );
    debugPrint('🔍 Fetching selected cryptos (CoinGecko): $uri');
    try {
      final res = await http.get(uri, headers: _headers());
      if (res.statusCode != 200) {
        debugPrint('❌ Crypto API error: ${res.statusCode} ${res.body}');
        if (_cache != null && _cache!.isNotEmpty) return _cache!;
        return _fallback();
      }
      final List data = json.decode(res.body) as List;
      final items =
          data
              .map((e) => CryptoAsset.fromJson(e as Map<String, dynamic>))
              .toList();
      items.sort((a, b) => a.rank.compareTo(b.rank));
      _cache = items;
      _cacheAt = now;
      return items;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('❌ Crypto fetch error: $e\n$st');
      }
      if (_cache != null && _cache!.isNotEmpty) return _cache!;
      return _fallback();
    }
  }

  static List<CryptoAsset> _fallback() {
    return [
      const CryptoAsset(
        id: 'bitcoin',
        symbol: 'BTC',
        name: 'Bitcoin',
        currentPrice: 65000.0,
        marketCap: 1.28e12,
        volume24h: 24e9,
        changePercent24h: 1.2,
        rank: 1,
        imageUrl:
            'https://assets.coingecko.com/coins/images/1/large/bitcoin.png',
      ),
      const CryptoAsset(
        id: 'ethereum',
        symbol: 'ETH',
        name: 'Ethereum',
        currentPrice: 3400.0,
        marketCap: 4.1e11,
        volume24h: 12e9,
        changePercent24h: -0.6,
        rank: 2,
        imageUrl:
            'https://assets.coingecko.com/coins/images/279/large/ethereum.png',
      ),
    ];
  }
}
