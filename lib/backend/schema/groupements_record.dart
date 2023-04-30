import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'groupements_record.g.dart';

abstract class GroupementsRecord
    implements Built<GroupementsRecord, GroupementsRecordBuilder> {
  static Serializer<GroupementsRecord> get serializer =>
      _$groupementsRecordSerializer;

  String? get name;

  String? get image;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(GroupementsRecordBuilder builder) => builder
    ..name = ''
    ..image = '';

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('groupements');

  static Stream<GroupementsRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<GroupementsRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  GroupementsRecord._();
  factory GroupementsRecord([void Function(GroupementsRecordBuilder) updates]) =
      _$GroupementsRecord;

  static GroupementsRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;
}

Map<String, dynamic> createGroupementsRecordData({
  String? name,
  String? image,
}) {
  final firestoreData = serializers.toFirestore(
    GroupementsRecord.serializer,
    GroupementsRecord(
      (g) => g
        ..name = name
        ..image = image,
    ),
  );

  return firestoreData;
}
