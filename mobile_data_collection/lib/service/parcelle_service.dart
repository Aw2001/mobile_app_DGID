import 'package:dio/dio.dart';
import 'package:mobile_data_collection/service/dio_client.dart';
import '../utils/constants.dart';

class ParcelleService {
  final Dio _dio = DioClient().dio;

  // Méthode pour récupérer les parcelles
  Future<List<String>> listerParcelles(String? sectionNumSec, String? region, String? nomDepart, String? nomCommun) async {
    try {
    
      // Envoyer la requête GET
      final response = await _dio.get("http://$ip:8081/api/parcelles/bySection?sectionNumSec=$sectionNumSec&region=$region&nomDepart=$nomDepart&nomCommun=$nomCommun");

      // Vérifier le statut de la réponse
      if (response.statusCode == 200) {
        // Décoder la réponse JSON (liste de chaînes)
        final List<dynamic> jsonData = (response.data);
        return jsonData.cast<String>();
      } else {
        throw Exception('Erreur lors du chargement des parcelles');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }
}
