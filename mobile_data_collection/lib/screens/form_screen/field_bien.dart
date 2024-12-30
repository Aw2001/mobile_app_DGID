import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_data_collection/model/bien.dart';
import 'package:mobile_data_collection/screens/form_screen/send_button.dart';
import 'package:mobile_data_collection/service/bien_service.dart';
import 'package:mobile_data_collection/service/commune_service.dart';
import 'package:mobile_data_collection/service/departement_service.dart';
import 'package:mobile_data_collection/service/image_service.dart';
import 'package:mobile_data_collection/service/parcelle_service.dart';
import 'package:mobile_data_collection/service/section_service.dart';

class BuildFieldBien extends StatefulWidget {
  const BuildFieldBien({super.key});

  @override
  BuildFieldBienState createState() => BuildFieldBienState();
}

class BuildFieldBienState extends State<BuildFieldBien> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String?> _selectedDropdownValues = {
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
  final Map<String, String?> _selectedRadioValues = {
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
  bool isPaysagerSelected = false;
  bool isPiscineSelected = false;
  bool isCoursGazonneeSelected = false;
  bool isCoursTennisSelected = false;
  bool isJardinSelected = false;
  bool isTerrainGolfSelected = false;
  bool isAutreSelected = false;
  late String jardinValue = '';
  late String piscineValue = '';
  late String coursDeTennisValue = '';
  late String coursGazonneeValue = '';
  late String terrainGolfValue = '';
  late String autreValue = '';
  String recensementId = "12152024DKRURUE0410133019100100005";

  List<XFile> _imageFiles = [];

  // Configuration of fields for Bien with dropdowns and radio buttons
  final List<Map<String, String>> _fieldsBien = [
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

  // Dropdown options for specific fields
  final Map<String, Future<List<String>>> dropdownItems = {
    "typeParcelle": Future.value([
      'Usage scolaire',
      'Usage médical',
      'Usage religieux',
      'Service public',
      'Distribution en eau',
      'Distribution en électricité',
      'Bâtiment en chantier',
      'Parcelle elligible',
      'Terrain nu sans activité',
      'Terrain nu à usage commercial',
      'Terrain nu à usage industriel',
      'Autre'
    ]),
    "typeVoirie": Future.value(
        ['Rue', 'Boulevard', 'Allée', 'Avenue', 'Rocade', 'Autre']),
    "usage": Future.value(['Résidentiel', 'Commercial', 'Mixte']),
    "typeCloture":
        Future.value(['Mur', 'Mur avec fer forgé', 'Grillage', 'Absence']),
    "etatCloture": Future.value(['Très Bon', 'Bon', 'Moyen', 'Mauvais']),
    "toiture": Future.value(['Tuile', 'Fibrociment', 'Tôle galvanisée']),
    "typeRevetement": Future.value([
      'Carrelage',
      'Pierre',
      'Enduit simple',
      'Enduit wis',
      'Peinture',
      'Absence'
    ]),
    "typeCarrelage": Future.value([
      'Marbre',
      'Granite',
      'Grès poli',
      'Grès cérame de 1er choix',
      'Grès cérame de 2ème choix',
      'Grès émaillé de 1er choix',
      'Grès émaillé de 2ème choix',
      'Aucun',
    ]),
    "menuiserie": Future.value([
      'Aluminium',
      'Bois noble',
      'Bois fraké ou similaire',
      'Bois isoplane',
      'Fer forgé'
    ]),
    "conceptionPieces": Future.value([
      'Large',
      'Moyenne',
      'Petite',
    ]),
    "appareilsSanitaires": Future.value(
        ['Aluminium', 'Haute gamme', 'Gamme moyenne', 'Qualité ordinaire']),
    "parkingInterieur": Future.value([
      'Couvert',
      'Non couvert',
      'Aucun',
    ]),
    "confort": Future.value([
      'Très grand confort',
      'Grand confort',
      'Pas de confort',
    ]),
    "etatRevetement":
        Future.value(['Très bon', 'Bon', 'Moyen', 'Mauvais', 'Standard']),
    "situationRoute": Future.value([
      'Loin de la route principale',
      'Proche de la route principale',
      'Sur la route principale'
    ]),
    "typeRoute": Future.value(
        ['Goudron', 'Graviers', 'Pas de voirie', 'Pavés', 'Sable']),
    "garage": Future.value(['Simple', 'Double', 'Multiple', 'Absence']),
    "qualitePorteEtFenetre": Future.value(
        ['Très bonne', 'Bonne', 'Moyenne', 'Mauvaise', 'Standard']),
    "localisationLot":
        Future.value(['Gauche', 'Droite', 'Centre', 'Tout le niveau']),
    "situationLot": Future.value([
      'Totalité d\'un bâtiment',
      'Partie du bâtiment',
      'Totalité des bâtiments'
    ]),
    "typeLot": Future.value(
        ['Maison individuelle', 'Immeuble collectif', 'Copropriété']),
    "region": Future.value([
      'Kédouguou',
      'Tambacounda',
      'Kaolack',
      'Thiès',
      'Dakar',
      'Diourbel',
      'Louga',
      'Matam',
      'Saint-Louis',
      'Ziguinchor',
      'Sédhiou',
      'Kolda',
      'Kaffrine',
      'Fatick'
    ]),
    "departement": Future.value([]),
    "commune": Future.value([]),
    "section": Future.value([]),
    "nicad": Future.value([])
  };

  void ajouterBien(BienService bienService) async {

    ImageService imageService = ImageService();
    final Bien bienData = Bien(
      // Autres champs récupérés des contrôleurs
      idProprietaire: _controllers["numIdentifiantProprietaire"]?.text,
      idParcelle:
          _selectedDropdownValues["nicad"] ?? _controllers["nicad"]?.text,
      nomRue: _controllers["nomRue"]?.text,
      codeDeRueAdm: _controllers["codeRue"]?.text,
      quartier: _controllers["quartier"]?.text,
      village: _controllers["village"]?.text,
      typeParcelle: _selectedDropdownValues["typeParcelle"] ??
          _controllers["typeParcelle"]?.text,
      identifiant: _controllers["identifiant"]?.text,
      nomVoirie: _controllers["nomVoirie"]?.text,
      typeVoirie: _selectedDropdownValues["typeVoirie"] ??
          _controllers["typeVoirie"]?.text,
      nomAutreVoirie: _controllers["nomAutreVoirie"]?.text,
      typeLot:
          _selectedDropdownValues["typeLot"] ?? _controllers["typeLot"]?.text,
      localisationLot: _selectedDropdownValues["localisationLot"] ??
          _controllers["localisationLot"]?.text,
      situationLot: _selectedDropdownValues["situationLot"] ??
          _controllers["situationLot"]?.text,
      numLot: _controllers["numeroLot"]?.text,
      niveauLot: int.tryParse(_controllers["niveauLot"]?.text ?? "0"),
      numPorteAdm: _controllers["numeroPorte"]?.text,
      adresse: _controllers["adresse"]?.text,
      superficie: double.tryParse(_controllers["superficie"]?.text ?? "0"),
      typeOccupation: _controllers["typeOccupation"]?.text,
      dateDelivranceTypeOccupation:
          _controllers["dateDelivranceTypeOccupation"]?.text != null &&
                  _controllers["dateDelivranceTypeOccupation"]!.text.isNotEmpty
              ? DateTime.tryParse(
                  _controllers["dateDelivranceTypeOccupation"]!.text)
              : null,
      usagee: _selectedDropdownValues["usage"] ?? _controllers["usage"]?.text,
      typeConstruction: _controllers["typeConstruction"]?.text,
      toiture:
          _selectedDropdownValues["toiture"] ?? _controllers["toiture"]?.text,
      typeCloture: _selectedDropdownValues["typeCloture"] ??
          _controllers["typeCloture"]?.text,
      etatCloture: _selectedDropdownValues["etatCloture"] ??
          _controllers["etatCloture"]?.text,
      typeRevetement: _selectedDropdownValues["typeRevetement"] ??
          _controllers["typeRevetement"]?.text,
      etatRevetement: _selectedDropdownValues["etatRevetement"] ??
          _controllers["etatRevetement"]?.text,
      situationRoute: _selectedDropdownValues["situationRoute"] ??
          _controllers["situationRoute"]?.text,
      typeRoute: _selectedDropdownValues["typeRoute"] ??
          _controllers["typeRoute"]?.text,
      garage: _selectedDropdownValues["garage"] ?? _controllers["garage"]?.text,
      qualitePorteFenetre: _selectedDropdownValues["qualitePorteEtFenetre"] ??
          _controllers["qualitePorteEtFenetre"]?.text,
      typeCarrelage: _selectedDropdownValues["typeCarrelage"] ??
          _controllers["typeCarrelage"]?.text,
      menuiserie: _selectedDropdownValues["menuiserie"] ??
          _controllers["menuiserie"]?.text,
      conceptionPieces: _selectedDropdownValues["conceptionPieces"] ??
          _controllers["conceptionPieces"]?.text,
      appareilsSanitaires: _selectedDropdownValues["appareilsSanitaires"] ??
          _controllers["appareilsSanitaires"]?.text,
      parkingInterieur: _selectedDropdownValues["parkingInterieur"] ??
          _controllers["parkingInterieur"]?.text,
      nbAscenseurs: int.tryParse(_controllers["nbAscenseurs"]?.text ?? "0"),
      nbSalleBain: int.tryParse(_controllers["nbSallesBain"]?.text ?? "0"),
      nbSalleEau: int.tryParse(_controllers["nbSallesEau"]?.text ?? "0"),
      nbPieceReception:
          int.tryParse(_controllers["nbPieceReception"]?.text ?? "0"),
      nbTotalPiece: int.tryParse(_controllers["nbPiece"]?.text ?? "0"),
      nbEtage: int.tryParse(_controllers["nbEtages"]?.text ?? "0"),
      confort:
          _selectedDropdownValues["confort"] ?? _controllers["confort"]?.text,
      numCompteurSenelec: _controllers["nbCompteurElectricite"]?.text,
      numTitreFoncier: _controllers["numTitreFoncier"]?.text,
      dateAcquisition: _controllers["dateAcquisition"]?.text != null &&
              _controllers["dateAcquisition"]!.text.isNotEmpty
          ? DateTime.tryParse(_controllers["dateAcquisition"]!.text!)
          : null,
      valeurLocativeAnnuelle:
          double.tryParse(_controllers["valeurLocativeAnnuelle"]?.text ?? "0"),
      valeurLocativeAnnuelleSaisie: double.tryParse(
          _controllers["valeurLocativeAnnuelleSaisie"]?.text ?? "0"),
      valeurLocativeMensuelle:
          double.tryParse(_controllers["valeurLocativeMensuelle"]?.text ?? "0"),
      valeurLocativeMensuelleSaisie: double.tryParse(
          _controllers["valeurLocativeMensuelleSaisie"]?.text ?? "0"),
      commentaire: _controllers["commentaire"]?.text,
      escalier: _selectedRadioValues["typeParcelle"] ??
          _controllers["escalierPrésent"]?.text,
      videOrdure: _selectedRadioValues["videOrdure"] ??
          _controllers["videOrdure"]?.text,
      monteCharge: _selectedRadioValues["monteCharge"] ??
          _controllers["monteCharge"]?.text,
      groupeElectrogene: _selectedRadioValues["groupeElectrogene"] ??
          _controllers["groupeElectrogene"]?.text,
      dependanceIsolee: _selectedRadioValues["dependanceIsolee"] ??
          _controllers["dependanceIsolee"]?.text,
      garageSouterrain: _selectedRadioValues["garageSouterrain"] ??
          _controllers["garageSouterrain"]?.text,
      systemeClimatisation: _selectedRadioValues["systemeClimatisation"] ??
          _controllers["systemeClimatisation"]?.text,
      systemeDomotique: _selectedRadioValues["systemeDomotique"] ??
          _controllers["systemeDomotique"]?.text,
      balcon: _selectedRadioValues["presenceBalcon"] ??
          _controllers["presenceBalcon"]?.text,
      terrasse: _selectedRadioValues["presenceTerrasse"] ??
          _controllers["presenceTerrasse"]?.text,
      systemeSurveillance:
          _selectedRadioValues["presenceSystemeSurveillance"] ??
              _controllers["presenceSystemeSurveillance"]?.text,
      amenagementPaysager: _selectedRadioValues["amenagementPaysager"] ??
          _controllers["amenagementPaysager"]?.text,
      jardin: jardinValue,
      piscine: piscineValue,
      coursDeTennis: coursDeTennisValue,
      coursGazonnee: coursGazonneeValue,
      terrainGolf: terrainGolfValue,
      autre: autreValue,
      angle: _selectedRadioValues["angle"] ?? _controllers["angle"]?.text,
      eclairagePublic: _selectedRadioValues["eclairagePublic"] ??
          _controllers["eclairagePublic"]?.text,
      murEnCiment: _selectedRadioValues["murEnCiment"] ??
          _controllers["murEnCiment"]?.text,
      attributsArchitecturaux:
          _selectedRadioValues["attributsArchitecturaux"] ??
              _controllers["attributsArchitecturaux"]?.text,
      trottoir:
          _selectedRadioValues["troittoir"] ?? _controllers["trottoir"]?.text,
      proprieteEnLocation: _selectedRadioValues["proprieteEnLocation"] ??
          _controllers["proprieteEnLocation"]?.text,
      autreTypeOccupation: _selectedRadioValues["autreOccupation"] ??
          _controllers["autreOccupation"]?.text,
      // Ajoutez d'autres champs ici
    );

    if (await bienService.retournerBien(bienData.identifiant) == 0) {
      //
      try {

        await bienService.ajouterBien(recensementId, bienData);
        print("Bien ajouté avec succès !");

      } catch (e) {

        print("Erreur lors de l'ajout du bien : $e");

      }
    } else if (await bienService.retournerBien(bienData.identifiant) == 1) {
      try {

        await bienService.mettreAJourBien(recensementId, bienData);
        print("Bien modifié avec succès !");

      } catch (e) {

        print("Erreur lors de la modification du bien : $e");

      }
    } else {

      print("Pas d'ajout ni de modification");

    }
    if (_imageFiles.isNotEmpty) {
      await imageService.ajouterImage(bienData.identifiant, _imageFiles);
    }
  }

  void fetchDepartements(String? regionName) {
    DepartementService departementService = DepartementService();
    Future<List<String>> departements = departementService.listerDepartements(regionName);
    try {
      setState(() {
        dropdownItems["departement"] = departements;
      });
    } catch (e) {
      print("Erreur lors de la récupération des départements : $e");
    }
  }

  void fetchCommunes(String? departementName) {
    CommuneService communeService = CommuneService();
    Future<List<String>> communes = communeService.listerCommunes(departementName);

    try {
      setState(() {
        dropdownItems["commune"] = communes;
      });
    } catch (e) {
      print("Erreur lors de la récupération des communes : $e");
    }
  }

  void fetchSections(String? communeName) {
    SectionService sectionService = SectionService();
    Future<List<String>> sections = sectionService.listerSections(communeName);

    try {
      setState(() {
        dropdownItems["section"] = sections;
      });
    } catch (e) {
      print("Erreur lors de la récupération des sections : $e");
    }
  }

  void fetchParcelles(String? sectionNumSec) {
    ParcelleService parcelleService = ParcelleService();
    Future<List<String>> parcelles = parcelleService.listerParcelles(sectionNumSec);

    try {
      setState(() {
        dropdownItems["nicad"] = parcelles;
      });
    } catch (e) {
      print("Erreur lors de la récupération des parcelles : $e");
    }
  }

  @override
  void initState() {
    super.initState();

    for (var field in _fieldsBien) {
      if (field["key"] != null) {
        _controllers[field["key"]!] = TextEditingController();
      }
    }
  }

  // Méthode pour choisir plusieurs images

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._fieldsBien.map((field) {
          String fieldKey = field["key"]!;
          String? labelText = field["label"];

          if (dropdownItems.containsKey(fieldKey)) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: FutureBuilder<List<String>>(
                future: dropdownItems[
                    fieldKey], // Assurez-vous que fieldKey pointe vers un Future<List<String>>
                builder: (context, snapshot) {
                  final items = snapshot.data!;
                  return DropdownButtonFormField<String>(
                    value: _selectedDropdownValues[fieldKey],
                    hint: Text(labelText!),
                    items: items.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDropdownValues[fieldKey] = newValue;
                        if (fieldKey == "region") {
                          fetchDepartements(newValue);
                        } else if (fieldKey == "departement") {
                          fetchCommunes(newValue);
                        } else if (fieldKey == "commune") {
                          fetchSections(newValue);
                        } else if (fieldKey == "section") {
                          fetchParcelles(newValue);
                        }
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 255, 254, 251),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(color: Color(0xFFC3AD65)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (fieldKey == "numIdentifiantProprietaire" ||
              fieldKey == "nomRue" ||
              fieldKey == "codeRue" ||
              fieldKey == "quartier" ||
              fieldKey == "village" ||
              fieldKey == "identifiant" ||
              fieldKey == "nomVoirie" ||
              fieldKey == "nomAutreVoirie" ||
              fieldKey == "superficie" ||
              fieldKey == "adresse" ||
              fieldKey == "typeOccupation" ||
              fieldKey == "autreTypeOccupation" ||
              fieldKey == "typeConstruction" ||
              fieldKey == "toiture" ||
              fieldKey == "numTitreFoncier" ||
              fieldKey == "numeroLot" ||
              fieldKey == "numeroPorte" ||
              fieldKey == "valeurLocativeAnnuelle" ||
              fieldKey == "valeurLocativeAnnuelleSaisie" ||
              fieldKey == "valeurLocativeMensuelle" ||
              fieldKey == "valeurLocativeMensuelleSaisie" ||
              fieldKey == "nbCompteurEau" ||
              fieldKey == "nbCompteurElectricite") {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                maxLines: null,
                controller: _controllers[fieldKey],
                cursorColor: Color(0xFFC3AD65),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 254, 251),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: Color(0xFFC3AD65)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  labelText: labelText,
                  floatingLabelStyle: TextStyle(color: Color(0xFFC3AD65)),
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),
            );
          } else if (fieldKey == "dateAcquisition" ||
              fieldKey == "dateDelivranceTypeOccupation") {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: _controllers[fieldKey],
                readOnly: true,
                cursorColor: Color(0xFFC3AD65),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 254, 251),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: Color(0xFFC3AD65)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  labelText: labelText,
                  floatingLabelStyle: TextStyle(color: Color(0xFFC3AD65)),
                  labelStyle: TextStyle(color: Colors.grey),
                  suffixIcon: Icon(Icons.calendar_today, color: Colors.grey),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    String formattedDate =
                        "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                    _controllers[fieldKey]?.text = formattedDate;
                  }
                },
              ),
            );
          } else if (fieldKey == "commentaire") {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                maxLines: null,
                controller: _controllers[fieldKey],
                cursorColor: Color(0xFFC3AD65),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 254, 251),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: Color(0xFFC3AD65)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  labelText: labelText,
                  floatingLabelStyle: TextStyle(color: Color(0xFFC3AD65)),
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),
            );
          } else if (fieldKey == "photos") {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    labelText!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sélectionner des images',
                        style: TextStyle(fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () async {
                          print("Bouton cliqué !");
                          try {
                            final List<XFile>? pickedImages =
                                await ImagePicker().pickMultiImage();
                            if (pickedImages != null) {
                              print(
                                  "Images sélectionnées : ${pickedImages.length}");
                              setState(() {
                                _imageFiles = pickedImages;
                              });
                            } else {
                              print("Aucune image sélectionnée.");
                            }
                          } catch (e) {
                            print("Erreur de sélection des images: $e");
                          }
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xFFC3AD65),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.file_upload,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_imageFiles.isNotEmpty)
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _imageFiles!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.file(
                              File(_imageFiles![index].path),
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          } else if (fieldKey == 'nbAscenseurs' ||
              fieldKey == 'nbSallesBain' ||
              fieldKey == 'nbSallesEau' ||
              fieldKey == 'nbPieceReception' ||
              fieldKey == 'nbEtages' ||
              fieldKey == 'niveauLot' ||
              fieldKey == 'nbPiece') {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: _controllers[fieldKey],
                cursorColor: const Color(0xFFC3AD65),
                keyboardType: TextInputType.number, // Clavier numérique
                inputFormatters: [
                  FilteringTextInputFormatter
                      .digitsOnly, // Permet uniquement les chiffres
                ],
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 254, 251),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: Color(0xFFC3AD65)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  labelText: labelText,
                  floatingLabelStyle: const TextStyle(color: Color(0xFFC3AD65)),
                  labelStyle: const TextStyle(color: Colors.grey),
                ),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    labelText!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: ["Oui", "Non"].map((option) {
                      return Expanded(
                        child: RadioListTile<String>(
                          title: Text(option),
                          value: option,
                          groupValue: _selectedRadioValues[fieldKey],
                          onChanged: (String? value) {
                            setState(() {
                              _selectedRadioValues[fieldKey] = value;
                              if (fieldKey == "amenagementPaysager") {
                                isPaysagerSelected = value == "Oui";
                                if (!isPaysagerSelected) {
                                  isPiscineSelected = false;
                                  isJardinSelected = false;
                                  isCoursGazonneeSelected = false;
                                  isCoursTennisSelected = false;
                                  isTerrainGolfSelected = false;
                                  isAutreSelected = false;
                                }
                              }
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  if (fieldKey == "amenagementPaysager" && isPaysagerSelected)
                    Column(
                      children: [
                        CheckboxListTile(
                          title: Text("Jardin"),
                          value: isJardinSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              isJardinSelected = value ?? false;
                              jardinValue = isJardinSelected ? 'Oui' : 'Non';
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text("Piscine"),
                          value: isPiscineSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              isPiscineSelected = value ?? false;
                              piscineValue = isPiscineSelected ? 'Oui' : 'Non';
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text("Cours de tennis"),
                          value: isCoursTennisSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              isCoursTennisSelected = value ?? false;
                              coursDeTennisValue =
                                  isCoursTennisSelected ? 'Oui' : 'Non';
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text("Cours gazonnée"),
                          value: isCoursGazonneeSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              isCoursGazonneeSelected = value ?? false;
                              coursGazonneeValue =
                                  isCoursGazonneeSelected ? 'Oui' : 'Non';
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text("Terrain de golf privé"),
                          value: isTerrainGolfSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              isTerrainGolfSelected = value ?? false;
                              terrainGolfValue =
                                  isTerrainGolfSelected ? 'Oui' : 'Non';
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text("Autre"),
                          value: isAutreSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              isAutreSelected = value ?? false;
                              autreValue = isAutreSelected ? 'Oui' : 'Non';
                            });
                          },
                        ),
                      ],
                    ),
                ],
              ),
            );
          }
        }).toList(),
        SendButton(
          onpressed:
              ajouterBien, // Passez une référence à la méthode ajouterBien.
          apiUrl: "http://10.0.2.2:8081/api/biens", // URL de l'API.
        ),
      ],
    );
  }
}
