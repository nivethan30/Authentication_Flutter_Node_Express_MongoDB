import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final SecureStorage instance = SecureStorage._();

  SecureStorage._();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> write({required String key, required String value}) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _secureStorage.deleteAll();
  }

  Future<Map<String, String>> readAll() async {
    try {
      return await _secureStorage.readAll();
    } catch (e) {
      return {};
    }
  }
}
