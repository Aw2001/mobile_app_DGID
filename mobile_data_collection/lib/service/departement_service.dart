import 'package:dio/dio.dart';
import 'package:mobile_data_collection/service/dio_client.dart';
import '../utils/constants.dart';

class DepartementService {
  final Dio _dio = DioClient().dio;

  // Méthode pour récupérer les departements
  Future<List<String>> listerDepartements(String? regionName) async {
    try {

      // Construire l'URL avec le paramètre de requête
      final response = await _dio.get("http://teranga-gestion.kheush.xyz:8081/api/departements/byRegion?regionName=$regionName");
     
      // Vérifier le statut de la réponse
      if (response.statusCode == 200) {
        // Décoder la réponse JSON (liste de chaînes)
        final List<dynamic> jsonData = response.data;
        return jsonData.cast<String>();
      } else {
        throw Exception('Erreur lors du chargement des départements');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }
}
