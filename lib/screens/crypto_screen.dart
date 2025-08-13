import 'package:flutter/material.dart';
import '../services/crypto_service.dart';
import '../models/crypto.dart';
import '../widgets/crypto_card.dart';

class CryptoScreen extends StatefulWidget {
  const CryptoScreen({super.key});

  @override
  State<CryptoScreen> createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  late Future<List<CryptoAsset>> _future;
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();
    _future = CryptoService.fetchTopByMarketCap(perPage: 10);
  }

  Future<void> _refresh() async {
    setState(() => _refreshing = true);
    final f = CryptoService.fetchTopByMarketCap(perPage: 10);
    final data = await f;
    if (!mounted) return;
    setState(() {
      _future = Future.value(data);
      _refreshing = false;
    });
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
                child: FutureBuilder<List<CryptoAsset>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final items = snapshot.data!;
                    if (items.isEmpty) {
                      return const Center(
                        child: Text(
                          'No hay datos de cripto disponibles',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: _refresh,
                      color: Colors.blue,
                      backgroundColor: Colors.black87,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 8, bottom: 16),
                        itemCount: items.length + (_refreshing ? 1 : 0),
                        itemBuilder: (context, i) {
                          if (_refreshing && i == items.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          }
                          final a = items[i];
                          return CryptoCard(asset: a);
                        },
                      ),
                    );
                  },
                ),
              ),
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
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Top Criptos',
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
}
