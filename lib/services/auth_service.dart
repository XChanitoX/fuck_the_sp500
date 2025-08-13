import 'http_client.dart';

class AuthService {
  final AuthHttpClient _http;
  AuthService(String baseUrl) : _http = AuthHttpClient(baseUrl: baseUrl);

  // Sign up / sign in with password
  Future<dynamic> signUp(String email, String password) async {
    print('[AuthService] signUp -> $email');
    final res = await _http.post('/api/auth/sign-up', body: {
      'email': email,
      'password': password,
    });
    print('[AuthService] signUp <- OK');
    return res;
  }

  Future<dynamic> signIn(String email, String password) async {
    print('[AuthService] signIn -> $email');
    final res = await _http.post('/api/auth/sign-in', body: {
      'email': email,
      'password': password,
    });
    print('[AuthService] signIn <- OK');
    return res;
  }

  // Email OTP
  Future<dynamic> sendEmailOtp(String email, {String type = 'sign-in'}) async {
    print('[AuthService] sendEmailOtp -> $email type=$type');
    try {
      final res = await _http.post('/api/auth/email-otp/send-verification-otp',
          body: {'email': email, 'type': type});
      print(
          '[AuthService] sendEmailOtp <- OK (email-otp/send-verification-otp)');
      return res;
    } on ApiException {
      final res = await _http.post('/api/auth/email/send-verification-otp',
          body: {'email': email, 'type': type});
      print('[AuthService] sendEmailOtp <- OK (email/send-verification-otp)');
      return res;
    }
  }

  Future<dynamic> signInWithEmailOtp(String email, String otp) async {
    print('[AuthService] signInWithEmailOtp -> $email');
    try {
      final res = await _http.post('/api/auth/sign-in/email-otp',
          body: {'email': email, 'otp': otp});
      print('[AuthService] signInWithEmailOtp <- OK (sign-in/email-otp)');
      return res;
    } on ApiException {
      try {
        final res = await _http.post('/api/auth/email-otp/sign-in',
            body: {'email': email, 'otp': otp});
        print('[AuthService] signInWithEmailOtp <- OK (email-otp/sign-in)');
        return res;
      } on ApiException {
        final res = await _http.post('/api/auth/email-otp/verify',
            body: {'email': email, 'otp': otp});
        print('[AuthService] signInWithEmailOtp <- OK (email-otp/verify)');
        return res;
      }
    }
  }

  Future<dynamic> signOut() async {
    try {
      print('[AuthService] signOut ->');
      final res = await _http.post('/api/auth/sign-out');
      print('[AuthService] signOut <- OK');
      return res;
    } finally {
      await _http.clearCookies();
      print('[AuthService] cookies cleared');
    }
  }

  Future<dynamic> getSession() async {
    print('[AuthService] getSession ->');
    try {
      final res = await _http.get('/api/auth/get-session');
      print('[AuthService] getSession <- OK (get-session)');
      return res;
    } on ApiException {
      final res = await _http.get('/api/auth/session');
      print('[AuthService] getSession <- OK (session)');
      return res;
    }
  }
}
