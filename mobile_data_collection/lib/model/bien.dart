import 'dart:core';
class Bien {
  String? idProprietaire;
  String? idParcelle;
  String? nomRue;
  String? codeDeRueAdm;
  String? quartier;
  String? village;
  String? typeParcelle;
  String? identifiant;
  String? nomVoirie;
  String? typeVoirie;
  String? nomAutreVoirie;
  String? typeLot;
  String? localisationLot;
  String? situationLot;
  String? numLot;
  int? niveauLot;
  String? numPorteAdm;
  String? adresse;
  double? superficie;
  String? typeOccupation;
  DateTime? dateDelivranceTypeOccupation;
  String? usagee;
  String? typeConstruction;
  String? toiture;
  String? typeCloture;
  String? etatCloture;
  String? typeRevetement;
  String? etatRevetement;
  String? situationRoute;
  String? typeRoute;
  String? garage;
  String? qualitePorteFenetre;
  String? typeCarrelage;
  String? menuiserie;
  String? conceptionPieces;
  String? appareilsSanitaires;
  String? parkingInterieur;
  int? nbAscenseurs;
  int? nbSalleBain;
  int? nbSalleEau;
  int? nbPieceReception;
  int? nbTotalPiece;
  int? nbEtage;
  String? confort;
  String? numCompteurSenelec;
  String? numCompteurSde;
  String? numTitreFoncier;
  DateTime? dateAcquisition;
  double? valeurLocativeAnnuelle;
  double? valeurLocativeAnnuelleSaisie;
  double? valeurLocativeMensuelle;
  double? valeurLocativeMensuelleSaisie;
  String? commentaire;
  String? escalier;
  String? videOrdure;
  String? monteCharge;
  String? groupeElectrogene;
  String? dependanceIsolee;
  String? garageSouterrain;
  String? systemeClimatisation;
  String? systemeDomotique;
  String? balcon;
  String? terrasse;
  String? systemeSurveillance;
  String? amenagementPaysager;
  String? jardin;
  String? piscine;
  String? coursDeTennis;
  String? coursGazonnee;
  String? terrainGolf;
  String? autre;
  String? angle;
  String? eclairagePublic;
  String? murEnCiment;
  String? attributsArchitecturaux;
  String? trottoir;
  String? proprieteEnLocation;
  String? autreTypeOccupation;

  Bien({
    this.idProprietaire,
    this.idParcelle,
    this.nomRue,
    this.codeDeRueAdm,
    this.quartier,
    this.village,
    this.typeParcelle,
    this.identifiant,
    this.nomVoirie,
    this.typeVoirie,
    this.nomAutreVoirie,
    this.typeLot,
    this.localisationLot,
    this.situationLot,
    this.numLot,
    this.niveauLot,
    this.numPorteAdm,
    this.adresse,
    this.superficie,
    this.typeOccupation,
    this.dateDelivranceTypeOccupation,
    this.usagee,
    this.typeConstruction,
    this.toiture,
    this.typeCloture,
    this.etatCloture,
    this.typeRevetement,
    this.etatRevetement,
    this.situationRoute,
    this.typeRoute,
    this.garage,
    this.qualitePorteFenetre,
    this.typeCarrelage,
    this.menuiserie,
    this.conceptionPieces,
    this.appareilsSanitaires,
    this.parkingInterieur,
    this.nbAscenseurs,
    this.nbSalleBain,
    this.nbSalleEau,
    this.nbPieceReception,
    this.nbTotalPiece,
    this.nbEtage,
    this.confort,
    this.numCompteurSenelec,
    this.numCompteurSde,
    this.numTitreFoncier,
    this.dateAcquisition,
    this.valeurLocativeAnnuelle,
    this.valeurLocativeAnnuelleSaisie,
    this.valeurLocativeMensuelle,
    this.valeurLocativeMensuelleSaisie,
    this.commentaire,
    this.escalier,
    this.videOrdure,
    this.monteCharge,
    this.groupeElectrogene,
    this.dependanceIsolee,
    this.garageSouterrain,
    this.systemeClimatisation,
    this.systemeDomotique,
    this.balcon,
    this.terrasse,
    this.systemeSurveillance,
    this.amenagementPaysager,
    this.jardin,
    this.piscine,
    this.coursDeTennis,
    this.coursGazonnee,
    this.terrainGolf,
    this.autre,
    this.angle,
    this.eclairagePublic,
    this.murEnCiment,
    this.attributsArchitecturaux,
    this.trottoir,
    this.proprieteEnLocation,
    this.autreTypeOccupation,
  });

  factory Bien.fromJson(Map<String, dynamic> json) {
    return Bien(
      identifiant: json['identifiant'],
      superficie: json['superficie'],
      proprieteEnLocation: json['proprieteEnLocation'],
      adresse: json['adresse'],
      numPorteAdm: json['numPorteAdm'],
      codeDeRueAdm: json['codeDeRueAdm'],
      nomRue: json['nomRue'],
      quartier: json['quartier'],
      village: json['village'],
      typeLot: json['typeLot'],
      niveauLot: json['niveauLot'],
      localisationLot: json['localisationLot'],
      situationLot: json['situationLot'],
      numLot: json['numLot'],
      valeurLocativeAnnuelle: json['valeurLocativeAnnuelle'],
      valeurLocativeAnnuelleSaisie: json['valeurLocativeAnnuelleSaisie'],
      numTitreFoncier: json['numTitreFoncier'],
      dateAcquisition: json['dateAcquisition'],
      typeOccupation: json['typeOccupation'],
      autreTypeOccupation: json['autreTypeOccupation'],
      dateDelivranceTypeOccupation: json['dateDelivranceTypeOccupation'],
      usagee: json['usagee'],
      numCompteurSde: json['numCompteurSde'],
      numCompteurSenelec: json['numCompteurSenelec'],
      typeConstruction: json['typeConstruction'],
      toiture: json['toiture'],
      typeCloture: json['typeCloture'],
      etatCloture: json['etatCloture'],
      typeRevetement: json['typeRevetement'],
      etatRevetement: json['etatRevetement'],
      situationRoute: json['situationRoute'],
      typeRoute: json['typeRoute'],
      garage: json['garage'],
      qualitePorteFenetre: json['qualitePorteFenetre'],
      typeCarrelage: json['typeCarrelage'],
      menuiserie: json['menuiserie'],
      conceptionPieces: json['conceptionPieces'],
      appareilsSanitaires: json['appareilsSanitaires'],
      parkingInterieur: json['parkingInterieur'],
      nbAscenseurs: json['nbAscenseurs'],
      nbSalleBain: json['nbSalleBain'],
      nbSalleEau: json['nbSalleEau'],
      nbPieceReception: json['nbPieceReception'],
      nbTotalPiece: json['nbTotalPiece'],
      nbEtage: json['nbEtage'],
      confort: json['confort'],
      valeurLocativeMensuelle: json['valeurLocativeMensuelle'],
      valeurLocativeMensuelleSaisie: json['valeurLocativeMensuelleSaisie'],
      escalier: json['escalier'],
      videOrdure: json['videOrdure'],
      monteCharge: json['monteCharge'],
      groupeElectrogene: json['groupeElectrogene'],
      dependanceIsolee: json['dependanceIsolee'],
      garageSouterrain: json['garageSouterrain'],
      systemeClimatisation: json['systemeClimatisation'],
      systemeDomotique: json['systemeDomotique'],
      balcon: json['balcon'],
      terrasse: json['terrasse'],
      systemeSurveillance: json['systemeSurveillance'],
      amenagementPaysager: json['amenagementPaysager'],
      jardin: json['jardin'],
      piscine: json['piscine'],
      coursDeTennis: json['coursDeTennis'],
      coursGazonnee: json['coursGazonnee'],
      terrainGolf: json['terrainGolf'],
      autre: json['autre'],
      angle: json['angle'],
      eclairagePublic: json['eclairagePublic'],
      murEnCiment: json['murEnCiment'],
      attributsArchitecturaux: json['attributsArchitecturaux'],
      trottoir: json['trottoir'],
      nomVoirie: json['nomVoirie'],
      typeVoirie: json['typeVoirie'],
      nomAutreVoirie: json['nomAutreVoirie'],
      typeParcelle: json['typeParcelle'],
      idProprietaire: json['idProprietaire'],
      idParcelle: json['idParcelle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'identifiant': identifiant,
      'superficie': superficie,
      'proprieteEnLocation': proprieteEnLocation,
      'adresse': adresse,
      'numPorteAdm': numPorteAdm,
      'codeDeRueAdm': codeDeRueAdm,
      'nomRue': nomRue,
      'quartier': quartier,
      'village': village,
      'typeLot': typeLot,
      'niveauLot': niveauLot,
      'localisationLot': localisationLot,
      'situationLot': situationLot,
      'numLot': numLot,
      'valeurLocativeAnnuelle': valeurLocativeAnnuelle,
      'valeurLocativeAnnuelleSaisie': valeurLocativeAnnuelleSaisie,
      'numTitreFoncier': numTitreFoncier,
      'dateAcquisition': dateAcquisition,
      'typeOccupation': typeOccupation,
      'autreTypeOccupation': autreTypeOccupation,
      'dateDelivranceTypeOccupation': dateDelivranceTypeOccupation,
      'usagee': usagee,
      'numCompteurSde': numCompteurSde,
      'numCompteurSenelec': numCompteurSenelec,
      'typeConstruction': typeConstruction,
      'toiture': toiture,
      'typeCloture': typeCloture,
      'etatCloture': etatCloture,
      'typeRevetement': typeRevetement,
      'etatRevetement': etatRevetement,
      'situationRoute': situationRoute,
      'typeRoute': typeRoute,
      'garage': garage,
      'qualitePorteFenetre': qualitePorteFenetre,
      'typeCarrelage': typeCarrelage,
      'menuiserie': menuiserie,
      'conceptionPieces': conceptionPieces,
      'appareilsSanitaires': appareilsSanitaires,
      'parkingInterieur': parkingInterieur,
      'nbAscenseurs': nbAscenseurs,
      'nbSalleBain': nbSalleBain,
      'nbSalleEau': nbSalleEau,
      'nbPieceReception': nbPieceReception,
      'nbTotalPiece': nbTotalPiece,
      'nbEtage': nbEtage,
      'confort': confort,
      'valeurLocativeMensuelle': valeurLocativeMensuelle,
      'valeurLocativeMensuelleSaisie': valeurLocativeMensuelleSaisie,
      'escalier': escalier,
      'videOrdure': videOrdure,
      'monteCharge': monteCharge,
      'groupeElectrogene': groupeElectrogene,
      'dependanceIsolee': dependanceIsolee,
      'garageSouterrain': garageSouterrain,
      'systemeClimatisation': systemeClimatisation,
      'systemeDomotique': systemeDomotique,
      'balcon': balcon,
      'terrasse': terrasse,
      'systemeSurveillance': systemeSurveillance,
      'amenagementPaysager': amenagementPaysager,
      'jardin': jardin,
      'piscine': piscine,
      'coursDeTennis': coursDeTennis,
      'coursGazonnee': coursGazonnee,
      'terrainGolf': terrainGolf,
      'autre': autre,
      'angle': angle,
      'eclairagePublic': eclairagePublic,
      'murEnCiment': murEnCiment,
      'attributsArchitecturaux': attributsArchitecturaux,
      'trottoir': trottoir,
      'nomVoirie': nomVoirie,
      'typeVoirie': typeVoirie,
      'nomAutreVoirie': nomAutreVoirie,
      'typeParcelle': typeParcelle,
      'idProprietaire': idProprietaire,
      'idParcelle': idParcelle,
    };
  }
}
