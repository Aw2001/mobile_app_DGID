// map_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _currentPosition; // Stocke la position actuelle de l'appareil
  final MapController _mapController = MapController(); // Contrôleur de la carte

  @override
  void initState() {
    super.initState();
  }

   
  // Fonction pour récupérer la position actuelle de l'appareil
  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Si la permission est refusée, afficher un message ou gérer l'erreur
      return;
    }

    // Obtenir la position actuelle
    Position position = await Geolocator.getCurrentPosition(
    // ignore: deprecated_member_use
    desiredAccuracy: LocationAccuracy.best);


    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _mapController.move(_currentPosition!, 16.0); // Centre la carte sur la position actuelle
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: FlutterMap(
        mapController: _mapController, // Utilisation du contrôleur pour contrôler la carte
        options: MapOptions(
          initialCenter: _currentPosition ?? const LatLng(14.6928, -17.4467), // Centre par défaut si la position n'est pas encore disponible
          initialZoom: 16, // Zoom initial
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.fr/osmfr/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            tileSize: 256.0,
          ),
          // Ajouter un marqueur à la position actuelle si elle est disponible
          if (_currentPosition != null)
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
        ],
        
      ),
    );
    
  }
}
