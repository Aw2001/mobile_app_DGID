import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {

  //validator
  validator(String value, String message) {
    if(value.isEmpty) {
      return message;
    } else {
      return null;
    }
  }

  //phone number
  String? phoneValidator(String value) {
    if(value.length < 9) {
      return 'Le numéro de téléphone doit contenir au moins 9 chiffre';
    }
    return null; 
  }
}