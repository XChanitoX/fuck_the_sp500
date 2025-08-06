import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../models/stock.dart';

class StockCard extends StatelessWidget {
  final Stock stock;
  final VoidCallback? onTap;
  final bool isExpanded;

  const StockCard({
    super.key,
    required this.stock,
    this.onTap,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = stock.change >= 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
          ),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header con ranking y símbolo
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.withOpacity(0.8),
                              Colors.purple.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            '#${stock.rank}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stock.symbol,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            Text(
                              stock.companyName,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                                fontFamily: 'Roboto',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Precio y cambio
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${stock.currentPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isPositive
                                    ? Icons.trending_up
                                    : Icons.trending_down,
                                color: isPositive ? Colors.green : Colors.red,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${isPositive ? '+' : ''}${stock.change.toStringAsFixed(2)} (${isPositive ? '+' : ''}${stock.changePercent.toStringAsFixed(2)}%)',
                                style: TextStyle(
                                  color: isPositive ? Colors.green : Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Información adicional
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          'Sector',
                          stock.sector,
                          Icons.business,
                        ),
                      ),
                      Expanded(
                        child: _buildInfoItem(
                          'P/E',
                          stock.peRatio.toStringAsFixed(1),
                          Icons.analytics,
                        ),
                      ),
                      Expanded(
                        child: _buildInfoItem(
                          'Div Yield',
                          '${stock.dividendYield.toStringAsFixed(2)}%',
                          Icons.attach_money,
                        ),
                      ),
                    ],
                  ),

                  if (isExpanded) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.psychology,
                                color: Colors.blue.withOpacity(0.8),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Análisis IA',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            stock.aiAnalysis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getRecommendationColor(
                                      stock.recommendation),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  stock.recommendation,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'Target: \$${stock.targetPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(
          begin: 0.3,
          duration: 600.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.6),
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Roboto',
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
            fontFamily: 'Roboto',
          ),
        ),
      ],
    );
  }

  Color _getRecommendationColor(String recommendation) {
    switch (recommendation.toUpperCase()) {
      case 'COMPRAR':
        return Colors.green.withOpacity(0.8);
      case 'MANTENER':
        return Colors.orange.withOpacity(0.8);
      case 'VENDER':
        return Colors.red.withOpacity(0.8);
      default:
        return Colors.grey.withOpacity(0.8);
    }
  }
}
