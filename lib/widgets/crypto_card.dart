import 'package:flutter/material.dart';
import '../models/crypto.dart';

class CryptoCard extends StatelessWidget {
  final CryptoAsset asset;
  final VoidCallback? onTap;

  const CryptoCard({super.key, required this.asset, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isUp = asset.changePercent24h >= 0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.10),
              Colors.white.withOpacity(0.06),
            ],
          ),
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white10,
              backgroundImage:
                  asset.imageUrl.isNotEmpty
                      ? NetworkImage(asset.imageUrl)
                      : null,
              child:
                  asset.imageUrl.isEmpty
                      ? Text(asset.symbol.substring(0, 1))
                      : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          asset.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Roboto',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white24, width: 1),
                        ),
                        child: Text(
                          '#${asset.rank}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    asset.symbol,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${asset.currentPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Roboto',
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isUp ? Icons.trending_up : Icons.trending_down,
                      size: 16,
                      color: isUp ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${isUp ? '+' : ''}${asset.changePercent24h.toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: isUp ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
