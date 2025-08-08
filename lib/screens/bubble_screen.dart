import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/stock.dart';
import '../services/stock_service.dart';
import 'stock_detail_screen.dart';

class BubbleScreen extends StatefulWidget {
  final List<Stock>? stocks;

  const BubbleScreen({super.key, this.stocks});

  @override
  State<BubbleScreen> createState() => _BubbleScreenState();
}

class _BubbleScreenState extends State<BubbleScreen>
    with SingleTickerProviderStateMixin {
  List<Stock> _stocks = [];
  bool _isLoading = true;
  Size? _areaSize;

  late final AnimationController _ticker;

  final List<_BubbleData> _bubbles = [];
  bool _simulationInitialized = false;

  @override
  void initState() {
    super.initState();
    _init();
    _ticker = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16000),
    )..addListener(_onTick);
    _ticker.repeat();
  }

  Future<void> _init() async {
    final incoming = widget.stocks;
    if (incoming != null && incoming.isNotEmpty) {
      setState(() {
        _stocks = incoming;
        _isLoading = false;
      });
      return;
    }

    try {
      final data = await StockService.fetchRealTimeStocks();
      if (mounted) {
        setState(() {
          _stocks = data;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  double _computeBubbleSizeRange(
      double magnitude, double minMag, double maxMag) {
    // Map magnitude linearly to a pixel size in [minSize, maxSize]
    const double minSize = 40;
    const double maxSize = 120;
    if (maxMag <= minMag) return (minSize + maxSize) / 2;
    final t = (magnitude - minMag) / (maxMag - minMag);
    return minSize + t * (maxSize - minSize);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              _buildHeader(theme),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    _areaSize =
                        Size(constraints.maxWidth, constraints.maxHeight);
                    if (!_simulationInitialized &&
                        !_isLoading &&
                        _stocks.isNotEmpty) {
                      _initSimulation();
                    }
                    if (_isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.blue),
                      );
                    }
                    if (_stocks.isEmpty) {
                      return Center(
                        child: Text(
                          'No hay datos para mostrar',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      );
                    }
                    return _buildBubbles();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
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
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: const Icon(Icons.arrow_back_ios,
                  color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Burbujas de Acciones',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
          ),
          // Legend
          _legendDot(Colors.green, 'Suben'),
          const SizedBox(width: 8),
          _legendDot(Colors.red, 'Bajan'),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
        ),
      ],
    );
  }

  void _initSimulation() {
    final size = _areaSize;
    if (size == null || _stocks.isEmpty) return;

    // Compute radii based on changePercent magnitude
    final magnitudes = _stocks.map((s) => s.changePercent.abs()).toList();
    final minMag =
        magnitudes.isEmpty ? 0.0 : magnitudes.reduce((a, b) => a < b ? a : b);
    final maxMag =
        magnitudes.isEmpty ? 0.0 : magnitudes.reduce((a, b) => a > b ? a : b);

    _bubbles.clear();
    final rand = math.Random(42);
    for (final s in _stocks) {
      final bubbleDiameter =
          _computeBubbleSizeRange(s.changePercent.abs(), minMag, maxMag);
      final radius = bubbleDiameter / 2;
      // Random non-overlapping-ish start positions
      final pos = Offset(
        radius + rand.nextDouble() * (size.width - radius * 2),
        radius + rand.nextDouble() * (size.height - radius * 2),
      );
      _bubbles.add(
        _BubbleData(
          stock: s,
          radius: radius,
          position: pos,
          velocity: Offset.zero,
        ),
      );
    }
    _simulationInitialized = true;
  }

  void _onTick() {
    if (!_simulationInitialized) return;
    final size = _areaSize;
    if (size == null) return;

    const double dt = 1 / 60.0; // seconds per frame approximation
    const double damping = 0.98; // friction
    const double repelStrength = 250.0; // collision push strength
    const double centerPull = 0.05; // gentle centering

    // Pairwise repulsion
    for (int i = 0; i < _bubbles.length; i++) {
      final bi = _bubbles[i];
      for (int j = i + 1; j < _bubbles.length; j++) {
        final bj = _bubbles[j];
        final delta = bj.position - bi.position;
        final dist = delta.distance;
        final minDist = bi.radius + bj.radius + 2;
        if (dist == 0) {
          // Nudge apart if perfectly overlapped
          final randomDir = Offset((math.Random().nextDouble() - 0.5),
                  (math.Random().nextDouble() - 0.5))
              .normalize();
          bi.velocity -= randomDir * 10;
          bj.velocity += randomDir * 10;
          continue;
        }
        if (dist < minDist) {
          final overlap = (minDist - dist) / dist;
          final push = delta * overlap * repelStrength * dt * 0.5;
          if (!bi.isDragging) bi.velocity -= push / math.max(bi.radius, 1);
          if (!bj.isDragging) bj.velocity += push / math.max(bj.radius, 1);
        }
      }
    }

    // Integrate with damping and bounds + center pull
    final center = Offset(size.width / 2, size.height / 2);
    for (final b in _bubbles) {
      // Centering force
      final toCenter = (center - b.position) * centerPull * dt;
      if (!b.isDragging) b.velocity += toCenter;

      // Damping
      b.velocity = b.velocity * damping;

      if (!b.isDragging) {
        b.position += b.velocity * (60 * dt) * 0.16; // tuned speed factor
      }

      // Bounds
      final left = b.radius;
      final right = size.width - b.radius;
      final top = b.radius;
      final bottom = size.height - b.radius;
      var px = b.position.dx;
      var py = b.position.dy;
      var vx = b.velocity.dx;
      var vy = b.velocity.dy;

      if (px < left) {
        px = left;
        vx = vx.abs();
      } else if (px > right) {
        px = right;
        vx = -vx.abs();
      }
      if (py < top) {
        py = top;
        vy = vy.abs();
      } else if (py > bottom) {
        py = bottom;
        vy = -vy.abs();
      }
      b.position = Offset(px, py);
      b.velocity = Offset(vx, vy);
    }

    if (mounted) setState(() {});
  }

  Widget _buildBubbles() {
    // Render current positions
    return Stack(
      children: [
        for (int i = 0; i < _bubbles.length; i++) _buildBubble(i),
      ],
    );
  }

  Widget _buildBubble(int index) {
    final b = _bubbles[index];
    final s = b.stock;
    final isUp = s.change >= 0;
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isUp
          ? [
              Colors.green.withOpacity(0.85),
              Colors.greenAccent.withOpacity(0.75),
            ]
          : [
              Colors.red.withOpacity(0.85),
              Colors.redAccent.withOpacity(0.75),
            ],
    );

    final diameter = b.radius * 2;
    final textColor = Colors.white;
    final symbolStyle = TextStyle(
      color: textColor,
      fontWeight: FontWeight.bold,
      fontSize: diameter * 0.18,
      fontFamily: 'Roboto',
    );
    final percentStyle = TextStyle(
      color: textColor.withOpacity(0.95),
      fontWeight: FontWeight.w600,
      fontSize: diameter * 0.14,
      fontFamily: 'Roboto',
    );

    return Positioned(
      left: b.position.dx - b.radius,
      top: b.position.dy - b.radius,
      width: diameter,
      height: diameter,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StockDetailScreen(stock: s),
            ),
          );
        },
        onPanStart: (d) {
          setState(() => b.isDragging = true);
        },
        onPanUpdate: (d) {
          final size = _areaSize;
          if (size == null) return;
          final local = Offset(
            (b.position.dx - b.radius) + d.delta.dx + b.radius,
            (b.position.dy - b.radius) + d.delta.dy + b.radius,
          );
          // Clamp within bounds
          final clamped = Offset(
            local.dx.clamp(b.radius, size.width - b.radius),
            local.dy.clamp(b.radius, size.height - b.radius),
          );
          setState(() {
            b.position = clamped;
            b.velocity = d.delta; // momentum after release
          });
        },
        onPanEnd: (_) {
          setState(() => b.isDragging = false);
        },
        child: Tooltip(
          message:
              '${s.symbol}  •  ${isUp ? '+' : ''}${s.changePercent.toStringAsFixed(2)}%',
          textStyle: const TextStyle(color: Colors.white),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: gradient,
              boxShadow: [
                BoxShadow(
                  color: (isUp ? Colors.green : Colors.red).withOpacity(0.25),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(s.symbol,
                      overflow: TextOverflow.ellipsis, style: symbolStyle),
                  SizedBox(height: diameter * 0.02),
                  Text(
                    '${isUp ? '+' : ''}${s.changePercent.toStringAsFixed(2)}%',
                    style: percentStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BubbleData {
  final Stock stock;
  final double radius;
  Offset position;
  Offset velocity;
  bool isDragging;

  _BubbleData({
    required this.stock,
    required this.radius,
    required this.position,
    required this.velocity,
    this.isDragging = false,
  });
}

extension on Offset {
  double get distance => math.sqrt(dx * dx + dy * dy);
  Offset normalize() {
    final len = distance;
    if (len == 0) return this;
    return this / len;
  }
}
