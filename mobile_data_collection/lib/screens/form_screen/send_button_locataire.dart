import 'package:flutter/material.dart';
import 'package:mobile_data_collection/service/locataire_service.dart';

class SendButtonLocataire extends StatelessWidget {
  final Function(LocataireService)
      onPressed; // Référence à la méthode ajouterBien.
  final String apiUrl; // URL de l'API.

  const SendButtonLocataire({
    Key? key,
    required this.onPressed,
    required this.apiUrl,
  }) : super(key: key);

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
              LocataireService locataireService = LocataireService(apiUrl);

              // Appelez la méthode ajouterBien via le callback onPressed.
              onPressed(locataireService);
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
