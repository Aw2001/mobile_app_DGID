import 'package:flutter/material.dart';
import 'package:mobile_data_collection/model/recensement.dart';
import 'package:mobile_data_collection/screens/formulaire/multi_form_page.dart';

class RecensementCard extends StatelessWidget {
  final bool isBrown;
  final Recensement recensement;

  const RecensementCard({super.key, required this.isBrown, required this.recensement});

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: 'recensement_${recensement.numRecensement}',
        child: GestureDetector(
        onTap: () async{
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  MultiFormPage(recensement: recensement),//on va dans multi stepscreen avec les info du recensement
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
          decoration: BoxDecoration(
            color: isBrown
                ? const Color.fromARGB(255, 67, 61, 55) // Couleur marron
                : Colors.white, // Couleur blanche
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Material(
            type: MaterialType.transparency,
            color: Colors.transparent,
            child: ListTile(
            title: Text(recensement.commentaire,
            style: TextStyle(color: isBrown ? Colors.white : Colors.black,
            fontSize: 14)),
            subtitle: Text('Créé le ${recensement.dateCreation}',
            style: TextStyle(color: isBrown ? Colors.white : Colors.black,
            fontSize: 14)),
            trailing: GestureDetector(
              onTap: () {
                // Affiche un modal bottom sheet
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                           ListTile(
                            leading: const Icon(
                              Icons.remove_circle_outline,
                              color: Colors.red,
                            ),
                            title: const Text(
                              'Supprimer de l\'appareil',
                              style: TextStyle(fontSize: 16),
                            ),
                            onTap: () {
                              // Ajouter l'action ici pour supprimer
                              // Exemple : print('Supprimer action déclenchée');
                            },
                          ),
                          
                          
                        ],
                      ),
                    );
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isBrown
                    ? Colors.white // Fond blanc pour le marron
                    : const Color(0xFFC3AD65), // Background circulaire blanc
                ),
                child: const Icon(
                  Icons.more_vert, // Trois points
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ),
            titleTextStyle: const TextStyle(
              fontSize: 18,
              color: Colors.white, // Couleur de texte blanche
              fontWeight: FontWeight.w500,
            ),
            subtitleTextStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
              color: Colors.white70, // Couleur de texte blanche avec opacité
            ),
          ),
          ),
          
        ),
      )
  );
     
  }
}
