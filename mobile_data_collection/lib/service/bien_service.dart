import 'package:dio/dio.dart';
import 'package:mobile_data_collection/model/bien.dart';
import 'package:mobile_data_collection/service/dio_client.dart';
import 'package:mobile_data_collection/utils/constants.dart';


class BienService {
  final Dio _dio = DioClient().dio;
  BienService();

  Future<void> ajouterBien(String? recensementId, Bien bien) async {
    
     final response = await _dio.post(
        "http://teranga-gestion.kheush.xyz:8081/api/biens/add?recensementId=$recensementId",
        data: bien.toJson(),  // Le corps de la requête
      );
    
    if (response.statusCode != 200) {
      throw Exception("Erreur serveur : ${response.data}");
    }
  }

  Future<Bien?> mettreAJourBien(String? recensementId, Bien bien) async {
    
    final response = await _dio.put(
        "http://teranga-gestion.kheush.xyz:8081/api/biens/update?recensementId=$recensementId",
        data: bien.toJson(),  // Le corps de la requête
      );

    if (response.statusCode == 200) {
      return Bien.fromJson(response.data);
    } else {
      throw Exception('Failed to update Bien');
    }
  }

  Future<int?> retournerBien(String? id) async {
    // Vérifiez que l'ID n'est pas nul
    if (id == null) {
      throw Exception('L\'ID du bien ne peut pas être nul');
    }
    try {
    
      final response = await _dio.get("http://teranga-gestion.kheush.xyz:8081/api/biens/research/$id");

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

        throw Exception('Erreur lors de la récupération du bien: $e');
    }
  }
}
