import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class DropdownsWidget extends StatefulWidget {
  const DropdownsWidget({super.key});

  @override
  _DropdownsWidgetState createState() => _DropdownsWidgetState();
}

class _DropdownsWidgetState extends State<DropdownsWidget> {
  String? selectedRegionId;
  String? selectedDepartmentId;
  String? selectedCommuneId;
  String? selectedSectionId;
  String? selectedParcelId;

  List<Map<String, String>> regions = [];
  List<Map<String, String>> departments = [];
  List<Map<String, String>> communes = [];
  List<String> sections = [];
  List<Map<String, String>> parcels = [];

  @override
  void initState() {
    super.initState();
    fetchRegions();  // Charger les régions au démarrage
  }

  // Fonction pour récupérer les régions depuis l'API
  Future<void> fetchRegions() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8081/api/regions/all'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        regions = data.map<Map<String, String>>((region) => {
          'id': region['id'].toString(),
          'name': region['reg'].toString(),
        }).toList();
      });
    }
  }

  // Fonction pour récupérer les départements d'une région
  Future<void> fetchDepartments(String regionId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8081/api/departements/region/$regionId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        departments = data.map<Map<String, String>>((dep) => {
          'id': dep['id'].toString(),
          'name': dep['nomDepart']
        }).toList();
      });
    }
  }

  // Fonction pour récupérer les communes d'un département
  Future<void> fetchCommunes(String departmentId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8081/api/communes/departement/$departmentId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        communes = data.map<Map<String, String>>((com) => {
          'id': com['id'].toString(),
          'name': com['nomCommun']
        }).toList();
      });
    }
  }

  // Fonction pour récupérer les sections d'une commune
  Future<void> fetchSections(String communeName) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8081/api/parcelles/$communeName/sections'));
    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      final List<dynamic> data = jsonDecode(response.body);
      // Afficher la réponse pour déboguer
      print('Sections data: $data');
       setState(() {
      // Les sections sont simplement des chaînes de caractères
      sections = data.map<String>((sec) => sec.toString()).toList();
    });
    }
  }

  // Fonction pour récupérer les parcelles d'une section
  Future<void> fetchParcels(String communeName, String sectionNumber) async {
    final encodedCommuneName = Uri.encodeComponent(communeName);
    final encodedSectionNumber = Uri.encodeComponent(sectionNumber);
    final response = await http.get(Uri.parse('http://10.0.2.2:8081/api/parcelles/$encodedCommuneName/$encodedSectionNumber'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        parcels = data.map<Map<String, String>>((par) => {
          'id': par['id'].toString(),
          'name': par['numParc']
        }).toList();
      });
    }
  }
String selectedCommuneName = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildDropdown(
            label: 'Sélectionnez une région',
            value: selectedRegionId,
            items: regions,
            onChanged: (String? newValue) {
              setState(() {
                selectedRegionId = newValue;
                selectedDepartmentId = null;
                selectedCommuneId = null;
                selectedSectionId = null;
                selectedParcelId = null;
                departments.clear();
                communes.clear();
                sections.clear();
                parcels.clear();
              });
              if (newValue != null) {
                fetchDepartments(newValue);  // Charger les départements de la région sélectionnée
              }
            },
            isEnabled: regions.isNotEmpty, // Active si la liste des régions est non vide
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            label: 'Sélectionnez un département',
            value: selectedDepartmentId,
            items: departments,
            onChanged: (String? newValue) {
              setState(() {
                selectedDepartmentId = newValue;
                selectedCommuneId = null;
                selectedSectionId = null;
                selectedParcelId = null;
                communes.clear();
                sections.clear();
                parcels.clear();
              });
              if (newValue != null) {
                fetchCommunes(newValue);  // Charger les communes du département sélectionné
              }
            },
            isEnabled: departments.isNotEmpty, // Active seulement si la liste des départements est non vide
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            label: 'Sélectionnez une commune',
            value: selectedCommuneId,
            items: communes,
            onChanged: (String? newValue) {
              setState(() {
                selectedCommuneId = newValue;
                selectedSectionId = null;
                selectedParcelId = null;
                sections.clear();
                parcels.clear();

                // Met à jour le nom de la commune sélectionnée
                if (newValue != null) {
                  // Débogage : afficher le nouvel ID de la commune
                  print("Nouvelle commune ID: $newValue");

                  final selectedCommune = communes.firstWhere(
                    (commune) => commune['id'] == newValue,
                    orElse: () => <String, String>{},  // Ajout d'une sécurité pour éviter une erreur si aucun élément n'est trouvé
                  );

                  if (selectedCommune.isNotEmpty) {
                    print("Selected Commune Data: $selectedCommune");
                    selectedCommuneName = selectedCommune['name']?? '';
                    print("Nom de la commune sélectionnée: $selectedCommuneName");
                  } else {
                    print("Commune non trouvée pour l'ID: $newValue");
                  }

                }
              });

              // Charger les sections de la commune sélectionnée
              if (selectedCommuneName.isNotEmpty) {
                fetchSections(selectedCommuneName); // Utiliser le nom de la commune
              }

            },
            isEnabled: communes.isNotEmpty, // Active si la liste des communes est non vide
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            label: 'Sélectionnez une section',
            value: selectedSectionId,
            stringItems: sections, // sections contient directement les numéros de section
            onChanged: (String? newValue) {
              setState(() {
                selectedSectionId = newValue;
                selectedParcelId = null;
                parcels.clear();

                if (newValue != null) {
                  // Appeler fetchParcels avec le nom de la commune et le numéro de section
                  fetchParcels(selectedCommuneName, newValue); // newValue est le numéro de section
                }
              });
            },
            isEnabled: sections.isNotEmpty, // Active si la liste des sections est non vide
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            label: 'Sélectionnez une parcelle',
            value: selectedParcelId,
            items: parcels,
            onChanged: (String? newValue) {
              setState(() {
                selectedParcelId = newValue;
              });
            },
            isEnabled: parcels.isNotEmpty, // Active si la liste des parcelles est non vide
          ),
        ],
      ),
    );
  }

  // Fonction générique pour créer un DropdownButton
  Widget _buildDropdown({
    required String label,
    required String? value,
    List<Map<String, String>> items = const[],
    List<String> stringItems = const [],
    required ValueChanged<String?> onChanged,
    required bool isEnabled, // Nouveau paramètre pour indiquer si le Dropdown est activé ou non
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: label,
          fillColor: isEnabled ? Colors.white : Colors.grey[300], // Grise si désactivé
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: isEnabled ? Colors.grey : Colors.grey[400]!, width: 1.5),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1.5),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        value: value,
        items: isEnabled
          ? (items.isNotEmpty 
              ? items.map((item) => DropdownMenuItem<String>(
                  value: item['id'],
                  child: Text(item['name']!),
                )).toList()
              : stringItems.map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                )).toList())
          : [],
        
        onChanged: isEnabled ? onChanged : null, // Désactive si isEnabled est faux
        
      ),
    );
  }
}
