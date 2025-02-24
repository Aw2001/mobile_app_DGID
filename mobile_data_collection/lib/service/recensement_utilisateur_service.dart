
import 'package:mobile_data_collection/model/recensement.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_data_collection/service/storage_service.dart';

class RecensementUtilisateurService {
  
  static const String _baseUrl =
      'http://10.0.2.2:8081/api/recensementUtilisateurs/all';

  // Méthode pour récupérer les communes
  Future<List<Recensement>> listerRecensementsUtilisateurActifs(String email) async {

    try {
      // Récupérer le token depuis le stockage sécurisé
      final String? token = await StorageService.readData('jwt_token');

      if (token == null) {
        throw Exception('Token introuvable, veuillez vous reconnecter.');
      }
      
      // Construire l'URL avec le paramètre de requête
      final String url = '$_baseUrl/$email';

      // Envoyer la requête GET
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token', // Ajouter le token dans les headers
          'Content-Type': 'application/json',
        },
      );

      // Vérifier le statut de la réponse
      if (response.statusCode == 200) {
        print("Réponse brute : ${response.body}");
        // Décoder la réponse JSON (liste de chaînes)
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData
            .map((data) => Recensement.fromJson(data as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Erreur lors du chargement des recensements');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }
}