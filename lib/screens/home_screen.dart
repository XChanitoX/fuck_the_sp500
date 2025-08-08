import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'ranking_screen.dart';
import 'bubble_screen.dart';
import 'portfolio_list_screen.dart';
import 'chatbot_screen.dart';
import 'learning_screen.dart';
import 'public_portfolios_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 12),
                _buildQuickActions(context),
                const SizedBox(height: 16),
                Expanded(child: _buildSections(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
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
          child: const Icon(Icons.dashboard_customize,
              color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Inicio',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, duration: 600.ms);
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickAction(
            icon: Icons.trending_up,
            label: 'Ranking',
            gradient: const [Colors.blueAccent, Colors.purpleAccent],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RankingScreen()),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickAction(
            icon: Icons.bubble_chart_outlined,
            label: 'Burbujas',
            gradient: const [Colors.green, Colors.teal],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BubbleScreen()),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickAction(
            icon: Icons.workspaces_outline,
            label: 'Portafolios',
            gradient: const [Colors.orange, Colors.redAccent],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PortfolioListScreen()),
            ),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 700.ms, delay: 100.ms)
        .slideY(begin: -0.1, duration: 700.ms);
  }

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(colors: [
            gradient[0].withOpacity(0.15),
            gradient[1].withOpacity(0.10),
          ]),
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.75), fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: Colors.white54, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildSections(BuildContext context) {
    return ListView(
      children: [
        _tile(
          context,
          icon: Icons.chat_bubble_outline,
          title: 'Chatbot IA',
          subtitle: 'Asistente para dudas financieras y análisis',
          gradient: [Colors.indigo, Colors.blueAccent],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatbotScreen()),
            );
          },
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.1, duration: 600.ms),
        const SizedBox(height: 12),
        _tile(
          context,
          icon: Icons.school_outlined,
          title: 'Aprendizaje',
          subtitle: 'Desde conceptos básicos hasta análisis avanzado',
          gradient: [Colors.green, Colors.teal],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LearningScreen()),
            );
          },
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 50.ms)
            .slideY(begin: 0.1, duration: 600.ms),
        const SizedBox(height: 12),
        _tile(
          context,
          icon: Icons.leaderboard_outlined,
          title: 'Ranking de Acciones',
          subtitle: 'Explora y analiza el ranking en tiempo real',
          gradient: [Colors.blue, Colors.purpleAccent],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RankingScreen()),
            );
          },
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 100.ms)
            .slideY(begin: 0.1, duration: 600.ms),
        const SizedBox(height: 12),
        _tile(
          context,
          icon: Icons.bubble_chart_outlined,
          title: 'Burbujas',
          subtitle: 'Visualiza subidas y bajadas con física interactiva',
          gradient: [Colors.redAccent, Colors.orange],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BubbleScreen()),
            );
          },
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 150.ms)
            .slideY(begin: 0.1, duration: 600.ms),
        const SizedBox(height: 12),
        _tile(
          context,
          icon: Icons.workspaces_outline,
          title: 'Portafolios',
          subtitle: 'Copia portafolios temáticos con rendimiento histórico',
          gradient: [Colors.orange, Colors.redAccent],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PublicPortfoliosScreen()),
            );
          },
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 200.ms)
            .slideY(begin: 0.1, duration: 600.ms),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(colors: [
            gradient[0].withOpacity(0.25),
            gradient[1].withOpacity(0.2),
          ]),
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(label,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
