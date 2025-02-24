
import 'package:mobile_data_collection/model/recensement.dart';
import 'package:mobile_data_collection/screens/formulaire/custom_form_field.dart';
import 'package:mobile_data_collection/screens/formulaire/expansion_panel_bienn.dart';
import 'package:mobile_data_collection/screens/formulaire/expansion_panel_locataire.dart';
import 'package:mobile_data_collection/screens/formulaire/expansion_panel_proprietaire.dart';
import 'package:mobile_data_collection/screens/formulaire/field_bienn.dart';
import 'package:mobile_data_collection/screens/formulaire/field_locataire.dart';
import 'package:mobile_data_collection/screens/formulaire/field_proprietaire.dart';
import 'package:mobile_data_collection/screens/home_screen/navbar_screen.dart';
import 'package:mobile_data_collection/screens/welcome_screen.dart';
import 'package:mobile_data_collection/service/proprietaire_service.dart';
import 'package:mobile_data_collection/utils/constants.dart';
import 'package:mobile_data_collection/utils/exports.dart';
import 'package:mobile_data_collection/utils/extensions.dart';

class MultiFormPage extends StatefulWidget {
  final Recensement recensement;
  const MultiFormPage({super.key, required this.recensement, });

  @override
  State<MultiFormPage> createState() => _MultiFormPageState();

}

  class _MultiFormPageState extends State<MultiFormPage> {
    final _formKeys = [
      GlobalKey<FormState>(),
      GlobalKey<FormState>(),
      GlobalKey<FormState>(),
    ];

    int nbItemsForBien = 1;
    int nbItemsForProprietaire = 1;
    int nbItemsForLocataire = 1;
    int currentStep = 0;
   
    List<Widget> panelsBien = []; // Liste des panneaux ajoutés
    List<Widget> panelsProprietaire = [];
    List<Widget> panelsLocataire = [] ;
    bool get isFirstStep => currentStep == 0;
    bool get isLastStep => currentStep == steps().length - 1;
    
    List<Map<String, TextEditingController>> listOfControllersBien = [];
    List<Map<String, TextEditingController>> listOfControllersProprietaire = [];
    List<Map<String, TextEditingController>> listOfControllers = [{}];
    List<Map<String, TextEditingController>> listOfControllersLocataire = [];
    List<Map<String, String?>> dropdownBien = [];
    List<Map<String, String?>> radioBien = [];
    List<Map<String, String?>> dropdownProprietaire = [];
    List<Map<String, String?>> radioProprietaire = [];
    List<Map<String, String?>> dropdownLocataire = [];
    List<Recensement> recensementId = [];
    final List<Map<String, String>> fieldsBien = [
        {"label": "Identifiant propriétaire", "key": "numIdentifiantProprietaire"},
        {"label": "Région", "key": "region"},
        {"label": "Département", "key": "departement"},
        {"label": "Commune", "key": "commune"},
        {"label": "Section", "key": "section"},
        {"label": "NICAD", "key": "nicad"},
        {"label": "Nom Rue", "key": "nomRue"},
        {"label": "Code Rue", "key": "codeRue"},
        {"label": "Quartier", "key": "quartier"},
        {"label": "Village", "key": "village"},
        {"label": "Type Parcelle", "key": "typeParcelle"},
        {"label": "Identifiant", "key": "identifiant"},
        {"label": "Nom Voirie", "key": "nomVoirie"},
        {"label": "Type Voirie", "key": "typeVoirie"},
        {"label": "Nom Autre Voirie", "key": "nomAutreVoirie"},
        {"label": "Type Lot", "key": "typeLot"},
        {"label": "Localisation Lot", "key": "localisationLot"},
        {"label": "Situation du Lot", "key": "situationLot"},
        {"label": "Numéro Lot", "key": "numeroLot"},
        {"label": "Niveau Lot", "key": "niveauLot"},
        {"label": "Numéro de porte", "key": "numeroPorte"},
        {"label": "Adresse", "key": "adresse"},
        {"label": "Superficie", "key": "superficie"},
        {"label": "Type d'occupation", "key": "typeOccupation"},
        {"label": "Date de délivrance", "key": "dateDelivranceTypeOccupation"},
        {"label": "Usage", "key": "usage"},
        {"label": "Type de construction", "key": "typeConstruction"},
        {"label": "Toiture", "key": "toiture"},
        {"label": "Type de clôture", "key": "typeCloture"},
        {"label": "Etat du clôture", "key": "etatCloture"},
        {"label": "Type de revêtement", "key": "typeRevetement"},
        {"label": "Etat du revêtement", "key": "etatRevetement"},
        {"label": "Situation de la Route", "key": "situationRoute"},
        {"label": "Type de la route", "key": "typeRoute"},
        {"label": "Garage", "key": "garage"},
        {"label": "Qualité portes et fenêtres", "key": "qualitePorteEtFenetre"},
        {"label": "Type de carrelage", "key": "typeCarrelage"},
        {"label": "Menuiserie", "key": "menuiserie"},
        {"label": "Conception des pièces", "key": "conceptionPieces"},
        {"label": "Appareils sanitaires", "key": "appareilsSanitaires"},
        {"label": "Parking intérieur", "key": "parkingInterieur"},
        {"label": "Nombre d'ascenseurs", "key": "nbAscenseurs"},
        {"label": "Nombre de salles de bain", "key": "nbSallesBain"},
        {"label": "Nombre de salles d'eau", "key": "nbSallesEau"},
        {"label": "Nombre de pièces de réception", "key": "nbPieceReception"},
        {"label": "Nombre total de pièces", "key": "nbPiece"},
        {"label": "Nombre étages", "key": "nbEtages"},
        {"label": "Confort", "key": "confort"},
        {
          "label": "Numéro du compteur d'électricité",
          "key": "nbCompteurElectricite"
        },
        {"label": "Numéro titre foncier", "key": "numTitreFoncier"},
        {"label": "Date d'acquisition", "key": "dateAcquisition"},
        {"label": "Valeur locative annuelle", "key": "valeurLocativeAnnuelle"},
        {
          "label": "Valeur locative annuelle saisie",
          "key": "valeurLocativeAnnuelleSaisie"
        },
        {"label": "Valeur locative mensuelle", "key": "valeurLocativeMensuelle"},
        {
          "label": "Valeur locative mensuelle saisie",
          "key": "valeurLocativeMensuelleSaisie"
        },
        {"label": "Commentaire", "key": "commentaire"},
        {"label": "Images du bien", "key": "photos"},
        {"label": "Escaliers de service présents ?", "key": "escalierPrésent"},
        {"label": "Vide ordure présente ?", "key": "videOrdure"},
        {"label": "Monte charge présente ?", "key": "monteCharge"},
        {"label": "Groupe électrogène présent ?", "key": "groupeElectrogene"},
        {"label": "Dépendances isolées présentes ?", "key": "dependanceIsolee"},
        {"label": "Garage souterrain présent ?", "key": "garageSouterrain"},
        {
          "label": "Système de climatisation présent ?",
          "key": "systemeClimatisation"
        },
        {"label": "Système domotique présent ?", "key": "systemeDomotique"},
        {"label": "Balcon présent ?", "key": "presenceBalcon"},
        {"label": "Terrasse présente ?", "key": "presenceTerrasse"},
        {
          "label": "Système de surveillance présent ?",
          "key": "presenceSystemeSurveillance"
        },
        {"label": "Aménagement paysager présent ?", "key": "amenagementPaysager"},
        {"label": "Situé en angle ?", "key": "angle"},
        {"label": "Éclairage public disponible ?", "key": "eclairagePublic"},
        {"label": "Mur en ciment présent ?", "key": "murEnCiment"},
        {
          "label": "Attributs architecturaux présents ?",
          "key": "attributsArchitecturaux"
        },
        {"label": "Trottoir présent ?", "key": "trottoir"},
        {"label": "Propriété en location ?", "key": "proprieteEnLocation"},
        {"label": "Autre type d'occupation ?", "key": "autreOccupation"},
      ];
    final List<Map<String, String>> fieldsProprietaire = [
    {"label": "Prénom", "key": "prenom"},
    {"label": "Nom", "key": "nom"},
    {"label": "Téléphone", "key": "telephone"},
    {"label": "Adresse email", "key": "email"},
    {"label": "Date de naissance", "key": "dateNaissance"},
    {"label": "Lieu de naissance", "key": "lieuNaissance"},
    {"label": "NINEA", "key": "ninea"},
    {"label": "Type d'identification", "key": "typeIdentification"},
    {"label": "Numéro d'identification", "key": "numeroIdentification"},
    {"label": "Date de délivrance", "key": "dateDelivrance"},
    {"label": "Date d'expiration", "key": "dateExpiration"},
    {"label": "Statut", "key": "statut"},
    {"label": "Téléphone du contribuable", "key": "telephoneContribuable"},
    {"label": "Valeur locative mensuelle", "key": "valeurLocativeMensuelle"},
    {"label": "Commentaire", "key": "commentaire"},
    {"label": "Propriétaire rencontré ?", "key": "propRencontre"},
    {"label": "Propriétaire pensionné ?", "key": "propPensionne"},
    {"label": "Propriétaire salarié ?", "key": "propSalarie"},
    {"label": "Posséde t-il d'autres propriétés ?", "key": "dautresProp"},
    {"label": "Est-il enregistré pour la cgf ?", "key": "enregistreCgf"},
  ];
    final List<Map<String, String>> fieldsLocataire = [
    {"label": "Matricule du local", "key": "matricule"},
    {"label": "Dénomination", "key": "denomination"},
    {"label": "Prénom", "key": "prenom"},
    {"label": "Nom", "key": "nom"},
    {"label": "Telephone", "key": "telephone"},
    {"label": "CNI", "key": "cni"},
    {"label": "Activité économique", "key": "activiteEconomique"},
    {"label": "Type occupation", "key": "typeOccupation"},
    {"label": "Date signature contrat", "key": "dateSignatureContrat"},
    {"label": "Loyer annuel ", "key": "loyerAnnuel"},
    {"label": "Nombre de pièces occupées", "key": "nbPieceOccupe"},
    {"label": "Commentaire", "key": "commentaire"},
  ];
    
    bool isComplete = false;

  void ajouterLocal() {
    // Créer un nouvel identifiant unique basé sur le nombre de panels existants
    final newIndex = panelsBien.length;
    final Map<String, TextEditingController> newController = {};
    final Map <String, String?> selectedDropdownValues = {
    'typeParcelle': null,
    'typeVoirie': null,
    'toiture': null,
    'usage': null,
    'typeCloture': null,
    'etatCloture': null,
    'typeCarrelage': null,
    'menuiserie': null,
    'conceptionPieces': null,
    'appareilsSanitaires': null,
    'parkingInterieur': null,
    'confort': null,
    'typeRevetement': null,
    'etatRevetement': null,
    'situationRoute': null,
    'typeRoute': null,
    'garage': null,
    'qualitePorteEtFenetre': null,
    'localisationLot': null,
    'situationLot': null,
    'typeLot': null,
    'region': null,
    'departement': null,
    'commune': null,
    'section': null,
    'nicad': null
  };
    
    final Map<String, String?> selectedRadioValues = {
    'escalierPrésent': null,
    'videOrdure': null,
    'monteCharge': null,
    'groupeElectrogene': null,
    'dependanceIsolee': null,
    'garageSouterrain': null,
    'systemeClimatisation': null,
    'systemeDomotique': null,
    'presenceBalcon': null,
    'presenceTerrasse': null,
    'presenceSystemeSurveillance': null,
    'amenagementPaysager': null,
    'angle': null,
    'eclairagePublic': null,
    'murEnCiment': null,
    'attributsArchitecturaux': null,
    'trottoir': null,
    'proprieteEnLocation': null,
    'autreOccupation': null,
  };

    setState(() {
      // Ajouter un nouveau contrôleur à la liste
     
      listOfControllersBien.add(newController);
      dropdownBien.add(selectedDropdownValues);
      radioBien.add(selectedRadioValues);
      recensementId.add(widget.recensement);
      // Ajouter un nouveau panel
      panelsBien.add(
        Column(
          key: ValueKey(newIndex), // Utilisation d'une clé basée sur newIndex
          children: [
            ExpansionPanelListExampleBien(
              headerValue: 'Informations du local',
              nbItems: nbItemsForBien,
              onDelete: () {
                setState(() {
                  // Supprimer le panel et son contrôleur associé
                  panelsBien.removeWhere((panel) => panel.key == ValueKey(newIndex));
                  listOfControllersBien.removeAt(newIndex);
                  dropdownBien.removeAt(newIndex);
                  radioBien.removeAt(newIndex);
                  nbItemsForBien--;
                });
              },
              recensement: recensementId[newIndex],
              controllers: listOfControllersBien[newIndex], // Associer au contrôleur créé
              dropDownBien: dropdownBien[newIndex],
              radioBien: radioBien[newIndex],
              fieldsBien: fieldsBien,
            ),
          ],
        ),
      );
    });

    print("Panel ajouté avec l'index : $newIndex");
}
  void ajouterProprietaire() {
    // Créer un nouvel identifiant unique basé sur le nombre de panels existants
    final newIndex = panelsProprietaire.length;
    final Map<String, TextEditingController> newController = {};
    final Map<String, String?> selectedDropdownValues = {};
    final Map<String, String?> selectedRadioValues = {};
    setState(() {
      // Ajouter un nouveau contrôleur à la liste
     
      listOfControllersProprietaire.add(newController);
      dropdownProprietaire.add(selectedDropdownValues);
      radioProprietaire.add(selectedRadioValues);

      // Ajouter un nouveau panel
      panelsProprietaire.add(
        Column(
          key: ValueKey(newIndex), // Utilisation d'une clé basée sur newIndex
          children: [
            ExpansionPanelListExampleProprietaire(
              headerValue: 'Informations du propriétaire',
              nbItems: nbItemsForProprietaire,
              onDelete: () {
                setState(() {
                  // Supprimer le panel et son contrôleur associé
                  panelsProprietaire.removeWhere((panel) => panel.key == ValueKey(newIndex));
                  listOfControllersProprietaire.removeAt(newIndex);
                  dropdownProprietaire.removeAt(newIndex);
                  radioProprietaire.removeAt(newIndex);
                  nbItemsForProprietaire--;
                });
              },
              controllers: listOfControllersProprietaire[newIndex], // Associer au contrôleur créé
              dropdownProprietaire: dropdownProprietaire[newIndex],
              radioProprietaire: radioProprietaire[newIndex],
              fields: fieldsProprietaire,
            ),
          ],
        ),
      );
    });

    print("Panel ajouté avec l'index : $newIndex");
}
  void ajouterLocataire() {
    // Créer un nouvel identifiant unique basé sur le nombre de panels existants
    final newIndex = panelsLocataire.length;
    final Map<String, TextEditingController> newController = {};
    final Map<String, String?> selectedDropdownValues = {};
    setState(() {
      // Ajouter un nouveau contrôleur à la liste
     
      listOfControllersLocataire.add(newController);
      dropdownLocataire.add(selectedDropdownValues);

      // Ajouter un nouveau panel
      panelsLocataire.add(
        Column(
          key: ValueKey(newIndex), // Utilisation d'une clé basée sur newIndex
          children: [
            ExpansionPanelListExampleLocataire(
              headerValue: 'Informations du locataire',
              nbItems: nbItemsForLocataire,
              onDelete: () {
                setState(() {
                  // Supprimer le panel et son contrôleur associé
                  panelsLocataire.removeWhere((panel) => panel.key == ValueKey(newIndex));
                  listOfControllersLocataire.removeAt(newIndex);
                  dropdownLocataire.removeAt(newIndex);
                  nbItemsForLocataire--;
                });
              },
              controllers: listOfControllersLocataire[newIndex], // Associer au contrôleur créé
              dropdownLocataire: dropdownLocataire[newIndex],
              fields: fieldsLocataire,
            ),
          ],
        ),
      );
    });

    print("Panel ajouté avec l'index : $newIndex");
}
  void ajouterInfos() {
    final BuildFieldProprietaireState buildFieldProprietaire = BuildFieldProprietaireState();
    final BuildFieldBienState buildFieldBien = BuildFieldBienState();
    final BuildFieldLocataireState buildFieldLocataire = BuildFieldLocataireState();
    
      if (listOfControllersProprietaire.isNotEmpty) {
        int index = 0;
        for (Map<String, TextEditingController> controller in listOfControllersProprietaire) {
          buildFieldProprietaire.ajouterProprietaire(controller, dropdownProprietaire[index], radioProprietaire[index]);
          index++;
        }
      } 
      if (listOfControllersBien.isNotEmpty) {
        int index = 0;
        for (Map<String, TextEditingController> controller in listOfControllersBien) {
          buildFieldBien.ajouterBien(controller, dropdownBien[index], radioBien[index], recensementId[index]);
          index++;
        }
      } 
      if (listOfControllersLocataire.isNotEmpty) {
        int index = 0;
        for (Map<String, TextEditingController> controller in listOfControllersLocataire) {
          buildFieldLocataire.ajouterLocataire(controller, dropdownLocataire[index]);
          index++;
        }
      }
    
    print("ajout terminé");
  }

  @override
  void initState() {
    super.initState();
    // listOfControllersBien.add(controllers);
    // panelsBien.add(
    //     Column(
    //       key: ValueKey(0), // Utilisation d'une clé basée sur newIndex
    //       children: [
    //         ExpansionPanelListExampleBien(
    //           headerValue: 'Informations du local',
    //           nbItems: nbItemsForBien,
    //           onDelete: () {
    //             setState(() {
    //               // Supprimer le panel et son contrôleur associé
    //               panelsBien.removeWhere((panel) => panel.key == ValueKey(0));
    //               listOfControllersBien.removeAt(0);
    //               nbItemsForBien--;
    //             });
    //           },
    //           recensement: widget.recensement,
    //           controllers: listOfControllersBien[0], // Associer au contrôleur créé
    //           fieldsBien: fieldsBien,
    //         ),
    //       ],
    //     ),
    //   );
  } 
  void decrementNbItemsForBien() {
    setState(() {
      if (nbItemsForBien > 0) {
        nbItemsForBien--; // Réduire nbItems seulement si > 0
      }
    });
  }

  void decrementNbItemsForProprietaire() {
    setState(() {
      if (nbItemsForProprietaire > 0) {
        nbItemsForProprietaire--; // Réduire nbItems seulement si > 0
      }
    });
  }

  void decrementNbItemsForLocataire() {
    setState(() {
      if (nbItemsForLocataire > 0) {
        nbItemsForLocataire--; // Réduire nbItems seulement si > 0
      }
    });
  }

  //list of steps
  List<Step> steps() => [
    Step(
      state: currentStep > 0 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 0,
      title: const Text("Proprietaire"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKeys[0],
          child: Column(
            children: [
              if(panelsProprietaire.isNotEmpty)
                ...panelsProprietaire,
              const SizedBox(height: 16.0),
              Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton.extended(
                  heroTag: null,
                  onPressed: () {
                    setState(() {
                      nbItemsForProprietaire++;
                    
                    });
                  ajouterProprietaire();
                  },
                  backgroundColor: Color.fromARGB(255, 148, 92, 34),
                  label: const Text(
                    "Ajouter un propriétaire",
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: Icon(Icons.add, color: Colors.white),
                ),
                ),
            ],
          )
          
        ),
      )
      
    ),
    Step(
      state: currentStep > 1 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 1,
      title: const Text("Local"),
      content: Form(
        key: _formKeys[1],
        child: Column(
          children: [
            if(panelsBien.isNotEmpty)
              ...panelsBien,
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton.extended(
                heroTag: null,
                onPressed: () {
                  setState(() {
                    nbItemsForBien++;
                  
                  });
                  ajouterLocal();
                },
                backgroundColor: Color.fromARGB(255, 148, 92, 34),
                label: const Text(
                  "Ajouter un local",
                  style: TextStyle(color: Colors.white),
                ),
                icon: Icon(Icons.add, color: Colors.white),
              ),
              ),
            
          ],
        ),
      ),
    ),
    Step(
      state: currentStep > 2 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 2,
      title: Text("Locataire"),
      content: SingleChildScrollView(
        child:Form(
        key: _formKeys[2],
        child: Column(
          children: [
            if(panelsLocataire.isNotEmpty)
              ...panelsLocataire,
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton.extended(
                heroTag: null,
                onPressed: () {
                  setState(() {
                    nbItemsForLocataire++;
                  
                  });
                  ajouterLocataire();
                },
                backgroundColor: Color.fromARGB(255, 148, 92, 34),
                label: const Text(
                  "Ajouter un locataire",
                  style: TextStyle(color: Colors.white),
                ),
                icon: Icon(Icons.add, color: Colors.white),
              ),
              ),
          ],
        ),
      ),
      ),
      
    ),
    

  ];

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
        
        backgroundColor: kBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xFF8c6023),
          ),
          onPressed: () {},
        ),
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Recensement",
                style: TextStyle(
                  color: Color(0xFFC3AD65),
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Hero(
        tag: 'recensement_${widget.recensement.numRecensement}',
        child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Color.fromRGBO(195, 173, 101, 1),
            onPrimary: Colors.white,
          ),
        ), 
        child: Scaffold(
          
          body: Stepper(
            type: StepperType.horizontal,
            steps: steps(),
            currentStep: currentStep,
            onStepContinue: (){
              if(_formKeys[currentStep].currentState!.validate()) {
                if(isLastStep) {
                  setState(() => isComplete = true);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                       
                        title: const Text('Confirmation'),
                        content: const Text('Voulez-vous confirmer les informations saisies ?'),
                        actions: [
                          TextButton(
                           
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: const Color.fromRGBO(195, 173, 101, 1), 
                            
                            ),
                            child: const Text('Annuler'),
                            
                          ),
                          TextButton(
                            
                            onPressed: () {
                              Navigator.of(context).pop();
                              ajouterInfos();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: const Color.fromRGBO(195, 173, 101, 1), 
                            
                            ),
                            child: const Text('Confirmer'),
                            
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  setState(() => currentStep += 1);
                  
                }
              } else {
                print("zzzzzzzzzzzzzzz");
              }
              
            },
            onStepCancel: 
              isFirstStep ? null : () => setState(() => currentStep -= 1),
            onStepTapped: (step) => setState(() => currentStep = step),
            controlsBuilder: (context, details) => Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Row(
                children: [
                  if(!isFirstStep) ...[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isFirstStep ? null : details.onStepCancel, 
                        child: const Text('Retour'))
                    ),
                  ],
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: details.onStepContinue, 
                      child: Text (isLastStep ? 'Terminer' : 'Suivant'),
                    ),
                  ),
                  
                ],
              ),
            ),
            )
        ),
        )
        ),
      );
      
      
    }
  }
