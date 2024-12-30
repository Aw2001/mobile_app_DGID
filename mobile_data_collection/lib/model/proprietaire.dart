import 'dart:core';

class Proprietaire {
  String? numIdentifiant;
  String? nom;
  String? prenom;
  String? email;
  String? typeIdentifiant;
  DateTime? dateNaissance;
  String? lieuNaissance;
  DateTime? dateDelivranceIdentifiant;
  DateTime? dateExpirationIdentifiant;
  String? statut;
  String? salarie;
  String? civilite;
  String? ninea;
  String? rencontre;
  String? telephone;
  String? telephoneContribuable;
  double? valeurLocativeProprietaire;
  String? enregistre;
  String? pensionne;
  String? autrePropriete;
  String? commentaire;

  Proprietaire(
      {this.numIdentifiant,
      this.nom,
      this.prenom,
      this.email,
      this.typeIdentifiant,
      this.dateNaissance,
      this.lieuNaissance,
      this.dateDelivranceIdentifiant,
      this.dateExpirationIdentifiant,
      this.statut,
      this.salarie,
      this.civilite,
      this.ninea,
      this.rencontre,
      this.telephone,
      this.telephoneContribuable,
      this.valeurLocativeProprietaire,
      this.enregistre,
      this.pensionne,
      this.autrePropriete,
      this.commentaire});

  factory Proprietaire.fromJson(Map<String, dynamic> json) {
    return Proprietaire(
        numIdentifiant: json['numIdentifiant'],
        nom: json['nom'],
        prenom: json['prenom'],
        email: json['email'],
        typeIdentifiant: json['typeIdentifiant'],
        dateNaissance: json["dateNaissance"] != null
            ? DateTime.parse(json["dateNaissance"])
            : null,
        lieuNaissance: json['lieuNaissance'],
        dateDelivranceIdentifiant: json["dateDelivranceIdentifiant"] != null
            ? DateTime.parse(json["dateDelivranceIdentifiant"])
            : null,
        dateExpirationIdentifiant: json["dateExpirationIdentifiant"] != null
            ? DateTime.parse(json["dateExpirationIdentifiant"])
            : null,
        statut: json['statut'],
        salarie: json['salarie'],
        civilite: json['civilite'],
        ninea: json['ninea'],
        rencontre: json['rencontre'],
        telephone: json['telephone'],
        telephoneContribuable: json['telephoneContribuable'],
        valeurLocativeProprietaire: json['valeurLocativeProprietaire'],
        enregistre: json['enregistre'],
        pensionne: json['pensionne'],
        autrePropriete: json['autrePropriete'],
        commentaire: json['commentaire']);
  }

  Map<String, dynamic> toJson() {
    return {
      'numIdentifiant': numIdentifiant,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'typeIdentifiant': typeIdentifiant,
      'dateNaissance': dateNaissance?.toIso8601String(),
      'lieuNaissance': lieuNaissance,
      "dateDelivranceIdentifiant": dateDelivranceIdentifiant?.toIso8601String(),
      "dateExpirationIdentifiant": dateExpirationIdentifiant?.toIso8601String(),
      'statut': statut,
      'salarie': salarie,
      'civilite': civilite,
      'ninea': ninea,
      'rencontre': rencontre,
      'telephone': telephone,
      'telephoneContribuable': telephoneContribuable,
      'valeurLocativeProprietaire': valeurLocativeProprietaire,
      'enregistre': enregistre,
      'pensionne': pensionne,
      'autrePropriete': autrePropriete,
      'commentaire': commentaire
    };
  }
}
