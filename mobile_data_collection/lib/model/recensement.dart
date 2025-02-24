import 'dart:core';
class Recensement {
  String? numRecensement;
  String? methodeRecensement;
  String? etat;
  String? service;
  String? typeService;
  String? dateDebut;
  String? dateFin;
  String commentaire;
  String? region;
  String? departement;
  String? commune;
  String? section;
  String dateCreation;
  

  Recensement({
    this.numRecensement,
    this.methodeRecensement,
    this.etat,
    this.service,
    this.typeService,
    this.dateDebut,
    this.dateFin,
    required this.commentaire,
    this.region,
    this.departement,
    this.commune,
    this.section,
    required this.dateCreation
   
  });

  factory Recensement.fromJson(Map<String, dynamic> json) {
    return Recensement(
      numRecensement: json['numRecensement'],
      methodeRecensement: json['methodeRecensement'] ?? "Classique",
      etat: json['etat'],
      service: json['service'] ?? "service",
      typeService: json['typeService'] ?? "typeService",
      dateDebut: json['dateDebut'] ?? "2024-01-05",
      dateFin: json['dateFin'] ?? "2024-01-05",
      commentaire: json['commentaire'] ?? "Nom inconnu",
      region: json['region'] ?? "Dakar",
      departement: json['departement'] ?? "Rufisque",
      commune: json['commune'] ?? "Rufisque Est",
      section: json['section'] ?? "006",
      dateCreation: json['dateCreation'] ?? "2024-01-05"
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numRecensement': numRecensement,
      'methodeRecensement': methodeRecensement,
      'etat': etat,
      'service': service,
      'typeService': typeService,
      'dateDebut': dateFin,
      'commentaire': commentaire,
      'region': region,
      'departement': departement,
      'commune': commune,
      'section': section,
      'dateCreation': dateCreation
      
    };
  }
}
