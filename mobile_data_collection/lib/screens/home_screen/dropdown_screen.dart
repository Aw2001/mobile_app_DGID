import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'map_screen.dart';

class DropdownsWidget extends StatefulWidget {
  const DropdownsWidget({super.key, required this.mapScreenKey});
  final GlobalKey<MapScreenState> mapScreenKey;

  @override
  DropdownsWidgetState createState() => DropdownsWidgetState();
}

class DropdownsWidgetState extends State<DropdownsWidget> {
  String? selectedRegionId;
  String? selectedDepartmentId;
  String? selectedCommuneId;
  String? selectedSectionId;
  String? selectedParcelId;
  String selectedCommuneName = '';
  String selectedSectionNum = '';
  String selectedNicadParcel = '';
  String selectedRegionName = '';
  String selectedDepartementName = '';

  List<Map<String, String>> regions = [];
  List<Map<String, String>> departments = [];
  List<Map<String, String>> communes = [];
  List<Map<String, String>> sections = [];
  List<Map<String, String>> parcels = [];
  List<List<LatLng>> polygonPoints = [];

  @override
  void initState() {
    super.initState();
    fetchRegions(); // Charger les régions au démarrage
  }

  // Fonction pour récupérer les régions depuis l'API
  Future<void> fetchRegions() async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8080/geoserver/data_collection/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=data_collection%3ARegions&maxFeatures=50&outputFormat=application%2Fjson'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        regions = (data['features'] as List<dynamic>)
            .map<Map<String, String>>((feature) {
          final regionProperties = feature['properties'];
          return {
            'id': feature['id'].toString(),
            'name': regionProperties['nom'].toString(),
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load regions');
    }
  }

  // Fonction pour récupérer les départements d'une région
  Future<void> fetchDepartments(String regionId) async {
    final cleanedRegionId = regionId.replaceAll(RegExp(r'^Regions\.'), '');
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8080/geoserver/data_collection/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=data_collection%3ADepartements&maxFeatures=50&outputFormat=application%2Fjson&CQL_FILTER=region_id=$cleanedRegionId'));
    if (response.statusCode == 200) {
      if (response.headers['content-type']?.contains('application/json') ??
          false) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          departments = (data['features'] as List<dynamic>)
              .map<Map<String, String>>((feature) {
            final departementProperties = feature['properties'];
            return {
              'id': feature['id'].toString(),
              'name': departementProperties['nom'].toString()
            };
          }).toList();
        });
      } else {
        print(
            'Erreur : La réponse n\'est pas au format JSON. Voici la réponse :');
        print(response.body);
      }
    } else {
      throw Exception('Failed to load departments');
    }
  }

  // Fonction pour récupérer les communes d'un département
  Future<void> fetchCommunes(String departementId) async {
    final cleanedDepartmentId =
        departementId.replaceAll(RegExp(r'^Departements\.'), '');
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8080/geoserver/data_collection/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=data_collection%3ACommunes&maxFeatures=50&outputFormat=application%2Fjson&CQL_FILTER=departement_id=$cleanedDepartmentId'));
    if (response.statusCode == 200) {
      if (response.headers['content-type']?.contains('application/json') ??
          false) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          communes = (data['features'] as List<dynamic>)
              .map<Map<String, String>>((com) {
            return {
              'id': com['id'].toString(),
              'name': com['properties']['nom_commun'].toString()
            };
          }).toList();
        });
      } else {
        print(
            'Erreur : La réponse n\'est pas au format JSON. Voici la réponse :');
        print(response.body);
      }
    } else {
      throw Exception('Failed to load communes: ${response.statusCode}');
    }
  }

  // Fonction pour récupérer les sections d'une commune
  Future<void> fetchSections(String communeName) async {
    String encodedNom = Uri.encodeComponent(communeName);
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8080/geoserver/data_collection/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=data_collection%3ASections&maxFeatures=50&outputFormat=application%2Fjson&CQL_FILTER=nom_commune=%27$encodedNom%27'));

    if (response.statusCode == 200) {
      if (response.headers['content-type']?.contains('application/json') ??
          false) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          sections = (data['features'] as List<dynamic>)
              .map<Map<String, String>>((section) {
            final properties = section['properties'];

            return {
              'id': section['id'].toString(),
              'name': properties['numero_sec']?.toString() ?? '',
            };
          }).toList();
        });
      } else {
        print(
            'Erreur : La réponse n\'est pas au format JSON. Voici la réponse :');
        print(response.body);
      }
    } else {
      print('Erreur lors de la requête : ${response.statusCode}');
    }
  }

  // Fonction pour récupérer les parcelles d'une section
  Future<void> fetchParcels(String communeName, String sectionNumber) async {
    final encodedCommuneName = Uri.encodeComponent(communeName);
    final encodedSectionNumber = Uri.encodeComponent(sectionNumber);
    var cleanedParcelleId;

    final url = Uri.parse(
        'http://10.0.2.2:8080/geoserver/data_collection/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=data_collection%3AParcelles&maxFeatures=50&outputFormat=application%2Fjson&CQL_FILTER=nom_commun%20=%20%27$encodedCommuneName%27%20and%20num_sect=%27$encodedSectionNumber%27');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      if (response.headers['content-type']?.contains('application/json') ??
          false) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          parcels = (data['features'] as List<dynamic>)
              .map<Map<String, String>>((parcel) {
            cleanedParcelleId =
                parcel['id'].replaceAll(RegExp(r'^Parcelles\.'), '');
            return {
              'id': parcel['id'].toString(),
              'name': cleanedParcelleId.toString()
            };
          }).toList();
        });
      }
    }
  }

  //Fonction pour recupérer les données GeoJSON de la région à partir du WFS
  Future<void> fetchGeoJsonRegion(String nom) async {
    String wfsUrl =
        'http://10.0.2.2:8080/geoserver/data_collection/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=data_collection%3ARegions&maxFeatures=50&outputFormat=application%2Fjson&CQL_FILTER=nom=%27$nom%27';

    try {
      final response = await http.get(Uri.parse(wfsUrl));
      if (response.statusCode == 200) {
        final geoJson = jsonDecode(response.body);

        setState(() {
          polygonPoints = extractPolygonPointsFromGeoJson(geoJson);

          if (widget.mapScreenKey.currentState != null) {
            widget.mapScreenKey.currentState!
                .updatePolygonPoints(polygonPoints);
          } else {
            print('narrive pas à appeler update()');
          }
        });
      } else {
        print('Erreur de chargement des données WFS: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  //Fonction pour recupérer les données GeoJSON du département à partir du WFS
  Future<void> fetchGeoJsonDepartement(String nom) async {
    String wfsUrl =
        'http://10.0.2.2:8080/geoserver/data_collection/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=data_collection%3ADepartements&maxFeatures=50&outputFormat=application%2Fjson&CQL_FILTER=nom=%27$nom%27';

    try {
      final response = await http.get(Uri.parse(wfsUrl));
      if (response.statusCode == 200) {
        final geoJson = jsonDecode(response.body);

        setState(() {
          polygonPoints = extractPolygonPointsFromGeoJson(geoJson);

          if (widget.mapScreenKey.currentState != null) {
            widget.mapScreenKey.currentState!
                .updatePolygonPoints(polygonPoints);
          } else {
            print('narrive pas à appeler update()');
          }
        });
      } else {
        print('Erreur de chargement des données WFS: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  //Fonction pour recupérer les données GeoJSON de la commune à partir du WFS
  Future<void> fetchGeoJsonCommune(String nom) async {
    String encodedNom = Uri.encodeComponent(nom);

    String wfsUrl =
        'http://10.0.2.2:8080/geoserver/data_collection/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=data_collection%3ACommunes&maxFeatures=50&outputFormat=application%2Fjson&CQL_FILTER=nom_commun=%27$encodedNom%27';

    try {
      final response = await http.get(Uri.parse(wfsUrl));

      if (response.statusCode == 200) {
        final geoJson = jsonDecode(response.body);

        setState(() {
          polygonPoints = extractPolygonPointsFromGeoJson(geoJson);

          if (widget.mapScreenKey.currentState != null) {
            widget.mapScreenKey.currentState!
                .updatePolygonCommune(polygonPoints);
          } else {
            print('narrive pas à appeler update()');
          }
        });
      } else {
        print('Erreur de chargement des données WFS: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  Future<void> fetchGeoJsonSection(String num) async {
    String wfsUrl =
        'http://10.0.2.2:8080/geoserver/data_collection/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=data_collection%3ASections&maxFeatures=50&outputFormat=application%2Fjson&CQL_FILTER=numero_sec=%27$num%27';

    try {
      final response = await http.get(Uri.parse(wfsUrl));

      if (response.statusCode == 200) {
        final geoJson = jsonDecode(response.body);

        setState(() {
          polygonPoints = extractPolygonPointsFromGeoJson(geoJson);

          if (widget.mapScreenKey.currentState != null) {
            widget.mapScreenKey.currentState!
                .updatePolygonSection(polygonPoints);
          } else {
            print('narrive pas à appeler update()');
          }
        });
      } else {
        print('Erreur de chargement des données WFS: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  // Fonction pour récupérer les données GeoJSON de la parcelle à partir du WFS
  Future<void> fetchGeoJsonParcelle(String nicad) async {
    String wfsUrl =
        'http://10.0.2.2:8080/geoserver/data_collection/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=data_collection%3AParcelles&maxFeatures=50&featureID=$nicad&outputFormat=application%2Fjson';

    try {
      final response = await http.get(Uri.parse(wfsUrl));
      if (response.statusCode == 200) {
        final geoJson = jsonDecode(response.body);
        setState(() {
          polygonPoints = extractPolygonPointsFromGeoJson(geoJson);

          if (widget.mapScreenKey.currentState != null) {
            widget.mapScreenKey.currentState!
                .updatePolygonParcelle(polygonPoints);
          } else {
            print('narrive pas à appeler update()');
          }
        });
      } else {
        print('Erreur de chargement des données WFS: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  List<List<LatLng>> extractPolygonPointsFromGeoJson(
      Map<String, dynamic> geoJson) {
    List<List<LatLng>> polygons = [];

    if (geoJson.containsKey('features') && geoJson['features'] is List) {
      final features = geoJson['features'];

      for (var feature in features) {
        if (feature.containsKey('geometry')) {
          final geometry = feature['geometry'];

          if (geometry['type'] == 'Polygon') {
            final coordinates = geometry['coordinates'];
            if (coordinates is List) {
              for (var ring in coordinates) {
                List<LatLng> ringPoints = [];
                if (ring is List) {
                  for (var coord in ring) {
                    if (coord is List && coord.length >= 2) {
                      ringPoints.add(LatLng(coord[1], coord[0]));
                    }
                  }
                }
                polygons.add(ringPoints);
              }
            }
          } else if (geometry['type'] == 'MultiPolygon') {
            final multiPolygons = geometry['coordinates'];
            if (multiPolygons is List) {
              for (var polygon in multiPolygons) {
                for (var ring in polygon) {
                  List<LatLng> ringPoints = [];
                  if (ring is List) {
                    for (var coord in ring) {
                      if (coord is List && coord.length >= 2) {
                        ringPoints.add(LatLng(coord[1], coord[0]));
                      }
                    }
                  }
                  polygons.add(ringPoints);
                }
              }
            }
          }
        }
      }
    } else {
      print('Aucune fonctionnalité trouvée dans le GeoJSON');
    }

    return polygons;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Région',
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
                  final selectedRegion = regions.firstWhere(
                    (region) => region['id'] == newValue,
                    orElse: () => <String, String>{},
                  );

                  if (selectedRegion.isNotEmpty) {
                    selectedRegionName = selectedRegion['name'] ?? '';
                    fetchGeoJsonRegion(selectedRegionName);
                    fetchDepartments(newValue);
                  }
                }
              },
              isEnabled: regions
                  .isNotEmpty, // Active si la liste des régions est non vide
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Département',
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
                  final selectedDepartement = departments.firstWhere(
                    (departement) => departement['id'] == newValue,
                    orElse: () => <String,
                        String>{}, // Ajout d'une sécurité pour éviter une erreur si aucun élément n'est trouvé
                  );

                  if (selectedDepartement.isNotEmpty) {
                    selectedDepartementName = selectedDepartement['name'] ?? '';
                    fetchGeoJsonDepartement(selectedDepartementName);
                    fetchCommunes(newValue);
                  }
                }
              },
              isEnabled: departments.isNotEmpty,
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Commune',
              value: selectedCommuneId,
              items: communes,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCommuneId = newValue;
                  selectedSectionId = null;
                  selectedParcelId = null;
                  sections.clear();
                  parcels.clear();
                });
                if (newValue != null) {
                  final selectedCommune = communes.firstWhere(
                    (commune) => commune['id'] == newValue,
                    orElse: () => <String, String>{},
                  );

                  if (selectedCommune.isNotEmpty) {
                    selectedCommuneName = selectedCommune['name'] ?? '';
                    fetchGeoJsonCommune(selectedCommuneName);
                    fetchSections(selectedCommuneName);
                  } else {
                    print("Commune non trouvée pour l'ID: $newValue");
                  }
                }
              },
              isEnabled: communes.isNotEmpty,
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Section',
              value: selectedSectionId,
              items: sections,
              onChanged: (String? newValue) {
                setState(() {
                  selectedSectionId = newValue;
                  selectedParcelId = null;
                  parcels.clear();

                  if (newValue != null) {
                    final selectedSection = sections.firstWhere(
                      (section) => section['id'] == newValue,
                      orElse: () => <String, String>{},
                    );

                    if (selectedSection.isNotEmpty) {
                      selectedSectionNum = selectedSection['name'] ?? '';
                      fetchGeoJsonSection(selectedSectionNum);
                      fetchParcels(selectedCommuneName, selectedSectionNum);
                    }
                  }
                });
              },
              isEnabled: sections.isNotEmpty,
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Parcelle',
              value: selectedParcelId,
              items: parcels,
              onChanged: (String? newValue) {
                setState(() {
                  selectedParcelId = newValue;
                  if (newValue != null) {
                    final selectedParcelle = parcels.firstWhere(
                      (parcelle) => parcelle['id'] == newValue,
                      orElse: () => <String, String>{},
                    );

                    if (selectedParcelle.isNotEmpty) {
                      selectedNicadParcel = selectedParcelle['id'] ?? '';
                      fetchGeoJsonParcelle(selectedNicadParcel);
                    }
                  }
                });
              },
              isEnabled: parcels.isNotEmpty,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    List<Map<String, String>> items = const [],
    List<String> stringItems = const [],
    required ValueChanged<String?> onChanged,
    required bool isEnabled,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: label,
          fillColor:
              isEnabled ? Color.fromARGB(255, 255, 254, 251) : Colors.grey[300],
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: isEnabled ? Color(0xFFC3AD65) : Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFFC3AD65),
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        value: value,
        items: isEnabled
            ? (items.isNotEmpty
                ? items
                    .map((item) => DropdownMenuItem<String>(
                          value: item['id'],
                          child: Text(item['name']!),
                        ))
                    .toList()
                : stringItems
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        ))
                    .toList())
            : [],
        onChanged: isEnabled ? onChanged : null,
      ),
    );
  }
}
