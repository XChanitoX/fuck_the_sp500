import 'package:flutter/material.dart';
import '../services/public_portfolio_service.dart';
import '../models/public_portfolio.dart';
import '../services/stock_service.dart';

class PublicPortfoliosScreen extends StatefulWidget {
  const PublicPortfoliosScreen({super.key});

  @override
  State<PublicPortfoliosScreen> createState() => _PublicPortfoliosScreenState();
}

class _PublicPortfoliosScreenState extends State<PublicPortfoliosScreen> {
  late Future<List<PublicPortfolio>> _future;

  @override
  void initState() {
    super.initState();
    _future = PublicPortfolioService.listPortfolios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0A0A), Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: FutureBuilder<List<PublicPortfolio>>(
                  future: _future,
                  builder: (context, snap) {
                    if (!snap.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final items = snap.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      itemBuilder: (context, i) => _portfolioCard(items[i]),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24, width: 1),
              ),
              child: const Icon(Icons.arrow_back_ios,
                  color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Copiar Portafolios',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _portfolioCard(PublicPortfolio p) {
    final perfColor30 = p.mockReturn30dPct >= 0 ? Colors.green : Colors.red;
    final perfColorYtd = p.mockReturnYtdPct >= 0 ? Colors.green : Colors.red;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(colors: [
          Colors.white.withOpacity(0.08),
          Colors.white.withOpacity(0.04),
        ]),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(p.description,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '30d: ${p.mockReturn30dPct >= 0 ? '+' : ''}${p.mockReturn30dPct.toStringAsFixed(1)}%',
                    style: TextStyle(
                        color: perfColor30, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'YTD: ${p.mockReturnYtdPct >= 0 ? '+' : ''}${p.mockReturnYtdPct.toStringAsFixed(1)}%',
                    style: TextStyle(
                        color: perfColorYtd, fontWeight: FontWeight.w600),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in p.symbols)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: Text(s,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12)),
                )
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _previewStocks(p),
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text('Ver acciones'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24, width: 1),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _copyPortfolio(p),
                  icon: const Icon(Icons.file_copy_outlined, size: 18),
                  label: const Text('Copiar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _previewStocks(PublicPortfolio p) async {
    // Fetch real-time data for symbols and show a bottom sheet list of stock cards
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F0F13),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return _PortfolioPreviewSheet(portfolio: p);
      },
    );
  }

  Future<void> _copyPortfolio(PublicPortfolio p) async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Portafolio "${p.title}" copiado a tu cuenta (demo).'),
      ),
    );
  }
}

class _PortfolioPreviewSheet extends StatefulWidget {
  final PublicPortfolio portfolio;
  const _PortfolioPreviewSheet({required this.portfolio});

  @override
  State<_PortfolioPreviewSheet> createState() => _PortfolioPreviewSheetState();
}

class _PortfolioPreviewSheetState extends State<_PortfolioPreviewSheet> {
  bool _loading = true;
  final List stocks = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await Future.wait(
      widget.portfolio.symbols.map((s) async {
        final quote = await StockService.getRealTimeQuote(s);
        final overview = await StockService.getCompanyOverview(s);
        if (quote == null) return null;
        return {
          'symbol': s,
          'companyName': overview?['companyName'] ?? s,
          'currentPrice': quote['currentPrice'] as double,
          'change': quote['change'] as double,
          'changePercent': quote['changePercent'] as double,
          'marketCap': overview?['marketCap'] ?? 0.0,
          'volume': quote['volume'] as double,
          'rank': 0,
          'aiAnalysis': '',
          'recommendation': 'W',
          'targetPrice': (quote['currentPrice'] as double) * 1.1,
          'sector': overview?['sector'],
          'peRatio': overview?['peRatio'] ?? 0.0,
          'dividendYield': overview?['dividendYield'] ?? 0.0,
          'logoUrl': StockService.getLogoUrl(s),
        };
      }),
    );
    stocks.addAll(data.whereType<Map>());
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Acciones en "${widget.portfolio.title}"',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: stocks.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final m = stocks[i];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white24, width: 1),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white10,
                                backgroundImage:
                                    NetworkImage(m['logoUrl'] as String),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(m['symbol'] as String,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                    Text(m['companyName'] as String,
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12)),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '\$${(m['currentPrice'] as double).toStringAsFixed(2)}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    '${((m['changePercent']) as double) >= 0 ? '+' : ''}${(m['changePercent'] as double).toStringAsFixed(2)}%',
                                    style: TextStyle(
                                        color:
                                            ((m['changePercent']) as double) >=
                                                    0
                                                ? Colors.green
                                                : Colors.red,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
