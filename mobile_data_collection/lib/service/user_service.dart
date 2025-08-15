import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_data_collection/model/user_dto.dart';
import 'package:mobile_data_collection/service/dio_client.dart';
import 'package:mobile_data_collection/service/storage_service.dart';
import 'package:mobile_data_collection/utils/constants.dart';
import 'dart:convert';

class UserService {
  final Dio _dio = DioClient().dio;
  UserService();
  

   Future<UserDto?> retournerUtilisateur(String? username) async {
    // Vérifiez que l'username n'est pas nul
    if (username == null) {
      throw Exception('L\'username ne peut pas être nul');
    }
    
    try {

      // Envoi de la requête HTTP
      final response = await _dio.get('http://$ip:8081/api/utilisateurs/$username');

      // Vérifiez si la réponse du serveur est réussie
      if (response.statusCode == 200) {
        if (response.data == null || response.data.toString().isEmpty){
          return null; // Aucune donnée dans la réponse
        } else {
          
          UserDto user = UserDto.fromJson(response.data);
          return user;
        }
      } else {
        throw Exception('Erreur serveur : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'utilisateur: $e');
    }
  }

  Future<String> retourneInitial(String username) async {
    
    try {
      
      // Envoi de la requête HTTP
      final response = await _dio.get('http://$ip:8081/api/utilisateurs/initial/$username');
       if (response.statusCode == 200) {
        final fullName = response.data?.toString() ?? "";
        if (fullName.isEmpty) {
           print("aucune reponse");
           return '';
        } else {
        
          // Séparation de la chaîne en mots
          List<String> nameParts = fullName.split(','); 
          List<String> firstNameParts = nameParts[0].split(' ');
          List<String> secondNameParts = nameParts[1].split(' ');
          String firstInitial = firstNameParts[0][0];
          String secondInitial = secondNameParts[0][0];
          
          String initial = firstInitial + secondInitial; 
          return initial;        
          
        }
      } else {
        throw Exception('Erreur serveur : ${response.statusCode}');
      }
      
    } catch (e) {
      print("Erreur : $e");
      return '';
    }
  }
  Future<int> logout(String email) async {
    try{
      final response = await _dio.post(
        "http://$ip:8081/auth/logout?email=$email",
      );
      if (response.statusCode == 200) {
        return 1;
      } else{
        throw Exception('Erreur serveur : ${response.statusCode}');
      }
    } catch (e) {
      print("Erreur : $e");
      return 2;
    }
  }

  Future<String> getEmailByUsername(String username) async {
    try {
      final response = await _dio.get('http://$ip:8081/api/utilisateurs/getEmail/$username');
      if (response.statusCode == 200) {
        return response.data?.toString() ?? '';
      } else {
        throw Exception('Erreur serveur : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'email: $e');
    }
  }

  Future<bool> login(String username, String password) async {
  try {
    final response = await http.post(
      Uri.parse("http://$ip:8081/auth/login"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
        'platform': 'MOBILE'
      })
    );
    
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      String token = jsonData['token'];
      await StorageService.writeData('jwt_token', token);
      return true;
    }
    return false;
  } catch (e) {
    print("Erreur login: $e");
    throw Exception('Erreur lors de la connexion');
  }
}
}
