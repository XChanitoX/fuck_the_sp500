import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/home_screen.dart';
import '../screens/auth/auth_screen.dart';
import '../services/auth_service.dart';

// Base URL for the Better Auth backend
const String kApiBase = 'https://finance-ed-server-dev.anquisbarr.workers.dev';

// Provide a singleton AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(kApiBase);
});

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

// Async auth state. Resolves to true if there is an active session.
final authStateProvider = FutureProvider<bool>((ref) async {
  final auth = ref.read(authServiceProvider);
  debugPrint('[Router] Checking session on startup...');
  try {
    final res = await auth.getSession();
    final ok = _hasActiveSession(res);
    debugPrint('[Router] get-session -> ${ok ? 'AUTHED' : 'NOT AUTHED'}');
    return ok;
  } catch (e) {
    debugPrint('[Router] get-session error: $e');
    return false;
  }
});

// GoRouter configured with Riverpod
final routerProvider = Provider<GoRouter>((ref) {
  final authAsync = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const _Splash()),
      GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    ],
    redirect: (context, state) {
      final atAuth = state.matchedLocation == '/auth';
      final atSplash = state.matchedLocation == '/splash';

      if (authAsync.isLoading) return atSplash ? null : '/splash';
      if (authAsync.hasError) return atAuth ? null : '/auth';
      final isAuthed = authAsync.value ?? false;
      debugPrint(
        '[Router] redirect: ${state.matchedLocation} -> authed=$isAuthed',
      );
      if (isAuthed) {
        return atAuth || atSplash ? '/home' : null;
      } else {
        return atAuth ? null : '/auth';
      }
    },
  );
});

class _Splash extends StatelessWidget {
  const _Splash();
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          height: 28,
          width: 28,
          child: CircularProgressIndicator(strokeWidth: 3),
        ),
      ),
    );
  }
}
