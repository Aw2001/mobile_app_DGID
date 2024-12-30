import 'dart:core';

class Locataire {
  String? cni;
  String? nom;
  String? prenom;
  String? telephone;
  String? typeOccupation;
  DateTime? dateSignatureContrat;
  double? loyerAnnuel;
  int? nbPieceOccupe;
  String? activiteEconomique;
  String? denomination;
  String? commentaire;

  Locataire({
    this.cni,
    this.nom,
    this.prenom,
    this.telephone,
    this.typeOccupation,
    this.dateSignatureContrat,
    this.loyerAnnuel,
    this.nbPieceOccupe,
    this.activiteEconomique,
    this.denomination,
    this.commentaire,
  });

  factory Locataire.fromJson(Map<String, dynamic> json) {
    return Locataire(
      cni: json['cni'],
      nom: json['nom'],
      prenom: json['prenom'],
      telephone: json['telephone'],
      typeOccupation: json['typeOccupation'],
      dateSignatureContrat: json["dateSignatureContrat"] != null
          ? DateTime.parse(json["dateSignatureContrat"])
          : null,
      loyerAnnuel: json['annuel'],
      nbPieceOccupe: json['nbPieceOccupe'],
      activiteEconomique: json['activiteEconomique'],
      denomination: json['denomination'],
      commentaire: json['commentaire'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cni': cni,
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'typeOccupation': typeOccupation,
      'dateSignatureContrat': dateSignatureContrat?.toIso8601String(),
      'loyerAnnuel': loyerAnnuel,
      'nbPieceOccupe': nbPieceOccupe,
      'activiteEconomique': activiteEconomique,
      'denomination': denomination,
      'commentaire': commentaire,
    };
  }
}
