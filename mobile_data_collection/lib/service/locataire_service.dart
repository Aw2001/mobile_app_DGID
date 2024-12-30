import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_data_collection/model/locataire.dart';

class LocataireService {
  String baseUrl;
  LocataireService(this.baseUrl);

  Future<void> ajouterLocataire(String? matricule, Locataire locataire) async {
    final url = Uri.parse('$baseUrl/add?matricule=$matricule');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(locataire.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur serveur : ${response.body}");
    }
  }

  Future<void> mettreAJourLocataire(Locataire locataire) async {
    final url = Uri.parse('$baseUrl/update');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(locataire.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur serveur : ${response.body}");
    }
  }

  Future<int?> retournerLocataire(String? id) async {
    // Vérifiez que l'ID n'est pas nul
    if (id == null) {
      throw Exception('L\'ID du locataire ne peut pas être nul');
    }
    final url = Uri.parse('$baseUrl/research/$id');
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return 0;
        } else {
          return 1;
        }
      } else {
        return -1;
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération du locataire: $e');
    }
  }
}
