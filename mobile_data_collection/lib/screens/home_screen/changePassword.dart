class ChangePassword {
  String password;
  String repeatPassword;

  ChangePassword({
    required this.password,
    required this.repeatPassword,
  });

  // Pour convertir l'objet en JSON lors de l'envoi à l'API
  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'repeatPassword': repeatPassword,
    };
  }
}
