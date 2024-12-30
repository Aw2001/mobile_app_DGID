import 'dart:convert';

import 'package:mobile_data_collection/model/proprietaire.dart';
import 'package:http/http.dart' as http;

class ProprietaireService {
  String baseUrl;
  ProprietaireService(this.baseUrl);

  Future<void> ajouterProprietaire(Proprietaire proprietaire) async {
    final url = Uri.parse('$baseUrl/add');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(proprietaire.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception("Erreur serveur : ${response.body}");
    }
  }

  Future<void> mettreAJourProprietaire(Proprietaire proprietaire) async {
    final url = Uri.parse('$baseUrl/update');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(proprietaire.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception("Erreur serveur : ${response.body}");
    }
  }

  Future<int?> retournerProprietaire(String? id) async {
    // Vérifiez que l'ID n'est pas nul
    if (id == null) {
      throw Exception('L\'ID du proprietaire ne peut pas être nul');
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
      // Attraper toute autre exception, comme une erreur de réseau

      throw Exception('Erreur lors de la récupération du propriétaire: $e');
    }
  }
}
