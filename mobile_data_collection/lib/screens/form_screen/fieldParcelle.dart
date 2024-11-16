import 'package:flutter/material.dart';

class BuildFieldParcelle extends StatefulWidget {
  const BuildFieldParcelle({super.key});

  @override
  _BuildFieldParcelleState createState() => _BuildFieldParcelleState();
}

class _BuildFieldParcelleState extends State<BuildFieldParcelle> {
  // Initialiser les contrôleurs pour les champs de texte
  final Map<String, TextEditingController> _controllers = {};

  // Valeurs des dropdowns
  final Map<String, String?> _selectedValues = {};

  // Configuration des champs de texte pour le Parcelle
  final List<Map<String, String>> _fieldsParcelle = [
    {"label": "NICAD", "key": "nicad"},
    {"label": "Type Parcelle", "key": "typeParcelle"},
    {"label": "Nom Voirie", "key": "nomVoirie"},
    {"label": "Type Voirie", "key": "typeVoirie"},
    {"label": "Nom Autre Voirie", "key": "nomAutreVoirie"},
    {"label": "Nom Rue", "key": "nomRue"},
    {"label": "Code Rue", "key": "codeRue"},
    {"label": "Quartier", "key": "quartier"},
    {"label": "Village", "key": "village"},
  ];

  // Valeurs des dropdowns spécifiques par champ
  final Map<String, List<String>> dropdownItems = {
    "typeParcelle": [
      'Usage scolaire',
      'Usage médical',
      'Usage religieux',
      'Service public',
      'Ouvrage pour une distribution en eau',
      'Ouvrage pour une distribution en électricité',
      'Bâtiment en chantier',
      'Parcelle elligible',
      'Terrain nu sans activité',
      'Terrain nu à usage commercial',
      'Terrain nu à usage industriel',
      'Autre'
    ],
    "typeVoirie": ['Rue', 'Boulevard', 'Allée', 'Avenue', 'Rocade', 'Autre'],
  };

  @override
  void initState() {
    super.initState();

    // Initialiser les contrôleurs et les états d'expansion
    for (var field in _fieldsParcelle) {
      if (field["key"] != null) {
        _controllers[field["key"]!] = TextEditingController();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _fieldsParcelle.map((field) {
        String fieldKey = field["key"]!;
        String? labelText = field["label"];

        // Vérifier si le champ est un Dropdown
        if (dropdownItems.containsKey(fieldKey)) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: DropdownButtonFormField<String>(
              value: _selectedValues[fieldKey],
              hint: Text(labelText!),
              items: dropdownItems[fieldKey]!.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                // Mise à jour de la valeur sélectionnée
                setState(() {
                  _selectedValues[fieldKey] = newValue;
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

        // Vérifier si le champ est un champ de texte multi-lignes
        if (fieldKey == "commentaire") {
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

        // Sinon, c'est un champ de texte standard
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
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
      }).toList(),
    );
  }
}
