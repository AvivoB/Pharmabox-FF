// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pharmacies_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<PharmaciesRecord> _$pharmaciesRecordSerializer =
    new _$PharmaciesRecordSerializer();

class _$PharmaciesRecordSerializer
    implements StructuredSerializer<PharmaciesRecord> {
  @override
  final Iterable<Type> types = const [PharmaciesRecord, _$PharmaciesRecord];
  @override
  final String wireName = 'PharmaciesRecord';

  @override
  Iterable<Object?> serialize(Serializers serializers, PharmaciesRecord object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'groupement',
      serializers.serialize(object.groupement,
          specifiedType: const FullType(GroupementStruct)),
      'lgo',
      serializers.serialize(object.lgo,
          specifiedType: const FullType(LgoStruct)),
    ];
    Object? value;
    value = object.nom;
    if (value != null) {
      result
        ..add('nom')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.presentation;
    if (value != null) {
      result
        ..add('presentation')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.maitreDeStage;
    if (value != null) {
      result
        ..add('maitre-de-stage')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.email;
    if (value != null) {
      result
        ..add('email')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.telephone;
    if (value != null) {
      result
        ..add('telephone')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.preferenceContact;
    if (value != null) {
      result
        ..add('preference-contact')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.adresse;
    if (value != null) {
      result
        ..add('adresse')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(LatLng)));
    }
    value = object.rer;
    if (value != null) {
      result
        ..add('rer')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.metro;
    if (value != null) {
      result
        ..add('metro')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.bus;
    if (value != null) {
      result
        ..add('bus')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.tramway;
    if (value != null) {
      result
        ..add('tramway')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.gare;
    if (value != null) {
      result
        ..add('gare')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.stationnement;
    if (value != null) {
      result
        ..add('stationnement')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.typologie;
    if (value != null) {
      result
        ..add('typologie')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.nonStop;
    if (value != null) {
      result
        ..add('non-stop')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.patientsJour;
    if (value != null) {
      result
        ..add('patients-jour')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.missionCovid;
    if (value != null) {
      result
        ..add('mission-covid')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.missionVaccination;
    if (value != null) {
      result
        ..add('mission-vaccination')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.missionEntretienPharmaceutique;
    if (value != null) {
      result
        ..add('mission-entretien-pharmaceutique')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.missionTypePreparation;
    if (value != null) {
      result
        ..add('mission-type-preparation')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.missionBorneTelemedecine;
    if (value != null) {
      result
        ..add('mission-borne-telemedecine')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.confortSalleDePause;
    if (value != null) {
      result
        ..add('confort-salle-de-pause')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.confortRobot;
    if (value != null) {
      result
        ..add('confort-robot')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.confortEtiquetteElectronique;
    if (value != null) {
      result
        ..add('confort-etiquette-electronique')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.confortMoneyeur;
    if (value != null) {
      result
        ..add('confort-moneyeur')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.confortClim;
    if (value != null) {
      result
        ..add('confort-clim')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.confortChauffage;
    if (value != null) {
      result
        ..add('confort-chauffage')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.confortVigile;
    if (value != null) {
      result
        ..add('confort-vigile')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.confortComiteEntreprise;
    if (value != null) {
      result
        ..add('confort-comite-entreprise')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.tendancesOrdonances;
    if (value != null) {
      result
        ..add('tendances-ordonances')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.tendancesCosmetiques;
    if (value != null) {
      result
        ..add('tendances-cosmetiques')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.tendancesPhyto;
    if (value != null) {
      result
        ..add('tendances-phyto')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.tendancesNutrition;
    if (value != null) {
      result
        ..add('tendances-nutrition')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.tendancesConseil;
    if (value != null) {
      result
        ..add('tendances-conseil')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.equipePharma;
    if (value != null) {
      result
        ..add('equipe-pharma')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.equipePreparateurs;
    if (value != null) {
      result
        ..add('equipe-preparateurs')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.equipeRayonnistes;
    if (value != null) {
      result
        ..add('equipe-rayonnistes')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.equipeConseillers;
    if (value != null) {
      result
        ..add('equipe-conseillers')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.equipeApprentis;
    if (value != null) {
      result
        ..add('equipe-apprentis')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.equipeEtudiantsPharmacie;
    if (value != null) {
      result
        ..add('equipe-etudiants-pharmacie')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.equipeEtudiants6Annee;
    if (value != null) {
      result
        ..add('equipe-etudiants-6-annee')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.horaireLundi;
    if (value != null) {
      result
        ..add('Horaire-Lundi')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(DateTime)])));
    }
    value = object.horaireMardi;
    if (value != null) {
      result
        ..add('Horaire-Mardi')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(DateTime)])));
    }
    value = object.horaireMercredi;
    if (value != null) {
      result
        ..add('Horaire-Mercredi')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(DateTime)])));
    }
    value = object.horaireJeudi;
    if (value != null) {
      result
        ..add('Horaire-Jeudi')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(DateTime)])));
    }
    value = object.horaireVendredi;
    if (value != null) {
      result
        ..add('Horaire-Vendredi')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(DateTime)])));
    }
    value = object.horaireSamedi;
    if (value != null) {
      result
        ..add('Horaire-Samedi')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(DateTime)])));
    }
    value = object.horaieDimanche;
    if (value != null) {
      result
        ..add('Horaie-Dimanche')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(DateTime)])));
    }
    value = object.titulaire;
    if (value != null) {
      result
        ..add('titulaire')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.coTitulaire;
    if (value != null) {
      result
        ..add('co-titulaire')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    value = object.ffRef;
    if (value != null) {
      result
        ..add('Document__Reference__Field')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                DocumentReference, const [const FullType.nullable(Object)])));
    }
    return result;
  }

  @override
  PharmaciesRecord deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PharmaciesRecordBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'nom':
          result.nom = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'groupement':
          result.groupement.replace(serializers.deserialize(value,
                  specifiedType: const FullType(GroupementStruct))!
              as GroupementStruct);
          break;
        case 'presentation':
          result.presentation = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'maitre-de-stage':
          result.maitreDeStage = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'telephone':
          result.telephone = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'preference-contact':
          result.preferenceContact = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'adresse':
          result.adresse = serializers.deserialize(value,
              specifiedType: const FullType(LatLng)) as LatLng?;
          break;
        case 'rer':
          result.rer = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'metro':
          result.metro = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'bus':
          result.bus = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'tramway':
          result.tramway = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'gare':
          result.gare = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'stationnement':
          result.stationnement = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'typologie':
          result.typologie = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'non-stop':
          result.nonStop = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'patients-jour':
          result.patientsJour = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'mission-covid':
          result.missionCovid = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'mission-vaccination':
          result.missionVaccination = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'mission-entretien-pharmaceutique':
          result.missionEntretienPharmaceutique = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'mission-type-preparation':
          result.missionTypePreparation = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'mission-borne-telemedecine':
          result.missionBorneTelemedecine = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'lgo':
          result.lgo.replace(serializers.deserialize(value,
              specifiedType: const FullType(LgoStruct))! as LgoStruct);
          break;
        case 'confort-salle-de-pause':
          result.confortSalleDePause = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'confort-robot':
          result.confortRobot = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'confort-etiquette-electronique':
          result.confortEtiquetteElectronique = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'confort-moneyeur':
          result.confortMoneyeur = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'confort-clim':
          result.confortClim = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'confort-chauffage':
          result.confortChauffage = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'confort-vigile':
          result.confortVigile = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'confort-comite-entreprise':
          result.confortComiteEntreprise = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'tendances-ordonances':
          result.tendancesOrdonances = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
        case 'tendances-cosmetiques':
          result.tendancesCosmetiques = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
        case 'tendances-phyto':
          result.tendancesPhyto = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
        case 'tendances-nutrition':
          result.tendancesNutrition = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
        case 'tendances-conseil':
          result.tendancesConseil = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
        case 'equipe-pharma':
          result.equipePharma = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'equipe-preparateurs':
          result.equipePreparateurs = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'equipe-rayonnistes':
          result.equipeRayonnistes = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'equipe-conseillers':
          result.equipeConseillers = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'equipe-apprentis':
          result.equipeApprentis = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'equipe-etudiants-pharmacie':
          result.equipeEtudiantsPharmacie = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'equipe-etudiants-6-annee':
          result.equipeEtudiants6Annee = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'Horaire-Lundi':
          result.horaireLundi.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(DateTime)]))!
              as BuiltList<Object?>);
          break;
        case 'Horaire-Mardi':
          result.horaireMardi.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(DateTime)]))!
              as BuiltList<Object?>);
          break;
        case 'Horaire-Mercredi':
          result.horaireMercredi.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(DateTime)]))!
              as BuiltList<Object?>);
          break;
        case 'Horaire-Jeudi':
          result.horaireJeudi.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(DateTime)]))!
              as BuiltList<Object?>);
          break;
        case 'Horaire-Vendredi':
          result.horaireVendredi.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(DateTime)]))!
              as BuiltList<Object?>);
          break;
        case 'Horaire-Samedi':
          result.horaireSamedi.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(DateTime)]))!
              as BuiltList<Object?>);
          break;
        case 'Horaie-Dimanche':
          result.horaieDimanche.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(DateTime)]))!
              as BuiltList<Object?>);
          break;
        case 'titulaire':
          result.titulaire = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'co-titulaire':
          result.coTitulaire.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'Document__Reference__Field':
          result.ffRef = serializers.deserialize(value,
              specifiedType: const FullType(DocumentReference, const [
                const FullType.nullable(Object)
              ])) as DocumentReference<Object?>?;
          break;
      }
    }

    return result.build();
  }
}

class _$PharmaciesRecord extends PharmaciesRecord {
  @override
  final String? nom;
  @override
  final GroupementStruct groupement;
  @override
  final String? presentation;
  @override
  final bool? maitreDeStage;
  @override
  final String? email;
  @override
  final String? telephone;
  @override
  final String? preferenceContact;
  @override
  final LatLng? adresse;
  @override
  final String? rer;
  @override
  final String? metro;
  @override
  final String? bus;
  @override
  final String? tramway;
  @override
  final String? gare;
  @override
  final String? stationnement;
  @override
  final String? typologie;
  @override
  final bool? nonStop;
  @override
  final String? patientsJour;
  @override
  final bool? missionCovid;
  @override
  final bool? missionVaccination;
  @override
  final bool? missionEntretienPharmaceutique;
  @override
  final String? missionTypePreparation;
  @override
  final bool? missionBorneTelemedecine;
  @override
  final LgoStruct lgo;
  @override
  final bool? confortSalleDePause;
  @override
  final bool? confortRobot;
  @override
  final bool? confortEtiquetteElectronique;
  @override
  final String? confortMoneyeur;
  @override
  final bool? confortClim;
  @override
  final bool? confortChauffage;
  @override
  final bool? confortVigile;
  @override
  final bool? confortComiteEntreprise;
  @override
  final double? tendancesOrdonances;
  @override
  final double? tendancesCosmetiques;
  @override
  final double? tendancesPhyto;
  @override
  final double? tendancesNutrition;
  @override
  final double? tendancesConseil;
  @override
  final String? equipePharma;
  @override
  final String? equipePreparateurs;
  @override
  final String? equipeRayonnistes;
  @override
  final String? equipeConseillers;
  @override
  final String? equipeApprentis;
  @override
  final String? equipeEtudiantsPharmacie;
  @override
  final String? equipeEtudiants6Annee;
  @override
  final BuiltList<DateTime>? horaireLundi;
  @override
  final BuiltList<DateTime>? horaireMardi;
  @override
  final BuiltList<DateTime>? horaireMercredi;
  @override
  final BuiltList<DateTime>? horaireJeudi;
  @override
  final BuiltList<DateTime>? horaireVendredi;
  @override
  final BuiltList<DateTime>? horaireSamedi;
  @override
  final BuiltList<DateTime>? horaieDimanche;
  @override
  final String? titulaire;
  @override
  final BuiltList<String>? coTitulaire;
  @override
  final DocumentReference<Object?>? ffRef;

  factory _$PharmaciesRecord(
          [void Function(PharmaciesRecordBuilder)? updates]) =>
      (new PharmaciesRecordBuilder()..update(updates))._build();

  _$PharmaciesRecord._(
      {this.nom,
      required this.groupement,
      this.presentation,
      this.maitreDeStage,
      this.email,
      this.telephone,
      this.preferenceContact,
      this.adresse,
      this.rer,
      this.metro,
      this.bus,
      this.tramway,
      this.gare,
      this.stationnement,
      this.typologie,
      this.nonStop,
      this.patientsJour,
      this.missionCovid,
      this.missionVaccination,
      this.missionEntretienPharmaceutique,
      this.missionTypePreparation,
      this.missionBorneTelemedecine,
      required this.lgo,
      this.confortSalleDePause,
      this.confortRobot,
      this.confortEtiquetteElectronique,
      this.confortMoneyeur,
      this.confortClim,
      this.confortChauffage,
      this.confortVigile,
      this.confortComiteEntreprise,
      this.tendancesOrdonances,
      this.tendancesCosmetiques,
      this.tendancesPhyto,
      this.tendancesNutrition,
      this.tendancesConseil,
      this.equipePharma,
      this.equipePreparateurs,
      this.equipeRayonnistes,
      this.equipeConseillers,
      this.equipeApprentis,
      this.equipeEtudiantsPharmacie,
      this.equipeEtudiants6Annee,
      this.horaireLundi,
      this.horaireMardi,
      this.horaireMercredi,
      this.horaireJeudi,
      this.horaireVendredi,
      this.horaireSamedi,
      this.horaieDimanche,
      this.titulaire,
      this.coTitulaire,
      this.ffRef})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        groupement, r'PharmaciesRecord', 'groupement');
    BuiltValueNullFieldError.checkNotNull(lgo, r'PharmaciesRecord', 'lgo');
  }

  @override
  PharmaciesRecord rebuild(void Function(PharmaciesRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PharmaciesRecordBuilder toBuilder() =>
      new PharmaciesRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PharmaciesRecord &&
        nom == other.nom &&
        groupement == other.groupement &&
        presentation == other.presentation &&
        maitreDeStage == other.maitreDeStage &&
        email == other.email &&
        telephone == other.telephone &&
        preferenceContact == other.preferenceContact &&
        adresse == other.adresse &&
        rer == other.rer &&
        metro == other.metro &&
        bus == other.bus &&
        tramway == other.tramway &&
        gare == other.gare &&
        stationnement == other.stationnement &&
        typologie == other.typologie &&
        nonStop == other.nonStop &&
        patientsJour == other.patientsJour &&
        missionCovid == other.missionCovid &&
        missionVaccination == other.missionVaccination &&
        missionEntretienPharmaceutique ==
            other.missionEntretienPharmaceutique &&
        missionTypePreparation == other.missionTypePreparation &&
        missionBorneTelemedecine == other.missionBorneTelemedecine &&
        lgo == other.lgo &&
        confortSalleDePause == other.confortSalleDePause &&
        confortRobot == other.confortRobot &&
        confortEtiquetteElectronique == other.confortEtiquetteElectronique &&
        confortMoneyeur == other.confortMoneyeur &&
        confortClim == other.confortClim &&
        confortChauffage == other.confortChauffage &&
        confortVigile == other.confortVigile &&
        confortComiteEntreprise == other.confortComiteEntreprise &&
        tendancesOrdonances == other.tendancesOrdonances &&
        tendancesCosmetiques == other.tendancesCosmetiques &&
        tendancesPhyto == other.tendancesPhyto &&
        tendancesNutrition == other.tendancesNutrition &&
        tendancesConseil == other.tendancesConseil &&
        equipePharma == other.equipePharma &&
        equipePreparateurs == other.equipePreparateurs &&
        equipeRayonnistes == other.equipeRayonnistes &&
        equipeConseillers == other.equipeConseillers &&
        equipeApprentis == other.equipeApprentis &&
        equipeEtudiantsPharmacie == other.equipeEtudiantsPharmacie &&
        equipeEtudiants6Annee == other.equipeEtudiants6Annee &&
        horaireLundi == other.horaireLundi &&
        horaireMardi == other.horaireMardi &&
        horaireMercredi == other.horaireMercredi &&
        horaireJeudi == other.horaireJeudi &&
        horaireVendredi == other.horaireVendredi &&
        horaireSamedi == other.horaireSamedi &&
        horaieDimanche == other.horaieDimanche &&
        titulaire == other.titulaire &&
        coTitulaire == other.coTitulaire &&
        ffRef == other.ffRef;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, nom.hashCode);
    _$hash = $jc(_$hash, groupement.hashCode);
    _$hash = $jc(_$hash, presentation.hashCode);
    _$hash = $jc(_$hash, maitreDeStage.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, telephone.hashCode);
    _$hash = $jc(_$hash, preferenceContact.hashCode);
    _$hash = $jc(_$hash, adresse.hashCode);
    _$hash = $jc(_$hash, rer.hashCode);
    _$hash = $jc(_$hash, metro.hashCode);
    _$hash = $jc(_$hash, bus.hashCode);
    _$hash = $jc(_$hash, tramway.hashCode);
    _$hash = $jc(_$hash, gare.hashCode);
    _$hash = $jc(_$hash, stationnement.hashCode);
    _$hash = $jc(_$hash, typologie.hashCode);
    _$hash = $jc(_$hash, nonStop.hashCode);
    _$hash = $jc(_$hash, patientsJour.hashCode);
    _$hash = $jc(_$hash, missionCovid.hashCode);
    _$hash = $jc(_$hash, missionVaccination.hashCode);
    _$hash = $jc(_$hash, missionEntretienPharmaceutique.hashCode);
    _$hash = $jc(_$hash, missionTypePreparation.hashCode);
    _$hash = $jc(_$hash, missionBorneTelemedecine.hashCode);
    _$hash = $jc(_$hash, lgo.hashCode);
    _$hash = $jc(_$hash, confortSalleDePause.hashCode);
    _$hash = $jc(_$hash, confortRobot.hashCode);
    _$hash = $jc(_$hash, confortEtiquetteElectronique.hashCode);
    _$hash = $jc(_$hash, confortMoneyeur.hashCode);
    _$hash = $jc(_$hash, confortClim.hashCode);
    _$hash = $jc(_$hash, confortChauffage.hashCode);
    _$hash = $jc(_$hash, confortVigile.hashCode);
    _$hash = $jc(_$hash, confortComiteEntreprise.hashCode);
    _$hash = $jc(_$hash, tendancesOrdonances.hashCode);
    _$hash = $jc(_$hash, tendancesCosmetiques.hashCode);
    _$hash = $jc(_$hash, tendancesPhyto.hashCode);
    _$hash = $jc(_$hash, tendancesNutrition.hashCode);
    _$hash = $jc(_$hash, tendancesConseil.hashCode);
    _$hash = $jc(_$hash, equipePharma.hashCode);
    _$hash = $jc(_$hash, equipePreparateurs.hashCode);
    _$hash = $jc(_$hash, equipeRayonnistes.hashCode);
    _$hash = $jc(_$hash, equipeConseillers.hashCode);
    _$hash = $jc(_$hash, equipeApprentis.hashCode);
    _$hash = $jc(_$hash, equipeEtudiantsPharmacie.hashCode);
    _$hash = $jc(_$hash, equipeEtudiants6Annee.hashCode);
    _$hash = $jc(_$hash, horaireLundi.hashCode);
    _$hash = $jc(_$hash, horaireMardi.hashCode);
    _$hash = $jc(_$hash, horaireMercredi.hashCode);
    _$hash = $jc(_$hash, horaireJeudi.hashCode);
    _$hash = $jc(_$hash, horaireVendredi.hashCode);
    _$hash = $jc(_$hash, horaireSamedi.hashCode);
    _$hash = $jc(_$hash, horaieDimanche.hashCode);
    _$hash = $jc(_$hash, titulaire.hashCode);
    _$hash = $jc(_$hash, coTitulaire.hashCode);
    _$hash = $jc(_$hash, ffRef.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PharmaciesRecord')
          ..add('nom', nom)
          ..add('groupement', groupement)
          ..add('presentation', presentation)
          ..add('maitreDeStage', maitreDeStage)
          ..add('email', email)
          ..add('telephone', telephone)
          ..add('preferenceContact', preferenceContact)
          ..add('adresse', adresse)
          ..add('rer', rer)
          ..add('metro', metro)
          ..add('bus', bus)
          ..add('tramway', tramway)
          ..add('gare', gare)
          ..add('stationnement', stationnement)
          ..add('typologie', typologie)
          ..add('nonStop', nonStop)
          ..add('patientsJour', patientsJour)
          ..add('missionCovid', missionCovid)
          ..add('missionVaccination', missionVaccination)
          ..add(
              'missionEntretienPharmaceutique', missionEntretienPharmaceutique)
          ..add('missionTypePreparation', missionTypePreparation)
          ..add('missionBorneTelemedecine', missionBorneTelemedecine)
          ..add('lgo', lgo)
          ..add('confortSalleDePause', confortSalleDePause)
          ..add('confortRobot', confortRobot)
          ..add('confortEtiquetteElectronique', confortEtiquetteElectronique)
          ..add('confortMoneyeur', confortMoneyeur)
          ..add('confortClim', confortClim)
          ..add('confortChauffage', confortChauffage)
          ..add('confortVigile', confortVigile)
          ..add('confortComiteEntreprise', confortComiteEntreprise)
          ..add('tendancesOrdonances', tendancesOrdonances)
          ..add('tendancesCosmetiques', tendancesCosmetiques)
          ..add('tendancesPhyto', tendancesPhyto)
          ..add('tendancesNutrition', tendancesNutrition)
          ..add('tendancesConseil', tendancesConseil)
          ..add('equipePharma', equipePharma)
          ..add('equipePreparateurs', equipePreparateurs)
          ..add('equipeRayonnistes', equipeRayonnistes)
          ..add('equipeConseillers', equipeConseillers)
          ..add('equipeApprentis', equipeApprentis)
          ..add('equipeEtudiantsPharmacie', equipeEtudiantsPharmacie)
          ..add('equipeEtudiants6Annee', equipeEtudiants6Annee)
          ..add('horaireLundi', horaireLundi)
          ..add('horaireMardi', horaireMardi)
          ..add('horaireMercredi', horaireMercredi)
          ..add('horaireJeudi', horaireJeudi)
          ..add('horaireVendredi', horaireVendredi)
          ..add('horaireSamedi', horaireSamedi)
          ..add('horaieDimanche', horaieDimanche)
          ..add('titulaire', titulaire)
          ..add('coTitulaire', coTitulaire)
          ..add('ffRef', ffRef))
        .toString();
  }
}

class PharmaciesRecordBuilder
    implements Builder<PharmaciesRecord, PharmaciesRecordBuilder> {
  _$PharmaciesRecord? _$v;

  String? _nom;
  String? get nom => _$this._nom;
  set nom(String? nom) => _$this._nom = nom;

  GroupementStructBuilder? _groupement;
  GroupementStructBuilder get groupement =>
      _$this._groupement ??= new GroupementStructBuilder();
  set groupement(GroupementStructBuilder? groupement) =>
      _$this._groupement = groupement;

  String? _presentation;
  String? get presentation => _$this._presentation;
  set presentation(String? presentation) => _$this._presentation = presentation;

  bool? _maitreDeStage;
  bool? get maitreDeStage => _$this._maitreDeStage;
  set maitreDeStage(bool? maitreDeStage) =>
      _$this._maitreDeStage = maitreDeStage;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _telephone;
  String? get telephone => _$this._telephone;
  set telephone(String? telephone) => _$this._telephone = telephone;

  String? _preferenceContact;
  String? get preferenceContact => _$this._preferenceContact;
  set preferenceContact(String? preferenceContact) =>
      _$this._preferenceContact = preferenceContact;

  LatLng? _adresse;
  LatLng? get adresse => _$this._adresse;
  set adresse(LatLng? adresse) => _$this._adresse = adresse;

  String? _rer;
  String? get rer => _$this._rer;
  set rer(String? rer) => _$this._rer = rer;

  String? _metro;
  String? get metro => _$this._metro;
  set metro(String? metro) => _$this._metro = metro;

  String? _bus;
  String? get bus => _$this._bus;
  set bus(String? bus) => _$this._bus = bus;

  String? _tramway;
  String? get tramway => _$this._tramway;
  set tramway(String? tramway) => _$this._tramway = tramway;

  String? _gare;
  String? get gare => _$this._gare;
  set gare(String? gare) => _$this._gare = gare;

  String? _stationnement;
  String? get stationnement => _$this._stationnement;
  set stationnement(String? stationnement) =>
      _$this._stationnement = stationnement;

  String? _typologie;
  String? get typologie => _$this._typologie;
  set typologie(String? typologie) => _$this._typologie = typologie;

  bool? _nonStop;
  bool? get nonStop => _$this._nonStop;
  set nonStop(bool? nonStop) => _$this._nonStop = nonStop;

  String? _patientsJour;
  String? get patientsJour => _$this._patientsJour;
  set patientsJour(String? patientsJour) => _$this._patientsJour = patientsJour;

  bool? _missionCovid;
  bool? get missionCovid => _$this._missionCovid;
  set missionCovid(bool? missionCovid) => _$this._missionCovid = missionCovid;

  bool? _missionVaccination;
  bool? get missionVaccination => _$this._missionVaccination;
  set missionVaccination(bool? missionVaccination) =>
      _$this._missionVaccination = missionVaccination;

  bool? _missionEntretienPharmaceutique;
  bool? get missionEntretienPharmaceutique =>
      _$this._missionEntretienPharmaceutique;
  set missionEntretienPharmaceutique(bool? missionEntretienPharmaceutique) =>
      _$this._missionEntretienPharmaceutique = missionEntretienPharmaceutique;

  String? _missionTypePreparation;
  String? get missionTypePreparation => _$this._missionTypePreparation;
  set missionTypePreparation(String? missionTypePreparation) =>
      _$this._missionTypePreparation = missionTypePreparation;

  bool? _missionBorneTelemedecine;
  bool? get missionBorneTelemedecine => _$this._missionBorneTelemedecine;
  set missionBorneTelemedecine(bool? missionBorneTelemedecine) =>
      _$this._missionBorneTelemedecine = missionBorneTelemedecine;

  LgoStructBuilder? _lgo;
  LgoStructBuilder get lgo => _$this._lgo ??= new LgoStructBuilder();
  set lgo(LgoStructBuilder? lgo) => _$this._lgo = lgo;

  bool? _confortSalleDePause;
  bool? get confortSalleDePause => _$this._confortSalleDePause;
  set confortSalleDePause(bool? confortSalleDePause) =>
      _$this._confortSalleDePause = confortSalleDePause;

  bool? _confortRobot;
  bool? get confortRobot => _$this._confortRobot;
  set confortRobot(bool? confortRobot) => _$this._confortRobot = confortRobot;

  bool? _confortEtiquetteElectronique;
  bool? get confortEtiquetteElectronique =>
      _$this._confortEtiquetteElectronique;
  set confortEtiquetteElectronique(bool? confortEtiquetteElectronique) =>
      _$this._confortEtiquetteElectronique = confortEtiquetteElectronique;

  String? _confortMoneyeur;
  String? get confortMoneyeur => _$this._confortMoneyeur;
  set confortMoneyeur(String? confortMoneyeur) =>
      _$this._confortMoneyeur = confortMoneyeur;

  bool? _confortClim;
  bool? get confortClim => _$this._confortClim;
  set confortClim(bool? confortClim) => _$this._confortClim = confortClim;

  bool? _confortChauffage;
  bool? get confortChauffage => _$this._confortChauffage;
  set confortChauffage(bool? confortChauffage) =>
      _$this._confortChauffage = confortChauffage;

  bool? _confortVigile;
  bool? get confortVigile => _$this._confortVigile;
  set confortVigile(bool? confortVigile) =>
      _$this._confortVigile = confortVigile;

  bool? _confortComiteEntreprise;
  bool? get confortComiteEntreprise => _$this._confortComiteEntreprise;
  set confortComiteEntreprise(bool? confortComiteEntreprise) =>
      _$this._confortComiteEntreprise = confortComiteEntreprise;

  double? _tendancesOrdonances;
  double? get tendancesOrdonances => _$this._tendancesOrdonances;
  set tendancesOrdonances(double? tendancesOrdonances) =>
      _$this._tendancesOrdonances = tendancesOrdonances;

  double? _tendancesCosmetiques;
  double? get tendancesCosmetiques => _$this._tendancesCosmetiques;
  set tendancesCosmetiques(double? tendancesCosmetiques) =>
      _$this._tendancesCosmetiques = tendancesCosmetiques;

  double? _tendancesPhyto;
  double? get tendancesPhyto => _$this._tendancesPhyto;
  set tendancesPhyto(double? tendancesPhyto) =>
      _$this._tendancesPhyto = tendancesPhyto;

  double? _tendancesNutrition;
  double? get tendancesNutrition => _$this._tendancesNutrition;
  set tendancesNutrition(double? tendancesNutrition) =>
      _$this._tendancesNutrition = tendancesNutrition;

  double? _tendancesConseil;
  double? get tendancesConseil => _$this._tendancesConseil;
  set tendancesConseil(double? tendancesConseil) =>
      _$this._tendancesConseil = tendancesConseil;

  String? _equipePharma;
  String? get equipePharma => _$this._equipePharma;
  set equipePharma(String? equipePharma) => _$this._equipePharma = equipePharma;

  String? _equipePreparateurs;
  String? get equipePreparateurs => _$this._equipePreparateurs;
  set equipePreparateurs(String? equipePreparateurs) =>
      _$this._equipePreparateurs = equipePreparateurs;

  String? _equipeRayonnistes;
  String? get equipeRayonnistes => _$this._equipeRayonnistes;
  set equipeRayonnistes(String? equipeRayonnistes) =>
      _$this._equipeRayonnistes = equipeRayonnistes;

  String? _equipeConseillers;
  String? get equipeConseillers => _$this._equipeConseillers;
  set equipeConseillers(String? equipeConseillers) =>
      _$this._equipeConseillers = equipeConseillers;

  String? _equipeApprentis;
  String? get equipeApprentis => _$this._equipeApprentis;
  set equipeApprentis(String? equipeApprentis) =>
      _$this._equipeApprentis = equipeApprentis;

  String? _equipeEtudiantsPharmacie;
  String? get equipeEtudiantsPharmacie => _$this._equipeEtudiantsPharmacie;
  set equipeEtudiantsPharmacie(String? equipeEtudiantsPharmacie) =>
      _$this._equipeEtudiantsPharmacie = equipeEtudiantsPharmacie;

  String? _equipeEtudiants6Annee;
  String? get equipeEtudiants6Annee => _$this._equipeEtudiants6Annee;
  set equipeEtudiants6Annee(String? equipeEtudiants6Annee) =>
      _$this._equipeEtudiants6Annee = equipeEtudiants6Annee;

  ListBuilder<DateTime>? _horaireLundi;
  ListBuilder<DateTime> get horaireLundi =>
      _$this._horaireLundi ??= new ListBuilder<DateTime>();
  set horaireLundi(ListBuilder<DateTime>? horaireLundi) =>
      _$this._horaireLundi = horaireLundi;

  ListBuilder<DateTime>? _horaireMardi;
  ListBuilder<DateTime> get horaireMardi =>
      _$this._horaireMardi ??= new ListBuilder<DateTime>();
  set horaireMardi(ListBuilder<DateTime>? horaireMardi) =>
      _$this._horaireMardi = horaireMardi;

  ListBuilder<DateTime>? _horaireMercredi;
  ListBuilder<DateTime> get horaireMercredi =>
      _$this._horaireMercredi ??= new ListBuilder<DateTime>();
  set horaireMercredi(ListBuilder<DateTime>? horaireMercredi) =>
      _$this._horaireMercredi = horaireMercredi;

  ListBuilder<DateTime>? _horaireJeudi;
  ListBuilder<DateTime> get horaireJeudi =>
      _$this._horaireJeudi ??= new ListBuilder<DateTime>();
  set horaireJeudi(ListBuilder<DateTime>? horaireJeudi) =>
      _$this._horaireJeudi = horaireJeudi;

  ListBuilder<DateTime>? _horaireVendredi;
  ListBuilder<DateTime> get horaireVendredi =>
      _$this._horaireVendredi ??= new ListBuilder<DateTime>();
  set horaireVendredi(ListBuilder<DateTime>? horaireVendredi) =>
      _$this._horaireVendredi = horaireVendredi;

  ListBuilder<DateTime>? _horaireSamedi;
  ListBuilder<DateTime> get horaireSamedi =>
      _$this._horaireSamedi ??= new ListBuilder<DateTime>();
  set horaireSamedi(ListBuilder<DateTime>? horaireSamedi) =>
      _$this._horaireSamedi = horaireSamedi;

  ListBuilder<DateTime>? _horaieDimanche;
  ListBuilder<DateTime> get horaieDimanche =>
      _$this._horaieDimanche ??= new ListBuilder<DateTime>();
  set horaieDimanche(ListBuilder<DateTime>? horaieDimanche) =>
      _$this._horaieDimanche = horaieDimanche;

  String? _titulaire;
  String? get titulaire => _$this._titulaire;
  set titulaire(String? titulaire) => _$this._titulaire = titulaire;

  ListBuilder<String>? _coTitulaire;
  ListBuilder<String> get coTitulaire =>
      _$this._coTitulaire ??= new ListBuilder<String>();
  set coTitulaire(ListBuilder<String>? coTitulaire) =>
      _$this._coTitulaire = coTitulaire;

  DocumentReference<Object?>? _ffRef;
  DocumentReference<Object?>? get ffRef => _$this._ffRef;
  set ffRef(DocumentReference<Object?>? ffRef) => _$this._ffRef = ffRef;

  PharmaciesRecordBuilder() {
    PharmaciesRecord._initializeBuilder(this);
  }

  PharmaciesRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nom = $v.nom;
      _groupement = $v.groupement.toBuilder();
      _presentation = $v.presentation;
      _maitreDeStage = $v.maitreDeStage;
      _email = $v.email;
      _telephone = $v.telephone;
      _preferenceContact = $v.preferenceContact;
      _adresse = $v.adresse;
      _rer = $v.rer;
      _metro = $v.metro;
      _bus = $v.bus;
      _tramway = $v.tramway;
      _gare = $v.gare;
      _stationnement = $v.stationnement;
      _typologie = $v.typologie;
      _nonStop = $v.nonStop;
      _patientsJour = $v.patientsJour;
      _missionCovid = $v.missionCovid;
      _missionVaccination = $v.missionVaccination;
      _missionEntretienPharmaceutique = $v.missionEntretienPharmaceutique;
      _missionTypePreparation = $v.missionTypePreparation;
      _missionBorneTelemedecine = $v.missionBorneTelemedecine;
      _lgo = $v.lgo.toBuilder();
      _confortSalleDePause = $v.confortSalleDePause;
      _confortRobot = $v.confortRobot;
      _confortEtiquetteElectronique = $v.confortEtiquetteElectronique;
      _confortMoneyeur = $v.confortMoneyeur;
      _confortClim = $v.confortClim;
      _confortChauffage = $v.confortChauffage;
      _confortVigile = $v.confortVigile;
      _confortComiteEntreprise = $v.confortComiteEntreprise;
      _tendancesOrdonances = $v.tendancesOrdonances;
      _tendancesCosmetiques = $v.tendancesCosmetiques;
      _tendancesPhyto = $v.tendancesPhyto;
      _tendancesNutrition = $v.tendancesNutrition;
      _tendancesConseil = $v.tendancesConseil;
      _equipePharma = $v.equipePharma;
      _equipePreparateurs = $v.equipePreparateurs;
      _equipeRayonnistes = $v.equipeRayonnistes;
      _equipeConseillers = $v.equipeConseillers;
      _equipeApprentis = $v.equipeApprentis;
      _equipeEtudiantsPharmacie = $v.equipeEtudiantsPharmacie;
      _equipeEtudiants6Annee = $v.equipeEtudiants6Annee;
      _horaireLundi = $v.horaireLundi?.toBuilder();
      _horaireMardi = $v.horaireMardi?.toBuilder();
      _horaireMercredi = $v.horaireMercredi?.toBuilder();
      _horaireJeudi = $v.horaireJeudi?.toBuilder();
      _horaireVendredi = $v.horaireVendredi?.toBuilder();
      _horaireSamedi = $v.horaireSamedi?.toBuilder();
      _horaieDimanche = $v.horaieDimanche?.toBuilder();
      _titulaire = $v.titulaire;
      _coTitulaire = $v.coTitulaire?.toBuilder();
      _ffRef = $v.ffRef;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PharmaciesRecord other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PharmaciesRecord;
  }

  @override
  void update(void Function(PharmaciesRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PharmaciesRecord build() => _build();

  _$PharmaciesRecord _build() {
    _$PharmaciesRecord _$result;
    try {
      _$result = _$v ??
          new _$PharmaciesRecord._(
              nom: nom,
              groupement: groupement.build(),
              presentation: presentation,
              maitreDeStage: maitreDeStage,
              email: email,
              telephone: telephone,
              preferenceContact: preferenceContact,
              adresse: adresse,
              rer: rer,
              metro: metro,
              bus: bus,
              tramway: tramway,
              gare: gare,
              stationnement: stationnement,
              typologie: typologie,
              nonStop: nonStop,
              patientsJour: patientsJour,
              missionCovid: missionCovid,
              missionVaccination: missionVaccination,
              missionEntretienPharmaceutique: missionEntretienPharmaceutique,
              missionTypePreparation: missionTypePreparation,
              missionBorneTelemedecine: missionBorneTelemedecine,
              lgo: lgo.build(),
              confortSalleDePause: confortSalleDePause,
              confortRobot: confortRobot,
              confortEtiquetteElectronique: confortEtiquetteElectronique,
              confortMoneyeur: confortMoneyeur,
              confortClim: confortClim,
              confortChauffage: confortChauffage,
              confortVigile: confortVigile,
              confortComiteEntreprise: confortComiteEntreprise,
              tendancesOrdonances: tendancesOrdonances,
              tendancesCosmetiques: tendancesCosmetiques,
              tendancesPhyto: tendancesPhyto,
              tendancesNutrition: tendancesNutrition,
              tendancesConseil: tendancesConseil,
              equipePharma: equipePharma,
              equipePreparateurs: equipePreparateurs,
              equipeRayonnistes: equipeRayonnistes,
              equipeConseillers: equipeConseillers,
              equipeApprentis: equipeApprentis,
              equipeEtudiantsPharmacie: equipeEtudiantsPharmacie,
              equipeEtudiants6Annee: equipeEtudiants6Annee,
              horaireLundi: _horaireLundi?.build(),
              horaireMardi: _horaireMardi?.build(),
              horaireMercredi: _horaireMercredi?.build(),
              horaireJeudi: _horaireJeudi?.build(),
              horaireVendredi: _horaireVendredi?.build(),
              horaireSamedi: _horaireSamedi?.build(),
              horaieDimanche: _horaieDimanche?.build(),
              titulaire: titulaire,
              coTitulaire: _coTitulaire?.build(),
              ffRef: ffRef);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'groupement';
        groupement.build();

        _$failedField = 'lgo';
        lgo.build();

        _$failedField = 'horaireLundi';
        _horaireLundi?.build();
        _$failedField = 'horaireMardi';
        _horaireMardi?.build();
        _$failedField = 'horaireMercredi';
        _horaireMercredi?.build();
        _$failedField = 'horaireJeudi';
        _horaireJeudi?.build();
        _$failedField = 'horaireVendredi';
        _horaireVendredi?.build();
        _$failedField = 'horaireSamedi';
        _horaireSamedi?.build();
        _$failedField = 'horaieDimanche';
        _horaieDimanche?.build();

        _$failedField = 'coTitulaire';
        _coTitulaire?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'PharmaciesRecord', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
