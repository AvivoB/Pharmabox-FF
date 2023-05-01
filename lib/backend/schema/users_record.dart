import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'users_record.g.dart';

abstract class UsersRecord implements Built<UsersRecord, UsersRecordBuilder> {
  static Serializer<UsersRecord> get serializer => _$usersRecordSerializer;

  String? get email;

  @BuiltValueField(wireName: 'photo_url')
  String? get photoUrl;

  String? get uid;

  @BuiltValueField(wireName: 'created_time')
  DateTime? get createdTime;

  @BuiltValueField(wireName: 'phone_number')
  String? get phoneNumber;

  String? get nom;

  String? get prenom;

  String? get ville;

  @BuiltValueField(wireName: 'code_postal')
  int? get codePostal;

  String? get presentation;

  @BuiltValueField(wireName: 'date_naissance')
  String? get dateNaissance;

  String? get poste;

  BuiltList<String>? get specialisations;

  @BuiltValueField(wireName: 'faculte_ecole')
  BuiltList<String>? get faculteEcole;

  BuiltList<String>? get experiences;

  BuiltList<String>? get competences;

  @BuiltValueField(wireName: 'IsTitulaire')
  bool? get isTitulaire;

  int? get likes;

  @BuiltValueField(wireName: 'display_name')
  String? get displayName;

  BuiltList<DataTypeLgoStruct>? get lgo;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(UsersRecordBuilder builder) => builder
    ..email = ''
    ..photoUrl = ''
    ..uid = ''
    ..phoneNumber = ''
    ..nom = ''
    ..prenom = ''
    ..ville = ''
    ..codePostal = 0
    ..presentation = ''
    ..dateNaissance = ''
    ..poste = ''
    ..specialisations = ListBuilder()
    ..faculteEcole = ListBuilder()
    ..experiences = ListBuilder()
    ..competences = ListBuilder()
    ..isTitulaire = false
    ..likes = 0
    ..displayName = ''
    ..lgo = ListBuilder();

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  UsersRecord._();
  factory UsersRecord([void Function(UsersRecordBuilder) updates]) =
      _$UsersRecord;

  static UsersRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  String? nom,
  String? prenom,
  String? ville,
  int? codePostal,
  String? presentation,
  String? dateNaissance,
  String? poste,
  bool? isTitulaire,
  int? likes,
  String? displayName,
}) {
  final firestoreData = serializers.toFirestore(
    UsersRecord.serializer,
    UsersRecord(
      (u) => u
        ..email = email
        ..photoUrl = photoUrl
        ..uid = uid
        ..createdTime = createdTime
        ..phoneNumber = phoneNumber
        ..nom = nom
        ..prenom = prenom
        ..ville = ville
        ..codePostal = codePostal
        ..presentation = presentation
        ..dateNaissance = dateNaissance
        ..poste = poste
        ..specialisations = null
        ..faculteEcole = null
        ..experiences = null
        ..competences = null
        ..isTitulaire = isTitulaire
        ..likes = likes
        ..displayName = displayName
        ..lgo = null,
    ),
  );

  return firestoreData;
}
