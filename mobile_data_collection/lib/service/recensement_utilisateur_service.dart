import 'package:dio/dio.dart';
import 'package:mobile_data_collection/model/recensement.dart';
import 'package:mobile_data_collection/service/dio_client.dart';
import '../utils/constants.dart';

class RecensementUtilisateurService {
  
  final Dio _dio = DioClient().dio;

  // Méthode pour récupérer les communes
  Future<List<Recensement>> listerRecensementsUtilisateurActifs(String email) async {

      try{

        // Envoyer la requête GET
        final response = await _dio.get("http://$ip:8081/api/recensementUtilisateurs/all/$email");

        // Vérifier le statut de la réponse
        if (response.statusCode == 200) {
          // Décoder la réponse JSON (liste de chaînes)
          final List<dynamic> jsonData = response.data;
          return jsonData
              .map((data) => Recensement.fromJson(data as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('Erreur lors du chargement des recensements');
        }
        
      } catch (e) {
        throw Exception('Erreur lors de la récupération des recensements: $e');
      }
      
  }
}