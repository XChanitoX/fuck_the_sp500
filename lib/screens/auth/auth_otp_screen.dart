import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../router/app_router.dart';
import '../../services/auth_service.dart';

class AuthOtpScreen extends StatefulWidget {
  const AuthOtpScreen({super.key});

  @override
  State<AuthOtpScreen> createState() => _AuthOtpScreenState();
}

class _AuthOtpScreenState extends State<AuthOtpScreen> {
  final _emailCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  late final AuthService _auth;
  bool _sent = false;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _auth = AuthService('https://finance-ed-server-dev.anquisbarr.workers.dev');
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
  void dispose() {
    _emailCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final email = _emailCtrl.text.trim();
      if (email.isEmpty || !email.contains('@')) {
        setState(() => _error = 'Email inválido');
      } else {
        debugPrint('[AuthOtpScreen] sendCode -> $email');
        await _auth.sendEmailOtp(email, type: 'sign-in');
        debugPrint('[AuthOtpScreen] sendCode <- OK');
        setState(() => _sent = true);
      }
    } catch (e) {
      debugPrint('[AuthOtpScreen] sendCode error: $e');
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _verify() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final email = _emailCtrl.text.trim();
      final otp = _otpCtrl.text.trim();
      // Basic OTP validation
      if (otp.isEmpty || otp.length < 4) {
        setState(() => _error = 'Código inválido');
        return;
      }
      debugPrint('[AuthOtpScreen] verify -> email=$email otp=$otp');
      await _auth.signInWithEmailOtp(email, otp);
      final sessionRes = await _auth.getSession();
      debugPrint('[AuthOtpScreen] getSession after OTP: $sessionRes');
      if (!_hasActiveSession(sessionRes)) {
        throw Exception('No active session after OTP sign-in');
      }
      if (!mounted) return;
      // Refresh auth state and navigate
      final container = ProviderScope.containerOf(context);
      container.invalidate(authStateProvider);
      context.go('/home');
    } catch (e) {
      debugPrint('[AuthOtpScreen] verify error: $e');
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ingresar con código (OTP)')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.mail_outline),
              ),
            ),
            const SizedBox(height: 12),
            if (_sent)
              TextField(
                controller: _otpCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Código recibido',
                  prefixIcon: Icon(Icons.verified_outlined),
                ),
              ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.redAccent)),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _loading ? null : (_sent ? _verify : _sendCode),
                    child:
                        _loading
                            ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : Text(_sent ? 'Verificar' : 'Enviar código'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
