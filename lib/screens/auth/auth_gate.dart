import 'package:flutter/material.dart';
import '../home_screen.dart';
import 'auth_screen.dart';
import '../../services/auth_service.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  Future<bool>? _isAuthenticatedFuture;
  late final AuthService _auth;

  @override
  void initState() {
    super.initState();
    _auth = AuthService('https://finance-ed-server-dev.anquisbarr.workers.dev');
    _isAuthenticatedFuture = _checkSession();
  }

  Future<bool> _checkSession() async {
    try {
      final res = await _auth.getSession();
      return _hasActiveSession(res);
    } catch (_) {
      return false;
    }
  }

  bool _hasActiveSession(dynamic data) {
    if (data is Map) {
      final session = data['session'];
      final user = data['user'];
      if (session != null || user != null) return true;
      final nested = data['data'];
      if (nested is Map &&
          (nested['session'] != null || nested['user'] != null)) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isAuthenticatedFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const _Splash();
        return snapshot.data == true ? const HomeScreen() : const AuthScreen();
      },
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash();
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
            height: 28,
            width: 28,
            child: CircularProgressIndicator(strokeWidth: 3)),
      ),
    );
  }
}
