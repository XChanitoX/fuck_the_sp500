import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/foundation.dart';
import '../models/stock.dart';
import '../services/stock_service.dart';
import '../widgets/stock_card.dart';
import '../widgets/stock_shimmer.dart';
import '../config/api_config.dart';
import 'stock_detail_screen.dart';
import 'bubble_screen.dart';
import 'portfolio_list_screen.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen>
    with TickerProviderStateMixin {
  List<Stock> stocks = [];
  bool isLoading = true;
  bool isRefreshing = false;
  bool isProgressiveLoading = false;
  int totalSymbols = 0;
  int loadedSymbols = 0;
  String selectedFilter = 'Todos';
  final List<String> filters = [
    'Todos',
    'Tecnología',
    'Servicios Financieros',
    'Consumo Discrecional',
    'Salud',
  ];

  @override
  void initState() {
    super.initState();
    _loadStocks();
  }

  Future<void> _loadStocks() async {
    if (!isRefreshing) {
      setState(() {
        isLoading = true;
        isProgressiveLoading = true;
        stocks = []; // Limpiar stocks existentes
        totalSymbols = ApiConfig.popularSymbols.length;
        loadedSymbols = 0;
      });
    }

    try {
      // Primero probar la conexión a la API (solo en debug)
      if (kDebugMode) {
        await StockService.testApiConnection();
      }

      // Usar carga progresiva
      await for (final loadedStocks
          in StockService.fetchRealTimeStocksStream()) {
        if (mounted) {
          setState(() {
            stocks = loadedStocks;
            loadedSymbols = loadedStocks.length;
            isLoading = false;
            isRefreshing = false;
          });
        }
      }

      // Carga completada
      if (mounted) {
        setState(() {
          isProgressiveLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Error en _loadStocks: $e');
      setState(() {
        isLoading = false;
        isRefreshing = false;
        isProgressiveLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error al cargar los datos'),
            backgroundColor: Colors.red.withOpacity(0.8),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Future<void> _refreshStocks() async {
    setState(() {
      isRefreshing = true;
    });
    await _loadStocks();
  }

  List<Stock> get filteredStocks {
    if (selectedFilter == 'Todos') {
      return stocks;
    }
    return stocks.where((stock) => stock.sector == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0A0A),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Filter chips
              _buildFilterChips(),

              // Content
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0.8),
                      Colors.purple.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Top Stocks',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    Text(
                      'Ranking de las mejores acciones',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _refreshStocks,
                icon: Icon(
                  isRefreshing ? Icons.refresh : Icons.refresh_outlined,
                  color: Colors.white.withOpacity(0.8),
                  size: 24,
                ),
              ),
              const SizedBox(width: 8),
              Tooltip(
                message: 'Vista de burbujas',
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BubbleScreen(stocks: stocks),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.bubble_chart_outlined,
                    color: Colors.white.withOpacity(0.9),
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Tooltip(
                message: 'Portafolios',
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PortfolioListScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.workspaces_outline,
                    color: Colors.white.withOpacity(0.9),
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.psychology,
                  color: Colors.blue.withOpacity(0.8),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Análisis impulsado por IA',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.green.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(
          begin: -0.3,
          duration: 800.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;

          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedFilter = filter;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            Colors.blue.withOpacity(0.8),
                            Colors.purple.withOpacity(0.8),
                          ],
                        )
                      : null,
                  color: isSelected ? null : Colors.white.withOpacity(0.1),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.8),
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 200.ms).slideY(
          begin: -0.2,
          duration: 800.ms,
          delay: 200.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildContent() {
    if (isLoading) {
      return ListView.builder(
        padding: const EdgeInsets.only(top: 20),
        itemCount: 8,
        itemBuilder: (context, index) => const StockShimmer(),
      );
    }

    if (filteredStocks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No se encontraron acciones',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 18,
                fontFamily: 'Roboto',
              ),
            ),
            Text(
              'Intenta con otro filtro',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshStocks,
      color: Colors.blue,
      backgroundColor: Colors.black.withOpacity(0.8),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        itemCount: filteredStocks.length + (isProgressiveLoading ? 1 : 0),
        itemBuilder: (context, index) {
          // Mostrar indicador de progreso al final si está cargando
          if (isProgressiveLoading && index == filteredStocks.length) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Cargando más acciones... ($loadedSymbols/$totalSymbols)',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),
            );
          }

          final stock = filteredStocks[index];
          return StockCard(
            stock: stock,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StockDetailScreen(stock: stock),
                ),
              );
            },
          )
              .animate()
              .fadeIn(
                duration: 600.ms,
                delay: (index * 100).ms,
              )
              .slideY(
                begin: 0.3,
                duration: 600.ms,
                delay: (index * 100).ms,
                curve: Curves.easeOutCubic,
              );
        },
      ),
    );
  }
}
