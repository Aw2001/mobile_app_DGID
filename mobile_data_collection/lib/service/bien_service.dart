import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_data_collection/model/bien.dart';

class BienService {
  String baseUrl;

  BienService(this.baseUrl);

  Future<void> ajouterBien(String? recensementId, Bien bien) async {
    final url = Uri.parse('$baseUrl/add?recensementId=$recensementId');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bien.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur serveur : ${response.body}");
    }
  }

  Future<Bien?> mettreAJourBien(String? recensementId, Bien bien) async {
    final url = Uri.parse('$baseUrl/update?recensementId=$recensementId');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bien.toJson()),
    );

    if (response.statusCode == 200) {
      return Bien.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update Bien');
    }
  }

  Future<int?> retournerBien(String? id) async {
    // Vérifiez que l'ID n'est pas nul
    if (id == null) {
      throw Exception('L\'ID du bien ne peut pas être nul');
    }

    final url = Uri.parse('$baseUrl/research/$id');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        if (response.body == "null") {
          return 0;
        } else {
          return 1;
        }
      } else {
        return -1;
      }
    } catch (e) {
      // Attraper toute autre exception, comme une erreur de réseau

      throw Exception('Erreur lors de la récupération du bien: $e');
    }
  }
}
