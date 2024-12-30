import 'package:flutter/material.dart';
import '../../service/bien_service.dart'; // Importez votre classe BienService.

class SendButton extends StatelessWidget {
  final Function(BienService) onpressed; // Référence à la méthode ajouterBien.
  final String apiUrl; // URL de l'API.

  const SendButton({Key? key, required this.onpressed, required this.apiUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(
            onPressed: () async {
              print("Bouton cliqué");
              // Créez une instance de BienService.
              BienService bienService = BienService(apiUrl);

              // Appelez la méthode ajouterBien via le callback onPressed.
              onpressed(bienService);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC3AD65),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(5), // Définir le rayon des bords
              ),
            ),
            child: const Text(
              'Valider',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ));
  }
}
