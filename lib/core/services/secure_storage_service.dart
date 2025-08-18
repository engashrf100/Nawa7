import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  Future<void> write(String key, Map<String, dynamic> value) async {
    final jsonString = jsonEncode(value);
    await _storage.write(key: key, value: jsonString);
  }

  Future<Map<String, dynamic>?> read(String key) async {
    final jsonString = await _storage.read(key: key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}
