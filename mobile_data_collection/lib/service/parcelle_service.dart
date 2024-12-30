import 'dart:convert';
import 'package:http/http.dart' as http;

class ParcelleService {
  static const String _baseUrl = 'http://10.0.2.2:8081/api/parcelles/bySection';

  // Méthode pour récupérer les parcelles
  Future<List<String>> listerParcelles(String? sectionNumSec) async {
    try {
      // Construire l'URL avec le paramètre de requête
      final String url = '$_baseUrl?sectionNumSec=$sectionNumSec';

      // Envoyer la requête GET
      final response = await http.get(Uri.parse(url));

      // Vérifier le statut de la réponse
      if (response.statusCode == 200) {
        // Décoder la réponse JSON (liste de chaînes)
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.cast<String>();
      } else {
        throw Exception('Erreur lors du chargement des parcelles');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }
}
