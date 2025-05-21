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
  
  
  final ProprietaireService _proprietaireService = ProprietaireService();

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
      numIdentifiant: controllerProp["numeroIdentification"]?.text.trim(),
      nom: controllerProp["nom"]?.text.trim(),
      prenom: controllerProp["prenom"]?.text.trim(),
      email: controllerProp["email"]?.text.trim(),
      typeIdentifiant: dropdownProprietaire["typeIdentification"] ??
          controllerProp["typeIdentification"]?.text.trim(),
      dateNaissance: controllerProp["dateNaissace"]?.text.trim() != null &&
              controllerProp["dateNaissance"]!.text.trim().isNotEmpty
          ? DateTime.tryParse(controllerProp["dateNaissance"]!.text.trim())
          : null,
      lieuNaissance: controllerProp["lieuNaissance"]?.text.trim(),
      dateDelivranceIdentifiant: controllerProp["dateDelivrance"]?.text.trim() != null &&
              controllerProp["dateDelivrance"]!.text.trim().isNotEmpty
          ? DateTime.tryParse(controllerProp["dateDelivrance"]!.text.trim())
          : null,
      dateExpirationIdentifiant: controllerProp["dateExpiration"]?.text.trim() != null &&
              controllerProp["dateExpiration"]!.text.trim().isNotEmpty
          ? DateTime.tryParse(controllerProp["dateExpiration"]!.text.trim())
          : null,
      statut: dropdownProprietaire["statut"] ?? controllerProp["statut"]?.text.trim(),
      salarie: radioProprietaire["propSalarie"] ??
          controllerProp["propSalarie"]?.text.trim(),
      civilite: controllerProp["civilite"]?.text.trim(),
      ninea: controllerProp["ninea"]?.text.trim(),
      rencontre: radioProprietaire["propRencontre"] ??
          controllerProp["propRencontre"]?.text.trim(),
      telephone: controllerProp["telephone"]?.text.trim(),
      telephoneContribuable: controllerProp["telephoneContribuable"]?.text.trim(),
      valeurLocativeProprietaire:
          double.tryParse(controllerProp["valeurLocativeMensuelle"]?.text.trim() ?? "0"),
      enregistre: radioProprietaire["enregistreCgf"] ??
          controllerProp["enregistreCgf"]?.text.trim(),
      pensionne: radioProprietaire["propPensionne"] ??
          controllerProp["propPensionne"]?.text.trim(),
      autrePropriete: radioProprietaire["dautresProp"] ??
          controllerProp["dautresProp"]?.text.trim(),
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
                        hint: Text(labelText!, style: TextStyle(fontSize: 10)),
                        items: dropdownItems[fieldKey]!.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyle(fontSize: 10),),
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
                    if(val == null || val.trim().isEmpty) {
                      return null;
                    }
                    else if(!val.trim().isValidName) {
                      return 'Il doit contenir que des lettres'; 
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
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                  LengthLimitingTextInputFormatter(9), 
                ],
                validator: (val) {
                  if(val == null || val.trim().isEmpty) {
                      return null;
                    }
                    else if(!val.trim().isValidPhone) {
                      return 'Il doit contenir 9 chiffres'; 
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
                    if (fieldKey == "numeroIdentification" ) {
                      
                      if((val!.trim().isEmpty)){
                        return "Ce champ est obligatoire";
                      } else if (!val.trim().isValidCni) {
                          return 'Il doit contenir 13 ou 14 chiffres';
                      }
                      
                    } 
                    return null; 
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
                  if(val == null || val.trim().isEmpty) {
                      return null;
                    }
                    else if(!val.trim().isValidEmail) {
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
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                  ),
                  Row(
                    children: ["Oui", "Non"].map((option) {
                      return Expanded(
                        child: RadioListTile<String>(
                          title: Text(option, style: TextStyle(fontSize: 10),),
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
