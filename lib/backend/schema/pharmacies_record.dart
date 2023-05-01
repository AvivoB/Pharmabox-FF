import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'pharmacies_record.g.dart';

abstract class PharmaciesRecord
    implements Built<PharmaciesRecord, PharmaciesRecordBuilder> {
  static Serializer<PharmaciesRecord> get serializer =>
      _$pharmaciesRecordSerializer;

  String? get nom;

  String? get presentation;

  @BuiltValueField(wireName: 'maitre-de-stage')
  bool? get maitreDeStage;

  String? get email;

  String? get telephone;

  @BuiltValueField(wireName: 'preference-contact')
  String? get preferenceContact;

  LatLng? get adresse;

  String? get rer;

  String? get metro;

  String? get bus;

  String? get tramway;

  String? get gare;

  String? get stationnement;

  String? get typologie;

  @BuiltValueField(wireName: 'non-stop')
  bool? get nonStop;

  @BuiltValueField(wireName: 'patients-jour')
  String? get patientsJour;

  @BuiltValueField(wireName: 'mission-covid')
  bool? get missionCovid;

  @BuiltValueField(wireName: 'mission-vaccination')
  bool? get missionVaccination;

  @BuiltValueField(wireName: 'mission-entretien-pharmaceutique')
  bool? get missionEntretienPharmaceutique;

  @BuiltValueField(wireName: 'mission-type-preparation')
  String? get missionTypePreparation;

  @BuiltValueField(wireName: 'mission-borne-telemedecine')
  bool? get missionBorneTelemedecine;

  @BuiltValueField(wireName: 'confort-salle-de-pause')
  bool? get confortSalleDePause;

  @BuiltValueField(wireName: 'confort-robot')
  bool? get confortRobot;

  @BuiltValueField(wireName: 'confort-etiquette-electronique')
  bool? get confortEtiquetteElectronique;

  @BuiltValueField(wireName: 'confort-moneyeur')
  String? get confortMoneyeur;

  @BuiltValueField(wireName: 'confort-clim')
  bool? get confortClim;

  @BuiltValueField(wireName: 'confort-chauffage')
  bool? get confortChauffage;

  @BuiltValueField(wireName: 'confort-vigile')
  bool? get confortVigile;

  @BuiltValueField(wireName: 'confort-comite-entreprise')
  bool? get confortComiteEntreprise;

  @BuiltValueField(wireName: 'tendances-ordonances')
  double? get tendancesOrdonances;

  @BuiltValueField(wireName: 'tendances-cosmetiques')
  double? get tendancesCosmetiques;

  @BuiltValueField(wireName: 'tendances-phyto')
  double? get tendancesPhyto;

  @BuiltValueField(wireName: 'tendances-nutrition')
  double? get tendancesNutrition;

  @BuiltValueField(wireName: 'tendances-conseil')
  double? get tendancesConseil;

  @BuiltValueField(wireName: 'equipe-pharma')
  String? get equipePharma;

  @BuiltValueField(wireName: 'equipe-preparateurs')
  String? get equipePreparateurs;

  @BuiltValueField(wireName: 'equipe-rayonnistes')
  String? get equipeRayonnistes;

  @BuiltValueField(wireName: 'equipe-conseillers')
  String? get equipeConseillers;

  @BuiltValueField(wireName: 'equipe-apprentis')
  String? get equipeApprentis;

  @BuiltValueField(wireName: 'equipe-etudiants-pharmacie')
  String? get equipeEtudiantsPharmacie;

  @BuiltValueField(wireName: 'equipe-etudiants-6-annee')
  String? get equipeEtudiants6Annee;

  @BuiltValueField(wireName: 'Horaire-Lundi')
  BuiltList<DateTime>? get horaireLundi;

  @BuiltValueField(wireName: 'Horaire-Mardi')
  BuiltList<DateTime>? get horaireMardi;

  @BuiltValueField(wireName: 'Horaire-Mercredi')
  BuiltList<DateTime>? get horaireMercredi;

  @BuiltValueField(wireName: 'Horaire-Jeudi')
  BuiltList<DateTime>? get horaireJeudi;

  @BuiltValueField(wireName: 'Horaire-Vendredi')
  BuiltList<DateTime>? get horaireVendredi;

  @BuiltValueField(wireName: 'Horaire-Samedi')
  BuiltList<DateTime>? get horaireSamedi;

  @BuiltValueField(wireName: 'Horaie-Dimanche')
  BuiltList<DateTime>? get horaieDimanche;

  String? get titulaire;

  @BuiltValueField(wireName: 'co-titulaire')
  BuiltList<String>? get coTitulaire;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(PharmaciesRecordBuilder builder) => builder
    ..nom = ''
    ..presentation = ''
    ..maitreDeStage = false
    ..email = ''
    ..telephone = ''
    ..preferenceContact = ''
    ..rer = ''
    ..metro = ''
    ..bus = ''
    ..tramway = ''
    ..gare = ''
    ..stationnement = ''
    ..typologie = ''
    ..nonStop = false
    ..patientsJour = ''
    ..missionCovid = false
    ..missionVaccination = false
    ..missionEntretienPharmaceutique = false
    ..missionTypePreparation = ''
    ..missionBorneTelemedecine = false
    ..confortSalleDePause = false
    ..confortRobot = false
    ..confortEtiquetteElectronique = false
    ..confortMoneyeur = ''
    ..confortClim = false
    ..confortChauffage = false
    ..confortVigile = false
    ..confortComiteEntreprise = false
    ..tendancesOrdonances = 0.0
    ..tendancesCosmetiques = 0.0
    ..tendancesPhyto = 0.0
    ..tendancesNutrition = 0.0
    ..tendancesConseil = 0.0
    ..equipePharma = ''
    ..equipePreparateurs = ''
    ..equipeRayonnistes = ''
    ..equipeConseillers = ''
    ..equipeApprentis = ''
    ..equipeEtudiantsPharmacie = ''
    ..equipeEtudiants6Annee = ''
    ..horaireLundi = ListBuilder()
    ..horaireMardi = ListBuilder()
    ..horaireMercredi = ListBuilder()
    ..horaireJeudi = ListBuilder()
    ..horaireVendredi = ListBuilder()
    ..horaireSamedi = ListBuilder()
    ..horaieDimanche = ListBuilder()
    ..titulaire = ''
    ..coTitulaire = ListBuilder();

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('pharmacies');

  static Stream<PharmaciesRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<PharmaciesRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  PharmaciesRecord._();
  factory PharmaciesRecord([void Function(PharmaciesRecordBuilder) updates]) =
      _$PharmaciesRecord;

  static PharmaciesRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;
}

Map<String, dynamic> createPharmaciesRecordData({
  String? nom,
  String? presentation,
  bool? maitreDeStage,
  String? email,
  String? telephone,
  String? preferenceContact,
  LatLng? adresse,
  String? rer,
  String? metro,
  String? bus,
  String? tramway,
  String? gare,
  String? stationnement,
  String? typologie,
  bool? nonStop,
  String? patientsJour,
  bool? missionCovid,
  bool? missionVaccination,
  bool? missionEntretienPharmaceutique,
  String? missionTypePreparation,
  bool? missionBorneTelemedecine,
  bool? confortSalleDePause,
  bool? confortRobot,
  bool? confortEtiquetteElectronique,
  String? confortMoneyeur,
  bool? confortClim,
  bool? confortChauffage,
  bool? confortVigile,
  bool? confortComiteEntreprise,
  double? tendancesOrdonances,
  double? tendancesCosmetiques,
  double? tendancesPhyto,
  double? tendancesNutrition,
  double? tendancesConseil,
  String? equipePharma,
  String? equipePreparateurs,
  String? equipeRayonnistes,
  String? equipeConseillers,
  String? equipeApprentis,
  String? equipeEtudiantsPharmacie,
  String? equipeEtudiants6Annee,
  String? titulaire,
}) {
  final firestoreData = serializers.toFirestore(
    PharmaciesRecord.serializer,
    PharmaciesRecord(
      (p) => p
        ..nom = nom
        ..presentation = presentation
        ..maitreDeStage = maitreDeStage
        ..email = email
        ..telephone = telephone
        ..preferenceContact = preferenceContact
        ..adresse = adresse
        ..rer = rer
        ..metro = metro
        ..bus = bus
        ..tramway = tramway
        ..gare = gare
        ..stationnement = stationnement
        ..typologie = typologie
        ..nonStop = nonStop
        ..patientsJour = patientsJour
        ..missionCovid = missionCovid
        ..missionVaccination = missionVaccination
        ..missionEntretienPharmaceutique = missionEntretienPharmaceutique
        ..missionTypePreparation = missionTypePreparation
        ..missionBorneTelemedecine = missionBorneTelemedecine
        ..confortSalleDePause = confortSalleDePause
        ..confortRobot = confortRobot
        ..confortEtiquetteElectronique = confortEtiquetteElectronique
        ..confortMoneyeur = confortMoneyeur
        ..confortClim = confortClim
        ..confortChauffage = confortChauffage
        ..confortVigile = confortVigile
        ..confortComiteEntreprise = confortComiteEntreprise
        ..tendancesOrdonances = tendancesOrdonances
        ..tendancesCosmetiques = tendancesCosmetiques
        ..tendancesPhyto = tendancesPhyto
        ..tendancesNutrition = tendancesNutrition
        ..tendancesConseil = tendancesConseil
        ..equipePharma = equipePharma
        ..equipePreparateurs = equipePreparateurs
        ..equipeRayonnistes = equipeRayonnistes
        ..equipeConseillers = equipeConseillers
        ..equipeApprentis = equipeApprentis
        ..equipeEtudiantsPharmacie = equipeEtudiantsPharmacie
        ..equipeEtudiants6Annee = equipeEtudiants6Annee
        ..horaireLundi = null
        ..horaireMardi = null
        ..horaireMercredi = null
        ..horaireJeudi = null
        ..horaireVendredi = null
        ..horaireSamedi = null
        ..horaieDimanche = null
        ..titulaire = titulaire
        ..coTitulaire = null,
    ),
  );

  return firestoreData;
}
