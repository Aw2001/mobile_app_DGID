import 'package:mobile_data_collection/model/proprietaire.dart';
import 'package:mobile_data_collection/screens/formulaire/custom_form_field.dart';
import 'package:mobile_data_collection/service/proprietaire_service.dart';
import 'package:flutter/material.dart';
import 'package:mobile_data_collection/utils/exports.dart';
import 'package:mobile_data_collection/utils/extensions.dart';

class BuildFieldProprietaire extends StatefulWidget {
  final List<Map<String, String>> fields;
  final Map<String, TextEditingController> controllers;
  final Map<String, String?> dropdownProprietaire;
  final Map<String, String?> radioProprietaire;
  const BuildFieldProprietaire({super.key, required this.fields, required this.controllers, required this.dropdownProprietaire, required this.radioProprietaire});

  @override
  BuildFieldProprietaireState createState() => BuildFieldProprietaireState();

  

 
}

class BuildFieldProprietaireState extends State<BuildFieldProprietaire> {
  
  
  final ProprietaireService _proprietaireService = ProprietaireService("http://10.0.2.2:8081/api/proprietaires");

  // Configuration of fields for Proprietaire with dropdowns and radio buttons
  

  // Dropdown options for specific fields
  final Map<String, List<String>> dropdownItems = {
    "typeIdentification": ['CNI', 'N/A', 'Passport'],
    "statut": ['Personne physique', 'Personne morale', 'N/A'],
  };

  void ajouterProprietaire(Map<String, TextEditingController> controllerProp, Map<String, String?> dropdownProprietaire, Map<String, String?> radioProprietaire) async {
    // Données à envoyer
    final Proprietaire proprietaireData = Proprietaire(
      // Autres champs récupérés des contrôleurs
      numIdentifiant: controllerProp["numeroIdentification"]?.text,
      nom: controllerProp["nom"]?.text,
      prenom: controllerProp["prenom"]?.text,
      email: controllerProp["email"]?.text,
      typeIdentifiant: dropdownProprietaire["typeIdentification"] ??
          controllerProp["typeIdentification"]?.text,
      dateNaissance: controllerProp["dateNaissace"]?.text != null &&
              controllerProp["dateNaissance"]!.text.isNotEmpty
          ? DateTime.tryParse(controllerProp["dateNaissance"]!.text)
          : null,
      lieuNaissance: controllerProp["lieuNaissance"]?.text,
      dateDelivranceIdentifiant: controllerProp["dateDelivrance"]?.text != null &&
              controllerProp["dateDelivrance"]!.text.isNotEmpty
          ? DateTime.tryParse(controllerProp["dateDelivrance"]!.text)
          : null,
      dateExpirationIdentifiant: controllerProp["dateExpiration"]?.text != null &&
              controllerProp["dateExpiration"]!.text.isNotEmpty
          ? DateTime.tryParse(controllerProp["dateExpiration"]!.text)
          : null,
      statut: dropdownProprietaire["statut"] ?? controllerProp["statut"]?.text,
      salarie: radioProprietaire["propSalarie"] ??
          controllerProp["propSalarie"]?.text,
      civilite: controllerProp["civilite"]?.text,
      ninea: controllerProp["ninea"]?.text,
      rencontre: radioProprietaire["propRencontre"] ??
          controllerProp["propRencontre"]?.text,
      telephone: controllerProp["telephone"]?.text,
      telephoneContribuable: controllerProp["telephoneContribuable"]?.text,
      valeurLocativeProprietaire:
          double.tryParse(controllerProp["valeurLocativeMensuelle"]?.text ?? "0"),
      enregistre: radioProprietaire["enregistreCgf"] ??
          controllerProp["enregistreCgf"]?.text,
      pensionne: radioProprietaire["propPensionne"] ??
          controllerProp["propPensionne"]?.text,
      autrePropriete: radioProprietaire["dautresProp"] ??
          controllerProp["dautresProp"]?.text,
    );
    final int? proprietaireTrouve = await _proprietaireService
        .retournerProprietaire(proprietaireData.numIdentifiant);

    if (proprietaireTrouve == 0) {
      try {
        print(controllerProp['numeroIdentification']);
        await _proprietaireService.ajouterProprietaire(proprietaireData);

        print("Proprietaire ajouté avec succès !");
      } catch (e) {
        print("Erreur lors de l'ajout du proprietaire : $e");
      }
    } else if (proprietaireTrouve == 1) {
      print(proprietaireTrouve);
      try {
        await _proprietaireService.mettreAJourProprietaire(proprietaireData);

        print("Proprietaire modifié avec succès !");
      } catch (e) {
        print("Erreur lors de la modification du proprietaire : $e");
      }
    } else {
      print("Pas d'ajout ni de modification");
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialiser les contrôleurs et les états d'expansion
    for (var field in widget.fields) {
      if (field["key"] != null) {
        widget.controllers[field["key"]!] = TextEditingController();
      }
    }
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
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                     width: constraints.maxWidth - 18.0,
                     child: DropdownButtonFormField<String>(
                        value: widget.dropdownProprietaire[fieldKey],
                        hint: Text(labelText!),
                        items: dropdownItems[fieldKey]!.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            widget.dropdownProprietaire[fieldKey] = newValue;
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
                }
              ),
              
            );
          } else if (fieldKey == "prenom" || fieldKey == "nom") {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CustomFormField(
                labelText: fieldKey, 
                controller: widget.controllers[fieldKey],
                inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r"[a-zA-Z]+|\s"),
                    )
                  ],
                  validator: (val) {
                    if(val == null || val.isEmpty) {
                      return null;
                    }
                    else if(!val.isValidName) {
                      return 'Veuiller saisir un nom valide'; 
                    }
                    else {
                      return null;
                    }
                    
                  },
              ),
            );
          } else if (fieldKey == "telephone" || fieldKey == "telephoneContribuable") {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CustomFormField(
                labelText: fieldKey,
                controller: widget.controllers[fieldKey]!,
                validator: (val) {
                  if(val == null || val.isEmpty) {
                      return null;
                    }
                    else if(!val.isValidPhone) {
                      return 'Veuiller saisir un numéro de téléphone valide'; 
                    }
                    else {
                      return null;
                    }
                },
                ),
            );
          } else if (fieldKey == "lieuNaissance" || fieldKey == "ninea" || fieldKey == "numeroIdentification" || fieldKey == "valeurLocativeMensuelle") {
              String labelText = fieldKey == "numeroIdentification" ? "$fieldKey (obligatoire)" : fieldKey;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CustomFormField(
                  labelText: labelText,
                  controller: widget.controllers[fieldKey],
                  validator: (val) {
                    if (fieldKey == "numeroIdentification" && (val!.isEmpty)) {
                      return "Ce champ est obligatoire";
                    }
                    return null; // Pas d'erreur pour les autres champs
                  },
                ),
              );
          }
          else if (fieldKey == "email") {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CustomFormField(
                labelText: fieldKey,
                controller: widget.controllers[fieldKey]!,
                validator: (val) {
                  if(val == null || val.isEmpty) {
                      return null;
                    }
                    else if(!val.isValidEmail) {
                      return 'Veuiller saisir un email valide'; 
                    }
                    else {
                      return null;
                    }
                },),
            );
            
          } else if (fieldKey == "dateDelivrance" ||
              fieldKey == "dateExpiration" ||
              fieldKey == "dateNaissance") {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CustomFormField(
                labelText: fieldKey, 
                controller: widget.controllers[fieldKey]!,
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
                controller: widget.controllers[fieldKey]!,

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
                          groupValue: widget.radioProprietaire[fieldKey],
                          onChanged: (String? value) {
                            setState(() {
                              widget.radioProprietaire[fieldKey] = value;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }
        }),
       
      ]),
    );
  }
}
