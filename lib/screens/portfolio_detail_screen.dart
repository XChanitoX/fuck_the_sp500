import 'package:flutter/material.dart';
import '../models/portfolio.dart';
import '../models/position.dart';
import '../services/portfolio_service.dart';
import '../services/stock_service.dart';

class PortfolioDetailScreen extends StatefulWidget {
  final Portfolio portfolio;

  const PortfolioDetailScreen({super.key, required this.portfolio});

  @override
  State<PortfolioDetailScreen> createState() => _PortfolioDetailScreenState();
}

class _PortfolioDetailScreenState extends State<PortfolioDetailScreen> {
  List<PositionItem> _positions = [];
  Map<String, double> _symbolToLastPrice = {};
  bool _loading = true;
  bool _loadingQuotes = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final all = await PortfolioService.getPositions();
    final items =
        all.where((p) => p.portfolioId == widget.portfolio.id).toList();
    setState(() {
      _positions = items;
      _loading = false;
    });
    await _refreshQuotes();
  }

  Future<void> _refreshQuotes() async {
    if (_positions.isEmpty) {
      setState(() => _symbolToLastPrice = {});
      return;
    }
    setState(() => _loadingQuotes = true);
    final symbols = _positions.map((e) => e.symbol).toSet().toList();
    final results = await Future.wait(symbols.map((s) async {
      final q = await StockService.getRealTimeQuote(s);
      return MapEntry(s, (q?['currentPrice'] ?? 0.0) as double);
    }));
    setState(() {
      _symbolToLastPrice = {for (final e in results) e.key: e.value};
      _loadingQuotes = false;
    });
  }

  double _getLastPrice(String symbol) => _symbolToLastPrice[symbol] ?? 0.0;

  Future<void> _addOrEditPosition({PositionItem? existing}) async {
    final symbolCtrl = TextEditingController(text: existing?.symbol ?? '');
    final qtyCtrl = TextEditingController(
        text: existing != null ? existing.quantity.toString() : '');
    final avgCtrl = TextEditingController(
        text: existing != null ? existing.avgPrice.toString() : '');

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF121212),
        title: Text(existing == null ? 'Agregar posición' : 'Editar posición',
            style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: symbolCtrl,
              textCapitalization: TextCapitalization.characters,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Símbolo',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
            ),
            TextField(
              controller: qtyCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Cantidad',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
            ),
            TextField(
              controller: avgCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Precio promedio',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final symbol = symbolCtrl.text.trim().toUpperCase();
              final qty = double.tryParse(qtyCtrl.text.trim()) ?? 0.0;
              final avg = double.tryParse(avgCtrl.text.trim()) ?? 0.0;
              if (symbol.isEmpty || qty <= 0 || avg <= 0) return;
              final pos = PositionItem(
                portfolioId: widget.portfolio.id,
                symbol: symbol,
                quantity: qty,
                avgPrice: avg,
              );
              await PortfolioService.upsertPosition(pos);
              if (ctx.mounted) Navigator.pop(ctx);
              if (!mounted) return;
              await _load();
            },
            child: Text(existing == null ? 'Agregar' : 'Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePosition(PositionItem p) async {
    await PortfolioService.deletePosition(p.portfolioId, p.symbol);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.portfolio.name;
    final totals = _computeTotals();
    final pnlColor = totals.pnl >= 0 ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshQuotes,
            tooltip: 'Actualizar precios',
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditPosition(),
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Valor actual: '
                                '\$${totals.currentValue.toStringAsFixed(2)}'),
                            Text('Invertido: '
                                '\$${totals.invested.toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'PnL: \$${totals.pnl.toStringAsFixed(2)}',
                            style: TextStyle(
                                color: pnlColor, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${totals.invested > 0 ? (totals.pnl / totals.invested * 100).toStringAsFixed(2) : '0.00'}% ',
                            style: TextStyle(color: pnlColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (_loadingQuotes)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: LinearProgressIndicator(minHeight: 2),
                  ),
                Expanded(
                  child: _positions.isEmpty
                      ? const Center(child: Text('Sin posiciones'))
                      : RefreshIndicator(
                          onRefresh: _refreshQuotes,
                          child: ListView.separated(
                            itemCount: _positions.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final p = _positions[index];
                              final last = _getLastPrice(p.symbol);
                              final invested = p.quantity * p.avgPrice;
                              final current = p.quantity * last;
                              final pnl = current - invested;
                              final pnlPct =
                                  invested > 0 ? pnl / invested * 100 : 0.0;
                              final color =
                                  pnl >= 0 ? Colors.green : Colors.red;

                              return ListTile(
                                title: Text(p.symbol),
                                subtitle: Text(
                                    'Qty: ${p.quantity.toStringAsFixed(2)} • Avg: \$${p.avgPrice.toStringAsFixed(2)}'),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('Last: \$${last.toStringAsFixed(2)}'),
                                    Text(
                                      '${pnl >= 0 ? '+' : ''}${pnl.toStringAsFixed(2)} (${pnlPct.toStringAsFixed(2)}%)',
                                      style: TextStyle(
                                          color: color,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                onTap: () => _addOrEditPosition(existing: p),
                                onLongPress: () => _confirmDelete(p),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  Future<void> _confirmDelete(PositionItem p) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar posición'),
        content: Text('¿Eliminar ${p.symbol}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              await _deletePosition(p);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  _Totals _computeTotals() {
    double invested = 0;
    double current = 0;
    for (final p in _positions) {
      invested += p.quantity * p.avgPrice;
      final last = _getLastPrice(p.symbol);
      current += p.quantity * last;
    }
    return _Totals(invested: invested, currentValue: current);
  }
}

class _Totals {
  final double invested;
  final double currentValue;
  double get pnl => currentValue - invested;
  const _Totals({required this.invested, required this.currentValue});
}
