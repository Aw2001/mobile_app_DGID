import 'package:flutter/material.dart';

class LocataireProvider extends ChangeNotifier {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String?> _selectedDropdownValues = {};

  // Méthode pour récupérer un contrôleur
  TextEditingController getController(String key) {
    _controllers.putIfAbsent(key, () => TextEditingController());
    return _controllers[key]!;
  }

  // Méthode pour obtenir la valeur d'une dropdown
  String? getSelectedValue(String key) => _selectedDropdownValues[key];

  // Méthode pour définir une valeur sélectionnée
  void setSelectedValue(String key, String value) {
    _selectedDropdownValues[key] = value;
    notifyListeners();
  }

  // Méthode pour réinitialiser tous les champs
  void resetFields() {
    _controllers.forEach((key, controller) => controller.clear());
    _selectedDropdownValues.clear();
    notifyListeners();
  }
}
