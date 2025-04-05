import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_data_collection/model/bien.dart';
import 'package:mobile_data_collection/model/recensement.dart';
import 'package:mobile_data_collection/screens/formulaire/custom_form_field.dart';
import 'package:mobile_data_collection/service/bien_service.dart';
import 'package:mobile_data_collection/service/commune_service.dart';
import 'package:mobile_data_collection/service/departement_service.dart';
import 'package:mobile_data_collection/service/image_service.dart';
import 'package:mobile_data_collection/service/parcelle_service.dart';
import 'package:mobile_data_collection/service/section_service.dart';
import 'package:mobile_data_collection/utils/extensions.dart';

class BuildFieldBien extends StatefulWidget {
  final Recensement recensement;
  final List<Map<String, String>> fieldsBien;
  final Map<String, TextEditingController> controllers;
  
  final Map<String, String?> dropDownBien;
  final Map<String, String?> radioBien;
  
  const BuildFieldBien({super.key, required this.recensement, required this.fieldsBien, required this.controllers, required this.dropDownBien, required this.radioBien});

  @override
  BuildFieldBienState createState() => BuildFieldBienState();

 
}

class BuildFieldBienState extends State<BuildFieldBien> {
  
  
  bool isPaysagerSelected = false;
  bool isPiscineSelected = false;
  bool isCoursGazonneeSelected = false;
  bool isCoursTennisSelected = false;
  bool isJardinSelected = false;
  bool isTerrainGolfSelected = false;
  bool isAutreSelected = false;
  late String jardinValue = "";
  late String piscineValue = "";
  late String coursDeTennisValue = "";
  late String coursGazonneeValue = "";
  late String terrainGolfValue = "";
  late String autreValue = "";
  ParcelleService parcelleService = ParcelleService();
  Future<List<String>> parcelles = Future.value([
      'NNN',
     
    ]);
  final BienService bienService = BienService("http://192.168.1.7:8081/api/biens");

  List<XFile> _imageFiles = [];
  bool allValuesValid = true;

  // Configuration of fields for Bien with dropdowns and radio buttons
  

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
   
    "nicad": Future.value([])
  };

  void ajouterBien(Map<String, TextEditingController> controllerBien, Map<String, String?> dropdown, Map<String, String?> radio, Recensement recensementId) async {
    ImageService imageService = ImageService();
     controllerBien.forEach((key, controller) {
        String? value = controller.text;

        if (value == null) {
          print('Clé: $key, Valeur: (nulle)');
          allValuesValid = false;
        } else {
          
        }
      });
    
    if (allValuesValid == true) {
      final Bien bienData = Bien(
      // Autres champs récupérés des contrôleurs
      idProprietaire: controllerBien["numIdentifiantProprietaire"]?.text,
      idParcelle:
          dropdown["nicad"] ?? controllerBien["nicad"]?.text,
      nomRue: controllerBien["nomRue"]?.text ,
      codeDeRueAdm: controllerBien["codeRue"]?.text  ,
      quartier: controllerBien["quartier"]?.text ,
      village: controllerBien["village"]?.text ,
      typeParcelle: dropdown["typeParcelle"] ??
          controllerBien["typeParcelle"]?.text ,
      identifiant: controllerBien["identifiant"]?.text ,
      nomVoirie: controllerBien["nomVoirie"]?.text ,
      typeVoirie: dropdown["typeVoirie"] ??
          controllerBien["typeVoirie"]?.text ,
      nomAutreVoirie: controllerBien["nomAutreVoirie"]?.text ,
      typeLot:
          dropdown["typeLot"] ?? controllerBien["typeLot"]?.text ,
      localisationLot: dropdown["localisationLot"] ??
          controllerBien["localisationLot"]?.text ,
      situationLot: dropdown["situationLot"] ??
          controllerBien["situationLot"]?.text ,
      numLot: controllerBien["numeroLot"]?.text ,
      niveauLot: int.tryParse(controllerBien["niveauLot"]?.text ?? "0"),
      numPorteAdm: controllerBien["numeroPorte"]?.text ,
      adresse: controllerBien["adresse"]?.text ,
      superficie: double.tryParse(controllerBien["superficie"]?.text ?? "0"),
      typeOccupation: controllerBien["typeOccupation"]?.text ,
      dateDelivranceTypeOccupation:
          controllerBien["dateDelivranceTypeOccupation"]?.text != null &&
            controllerBien["dateDelivranceTypeOccupation"]!.text.isNotEmpty
              ? DateTime.tryParse(
                  controllerBien["dateDelivranceTypeOccupation"]!.text)
              : null,
      usagee: dropdown["usage"] ?? controllerBien["usage"]?.text ,
      typeConstruction: controllerBien["typeConstruction"]?.text ,
      toiture:
          dropdown["toiture"] ?? controllerBien["toiture"]?.text ,
      typeCloture: dropdown["typeCloture"] ??
          controllerBien["typeCloture"]?.text ,
      etatCloture: dropdown["etatCloture"] ??
          controllerBien["etatCloture"]?.text ,
      typeRevetement: dropdown["typeRevetement"] ??
          controllerBien["typeRevetement"]?.text ,
      etatRevetement: dropdown["etatRevetement"] ??
          controllerBien["etatRevetement"]?.text ,
      situationRoute: dropdown["situationRoute"] ??
          controllerBien["situationRoute"]?.text ,
      typeRoute: dropdown["typeRoute"] ??
          controllerBien["typeRoute"]?.text ,
      garage: dropdown["garage"] ?? controllerBien["garage"]?.text ,
      qualitePorteFenetre: dropdown["qualitePorteEtFenetre"] ??
          controllerBien["qualitePorteEtFenetre"]?.text ,
      typeCarrelage: dropdown["typeCarrelage"] ??
          controllerBien["typeCarrelage"]?.text ,
      menuiserie: dropdown["menuiserie"] ??
          controllerBien["menuiserie"]?.text ,
      conceptionPieces: dropdown["conceptionPieces"] ??
          controllerBien["conceptionPieces"]?.text ,
      appareilsSanitaires: dropdown["appareilsSanitaires"] ??
          controllerBien["appareilsSanitaires"]?.text ,
      parkingInterieur: dropdown["parkingInterieur"] ??
          controllerBien["parkingInterieur"]?.text ,
      nbAscenseurs: int.tryParse(controllerBien["nbAscenseurs"]?.text ?? "0"),
      nbSalleBain: int.tryParse(controllerBien["nbSallesBain"]?.text ?? "0"),
      nbSalleEau: int.tryParse(controllerBien["nbSallesEau"]?.text ?? "0"),
      nbPieceReception:
          int.tryParse(controllerBien["nbPieceReception"]?.text ?? "0"),
      nbTotalPiece: int.tryParse(controllerBien["nbPiece"]?.text ?? "0"),
      nbEtage: int.tryParse(controllerBien["nbEtages"]?.text ?? "0"),
      confort:
          dropdown["confort"] ?? controllerBien["confort"]?.text ,
      numCompteurSenelec: controllerBien["nbCompteurElectricite"]?.text ,
      numTitreFoncier: controllerBien["numTitreFoncier"]?.text ,
      dateAcquisition: controllerBien["dateAcquisition"]?.text != null &&
              controllerBien["dateAcquisition"]!.text.isNotEmpty
          ? DateTime.tryParse(controllerBien["dateAcquisition"]!.text!)
          : null,
      valeurLocativeAnnuelle:
          double.tryParse(controllerBien["valeurLocativeAnnuelle"]?.text ?? "0"),
      valeurLocativeAnnuelleSaisie: double.tryParse(
          controllerBien["valeurLocativeAnnuelleSaisie"]?.text ?? "0"),
      valeurLocativeMensuelle:
          double.tryParse(controllerBien["valeurLocativeMensuelle"]?.text ?? "0"),
      valeurLocativeMensuelleSaisie: double.tryParse(
          controllerBien["valeurLocativeMensuelleSaisie"]?.text ?? "0"),
      commentaire: controllerBien["commentaire"]?.text ,
      escalier: radio["typeParcelle"] ??
          controllerBien["escalierPrésent"]?.text ,
      videOrdure: radio["videOrdure"] ??
          controllerBien["videOrdure"]?.text ,
      monteCharge: radio["monteCharge"] ??
          controllerBien["monteCharge"]?.text ,
      groupeElectrogene: radio["groupeElectrogene"] ??
          controllerBien["groupeElectrogene"]?.text ,
      dependanceIsolee: radio["dependanceIsolee"] ??
          controllerBien["dependanceIsolee"]?.text ,
      garageSouterrain: radio["garageSouterrain"] ??
          controllerBien["garageSouterrain"]?.text ,
      systemeClimatisation: radio["systemeClimatisation"] ??
          controllerBien["systemeClimatisation"]?.text ,
      systemeDomotique: radio["systemeDomotique"] ??
          controllerBien["systemeDomotique"]?.text ,
      balcon: radio["presenceBalcon"] ??
          controllerBien["presenceBalcon"]?.text ,
      terrasse: radio["presenceTerrasse"] ??
          controllerBien["presenceTerrasse"]?.text ,
      systemeSurveillance:
          radio["presenceSystemeSurveillance"] ??
              controllerBien["presenceSystemeSurveillance"]?.text ,
      amenagementPaysager: radio["amenagementPaysager"] ??
          controllerBien["amenagementPaysager"]?.text ,
      jardin: jardinValue,
      piscine: piscineValue,
      coursDeTennis: coursDeTennisValue,
      coursGazonnee: coursGazonneeValue,
      terrainGolf: terrainGolfValue,
      autre: autreValue,
      angle: radio["angle"] ?? controllerBien["angle"]?.text ,
      eclairagePublic: radio["eclairagePublic"] ??
          controllerBien["eclairagePublic"]?.text ,
      murEnCiment: radio["murEnCiment"] ??
          controllerBien["murEnCiment"]?.text ,
      attributsArchitecturaux:
          radio["attributsArchitecturaux"] ??
              controllerBien["attributsArchitecturaux"]?.text ,
      trottoir:
          radio["troittoir"] ?? controllerBien["trottoir"]?.text ,
      proprieteEnLocation: radio["proprieteEnLocation"] ??
          controllerBien["proprieteEnLocation"]?.text ,
      autreTypeOccupation: radio["autreOccupation"] ??
          controllerBien["autreOccupation"]?.text ,
      // Ajoutez d'autres champs ici
    );
    print(bienData.idParcelle);
    
    print(bienData.idProprietaire);
    if (await bienService.retournerBien(bienData.identifiant) == 0) {
      //
      try {

        await bienService.ajouterBien(recensementId.numRecensement, bienData);
        print("Bien ajouté avec succès !");

      } catch (e) {
        
        print("Erreur lors de l'ajout du bien : $e");
        

      }
    } else if (await bienService.retournerBien(bienData.identifiant) == 1) {
      try {

        await bienService.mettreAJourBien(recensementId.numRecensement, bienData);
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

  void fetchParcelles(String? sectionNumSec, String? region, String? nomDepart, String? nomCommun) {
    ParcelleService parcelleService = ParcelleService();
    Future<List<String>> parcelles = parcelleService.listerParcelles(sectionNumSec, region, nomDepart, nomCommun);
    try {
      setState(() {
        dropdownItems["nicad"] = parcelles;
        print(parcelles);
      });
    } catch (e) {
      print("Erreur lors de la récupération des parcelles : $e");
    }
  }

  @override
  void initState() {
    super.initState();
    parcelles = parcelleService.listerParcelles(widget.recensement.section, widget.recensement.region, widget.recensement.departement, widget.recensement.commune);
    print(parcelles);
    for (var field in widget.fieldsBien) {
      if (field.containsKey("key") && field["key"] != null && field["key"]!.isNotEmpty) {
        widget.controllers[field["key"]!] = TextEditingController();
      }
    }
  }

  // Méthode pour choisir plusieurs images

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...widget.fieldsBien.map((field) {
              String fieldKey = field["key"]!;
              String? labelText = field["label"];

              if (dropdownItems.containsKey(fieldKey)) {
                if(fieldKey == "nicad") {
                  dropdownItems['nicad'] = parcelles;
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxWidth - 18.0,
                        child: FutureBuilder<List<String>>(
                    future: dropdownItems[
                        fieldKey], // Assurez-vous que fieldKey pointe vers un Future<List<String>>
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Affiche un indicateur de chargement pendant que le futur se résout
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        // Affiche une erreur si quelque chose s'est mal passé
                        return Text('Erreur : ${snapshot.error}');
                      } else if(snapshot.hasData && snapshot.data != null) {
                          final items = snapshot.data!;
                        return DropdownButtonFormField<String>(
                          value: widget.dropDownBien[fieldKey],
                          hint: Text(labelText!, style: TextStyle(fontSize: 10),),
                          items: items.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: TextStyle(fontSize: 10),),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              widget.dropDownBien[fieldKey] = newValue;
                            
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
                      } else {
                        return Text("Aucune donnée disponible");
                      }
                      
                    },
                    ),
                      );
                    }
                  ),
                  
                );
              } else if (fieldKey == "region" ||
                  fieldKey == "departement" ||
                  fieldKey == "commune" ||
                  fieldKey == "section" ||
                  fieldKey == "numIdentifiantProprietaire" ||
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
                  fieldKey == "nbCompteurElectricite" ||
                  fieldKey == 'nbAscenseurs' ||
                  fieldKey == 'nbSallesBain' ||
                  fieldKey == 'nbSallesEau' ||
                  fieldKey == 'nbPieceReception' ||
                  fieldKey == 'nbEtages' ||
                  fieldKey == 'niveauLot' ||
                  fieldKey == 'nbPiece') {
                  if(fieldKey == "region"){ 
                    widget.controllers["region"]?.text = widget.recensement.region ?? '';
                  }  
                  if(fieldKey == "departement"){ widget.controllers["departement"]?.text = widget.recensement.departement ?? '';}
                  if(fieldKey == "commune"){widget.controllers["commune"]?.text = widget.recensement.commune ?? '';}
                  if(fieldKey == "section") {widget.controllers["section"]?.text = widget.recensement.section ?? '';}
                  // Ajouter une étoile pour "identifiant"
                  String labelText = fieldKey == "identifiant" ? "$fieldKey (obligatoire)" : fieldKey;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomFormField(
                    labelText: labelText, 
                    controller: widget.controllers[fieldKey],
                    validator: (val) {
                    if (fieldKey == "identifiant" && val!.isEmpty) {
                      return "Ce champ est obligatoire";
                    }
                    return null; // Pas d'erreur pour les autres champs
                  },
                  ),
                );
              } else if (fieldKey == "dateAcquisition" ||
                  fieldKey == "dateDelivranceTypeOccupation") {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomFormField(
                    labelText: fieldKey, 
                    controller: widget.controllers[fieldKey],
                    suffixIcon: Icon(Icons.calendar_today, color: Colors.grey),
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
                        widget.controllers[fieldKey]?.text = formattedDate;
                      }
                    },
                  ),
                );
              } else if (fieldKey == "commentaire") {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomFormField(
                    maxLines: null,
                    labelText: fieldKey, 
                    controller: widget.controllers[fieldKey],

                  ),
                );
              } else if (fieldKey == "photos") {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        labelText!,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sélectionner des images',
                            style: TextStyle(fontSize: 10),
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
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                color: Color(0xFFC3AD65),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.file_upload,
                                color: Colors.white,
                                size: 18,
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
                  child: CustomFormField(
                    labelText: fieldKey, 
                    controller: widget.controllers[fieldKey],
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, 
                    ],
                    validator: (val) {
                      if(val != null && !val.isValidNumber) {
                        return 'Veuiller saisir un nombre valide';
                      }
                      return null;
                    },

                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          labelText!,
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                        ),
                      Row(
                        children: ["Oui", "Non"].map((option) {
                          return Flexible(
                            child: RadioListTile<String>(
                              title: Text(option, style: TextStyle(fontSize:10),),
                              value: option,
                              groupValue: widget.radioBien[fieldKey],
                              onChanged: (String? value) {
                                setState(() {
                                  widget.radioBien[fieldKey] = value;
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CheckboxListTile(
                              title: Text("Jardin", style: TextStyle(fontSize: 10),),
                              value: isJardinSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  isJardinSelected = value ?? false;
                                  jardinValue = isJardinSelected ? 'Oui' : 'Non';
                                });
                              },
                            ),
                            CheckboxListTile(
                              title: Text("Piscine", style: TextStyle(fontSize: 10),),
                              value: isPiscineSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  isPiscineSelected = value ?? false;
                                  piscineValue = isPiscineSelected ? 'Oui' : 'Non';
                                });
                              },
                            ),
                            CheckboxListTile(
                              title: Text("Cours de tennis", style: TextStyle(fontSize: 10),),
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
                              title: Text("Cours gazonnée", style: TextStyle(fontSize: 10),),
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
                              title: Text("Terrain de golf privé", style: TextStyle(fontSize: 10),),
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
                              title: Text("Autre", style: TextStyle(fontSize: 10),),
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
           
          ],
        ),
      ),
      );
      
    
    
  }
}
