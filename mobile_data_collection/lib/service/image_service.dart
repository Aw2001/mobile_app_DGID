import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mobile_data_collection/service/dio_client.dart';

import '../utils/constants.dart';

class ImageService {
  final Dio _dio = DioClient().dio;
  

  Future<void> ajouterImage(String? identifiantBien, List<XFile> files) async {
    for (XFile xfile in files) {
      try {
        //Convertir XFile en File
        File file = File(xfile.path);
        if (file.existsSync() && file.lengthSync() > 0) {
          

           // Créer FormData pour multipart
          FormData formData = FormData.fromMap({
            'file': await MultipartFile.fromFile(file.path, filename: file.uri.pathSegments.last),
          });
          // Envoyer la requête
          final response = await _dio.post(
            "http://teranga-gestion.kheush.xyz:8081/api/images/add/$identifiantBien",
            data: formData
          );

          // Vérifier le statut de la réponse
          if (response.statusCode == 200) {
            print('Image ajoutée avec succès.');
          } else {
            
            throw Exception('Erreur serveur : ${response.statusCode}');
          }
        } else {
          print("Fichier invalide: ${file.path}");
        }
      } catch (e) {
        print("Erreur lors de l'envoi de l'image: $e");
      }
    }
  }
}
