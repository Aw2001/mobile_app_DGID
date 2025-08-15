import 'package:mobile_data_collection/model/locataire.dart';
import 'package:mobile_data_collection/screens/formulaire/custom_form_field.dart';
import 'package:mobile_data_collection/service/locataire_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_data_collection/utils/extensions.dart';

import '../../utils/constants.dart';

class BuildFieldLocataire extends StatefulWidget {
  
  final List<Map<String, String>> fields;
  final Map<String, TextEditingController> controllers;
  final Map<String, String?> dropdownLocataire;
  const BuildFieldLocataire({super.key, required this.controllers, required this.fields, required this.dropdownLocataire});

  @override
  BuildFieldLocataireState createState() => BuildFieldLocataireState();
}

class BuildFieldLocataireState extends State<BuildFieldLocataire> {
  final LocataireService locataireService = LocataireService();
  bool allValuesValid = true;

  // Dropdown options for specific fields
  final Map<String, List<String>> dropdownItems = {
    "denomination": ['Personne physique', 'Personne morale'],
    "typeOccupation": ['Résidentiel', 'Commercial', 'Mixte'],
  };

  void ajouterLocataire(Map<String, TextEditingController> controllerLocataire, Map<String, String?> dropdownLocataire) async {
    
    controllerLocataire.forEach((key, controller) {
        String? value = controller.text.trim();

        if (value == null) {
          print('Clé: $key, Valeur: (nulle)');
          allValuesValid = false;
        } else {
          
        }
      });
    // Données à envoyer
    if (allValuesValid) {
      final Locataire locataireData = Locataire(
      // Autres champs récupérés des contrôleurs
      cni: controllerLocataire["cni"]?.text.trim(),
      nom: controllerLocataire["nom"]?.text.trim(),
      prenom: controllerLocataire["prenom"]?.text.trim(),
      telephone: controllerLocataire["telephone"]?.text.trim(),
      typeOccupation: dropdownLocataire["typeOccupation"] ??
          controllerLocataire["typeOccupation"]?.text.trim(),
      dateSignatureContrat:
          controllerLocataire["dateSignatureContrat"]?.text.trim() != null &&
                  controllerLocataire["dateSignatureContrat"]!.text.trim().isNotEmpty
              ? DateTime.tryParse(controllerLocataire["dateSignatureContrat"]!.text.trim())
              : null,
      loyerAnnuel: double.tryParse(controllerLocataire["loyerAnnuel"]?.text.trim() ?? "0"),
      nbPieceOccupe: int.tryParse(controllerLocataire["nbPieceOccupe"]?.text.trim() ?? "0"),
      activiteEconomique: controllerLocataire["activiteEconomique"]?.text.trim(),
      denomination: dropdownLocataire["denomination"] ??
          controllerLocataire["denomination"]?.text.trim(),
      commentaire: controllerLocataire["commentaire"]?.text.trim(),
    );
    final int? locataireTrouve =
        await locataireService.retournerLocataire(locataireData.cni);

    if (locataireTrouve == 0) {
      try {
        await locataireService.ajouterLocataire(
           controllerLocataire["matricule"]?.text.trim(), locataireData);

        print("Locataire ajouté avec succès !");
      } catch (e) {
        print("Erreur lors de l'ajout du locataire : $e");
      }
    } else {
      try {
        await locataireService.mettreAJourLocataire(locataireData);

        print("Locataire modifié avec succès !");
      } catch (e) {
        print("Erreur lors de la modification des infos du locataire : $e");
      }
    }
    }
    
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        ...widget.fields.map((field) {
          String fieldKey = field["key"]!;
          String? labelText = field["label"];

          if (dropdownItems.containsKey(fieldKey)) {
           return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: constraints.maxWidth - 18.0, // Prend toute la largeur disponible du parent
                  child: DropdownButtonFormField<String>(
                    value: widget.dropdownLocataire[fieldKey],
                    hint: Text(labelText!, style: TextStyle(fontSize: 10),),
                    items: dropdownItems[fieldKey]!.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(fontSize: 10),),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.dropdownLocataire[fieldKey] = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 254, 251),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: const BorderSide(color: Color(0xFFC3AD65)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                );
              },
            ),
          );

          } else if (fieldKey == "dateSignatureContrat") {
              return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
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
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: CustomFormField(
                maxLines: null,
                labelText: fieldKey, 
                controller: widget.controllers[fieldKey],

              ),
            );
          } else if (fieldKey == 'nbPieceOccupe') {
              return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: CustomFormField(
                labelText: fieldKey, 
                controller: widget.controllers[fieldKey],
                inputFormatters: [
                  FilteringTextInputFormatter
                      .digitsOnly, // Permet uniquement les chiffres
                ],
                  validator: (val) {
                    if(val == null || val.trim().isEmpty) {
                      return null;
                    }
                    else if(!val.trim().isValidNumber) {
                      return 'Veuiller saisir un nombre valide'; 
                    }
                    else {
                      return null;
                    }
                    
                  },
              ),
            );
          } else if (fieldKey == 'prenom' || fieldKey == 'nom') {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: CustomFormField(
                  labelText: fieldKey, 
                  controller: widget.controllers[fieldKey],
                  inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r"[a-zA-Z]+|\s"),
                      )
                    ],
                    validator: (val) {
                      if(val == null || val.trim().isEmpty) {
                        return null;
                      }
                      else if(!val.trim().isValidName) {
                        return 'Veuiller saisir un nom valide'; 
                      }
                      else {
                        return null;
                      }
                      
                    },
                ),
              );
          } else if (fieldKey == 'telephone') {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: CustomFormField(
                labelText: fieldKey,
                controller: widget.controllers[fieldKey],
                validator: (val) {
                  if(val == null || val.trim().isEmpty) {
                      return null;
                    }
                    else if(!val.trim().isValidPhone) {
                      return 'Veuiller saisir un numéro de téléphone valide'; 
                    }
                    else {
                      return null;
                    }
                },
                ),
              );
          } else if(fieldKey == 'cni') {
              String labelText = fieldKey == "cni" ? "$fieldKey" : fieldKey;
              return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: CustomFormField(
                labelText: labelText,
                controller: widget.controllers[fieldKey],
                validator: (val) {
                  if(val == null || val.trim().isEmpty) {
                      return 'Ce champ est obligatoire';
                    }
                    else if(!val.trim().isValidCni) {
                      return 'Veuiller saisir un cni valide'; 
                    }
                    else {
                      return null;
                    }
                },),
            );
          } else {
              return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: CustomFormField(
                labelText: fieldKey, 
                controller: widget.controllers[fieldKey],

              ),
            );
          }
        }),
       
      ]),
    );
  }
}
