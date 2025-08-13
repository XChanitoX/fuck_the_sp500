import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? code;

  ApiException(this.message, {this.statusCode, this.code});

  @override
  String toString() => 'ApiException: $message (${statusCode ?? 'Unknown'})';
}

class AuthHttpClient {
  static const _storage = FlutterSecureStorage();
  static const _cookieKey = 'session_cookies_v1';

  final String baseUrl;
  final http.Client _client = http.Client();
  String? _cookies;

  AuthHttpClient({required this.baseUrl});

  Future<void> initializeCookies() async {
    _cookies = await _storage.read(key: _cookieKey);
    debugPrint(
      '[AuthHttpClient] Loaded cookies: ${_cookies != null ? _cookies!.split(';').first : 'none'}',
    );
  }

  Future<void> _saveCookies(String cookies) async {
    _cookies = cookies;
    await _storage.write(key: _cookieKey, value: cookies);
    debugPrint(
      '[AuthHttpClient] Saved Set-Cookie: ${cookies.split(';').first}',
    );
  }

  Future<void> clearCookies() async {
    _cookies = null;
    await _storage.delete(key: _cookieKey);
  }

  void _updateCookies(http.Response response) {
    final setCookieHeader = response.headers['set-cookie'];
    if (setCookieHeader != null && setCookieHeader.isNotEmpty) {
      // Normalize multiple Set-Cookie headers into a single Cookie header (name=value; ...)
      final RegExp cookiePair = RegExp(r'(?:(?:^|, )\s*)([\w\-.]+)=([^;]+)');
      final Map<String, String> jar = <String, String>{};

      if (_cookies != null && _cookies!.isNotEmpty) {
        for (final part in _cookies!.split(';')) {
          final idx = part.indexOf('=');
          if (idx > 0) {
            final name = part.substring(0, idx).trim();
            final value = part.substring(idx + 1).trim();
            if (name.isNotEmpty) jar[name] = value;
          }
        }
      }

      for (final m in cookiePair.allMatches(setCookieHeader)) {
        final name = m.group(1)?.trim();
        final value = m.group(2)?.trim();
        if (name != null && value != null && name.isNotEmpty) {
          jar[name] = value;
        }
      }

      final normalized = jar.entries
          .map((e) => '${e.key}=${e.value}')
          .join('; ');
      _saveCookies(normalized);
    }
    debugPrint(
      '[AuthHttpClient] ${response.request?.method} ${response.request?.url} -> ${response.statusCode}',
    );
  }

  Map<String, String> _headers([Map<String, String>? extra]) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_cookies != null) headers['Cookie'] = _cookies!;
    if (extra != null) headers.addAll(extra);
    return headers;
  }

  dynamic _handle(http.Response response) {
    _updateCookies(response);
    if (response.statusCode >= 400) {
      String message = 'Request failed';
      String? code;
      try {
        final body = json.decode(response.body);
        message = body['message'] ?? body['error'] ?? message;
        code = body['code'];
      } catch (_) {}
      throw ApiException(message, statusCode: response.statusCode, code: code);
    }
    if (response.body.isEmpty) return null;
    return json.decode(response.body);
  }

  Future<dynamic> get(String path, {Map<String, String>? query}) async {
    await initializeCookies();
    var uri = Uri.parse('$baseUrl$path');
    if (query != null && query.isNotEmpty) {
      uri = uri.replace(queryParameters: {...uri.queryParameters, ...query});
    }
    final res = await _client.get(uri, headers: _headers());
    return _handle(res);
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body}) async {
    await initializeCookies();
    final res = await _client.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers(),
      body: body == null ? null : json.encode(body),
    );
    return _handle(res);
  }

  void dispose() {
    _client.close();
  }
}
