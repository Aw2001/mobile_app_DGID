import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  // Instance de FlutterSecureStorage
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Méthode pour stocker des données
  static Future<void> writeData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // Méthode pour lire des données
  static Future<String?> readData(String key) async {
    return await _storage.read(key: key);
  }

  // Méthode pour supprimer des données
  static Future<void> deleteData(String key) async {
    await _storage.delete(key: key);
  }
}
