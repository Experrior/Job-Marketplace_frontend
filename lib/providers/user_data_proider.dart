import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserDataProvider extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
//todo refactor, to specified methods for each field, for better control

  Future<void> store(String key, String value) async {
    await _storage.write(key: key, value: value);
    notifyListeners();
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

}