import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_data_collection/model/recensement.dart';
import 'package:mobile_data_collection/screens/formulaire/expansion_panel_bienn.dart';
import 'package:mobile_data_collection/screens/formulaire/expansion_panel_locataire.dart';
import 'package:mobile_data_collection/screens/formulaire/expansion_panel_proprietaire.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Classe pour observer le cycle de vie de l'application
class _AppLifecycleObserver with WidgetsBindingObserver {
  final RecensementProvider provider;

  _AppLifecycleObserver(this.provider);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Sauvegarder les données lorsque l'application est mise en pause ou fermée
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      print('Application mise en pause ou fermée, sauvegarde des données...');
      provider.saveData();
    }
  }
}

class RecensementProvider extends ChangeNotifier {
  Map<String, RecensementData> recensements = {}; // Key = index

  RecensementProvider() {
    initialize(); // Chargement automatique au démarrage
    // Ajouter un écouteur pour sauvegarder les données lors de la mise en pause de l'application
    WidgetsBinding.instance.addObserver(_AppLifecycleObserver(this));
  }
  
  // Méthode pour sauvegarder explicitement les données
  Future<void> saveData() async {
    await _saveRecensementsToPreferences();
  }

  List<Map<String, String>> getAllBienValues(RecensementData recensementData) {
    return recensementData.listOfControllersBien.map((controllers) {
      return controllers.map((key, controller) => MapEntry(key, controller.text));
    }).toList();
  }

  RecensementData getRecensementData(int index, String? numRecensement) {
    // Crée une clé unique à partir de l'index et du numéro de recensement
    final key = '${index}_${numRecensement ?? 'unknown'}';

    if (!recensements.containsKey(key)) {
      recensements[key] = RecensementData(numRecensement: numRecensement);
    }

    return recensements[key]!;
  }

  void addRecensement(int index, String? numRecensement, RecensementData data) {
    final key = '${index}_${numRecensement ?? 'unknown'}';
    recensements[key] = data;
    _saveRecensementsToPreferences();
    notifyListeners();
  }

  void ajouterLocal(RecensementData recensementData, Recensement recensement) {
    final newIndex = recensementData.panelsBien.length;

    // Créer les contrôleurs avec les valeurs sauvegardées si elles existent
    final Map<String, TextEditingController> newController = {};
    final Map<String, String?> selectedDropdownValues = {};
    final Map<String, String?> selectedRadioValues = {};
    
    // Initialiser les contrôleurs avec les valeurs existantes si elles existent
    for (var field in recensementData.fieldsBien) {
      final key = field['key']!;
      getOrCreateController(newController, key);
    }

    recensementData.listOfControllersBien.add(newController);
    recensementData.dropdownBien.add(selectedDropdownValues);
    recensementData.radioBien.add(selectedRadioValues);
    recensementData.recensementId.add(recensement);

    recensementData.panelsBien.add(
      Column(
        key: ValueKey(newIndex),
        children: [
          ExpansionPanelListExampleBien(
            headerValue: 'Infos du local',
            nbItems: recensementData.nbItemsForBien,
            onDelete: () {
              recensementData.panelsBien.removeWhere((panel) => panel.key == ValueKey(newIndex));
              recensementData.listOfControllersBien.removeAt(newIndex);
              recensementData.dropdownBien.removeAt(newIndex);
              recensementData.radioBien.removeAt(newIndex);
              recensementData.nbItemsForBien--;
              _saveRecensementsToPreferences();
              notifyListeners();
            },
            recensement: recensementData.recensementId[newIndex],
            controllers: recensementData.listOfControllersBien[newIndex],
            dropDownBien: recensementData.dropdownBien[newIndex],
            radioBien: recensementData.radioBien[newIndex],
            fieldsBien: recensementData.fieldsBien,
            index: newIndex,
          ),
        ],
      ),
    );

    _saveRecensementsToPreferences();
    notifyListeners();
  }

  // Nouvelle méthode utilitaire pour garantir la persistance des TextEditingController
  TextEditingController getOrCreateController(Map<String, TextEditingController> controllers, String key, [String? initialValue]) {
    if (!controllers.containsKey(key)) {
      controllers[key] = TextEditingController(text: initialValue ?? "");
    }
    return controllers[key]!;
  }

  void ajouterProprietaire(RecensementData recensementData, Recensement recensement) {
    final newIndex = recensementData.panelsProprietaire.length;
    final Map<String, TextEditingController> newController = {};
    final Map<String, String?> selectedDropdownValues = {};
    final Map<String, String?> selectedRadioValues = {};

    // Initialiser les contrôleurs avec les valeurs existantes si elles existent
    for (var field in recensementData.fieldsProprietaire) {
      final key = field['key']!;
      getOrCreateController(newController, key);
    }

    recensementData.listOfControllersProprietaire.add(newController);
    recensementData.dropdownProprietaire.add(selectedDropdownValues);
    recensementData.radioProprietaire.add(selectedRadioValues);

    recensementData.panelsProprietaire.add(
      Column(
        key: ValueKey(newIndex),
        children: [
          ExpansionPanelListExampleProprietaire(
            headerValue: 'Infos du propriétaire',
            nbItems: recensementData.nbItemsForProprietaire,
            onDelete: () {
              recensementData.panelsProprietaire.removeWhere((panel) => panel.key == ValueKey(newIndex));
              recensementData.listOfControllersProprietaire.removeAt(newIndex);
              recensementData.dropdownProprietaire.removeAt(newIndex);
              recensementData.radioProprietaire.removeAt(newIndex);
              recensementData.nbItemsForProprietaire--;
              _saveRecensementsToPreferences();
              notifyListeners();
            },
            controllers: recensementData.listOfControllersProprietaire[newIndex],
            dropdownProprietaire: recensementData.dropdownProprietaire[newIndex],
            radioProprietaire: recensementData.radioProprietaire[newIndex],
            fields: recensementData.fieldsProprietaire,
            index: newIndex,
          ),
        ],
      ),
    );
    _saveRecensementsToPreferences();
    notifyListeners();
    print("Panel ajouté avec l'index : $newIndex");
  }

  void ajouterLocataire(RecensementData recensementData, Recensement recensement) {
    // Créer un nouvel identifiant unique basé sur le nombre de panels existants
    final newIndex = recensementData.panelsLocataire.length;
    final Map<String, TextEditingController> newController = {};
    final Map<String, String?> selectedDropdownValues = {};
    
    // Initialiser les contrôleurs avec les valeurs existantes si elles existent
    for (var field in recensementData.fieldsLocataire) {
      final key = field['key']!;
      getOrCreateController(newController, key);
    }

    // Ajouter un nouveau contrôleur à la liste
    recensementData.listOfControllersLocataire.add(newController);
    recensementData.dropdownLocataire.add(selectedDropdownValues);

    // Ajouter un nouveau panel
    recensementData.panelsLocataire.add(
      Column(
        key: ValueKey(newIndex), // Utilisation d'une clé basée sur newIndex
        children: [
          ExpansionPanelListExampleLocataire(
            headerValue: 'Infos du locataire',
            nbItems: recensementData.nbItemsForLocataire,
            onDelete: () {
              // Supprimer le panel et son contrôleur associé
              recensementData.panelsLocataire.removeWhere((panel) => panel.key == ValueKey(newIndex));
              recensementData.listOfControllersLocataire.removeAt(newIndex);
              recensementData.dropdownLocataire.removeAt(newIndex);
              recensementData.nbItemsForLocataire--;
              _saveRecensementsToPreferences();
              notifyListeners();
            },
            controllers: recensementData.listOfControllersLocataire[newIndex], // Associer au contrôleur créé
            dropdownLocataire: recensementData.dropdownLocataire[newIndex],
            fields: recensementData.fieldsLocataire,
            index: newIndex,
          ),
        ],
      ),
    );
    _saveRecensementsToPreferences();
    notifyListeners();

    print("Panel ajouté avec l'index : $newIndex");
  }

  // Sauvegarder tous les recensements dans SharedPreferences
  Future<void> _saveRecensementsToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recensementsJson = json.encode(recensements.map((key, value) => MapEntry(key, value.toJson())));
      await prefs.setString('recensements', recensementsJson);
      print('Recensements sauvegardés avec succès: ${recensements.length} entrées');
    } catch (e) {
      print('Erreur lors de la sauvegarde des recensements: $e');
    }
  }

  Future<void> initialize() async {
    await _loadRecensementsFromPreferences();
  }

  Future<void> _loadRecensementsFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recensementsJson = prefs.getString('recensements');
      if (recensementsJson != null) {
        final Map<String, dynamic> decodedMap = json.decode(recensementsJson);
        recensements = decodedMap.map((key, value) {
          final data = RecensementData.fromJson(value);
          _rebuildPanels(data);
          return MapEntry(key, data);
        });
        print('Recensements chargés avec succès: ${recensements.length} entrées');
        notifyListeners();
      } else {
        print('Aucun recensement trouvé dans SharedPreferences');
      }
    } catch (e) {
      print('Erreur lors du chargement des recensements: $e');
    }
  }

  void _rebuildPanels(RecensementData data) {
    data.panelsBien.clear();
    data.panelsProprietaire.clear();
    data.panelsLocataire.clear();

    if (data.listOfControllersProprietaire.isNotEmpty) {
      for (int i = 0; i < data.listOfControllersProprietaire.length; i++) {
        // Étape 3 : Ajouter le nouveau panel avec les contrôleurs restaurés
        data.panelsProprietaire.add(
          Column(
            key: ValueKey(i),
            children: [
              ExpansionPanelListExampleProprietaire(
                headerValue: 'Infos du propriétaire',
                nbItems: data.nbItemsForProprietaire,
                onDelete: () {
                  data.panelsProprietaire.removeWhere((panel) => panel.key == ValueKey(i));
                  data.listOfControllersProprietaire.removeAt(i);
                  data.dropdownProprietaire.removeAt(i);
                  data.radioProprietaire.removeAt(i);
                  data.nbItemsForProprietaire--;
                  _saveRecensementsToPreferences();
                  notifyListeners();
                },
                controllers: data.listOfControllersProprietaire[i],
                dropdownProprietaire: data.dropdownProprietaire[i],
                radioProprietaire: data.radioProprietaire[i],
                fields: data.fieldsProprietaire,
                index: i,
              ),
            ],
          ),
        );
      }
    }

    if (data.listOfControllersBien.isNotEmpty) {
      for (int i = 0; i < data.listOfControllersBien.length; i++) {
        // Étape 3 : Ajouter le nouveau panel avec les contrôleurs restaurés
        data.panelsBien.add(
          Column(
            key: ValueKey(i),
            children: [
              ExpansionPanelListExampleBien(
                headerValue: 'Infos du local',
                nbItems: data.nbItemsForBien,
                onDelete: () {
                  data.panelsBien.removeWhere((panel) => panel.key == ValueKey(i));
                  data.listOfControllersBien.removeAt(i);
                  data.dropdownBien.removeAt(i);
                  data.radioBien.removeAt(i);
                  data.nbItemsForBien--;
                  _saveRecensementsToPreferences();
                  notifyListeners();
                },
                recensement: data.recensementId[i],
                controllers: data.listOfControllersBien[i],
                dropDownBien: data.dropdownBien[i],
                radioBien: data.radioBien[i],
                fieldsBien: data.fieldsBien,
                index: i,
              ),
            ],
          ),
        );
      }
    }

    if (data.listOfControllersLocataire.isNotEmpty) {
      for (int i = 0; i < data.listOfControllersLocataire.length; i++) {
        // Étape 3 : Ajouter le nouveau panel avec les contrôleurs restaurés
        data.panelsLocataire.add(
          Column(
            key: ValueKey(i),
            children: [
              ExpansionPanelListExampleLocataire(
                headerValue: 'Infos du locataire',
                nbItems: data.nbItemsForLocataire,
                onDelete: () {
                  data.panelsLocataire.removeWhere((panel) => panel.key == ValueKey(i));
                  data.listOfControllersLocataire.removeAt(i);
                  data.dropdownLocataire.removeAt(i);
                  data.nbItemsForLocataire--;
                  _saveRecensementsToPreferences();
                  notifyListeners();
                },
                controllers: data.listOfControllersLocataire[i],
                dropdownLocataire: data.dropdownLocataire[i],
                fields: data.fieldsLocataire,
                index: i,
              ),
            ],
          ),
        );
      }
    }

    _saveRecensementsToPreferences();
    notifyListeners();
  }
}

class RecensementData {
  int nbItemsForProprietaire = 1;
  int nbItemsForBien = 1;
  int nbItemsForLocataire = 1;

  final List<Widget> panelsProprietaire = [];
  final List<Widget> panelsBien = [];
  final List<Widget> panelsLocataire = [];

  List<Map<String, TextEditingController>> listOfControllersBien = [];
  List<Map<String, TextEditingController>> listOfControllersProprietaire = [];
  List<Map<String, TextEditingController>> listOfControllersLocataire = [];
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
    {"label": "Numéro du compteur d'électricité", "key": "nbCompteurElectricite"},
    {"label": "Numéro titre foncier", "key": "numTitreFoncier"},
    {"label": "Date d'acquisition", "key": "dateAcquisition"},
    {"label": "Valeur locative annuelle", "key": "valeurLocativeAnnuelle"},
    {"label": "Valeur locative annuelle saisie", "key": "valeurLocativeAnnuelleSaisie"},
    {"label": "Valeur locative mensuelle", "key": "valeurLocativeMensuelle"},
    {"label": "Valeur locative mensuelle saisie", "key": "valeurLocativeMensuelleSaisie"},
    {"label": "Commentaire", "key": "commentaire"},
    {"label": "Images du bien", "key": "photos"},
    {"label": "Escaliers de service présents ?", "key": "escalierPrésent"},
    {"label": "Vide ordure présente ?", "key": "videOrdure"},
    {"label": "Monte charge présente ?", "key": "monteCharge"},
    {"label": "Groupe électrogène présent ?", "key": "groupeElectrogene"},
    {"label": "Dépendances isolées présentes ?", "key": "dependanceIsolee"},
    {"label": "Garage souterrain présent ?", "key": "garageSouterrain"},
    {"label": "Système de climatisation présent ?", "key": "systemeClimatisation"},
    {"label": "Système domotique présent ?", "key": "systemeDomotique"},
    {"label": "Balcon présent ?", "key": "presenceBalcon"},
    {"label": "Terrasse présente ?", "key": "presenceTerrasse"},
    {"label": "Système de surveillance présent ?", "key": "presenceSystemeSurveillance"},
    {"label": "Aménagement paysager présent ?", "key": "amenagementPaysager"},
    {"label": "Situé en angle ?", "key": "angle"},
    {"label": "Éclairage public disponible ?", "key": "eclairagePublic"},
    {"label": "Mur en ciment présent ?", "key": "murEnCiment"},
    {"label": "Attributs architecturaux présents ?", "key": "attributsArchitecturaux"},
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

  List<Map<String, String?>> dropdownBien = [];
  List<Map<String, String?>> radioBien = [];
  List<Map<String, String?>> dropdownProprietaire = [];
  List<Map<String, String?>> radioProprietaire = [];
  List<Map<String, String?>> dropdownLocataire = [];
  int newIndex = 0;
  List<Recensement> recensementId = [];
  Map<String, String?> selectedDropdownValuesBien = {
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
  Map<String, String?> selectedRadioValuesBien = {
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
  Map<String, String?> selectedRadioValuesProprietaire = {};
  Map<String, String?> selectedDropdownValuesProprietaire = {};
  Map<String, String?> selectedDropdownValuesLocataire = {};
  String? numRecensement;

  RecensementData({this.numRecensement});

  Map<String, dynamic> toJson() {
    return {
      'numRecensement': numRecensement,
      'nbItemsForBien': nbItemsForBien,
      'nbItemsForProprietaire': nbItemsForProprietaire,
      'nbItemsForLocataire': nbItemsForLocataire,
      'listOfControllersBien': listOfControllersBien.map((map) {
        return map.map((key, controller) => MapEntry(key, controller.text));
      }).toList(),
      'listOfControllersProprietaire': listOfControllersProprietaire.map((map) {
        return map.map((key, controller) => MapEntry(key, controller.text));
      }).toList(),
      'listOfControllersLocataire': listOfControllersLocataire.map((map) {
        return map.map((key, controller) => MapEntry(key, controller.text));
      }).toList(),
      'dropdownBien': dropdownBien,
      'radioBien': radioBien,
      'dropdownProprietaire': dropdownProprietaire,
      'radioProprietaire': radioProprietaire,
      'dropdownLocataire': dropdownLocataire,
      'recensementId': recensementId.map((r) => r.toJson()).toList(),
      'selectedDropdownValuesBien': selectedDropdownValuesBien,
      'selectedRadioValuesBien': selectedRadioValuesBien,
      'selectedDropdownValuesProprietaire': selectedDropdownValuesProprietaire,
      'selectedRadioValuesProprietaire': selectedRadioValuesProprietaire,
      'selectedDropdownValuesLocataire': selectedDropdownValuesLocataire,
    };
  }

  factory RecensementData.fromJson(Map<String, dynamic> json) {
    final data = RecensementData(
      numRecensement: json['numRecensement'],
    );

    data.nbItemsForBien = json['nbItemsForBien'] ?? 1;
    data.nbItemsForProprietaire = json['nbItemsForProprietaire'] ?? 1;
    data.nbItemsForLocataire = json['nbItemsForLocataire'] ?? 1;

    // Restaurer les contrôleurs avec leurs valeurs
    final List<dynamic> controllersList = json['listOfControllersBien'] ?? [];
    data.listOfControllersBien = controllersList.map<Map<String, TextEditingController>>((map) {
      return Map.fromEntries((map as Map<String, dynamic>).entries.map((entry) {
        return MapEntry(entry.key, TextEditingController(text: entry.value ?? ""));
      }));
    }).toList();

    final List<dynamic> propControllersList = json['listOfControllersProprietaire'] ?? [];
    data.listOfControllersProprietaire = propControllersList.map<Map<String, TextEditingController>>((map) {
      return Map.fromEntries((map as Map<String, dynamic>).entries.map((entry) {
        return MapEntry(entry.key, TextEditingController(text: entry.value ?? ""));
      }));
    }).toList();

    final List<dynamic> locControllersList = json['listOfControllersLocataire'] ?? [];
    data.listOfControllersLocataire = locControllersList.map<Map<String, TextEditingController>>((map) {
      return Map.fromEntries((map as Map<String, dynamic>).entries.map((entry) {
        return MapEntry(entry.key, TextEditingController(text: entry.value ?? ""));
      }));
    }).toList();

    // Restaurer les autres données
    data.dropdownBien = List<Map<String, String?>>.from(
        json['dropdownBien']?.map((e) => Map<String, String?>.from(e)) ?? [{}]);

    data.radioBien = List<Map<String, String?>>.from(
        json['radioBien']?.map((e) => Map<String, String?>.from(e)) ?? [{}]);

    data.dropdownProprietaire = List<Map<String, String?>>.from(
        json['dropdownProprietaire']?.map((e) => Map<String, String?>.from(e)) ?? [{}]);

    data.radioProprietaire = List<Map<String, String?>>.from(
        json['radioProprietaire']?.map((e) => Map<String, String?>.from(e)) ?? [{}]);

    data.dropdownLocataire = List<Map<String, String?>>.from(
        json['dropdownLocataire']?.map((e) => Map<String, String?>.from(e)) ?? [{}]);

    data.recensementId = (json['recensementId'] as List?)?.map((e) => Recensement.fromJson(e)).toList() ?? [];

    data.selectedDropdownValuesBien = Map<String, String?>.from(json['selectedDropdownValuesBien'] ?? {});

    data.selectedRadioValuesBien = Map<String, String?>.from(json['selectedRadioValuesBien'] ?? {});

    data.selectedDropdownValuesProprietaire = Map<String, String?>.from(json['selectedDropdownValuesProprietaire'] ?? {});

    data.selectedRadioValuesProprietaire = Map<String, String?>.from(json['selectedRadioValuesProprietaire'] ?? {});

    data.selectedDropdownValuesLocataire = Map<String, String?>.from(json['selectedDropdownValuesLocataire'] ?? {});

    return data;
  }
}
