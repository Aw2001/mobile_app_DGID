import 'package:mobile_data_collection/model/proprietaire.dart';
import 'package:mobile_data_collection/screens/form_screen/send_button_proprietaire.dart';
import 'package:mobile_data_collection/service/proprietaire_service.dart';
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

  // Configuration of fields for Proprietaire with dropdowns and radio buttons
  final List<Map<String, String>> _fieldsProprietaire = [
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

  // Dropdown options for specific fields
  final Map<String, List<String>> dropdownItems = {
    "typeIdentification": ['CNI', 'N/A', 'Passport'],
    "statut": ['Personne physique', 'Personne morale', 'N/A'],
  };

  void ajouterProprietaire(ProprietaireService proprietaireService) async {
    // Données à envoyer
    final Proprietaire proprietaireData = Proprietaire(
      // Autres champs récupérés des contrôleurs
      numIdentifiant: _controllers["numeroIdentification"]?.text,
      nom: _controllers["nom"]?.text,
      prenom: _controllers["prenom"]?.text,
      email: _controllers["email"]?.text,
      typeIdentifiant: _selectedDropdownValues["typeIdentification"] ??
          _controllers["typeIdentification"]?.text,
      dateNaissance: _controllers["dateNaissance"]?.text != null &&
              _controllers["dateNaissance"]!.text.isNotEmpty
          ? DateTime.tryParse(_controllers["dateNaissance"]!.text)
          : null,
      lieuNaissance: _controllers["lieuNaissance"]?.text,
      dateDelivranceIdentifiant: _controllers["dateDelivrance"]?.text != null &&
              _controllers["dateDelivrance"]!.text.isNotEmpty
          ? DateTime.tryParse(_controllers["dateDelivrance"]!.text)
          : null,
      dateExpirationIdentifiant: _controllers["dateExpiration"]?.text != null &&
              _controllers["dateExpiration"]!.text.isNotEmpty
          ? DateTime.tryParse(_controllers["dateExpiration"]!.text)
          : null,
      statut: _selectedDropdownValues["statut"] ?? _controllers["statut"]?.text,
      salarie: _selectedRadioValues["propSalarie"] ??
          _controllers["propSalarie"]?.text,
      civilite: _controllers["civilite"]?.text,
      ninea: _controllers["ninea"]?.text,
      rencontre: _selectedRadioValues["propRencontre"] ??
          _controllers["propRencontre"]?.text,
      telephone: _controllers["telephone"]?.text,
      telephoneContribuable: _controllers["telephoneContribuable"]?.text,
      valeurLocativeProprietaire:
          double.tryParse(_controllers["valeurLocativeMensuelle"]?.text ?? "0"),
      enregistre: _selectedRadioValues["enregistreCgf"] ??
          _controllers["enregistreCgf"]?.text,
      pensionne: _selectedRadioValues["propPensionne"] ??
          _controllers["propPensionne"]?.text,
      autrePropriete: _selectedRadioValues["dautresProp"] ??
          _controllers["dautresProp"]?.text,
    );
    final int? proprietaireTrouve = await proprietaireService
        .retournerProprietaire(proprietaireData.numIdentifiant);

    if (proprietaireTrouve == 0) {
      try {
        await proprietaireService.ajouterProprietaire(proprietaireData);

        print("Proprietaire ajouté avec succès !");
      } catch (e) {
        print("Erreur lors de l'ajout du proprietaire : $e");
      }
    } else if (proprietaireTrouve == 1) {
      print(proprietaireTrouve);
      try {
        await proprietaireService.mettreAJourProprietaire(proprietaireData);

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
        SendButtonProprietaire(
          emailController: _controllers['email']!,
          onPressed:
              ajouterProprietaire, // Passez une référence à la méthode ajouterBien.
          apiUrl: "http://10.0.2.2:8081/api/proprietaires", // URL de l'API.
        ),
      ]),
    );
  }
}
