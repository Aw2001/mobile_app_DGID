import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_data_collection/service/storage_service.dart';

class DepartementService {
  static const String _baseUrl =
      'http://192.168.1.7:8081/api/departements/byRegion';

  // Méthode pour récupérer les departements
  Future<List<String>> listerDepartements(String? regionName) async {
    try {
      // Construire l'URL avec le paramètre de requête
      final String url = '$_baseUrl?regionName=$regionName';

      // Récupérer le token depuis le stockage sécurisé
      final String? token = await StorageService.readData('jwt_token');

      if (token == null) {
        throw Exception('Token introuvable, veuillez vous reconnecter.');
      }

      // Envoyer la requête GET
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        }
      );

      // Vérifier le statut de la réponse
      if (response.statusCode == 200) {
        // Décoder la réponse JSON (liste de chaînes)
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.cast<String>();
      } else {
        throw Exception('Erreur lors du chargement des départements');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }
}
