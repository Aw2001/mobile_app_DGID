import 'package:dio/dio.dart';
import 'package:mobile_data_collection/model/proprietaire.dart';
import 'package:mobile_data_collection/service/dio_client.dart';
import 'package:mobile_data_collection/utils/constants.dart';

class ProprietaireService {
  final Dio _dio = DioClient().dio;
  ProprietaireService();

  Future<void> ajouterProprietaire(Proprietaire proprietaire) async {

    final response = await _dio.post(
        "http://teranga-gestion.kheush.xyz:8081/api/proprietaires/add",
        data: proprietaire.toJson(),  // Le corps de la requête
      );
    if (response.statusCode != 200) {
      throw Exception("Erreur serveur : ${response.data}");
    }
  }

  Future<void> mettreAJourProprietaire(Proprietaire proprietaire) async {
  
    final response = await _dio.put(
        "http://teranga-gestion.kheush.xyz:8081/api/proprietaires/update",
        data: proprietaire.toJson(),  // Le corps de la requête
      );
    if (response.statusCode != 200) {
      throw Exception("Erreur serveur : ${response.data}");
    }
  }

  Future<int?> retournerProprietaire(String? id) async {
    // Vérifiez que l'ID n'est pas nul
    if (id == null) {
      throw Exception('L\'ID du proprietaire ne peut pas être nul');
    }
    
    try {
      final response = await _dio.get("http://teranga-gestion.kheush.xyz:8081/api/proprietaires/research/$id");
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
      // Attraper toute autre exception, comme une erreur de réseau

      throw Exception('Erreur lors de la récupération du propriétaire: $e');
    }
  }
}
