import 'package:dio/dio.dart';
import 'package:mobile_data_collection/service/dio_client.dart';

import '../utils/constants.dart';

class SectionService {
  final Dio _dio = DioClient().dio;

  // Méthode pour récupérer les sections
  Future<List<String>> listerSections(String? communeName) async {
    try {

      // Envoyer la requête GET
      final response = await _dio.get("http://$ip:8081/api/sections/byCommune?communeName=$communeName")
;
      // Vérifier le statut de la réponse
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        return jsonData.cast<String>();
      } else {
        throw Exception('Erreur lors du chargement des sections');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }
}
