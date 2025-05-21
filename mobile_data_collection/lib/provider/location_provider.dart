import 'package:flutter/material.dart';

class DropdownState extends ChangeNotifier {
  bool isRegionsLoaded = false;
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

  void resetAllExceptRegion() {
    selectedDepartmentId = null;
    selectedCommuneId = null;
    selectedSectionId = null;
    selectedParcelId = null;
    departments.clear();
    communes.clear();
    sections.clear();
    parcels.clear();
    notifyListeners();
  }

  void resetBelowDepartment() {
    selectedCommuneId = null;
    selectedSectionId = null;
    selectedParcelId = null;
    communes.clear();
    sections.clear();
    parcels.clear();
    notifyListeners();
  }

  void resetBelowCommune() {
    selectedSectionId = null;
    selectedParcelId = null;
    sections.clear();
    parcels.clear();
    notifyListeners();
  }

  void resetBelowSection() {
    selectedParcelId = null;
    parcels.clear();
    notifyListeners();
  }

  void setRegion(String? id, String name) {
    selectedRegionId = id;
    selectedRegionName = name;
    resetAllExceptRegion();
    notifyListeners();
  }

  void setDepartment(String? id, String name) {
    selectedDepartmentId = id;
    selectedDepartementName = name;
    resetBelowDepartment();
    notifyListeners();
  }

  void setCommune(String? id, String name) {
    selectedCommuneId = id;
    selectedCommuneName = name;
    resetBelowCommune();
    notifyListeners();
  }

  void setSection(String? id, String num) {
    selectedSectionId = id;
    selectedSectionNum = num;
    resetBelowSection();
    notifyListeners();
  }

  void setParcel(String? id, String nicad) {
    selectedParcelId = id;
    selectedNicadParcel = nicad;
    notifyListeners();
  }
}