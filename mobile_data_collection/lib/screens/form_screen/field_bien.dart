import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BuildFieldBien extends StatefulWidget {
  const BuildFieldBien({super.key});

  @override
  BuildFieldBienState createState() => BuildFieldBienState();
}

class BuildFieldBienState extends State<BuildFieldBien> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String?> _selectedDropdownValues = {};
  final Map<String, String?> _selectedRadioValues = {};
  bool isPaysagerSelected = false;
  bool isPiscineSelected = false;
  bool isCoursGazonneeSelected = false;
  List<XFile>? _imageFiles = [];

  // Configuration of fields for Bien with dropdowns and radio buttons
  final List<Map<String, String>> _fieldsBien = [
    {"label": "Matricule", "key": "matricule"},
    {"label": "Numéro titre foncier", "key": "numTitreFoncier"},
    {"label": "Date d'acquisition", "key": "dateAcquisition"},
    {"label": "Numéro de porte", "key": "numeroPorte"},
    {"label": "Usage", "key": "usage"},
    {"label": "Numéro Lot", "key": "numeroLot"},
    {"label": "Niveau Lot", "key": "niveauLot"},
    {"label": "Type Lot", "key": "typeLot"},
    {"label": "Catégorie", "key": "categorie"},
    {"label": "Localisation Lot", "key": "localisationLot"},
    {"label": "Situation du Lot", "key": "situationLot"},
    {"label": "Type de clôture", "key": "typeCloture"},
    {"label": "Etat du clôture", "key": "etatCloture"},
    {"label": "Type de revêtement", "key": "typeRevetement"},
    {"label": "Etat du revêtement", "key": "etatRevetement"},
    {"label": "Situation de la Route", "key": "situationRoute"},
    {"label": "Type de la route", "key": "typeRoute"},
    {"label": "Garage", "key": "garage"},
    {"label": "Qualité portes et fenêtres", "key": "qualitePorteEtFenetre"},
    {"label": "Nombre de pièces", "key": "nbPieces"},
    {"label": "Nombre d'étages", "key": "nbEtage"},
    {"label": "Numéro du compteur d'eau", "key": "nbCompteurEau"},
    {
      "label": "Numéro du compteur d'électricité",
      "key": "nbCompteurElectricite"
    },
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
    {"label": "Carrelage présent ?", "key": "presenceCarrelage"},
    {"label": "Aménagement paysager présent ?", "key": "amenagementPaysager"},
    {"label": "Caméra présent ?", "key": "cameraPresent"},
    {"label": "Balcon présent ?", "key": "presenceBalcon"},
    {"label": "Terrasse présente ?", "key": "presenceTerrasse"},
    {"label": "Situé en angle ?", "key": "angle"},
    {"label": "Éclairage public disponible ?", "key": "eclairagePublic"},
    {"label": "Mur en ciment présent ?", "key": "murEnCiment"},
    {
      "label": "Attributs architecturaux présents ?",
      "key": "attributsArchitecturaux"
    },
    {"label": "Trottoir présent ?", "key": "trottoir"},
    {"label": "Avec étages ?", "key": "etages"},
  ];

  // Dropdown options for specific fields
  final Map<String, List<String>> dropdownItems = {
    "usage": ['Résidentiel', 'Commercial', 'Mixte'],
    "typeCloture": ['Mur', 'Mur avec fer forgé', 'Grillage', 'Absence'],
    "etatCloture": ['Très Bon', 'Bon', 'Moyen', 'Mauvais'],
    "typeRevetement": [
      'Carrelage',
      'Pierre',
      'Enduit simple',
      'Enduit wis',
      'Peinture',
      'Absence'
    ],
    "etatRevetement": ['Très bon', 'Bon', 'Moyen', 'Mauvais', 'Standard'],
    "situationRoute": [
      'Loin de la route principale',
      'Proche de la route principale',
      'Sur la route principale'
    ],
    "typeRoute": ['Goudron', 'Graviers', 'Pas de voirie', 'Pavés', 'Sable'],
    "garage": ['Simple', 'Double', 'Multiple', 'Absence'],
    "qualitePorteEtFenetre": [
      'Très bonne',
      'Bonne',
      'Moyenne',
      'Mauvaise',
      'Standard'
    ],
    "localisationLot": ['Gauche', 'Droite', 'Centre', 'Tout le niveau'],
    "situationLot": [
      'Totalité d\'un bâtiment',
      'Partie du bâtiment',
      'Totalité des bâtiments'
    ],
    "typeLot": ['Maison individuelle', 'Immeuble collectif', 'Copropriété'],
    "categorie": [
      'IC1',
      'IC2',
      'IC3',
      'IC4',
      'IC5',
      'IC6',
      'IC7',
      'MI1',
      'MI2',
      'MI3',
      'MI4',
      'MI5',
      'MI6',
      'MI7'
    ]
  };

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
      children: _fieldsBien.map((field) {
        String fieldKey = field["key"]!;
        String? labelText = field["label"];

        if (dropdownItems.containsKey(fieldKey)) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: DropdownButtonFormField<String>(
              value: _selectedDropdownValues[fieldKey],
              hint: Text(labelText!),
              items: dropdownItems[fieldKey]!.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDropdownValues[fieldKey] = newValue;
                  if (fieldKey == "typeLot") {
                    _selectedDropdownValues["categorie"] = null;
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
            ),
          );
        } else if (fieldKey == "matricule" ||
            fieldKey == "numTitreFoncier" ||
            fieldKey == "numeroLot" ||
            fieldKey == "niveauLot" ||
            fieldKey == "numeroPorte" ||
            fieldKey == "nbPieces" ||
            fieldKey == "nbEtage" ||
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
        } else if (fieldKey == "dateAcquisition") {
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
                if (_imageFiles != null && _imageFiles!.isNotEmpty)
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
        }
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
                              isCoursGazonneeSelected = false;
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
                      title: Text("Piscine"),
                      value: isPiscineSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          isPiscineSelected = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text("Cours gazonnée"),
                      value: isCoursGazonneeSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          isCoursGazonneeSelected = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
