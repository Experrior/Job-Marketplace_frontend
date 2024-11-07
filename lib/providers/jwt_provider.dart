import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JwtProvider extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String _jwtToken = '';

  JwtProvider() {
    _initializeJwt();
  }

  Future<void> _initializeJwt() async {
    final token = await _storage.read(key: 'JWT');
    if (token != null) {
      _jwtToken = token;
    }
    notifyListeners(); // Notify listeners when the token changes
  }

  String get jwtToken => _jwtToken;

  Future<void> setJwtToken(String token) async {
    await _storage.write(key: 'JWT', value: token);
    _jwtToken = token;
    notifyListeners();
  }

  Future<void> removeJwtToken() async {
    await _storage.delete(key: 'jwtToken');
    _jwtToken = '';
    notifyListeners();
  }
}