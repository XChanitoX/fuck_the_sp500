import 'dart:async';
import 'package:flutter/material.dart';

enum ChatRole { user, assistant }

class ChatMessage {
  final ChatRole role;
  final String text;
  final DateTime createdAt;

  ChatMessage({required this.role, required this.text, DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now();
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isBotTyping = false;

  @override
  void initState() {
    super.initState();
    _seedWelcome();
  }

  void _seedWelcome() {
    _messages.add(
      ChatMessage(
        role: ChatRole.assistant,
        text:
            'Hola, soy tu asistente financiero. Puedo explicarte conceptos de inversión, analizar empresas y ayudarte a construir portafolios. ¿Con qué empezamos?',
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _isBotTyping) return;
    setState(() {
      _messages.add(ChatMessage(role: ChatRole.user, text: text.trim()));
      _inputController.clear();
      _isBotTyping = true;
    });
    _scrollToBottom();

    // Simular respuesta de IA
    await Future.delayed(const Duration(milliseconds: 650));
    final reply = _generateMockResponse(text.trim());

    if (!mounted) return;
    setState(() {
      _messages.add(ChatMessage(role: ChatRole.assistant, text: reply));
      _isBotTyping = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    // Programar después del frame para que la lista ya tenga el nuevo item
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  String _generateMockResponse(String userText) {
    final lower = userText.toLowerCase();
    if (lower.contains('¿qué es la bolsa') ||
        lower.contains('que es la bolsa')) {
      return 'La bolsa es un mercado donde se compran y venden activos financieros (acciones, ETFs, bonos). Permite a empresas financiarse y a inversores participar en su crecimiento.';
    }
    if (lower.startsWith('analiza ') ||
        RegExp(r'^[A-Z]{2,5}\$?').hasMatch(userText)) {
      final symbol = userText.split(' ').last.toUpperCase();
      return 'Análisis rápido de $symbol:\n- Tendencia reciente: estable con ligera volatilidad.\n- Factores clave: crecimiento de ingresos, márgenes saludables.\n- Riesgos: ciclo macro y competencia.\n- Enfoque: diversificación y horizonte de largo plazo.';
    }
    if (lower.contains('diversificar') || lower.contains('riesgo')) {
      return 'Diversificar es repartir la inversión entre sectores, regiones y tipos de activos para reducir riesgo específico. Un ETF amplio (ej. VOO) es un buen punto de partida.';
    }
    if (lower.contains('portafolio') || lower.contains('cartera')) {
      return 'Para construir un portafolio: 1) Define objetivos y horizonte. 2) Elige asignación (ej. 70% índices, 20% bonos, 10% efectivo). 3) Rebalancea periódicamente.';
    }
    return 'Entendido. En breve podré consultar datos en tiempo real y generar análisis más profundos. ¿Quieres una explicación básica o avanzada?';
  }

  void _handleQuickPrompt(String text) {
    _sendMessage(text);
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
              _buildQuickPrompts(),
              const SizedBox(height: 8),
              _buildMessages(),
              _buildInputBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Chatbot IA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    )),
                SizedBox(height: 2),
                Text('Asistente financiero y de aprendizaje',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          if (_isBotTyping)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24, width: 1),
              ),
              child: const Row(
                children: [
                  SizedBox(
                      width: 10,
                      height: 10,
                      child: CircularProgressIndicator(strokeWidth: 2)),
                  SizedBox(width: 6),
                  Text('Escribiendo...',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuickPrompts() {
    final prompts = [
      '¿Qué es la bolsa?',
      'Analiza AAPL',
      'Cómo diversificar mi portafolio',
      '¿Qué es un ETF?',
    ];
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: prompts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final p = prompts[i];
          return GestureDetector(
            onTap: () => _handleQuickPrompt(p),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white.withOpacity(0.06),
                border: Border.all(color: Colors.white24, width: 1),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bolt, size: 16, color: Colors.amber),
                  const SizedBox(width: 6),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 220),
                    child: Text(
                      p,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessages() {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        itemCount: _messages.length + (_isBotTyping ? 1 : 0),
        itemBuilder: (context, index) {
          if (_isBotTyping && index == _messages.length) {
            return _typingBubble();
          }
          final m = _messages[index];
          final isUser = m.role == ChatRole.user;
          return _messageBubble(m.text, isUser);
        },
      ),
    );
  }

  Widget _messageBubble(String text, bool isUser) {
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final gradient = isUser
        ? [Colors.tealAccent.withOpacity(0.8), Colors.teal.withOpacity(0.7)]
        : [
            Colors.blueAccent.withOpacity(0.8),
            Colors.purpleAccent.withOpacity(0.7)
          ];
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(isUser ? 16 : 4),
      bottomRight: Radius.circular(isUser ? 4 : 16),
    );
    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: (isUser ? Colors.teal : Colors.blue).withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: Colors.white12, width: 1),
        ),
        child: Text(
          text,
          style:
              const TextStyle(color: Colors.white, fontSize: 14, height: 1.35),
        ),
      ),
    );
  }

  Widget _typingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dot(),
            const SizedBox(width: 4),
            _dot(delay: 150),
            const SizedBox(width: 4),
            _dot(delay: 300),
          ],
        ),
      ),
    );
  }

  Widget _dot({int delay = 0}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, v, _) => Opacity(
        opacity: v,
        child: Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
      onEnd: () {
        // Loop
        if (!mounted) return;
        setState(() {});
      },
    );
  }

  Widget _buildInputBar() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white24, width: 1),
                ),
                child: TextField(
                  controller: _inputController,
                  style: const TextStyle(color: Colors.white),
                  minLines: 1,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Escribe tu mensaje... (Enter para enviar)',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                  ),
                  textInputAction: TextInputAction.newline,
                  onSubmitted: (v) {
                    // En móviles, onSubmitted se dispara con enter si no hay shift
                    if (v.trim().isNotEmpty) _sendMessage(v);
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _sendMessage(_inputController.text),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Color(0xFF4A90E2),
                    Color(0xFF9B59B6),
                  ]),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
