import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  LatLng? _currentPosition; // Stocke la position actuelle de l'appareil
  List<List<LatLng>> polygonPoints = [];
  final MapController _mapController = MapController();
  final List<Marker> _markers = []; 


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
  LatLng getCurrentMapCenter() {
    if (_mapController == null) return LatLng(0, 0); // Fallback
    return _mapController.camera.center;
  }

  // Fonction pour obtenir la position de l'utilisateur
  Future<LatLng?> getUserLocation({bool useGps = true}) async {
  try {
    LatLng targetPosition;

    if (useGps) {
      // Partie GPS (comme avant)
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Activez votre GPS');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Permission refusée');
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      targetPosition = LatLng(position.latitude, position.longitude);
    } else {
      // Récupère le centre de la carte si GPS non utilisé
      targetPosition = getCurrentMapCenter();
    }

    // Met à jour la carte
    _markers.clear();
    _markers.add(
      Marker(
        point: targetPosition,
        width: 40,
        height: 40,
        child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
      ),
    );

      _mapController.move(targetPosition, 16.0);

    return targetPosition;
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur: ${e.toString()}')),
    );
    return null;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _currentPosition ?? const LatLng(14.5, -14.5), 
          initialZoom: 6.5, 
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
                "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
          
            maxZoom: 21,
            minZoom: 3,
            subdomains: ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(markers: _markers),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: Color.fromARGB(255, 148, 92, 34),
              onPressed: () async {
                await getUserLocation(useGps: true);
              },
              child: Icon(Icons.my_location),
            ),
          ),
          

          if (polygonPoints.isNotEmpty)
            PolygonLayer(polygons: createPolygons(polygonPoints)),
        ],
      ),
    );
  }
}
