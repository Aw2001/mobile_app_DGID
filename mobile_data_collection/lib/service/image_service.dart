import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImageService {
  static const String _baseUrl = 'http://192.168.1.7:8081/api/images';

  Future<void> ajouterImage(String? identifiantBien, List<XFile> files) async {
    for (XFile xfile in files) {
      try {
        //Convertir XFile en File
        File file = File(xfile.path);
        if (file.existsSync() && file.lengthSync() > 0) {
          // Construire l'URL avec l'identifiant du bien
          final url = Uri.parse('$_baseUrl/add/$identifiantBien');

          // Créer une requête multipart
          final request = http.MultipartRequest('POST', url);

          // Ajouter le fichier dans le champ "file"
          request.files.add(
            await http.MultipartFile.fromPath(
              'file', // Ce nom doit correspondre au nom attendu par votre backend
              file.path,
            ),
          );
          // Envoyer la requête
          final response = await request.send();

          // Vérifier le statut de la réponse
          if (response.statusCode == 200) {
            print('Image ajoutée avec succès.');
          } else {
            final responseBody = await response.stream.bytesToString();
            throw Exception('Erreur serveur : $responseBody');
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
