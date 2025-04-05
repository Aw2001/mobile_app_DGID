import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_data_collection/screens/welcome_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  LatLng? _currentPosition; // Stocke la position actuelle de l'appareil
  List<List<LatLng>> polygonPoints = [];
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
  }

  // Méthode pour mettre à jour les polygones des régions
  void updatePolygonPoints(List<List<LatLng>> newPolygonPoints) {
    setState(() {
      polygonPoints = newPolygonPoints;
    });
    if (newPolygonPoints.isNotEmpty) {
      final firstPoint = newPolygonPoints[0][0];
      _mapController.move(firstPoint, 10.5);
    }
  }

  // Méthode pour mettre à jour les polygones des communes
  void updatePolygonCommune(List<List<LatLng>> newPolygonPoints) {
    setState(() {
      polygonPoints = newPolygonPoints;
    });
    if (newPolygonPoints.isNotEmpty) {
      final firstPoint = newPolygonPoints[0][0];
      _mapController.move(firstPoint, 14);
    }
  }

  void updatePolygonSection(List<List<LatLng>> newPolygonPoints) {
    setState(() {
      polygonPoints = newPolygonPoints;
    });
    if (newPolygonPoints.isNotEmpty) {
      final firstPoint = newPolygonPoints[0][0];
      _mapController.move(firstPoint, 16);
    }
  }

  void updatePolygonParcelle(List<List<LatLng>> newPolygonPoints) {
    setState(() {
      polygonPoints = newPolygonPoints;
    });
    if (newPolygonPoints.isNotEmpty) {
      final firstPoint = newPolygonPoints[0][0];
      _mapController.move(firstPoint, 20);
    }
  }

  List<Polygon> createPolygons(List<List<LatLng>> polygonPoints) {
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
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Les services de localisation sont désactivés.');
      }

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

      final position = await Geolocator.getCurrentPosition();
      _currentPosition = LatLng(position.latitude, position.longitude);

      _mapController.move(_currentPosition!, 16.0);

      return _currentPosition!;
    } catch (e) {
      print('Erreur lors de la récupération de la localisation: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _currentPosition ?? const LatLng(14.955,-14.855), 
          initialZoom: 7, 
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
            urlTemplate:
                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            tileSize: 256,
            maxZoom: 30,
            minZoom: 3,
            subdomains: [],
          ),

          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: Color.fromARGB(255, 148, 92, 34),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        WelcomeScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
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
              child: Icon(Icons.history),
            ),
          ),
          if (polygonPoints.isNotEmpty)
            PolygonLayer(polygons: createPolygons(polygonPoints)),
        ],
      ),
    );
  }
}
