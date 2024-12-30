import 'package:mobile_data_collection/model/locataire.dart';
import 'package:mobile_data_collection/screens/form_screen/send_button_locataire.dart';
import 'package:mobile_data_collection/service/locataire_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BuildFieldLocataire extends StatefulWidget {
  const BuildFieldLocataire({super.key});

  @override
  BuildFieldLocataireState createState() => BuildFieldLocataireState();
}

class BuildFieldLocataireState extends State<BuildFieldLocataire> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String?> _selectedDropdownValues = {};

  // Configuration of fields for Locataire with dropdowns and radio buttons
  final List<Map<String, String>> _fieldsLocataire = [
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

  // Dropdown options for specific fields
  final Map<String, List<String>> dropdownItems = {
    "denomination": ['Personne physique', 'Entité'],
    "typeOccupation": ['Résidentiel', 'Commercial', 'Mixte'],
  };

  void ajouterLocataire(LocataireService locataireService) async {
    // Données à envoyer
    final Locataire locataireData = Locataire(
      // Autres champs récupérés des contrôleurs
      cni: _controllers["cni"]?.text,
      nom: _controllers["nom"]?.text,
      prenom: _controllers["prenom"]?.text,
      telephone: _controllers["telephone"]?.text,
      typeOccupation: _selectedDropdownValues["typeOccupation"] ??
          _controllers["typeOccupation"]?.text,
      dateSignatureContrat:
          _controllers["dateSignatureContrat"]?.text != null &&
                  _controllers["dateSignatureContrat"]!.text.isNotEmpty
              ? DateTime.tryParse(_controllers["dateSignatureContrat"]!.text)
              : null,
      loyerAnnuel: double.tryParse(_controllers["loyerAnnuel"]?.text ?? "0"),
      nbPieceOccupe: int.tryParse(_controllers["nbPieceOccupe"]?.text ?? "0"),
      activiteEconomique: _controllers["activiteEconomique"]?.text,
      denomination: _selectedDropdownValues["denomination"] ??
          _controllers["denomination"]?.text,
      commentaire: _controllers["commentaire"]?.text,
    );
    final int? locataireTrouve =
        await locataireService.retournerLocataire(locataireData.cni);

    if (locataireTrouve == 0) {
      try {
        await locataireService.ajouterLocataire(
            _controllers["matricule"]?.text, locataireData);

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

  @override
  void initState() {
    super.initState();

    // Initialiser les contrôleurs et les états d'expansion
    for (var field in _fieldsLocataire) {
      if (field["key"] != null) {
        _controllers[field["key"]!] = TextEditingController();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        ..._fieldsLocataire.map((field) {
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
          } else if (fieldKey == "dateSignatureContrat") {
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
          } else if (fieldKey == 'nbPieceOccupe') {
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
        }),
        SendButtonLocataire(
          onPressed:
              ajouterLocataire, // Passez une référence à la méthode ajouterBien.
          apiUrl: "http://10.0.2.2:8081/api/locataires", // URL de l'API.
        ),
      ]),
    );
  }
}
