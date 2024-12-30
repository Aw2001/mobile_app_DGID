import 'dart:convert';
import 'package:http/http.dart' as http;

class DepartementService {
  static const String _baseUrl =
      'http://10.0.2.2:8081/api/departements/byRegion';

  // Méthode pour récupérer les departements
  Future<List<String>> listerDepartements(String? regionName) async {
    try {
      // Construire l'URL avec le paramètre de requête
      final String url = '$_baseUrl?regionName=$regionName';

      // Envoyer la requête GET
      final response = await http.get(Uri.parse(url));

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
