import 'package:flutter/material.dart';
import '../models/portfolio.dart';
import '../services/portfolio_service.dart';
import 'portfolio_detail_screen.dart';

class PortfolioListScreen extends StatefulWidget {
  const PortfolioListScreen({super.key});

  @override
  State<PortfolioListScreen> createState() => _PortfolioListScreenState();
}

class _PortfolioListScreenState extends State<PortfolioListScreen> {
  List<Portfolio> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final items = await PortfolioService.getPortfolios();
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  Future<void> _createPortfolio() async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF121212),
        title: const Text('Nuevo Portafolio',
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Nombre',
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white24),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              final id = 'p_${DateTime.now().microsecondsSinceEpoch}';
              final p = Portfolio(
                id: id,
                name: name,
                ownerUserId: 'local',
                createdAt: DateTime.now(),
              );
              await PortfolioService.upsertPortfolio(p);
              if (ctx.mounted) Navigator.pop(ctx);
              if (!mounted) return;
              await _load();
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePortfolio(Portfolio p) async {
    await PortfolioService.deletePortfolio(p.id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portafolios'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createPortfolio,
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? const Center(
                  child: Text('Crea tu primer portafolio'),
                )
              : ListView.separated(
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final p = _items[index];
                    return ListTile(
                      title: Text(p.name),
                      subtitle: Text('Creado: ${p.createdAt.toLocal()}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _deletePortfolio(p),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PortfolioDetailScreen(portfolio: p),
                          ),
                        ).then((_) => _load());
                      },
                    );
                  },
                ),
    );
  }
}
