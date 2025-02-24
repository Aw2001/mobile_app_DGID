extension StringExtension on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

    bool get isValidName {
    final nameRegExp = RegExp(r"^[A-Za-zÀ-ÿ]+(?:[\s-][A-Za-zÀ-ÿ]+)*$");
    return nameRegExp.hasMatch(this);
  }


  bool get isValidPhone {
    final phoneRegExp = RegExp(r"^(?:[+0]9)?[0-9]{9}$");
    return phoneRegExp.hasMatch(this);
  }

   bool get isValidNumber {
    final numberRegExp = RegExp(r"^\d+$");
    return numberRegExp.hasMatch(this);
  }

  bool get isValidCni {
    final cniRegExp = RegExp(r"^\d{13,14}$");
    return cniRegExp.hasMatch(this);
  }
}