import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_data_collection/model/user_dto.dart';
import 'package:mobile_data_collection/service/storage_service.dart';

class UserService {
  String baseUrl;
  UserService(this.baseUrl);

  
   Future<UserDto?> retournerUtilisateur(String? email) async {
    // Vérifiez que l'email n'est pas nul
    if (email == null) {
      throw Exception('L\'email ne peut pas être nul');
    }

    // Créer l'URL de la requête avec l'email
    final url = Uri.parse('$baseUrl/$email');
    
    try {
      // Récupérer le token JWT depuis le stockage local
      final String? token = await StorageService.readData('jwt_token');

      // Vérifiez si le token est null
      if (token == null) {
        throw Exception('Token introuvable, veuillez vous reconnecter.');
      }

      // Envoi de la requête HTTP
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Vérifiez si la réponse du serveur est réussie
      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return null; // Aucune donnée dans la réponse
        } else {
          // Convertir la réponse JSON en un objet UserDto
          var data = jsonDecode(response.body);
          UserDto user = UserDto.fromJson(data); // Assurez-vous que la méthode fromJson existe dans UserDto
          return user;
        }
      } else {
        throw Exception('Erreur serveur : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'utilisateur: $e');
    }
  }
}
