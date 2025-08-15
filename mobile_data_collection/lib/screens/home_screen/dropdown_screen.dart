import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/location_provider.dart';
import '../../utils/constants.dart';
import 'map_screen.dart';

class DropdownsWidget extends StatefulWidget {
  const DropdownsWidget({super.key, required this.mapScreenKey});
  final GlobalKey<MapScreenState> mapScreenKey;

  @override
  DropdownsWidgetState createState() => DropdownsWidgetState();
}

class DropdownsWidgetState extends State<DropdownsWidget> {
  String selectedCommuneName = '';
  List<List<LatLng>> polygonPoints = [];

  @override
  void initState() {
    super.initState();
    final dropdownState = Provider.of<DropdownState>(context, listen: false);
    
    print(dropdownState.isRegionsLoaded);
    
    fetchRegions(); // Load regions on startup
      
  }

  // Fonction pour récupérer les régions depuis l'API
  Future<void> fetchRegions() async {
    print("mee");
    final dropdownState = Provider.of<DropdownState>(context, listen: false);
    String url = 'http://10.0.2.2:8080/geoserver/data_collection/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=data_collection%3ARegions&maxFeatures=50&outputFormat=application%2Fjson';
    print("URL utilisée: $url");
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        dropdownState.regions = (data['features'] as List<dynamic>)
            .map<Map<String, String>>((feature) {
          final regionProperties = feature['properties'];
          return {
            'id': feature['id'].toString(),
            'name': regionProperties['nom'].toString(),
          };
        }).toList();
        dropdownState.notifyListeners();
      });
      
    } else {
      throw Exception('Failed to load regions');
    }
  }

  // Fonction pour récupérer les départements d'une région
  Future<void> fetchDepartments(String regionId) async {
    final dropdownState = Provider.of<DropdownState>(context, listen: false);
    final cleanedRegionId = regionId.replaceAll(RegExp(r'^Regions\.'), '');
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8080/geoserver/data_collection/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=data_collection%3ADepartements&maxFeatures=50&outputFormat=application%2Fjson&CQL_FILTER=region_id=$cleanedRegionId'));
    if (response.statusCode == 200) {
      if (response.headers['content-type']?.contains('application/json') ??
          false) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          dropdownState.departments = (data['features'] as List<dynamic>)
              .map<Map<String, String>>((feature) {
            final departementProperties = feature['properties'];
            return {
              'id': feature['id'].toString(),
              'name': departementProperties['nom'].toString()
            };
          }).toList();

          dropdownState.notifyListeners();
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
    final dropdownState = Provider.of<DropdownState>(context, listen: false);
    final cleanedDepartmentId =
        departementId.replaceAll(RegExp(r'^Departements\.'), '');
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8080/geoserver/data_collection/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=data_collection%3ACommunes&maxFeatures=50&outputFormat=application%2Fjson&CQL_FILTER=departement_id=$cleanedDepartmentId'));
    if (response.statusCode == 200) {
      if (response.headers['content-type']?.contains('application/json') ??
          false) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          dropdownState.communes = (data['features'] as List<dynamic>)
              .map<Map<String, String>>((com) {
            return {
              'id': com['id'].toString(),
              'name': com['properties']['nom_commun'].toString()
            };
          }).toList();
          dropdownState.notifyListeners();
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
    final dropdownState = Provider.of<DropdownState>(context, listen: false);
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8080/geoserver/data_collection/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=data_collection%3ASections&maxFeatures=50&outputFormat=application%2Fjson&CQL_FILTER=nom_commune=%27$encodedNom%27'));

    if (response.statusCode == 200) {
      if (response.headers['content-type']?.contains('application/json') ??
          false) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          dropdownState.sections = (data['features'] as List<dynamic>)
              .map<Map<String, String>>((section) {
            final properties = section['properties'];

            return {
              'id': section['id'].toString(),
              'name': properties['numero_sec']?.toString() ?? '',
            };
          }).toList();
          dropdownState.notifyListeners();
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
    final dropdownState = Provider.of<DropdownState>(context, listen: false);
    var cleanedParcelleId;

    final url = Uri.parse(
        'http://10.0.2.2:8080/geoserver/data_collection/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=data_collection%3AParcelles&maxFeatures=50&outputFormat=application%2Fjson&CQL_FILTER=nom_commun%20=%20%27$encodedCommuneName%27%20and%20num_sect=%27$encodedSectionNumber%27');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      if (response.headers['content-type']?.contains('application/json') ??
          false) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          dropdownState.parcels = (data['features'] as List<dynamic>)
              .map<Map<String, String>>((parcel) {
            cleanedParcelleId =
                parcel['id'].replaceAll(RegExp(r'^Parcelles\.'), '');
            return {
              'id': parcel['id'].toString(),
              'name': cleanedParcelleId.toString()
            };
          }).toList();
          dropdownState.notifyListeners();
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
    return Consumer<DropdownState>(builder: (context, dropdownState, child) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Région',
                value: dropdownState.selectedRegionId,
                items: dropdownState.regions,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    final selectedRegion = dropdownState.regions.firstWhere(
                      (region) => region['id'] == newValue,
                      orElse: () => <String, String>{},
                    );

                    if (selectedRegion.isNotEmpty) {
                      dropdownState.setRegion(
                          newValue, selectedRegion['name']!);
                      fetchGeoJsonRegion(selectedRegion['name']!);
                      fetchDepartments(newValue);
                    }
                  }
                },
                isEnabled: dropdownState.regions
                    .isNotEmpty, // Active si la liste des régions est non vide
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Département',
                value: dropdownState.selectedDepartmentId,
                items: dropdownState.departments,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    final selectedDepartement =
                        dropdownState.departments.firstWhere(
                      (departement) => departement['id'] == newValue,
                      orElse: () => <String,
                          String>{}, // Ajout d'une sécurité pour éviter une erreur si aucun élément n'est trouvé
                    );

                    if (selectedDepartement.isNotEmpty) {
                      dropdownState.setDepartment(
                          newValue, selectedDepartement['name']!);
                      fetchGeoJsonDepartement(selectedDepartement['name']!);
                      fetchCommunes(newValue);
                    }
                  }
                },
                isEnabled: dropdownState.departments.isNotEmpty,
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Commune',
                value: dropdownState.selectedCommuneId,
                items: dropdownState.communes,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    final selectedCommune = dropdownState.communes.firstWhere(
                      (commune) => commune['id'] == newValue,
                      orElse: () => <String, String>{},
                    );

                    if (selectedCommune.isNotEmpty) {
                      dropdownState.setCommune(
                          newValue, selectedCommune['name']!);
                      selectedCommuneName = selectedCommune['name']!;
                      fetchGeoJsonCommune(selectedCommune['name']!);
                      fetchSections(selectedCommune['name']!);
                    } else {
                      print("Commune non trouvée pour l'ID: $newValue");
                    }
                  }
                },
                isEnabled: dropdownState.communes.isNotEmpty,
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Section',
                value: dropdownState.selectedSectionId,
                items: dropdownState.sections,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    final selectedSection = dropdownState.sections.firstWhere(
                      (section) => section['id'] == newValue,
                      orElse: () => <String, String>{},
                    );

                    if (selectedSection.isNotEmpty) {
                      dropdownState.setSection(
                          newValue, selectedSection['name']!);
                      fetchGeoJsonSection(selectedSection['name']!);
                      fetchParcels(
                          selectedCommuneName, selectedSection['name']!);
                    }
                  }
                },
                isEnabled: dropdownState.sections.isNotEmpty,
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Parcelle',
                value: dropdownState.selectedParcelId,
                items: dropdownState.parcels,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    final selectedParcelle = dropdownState.parcels.firstWhere(
                      (parcelle) => parcelle['id'] == newValue,
                      orElse: () => <String, String>{},
                    );

                    if (selectedParcelle.isNotEmpty) {
                      dropdownState.setParcel(
                          newValue, selectedParcelle['id']!);
                      fetchGeoJsonParcelle(selectedParcelle['id']!);
                    }
                  }
                },
                isEnabled: dropdownState.parcels.isNotEmpty,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    List<Map<String, String>> items = const [],
    List<String> stringItems = const [],
    required ValueChanged<String?> onChanged,
    required bool isEnabled,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Form(
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              fontSize: 12,
              color: Colors.black, 
              fontWeight: FontWeight.w400, 
            ),
            
            fillColor: isEnabled
                ? Color.fromARGB(255, 255, 254, 251)
                : Colors.grey[300],
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
                            child: Text(item['name']!,
                            style: TextStyle(fontSize: 12)
                            ),
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
      ),
    );
  }
}
