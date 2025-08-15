import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_data_collection/model/locataire.dart';
import 'package:mobile_data_collection/service/dio_client.dart';
import 'package:mobile_data_collection/service/storage_service.dart';
import 'package:mobile_data_collection/utils/constants.dart';

class LocataireService {
  final Dio _dio = DioClient().dio;
  LocataireService();

  Future<void> ajouterLocataire(String? matricule, Locataire locataire) async {

    final response = await _dio.post(
      "http://$ip:8081/api/locataires/add?matricule=$matricule",
      data: locataire.toJson(),  // Le corps de la requête
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur serveur : ${response.data}");
    }
  }

  Future<void> mettreAJourLocataire(Locataire locataire) async {
     final response = await _dio.post(
      "http://$ip:8081/api/locataires/update",
      data: locataire.toJson(),  // Le corps de la requête
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur serveur : ${response.data}");
    }
  }

  Future<int?> retournerLocataire(String? id) async {
    // Vérifiez que l'ID n'est pas nul
    if (id == null) {
      throw Exception('L\'ID du locataire ne peut pas être nul');
    }
    try {
      
      final response = await _dio.get("http://$ip:8081/api/locataires/research/$id");
      if (response.statusCode == 200) {
        if (response.data == null || response.data.toString().isEmpty) {
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
