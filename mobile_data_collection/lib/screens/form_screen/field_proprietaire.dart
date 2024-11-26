import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import 'field_locataire.dart';
import 'package:flutter/material.dart';

class BuildFieldProprietaire extends StatefulWidget {
  const BuildFieldProprietaire({super.key});

  @override
  BuildFieldProprietaireState createState() => BuildFieldProprietaireState();
}

class BuildFieldProprietaireState extends State<BuildFieldProprietaire> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String?> _selectedDropdownValues = {};
  final Map<String, String?> _selectedRadioValues = {};
  final List<MultiSelectItem<String>> bienOptions = [
    MultiSelectItem('bien1', 'AAFFL852'),
    MultiSelectItem('bien2', 'AASQH856'),
    MultiSelectItem('bien3', 'BVGHJ325'),
  ];

  // Configuration of fields for Proprietaire with dropdowns and radio buttons
  final List<Map<String, String>> _fieldsProprietaire = [
    {"label": "Matricule du bien", "key": "bien"},
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
    {"label": "Propriétaire salarié ?", "key": "propRencontre"},
    {"label": "Posséde t-il d'autres propriétés ?", "key": "dautresProp"},
    {"label": "Est-il enregistré pour la cgf ?", "key": "enregistreCgf"},
    {
      "label": "La propriété ou une partie est-elle en location ?",
      "key": "location"
    },
  ];

  // Dropdown options for specific fields
  final Map<String, List<String>> dropdownItems = {
    "typeIdentification": ['CNI', 'N/A', 'Passport'],
    "statut": ['Personne physique', 'Personne morale', 'N/A'],
  };

  @override
  void initState() {
    super.initState();

    // Initialiser les contrôleurs et les états d'expansion
    for (var field in _fieldsProprietaire) {
      if (field["key"] != null) {
        _controllers[field["key"]!] = TextEditingController();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        ..._fieldsProprietaire.map((field) {
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
          } else if (fieldKey == "bien") {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: MultiSelectDialogField(
                items: bienOptions,
                title: Text(labelText!),
                selectedColor: const Color(0xFFC3AD65),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 254, 251),
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                buttonIcon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey,
                ),
                buttonText: Text(
                  labelText,
                  style: const TextStyle(
                      color: Colors.grey, fontSize: 16, height: 2.6),
                ),
                onConfirm: (values) {
                  _controllers[fieldKey]?.text = values.join(", ");
                },
              ),
            );
          } else if (fieldKey == "prenom" ||
              fieldKey == "nom" ||
              fieldKey == "telephone" ||
              fieldKey == "lieuNaissance" ||
              fieldKey == "ninea" ||
              fieldKey == "numeroIdentification" ||
              fieldKey == "telephoneContribuable" ||
              fieldKey == "valeurLocativeMensuelle") {
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
          } else if (fieldKey == "email") {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                validator: (value) {
                  bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value!);
                  if (!emailValid) {
                    return 'Veuillez saisir une adresse email valide';
                  }

                  return null;
                },
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
          } else if (fieldKey == "dateDelivrance" ||
              fieldKey == "dateExpiration" ||
              fieldKey == "dateNaissance") {
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
                  children: ["Oui", "Non", "Je ne sais pas"].map((option) {
                    return Expanded(
                      child: RadioListTile<String>(
                        title: Text(option),
                        value: option,
                        groupValue: _selectedRadioValues[fieldKey],
                        onChanged: (String? value) {
                          setState(() {
                            _selectedRadioValues[fieldKey] = value;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 16.0),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              "Informations sur le locataire",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC3AD65),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        BuildFieldLocataire()
      ]),
    );
  }
}
