// map_screen.dart

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobile_data_collection/screens/form_screen/multi_step_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  LatLng? _currentPosition; // Stocke la position actuelle de l'appareil
  final MapController _mapController =
      MapController(); // Contrôleur de la carte
  List<List<LatLng>> polygonPoints =
      []; // Ajout d'une propriété pour recevoir les points des polygones
  var _isDragging = false;
  @override
  void initState() {
    super.initState();
  }

  //     _currentPosition = LatLng(position.latitude, position.longitude);
  //     _mapController.move(_currentPosition!, 16.0); // Centre la carte sur la position actuelle
  //   });
  // }
  // Méthode pour mettre à jour les polygones
  void updatePolygonPoints(List<List<LatLng>> newPolygonPoints) {
    setState(() {
      polygonPoints = newPolygonPoints; // Met à jour les points des polygones
      print(polygonPoints);
    });
    if (newPolygonPoints.isNotEmpty) {
      final firstPoint = newPolygonPoints[0][0];
      _mapController.move(firstPoint, 10.5); // Zoom et centrage sur le polygone
    }
  }

  // Méthode pour mettre à jour les polygones des communes
  void updatePolygonCommune(List<List<LatLng>> newPolygonPoints) {
    setState(() {
      polygonPoints = newPolygonPoints; // Met à jour les points des polygones
      print(polygonPoints);
    });
    if (newPolygonPoints.isNotEmpty) {
      final firstPoint = newPolygonPoints[0][0];
      _mapController.move(firstPoint, 14); // Zoom et centrage sur le polygone
    }
  }

  void updatePolygonSection(List<List<LatLng>> newPolygonPoints) {
    setState(() {
      polygonPoints = newPolygonPoints; // Met à jour les points des polygones
      print(polygonPoints);
    });
    if (newPolygonPoints.isNotEmpty) {
      final firstPoint = newPolygonPoints[0][0];
      _mapController.move(firstPoint, 16); // Zoom et centrage sur le polygone
    }
  }

  void updatePolygonParcelle(List<List<LatLng>> newPolygonPoints) {
    setState(() {
      polygonPoints = newPolygonPoints; // Met à jour les points des polygones
      print(polygonPoints);
    });
    if (newPolygonPoints.isNotEmpty) {
      final firstPoint = newPolygonPoints[0][0];
      _mapController.move(firstPoint, 20); // Zoom et centrage sur le polygone
    }
  }

  List<Polygon> createPolygons(List<List<LatLng>> polygonPoints) {
    print(polygonPoints);
    return polygonPoints.map((points) {
      return Polygon(
        points: points,
        color: const Color.fromARGB(255, 97, 80, 10).withOpacity(0.4),
        borderStrokeWidth: 3.0,
        borderColor: Colors.black,
        holePointsList: [],
      );
    }).toList();
  }

  // Fonction pour obtenir la position de l'utilisateur
  Future<LatLng?> getUserLocation() async {
    try {
      // Vérifiez si le service de localisation est activé
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Affiche un message d'erreur si le service de localisation est désactivé
        throw Exception('Les services de localisation sont désactivés.');
      }

      // Vérifiez et demandez les permissions de localisation si nécessaire
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Les permissions de localisation sont refusées.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Les permissions de localisation sont définitivement refusées.');
      }

      // Si tout est configuré, récupère la position actuelle
      final position = await Geolocator.getCurrentPosition();
      _currentPosition = LatLng(position.latitude, position.longitude);

      // Déplace la carte vers la position de l'utilisateur avec un zoom
      _mapController.move(_currentPosition!, 16.0);

      return _currentPosition!;
    } catch (e) {
      print('Erreur lors de la récupération de la localisation: $e');
      // Vous pouvez aussi afficher un message d'erreur à l'utilisateur si besoin
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _currentPosition ??
              const LatLng(14.6928,
                  -14.4736), // Centre par défaut si la position n'est pas encore disponible
          initialZoom: 7.8,
          interactionOptions: InteractionOptions(
            flags: InteractiveFlag.all, // Active toutes les interactions
            debugMultiFingerGestureWinner: false, // Désactive le débogage
            enableMultiFingerGestureRace:
                true, // Active la compétition entre gestes multi-doigts
            pinchZoomThreshold: 0.5, // Seuil de zoom par pincement
            pinchZoomWinGestures: MultiFingerGesture.pinchZoom |
                MultiFingerGesture.pinchMove, // Gestes gagnants pour le zoom
            pinchMoveThreshold: 40.0, // Seuil de mouvement pour le pincement
            pinchMoveWinGestures: MultiFingerGesture.pinchZoom |
                MultiFingerGesture
                    .pinchMove, // Gestes gagnants pour le mouvement de pincement
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            tileSize: 256.0,
            keepBuffer: 5,
          ),
          _isDragging == false
              ? Positioned(
                  bottom: 20,
                  left: 20,
                  child: FloatingActionButton(
                    backgroundColor: Color(0xFFC3AD65),
                    foregroundColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        _isDragging = true;
                      });
                    },
                    child: Icon(Icons.wrong_location),
                  ),
                )
              : Positioned(
                  bottom: 20,
                  left: 20,
                  child: FloatingActionButton(
                    backgroundColor: Color.fromARGB(255, 122, 188, 116),
                    foregroundColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        _isDragging = false;
                      });
                    },
                    child: Icon(Icons.add_location),
                  ),
                ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFFC3AD65),
              onPressed: getUserLocation,
              child: Icon(Icons.location_searching_rounded),
            ),
          ),
          // Nouveau bouton pour naviguer vers MultiStepScreen
          Positioned(
            bottom: 100,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Color.fromARGB(255, 148, 92, 34),
              foregroundColor: Colors.white,
              onPressed: () {
                // Naviguer vers MultiStepScreen
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        MultiStepScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin =
                          Offset(1.0, 0.0); // Départ à droite de l'écran
                      const end = Offset.zero; // Arrivée au centre
                      const curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: Icon(Icons.assignment),
            ),
          ),
          // Zoom progressif sur la position actuelle avec une animation
          if (_currentPosition != null && _isDragging == true)
            MarkerLayer(
              markers: [
                Marker(
                  point: _currentPosition!, // Marqueur à la position actuelle
                  width: 60,
                  height: 60,
                  alignment: Alignment.centerLeft,
                  child: const Icon(
                    Icons.location_pin,
                    size: 60,
                    color: Colors.red,
                  ),
                ),
              ],
            ),

          if (polygonPoints.isNotEmpty)
            PolygonLayer(polygons: createPolygons(polygonPoints)),
        ],
      ),
    );
  }
}
