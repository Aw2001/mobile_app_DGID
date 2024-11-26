import 'package:flutter/material.dart';

class BuildFieldLocataire extends StatefulWidget {
  const BuildFieldLocataire({super.key});

  @override
  BuildFieldLocataireState createState() => BuildFieldLocataireState();
}

class BuildFieldLocataireState extends State<BuildFieldLocataire> {
  final Map<String, TextEditingController> _controllers = {};

  final List<Map<String, String>> _fieldsLocataire = [
    {"label": "Prénom", "key": "prenom"},
    {"label": "Nom", "key": "nom"},
    {"label": "Téléphone", "key": "telephone"},
  ];

  @override
  void initState() {
    super.initState();

    for (var field in _fieldsLocataire) {
      if (field["key"] != null) {
        _controllers[field["key"]!] = TextEditingController();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _fieldsLocataire.map((field) {
        String fieldKey = field["key"]!;
        String? labelText = field["label"];

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
      }).toList(),
    );
  }
}
