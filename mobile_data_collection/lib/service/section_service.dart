import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_data_collection/service/storage_service.dart';

class SectionService {
  static const String _baseUrl = 'http://10.0.2.2:8081/api/sections/byCommune';

  // Méthode pour récupérer les sections
  Future<List<String>> listerSections(String? communeName) async {
    try {
      // Construire l'URL avec le paramètre de requête
      final String url = '$_baseUrl?communeName=$communeName';

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
        },);

      // Vérifier le statut de la réponse
      if (response.statusCode == 200) {
        // Décoder la réponse JSON (liste de chaînes)
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.cast<String>();
      } else {
        throw Exception('Erreur lors du chargement des sections');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }
}
