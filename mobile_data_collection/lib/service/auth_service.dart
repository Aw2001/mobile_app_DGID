import 'dart:convert';
import 'package:mobile_data_collection/service/storage_service.dart';
import 'package:mobile_data_collection/service/user_service.dart';

class AuthService {
  static final UserService _userService = UserService();

  // Vérifie si l'utilisateur est connecté en vérifiant la présence du token
  static Future<bool> isLoggedIn() async {
    final token = await StorageService.readData('jwt_token');
    return token != null && token.isNotEmpty;
  }

  // Récupère les informations de l'utilisateur stockées
  static Future<Map<String, String>> getUserInfo() async {
    final username = await StorageService.readData('username');
    final email = await StorageService.readData('email');
    final initial = await StorageService.readData('initial');
    
    if (username == null || email == null || initial == null) {
      return {};
    }
    
    return {
      'username': username,
      'email': email,
      'initial': initial,
    };
  }

  // Sauvegarde les informations de l'utilisateur
  static Future<void> saveUserInfo(String username, String email, String initial) async {
    await StorageService.writeData('username', username);
    await StorageService.writeData('email', email);
    await StorageService.writeData('initial', initial);
  }

  // Efface les informations de session
  static Future<void> logout() async {
    await StorageService.deleteData('jwt_token');
    await StorageService.deleteData('username');
    await StorageService.deleteData('email');
    await StorageService.deleteData('initial');
  }
}
