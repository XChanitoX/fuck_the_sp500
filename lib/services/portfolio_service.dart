import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/portfolio.dart';
import '../models/position.dart';

class PortfolioService {
  static const String _kPortfoliosKey = 'portfolios_v1';
  static const String _kPositionsKey = 'positions_v1';

  // Portfolios
  static Future<List<Portfolio>> getPortfolios() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kPortfoliosKey);
    if (raw == null || raw.isEmpty) return [];
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    return list.map(Portfolio.fromJson).toList();
  }

  static Future<void> savePortfolios(List<Portfolio> items) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_kPortfoliosKey, raw);
  }

  static Future<void> upsertPortfolio(Portfolio p) async {
    final list = await getPortfolios();
    final idx = list.indexWhere((e) => e.id == p.id);
    if (idx >= 0) {
      list[idx] = p;
    } else {
      list.add(p);
    }
    await savePortfolios(list);
  }

  static Future<void> deletePortfolio(String id) async {
    final items = await getPortfolios();
    final filtered = items.where((e) => e.id != id).toList();
    await savePortfolios(filtered);
    // Remove positions for that portfolio
    final positions = await getPositions();
    final newPositions = positions.where((p) => p.portfolioId != id).toList();
    await savePositions(newPositions);
  }

  // Positions
  static Future<List<PositionItem>> getPositions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kPositionsKey);
    if (raw == null || raw.isEmpty) return [];
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    return list.map(PositionItem.fromJson).toList();
  }

  static Future<void> savePositions(List<PositionItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_kPositionsKey, raw);
  }

  static Future<void> upsertPosition(PositionItem pos) async {
    final positions = await getPositions();
    final idx = positions.indexWhere(
      (e) => e.portfolioId == pos.portfolioId && e.symbol == pos.symbol,
    );
    if (idx >= 0) {
      positions[idx] = pos;
    } else {
      positions.add(pos);
    }
    await savePositions(positions);
  }

  static Future<void> deletePosition(String portfolioId, String symbol) async {
    final positions = await getPositions();
    final filtered = positions
        .where((p) => !(p.portfolioId == portfolioId && p.symbol == symbol))
        .toList();
    await savePositions(filtered);
  }
}
