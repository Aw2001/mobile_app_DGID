import 'package:flutter/material.dart';
import 'package:mobile_data_collection/service/proprietaire_service.dart';

class SendButtonProprietaire extends StatelessWidget {
  final Function(ProprietaireService)
      onPressed; // Référence à la méthode ajouterBien.
  final TextEditingController emailController;
  final String apiUrl; // URL de l'API.

  const SendButtonProprietaire(
      {Key? key,
      required this.onPressed,
      required this.apiUrl,
      required this.emailController})
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
              final email = emailController.text;

              // Validation de l'email
              if (email.isEmpty) {
                _showErrorDialog(context, 'Le champ email est obligatoire.');
                return;
              }

              bool emailValid = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$",
              ).hasMatch(email);

              if (!emailValid) {
                _showErrorDialog(
                    context, 'Veuillez saisir une adresse email valide.');
                return;
              }

              // Créez une instance de BienService.
              ProprietaireService proprietaireService =
                  ProprietaireService(apiUrl);

              // Appelez la méthode ajouterBien via le callback onPressed.
              onPressed(proprietaireService);
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

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Erreur'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
