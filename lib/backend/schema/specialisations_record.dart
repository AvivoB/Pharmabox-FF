import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'specialisations_record.g.dart';

abstract class SpecialisationsRecord
    implements Built<SpecialisationsRecord, SpecialisationsRecordBuilder> {
  static Serializer<SpecialisationsRecord> get serializer =>
      _$specialisationsRecordSerializer;

  String? get name;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(SpecialisationsRecordBuilder builder) =>
      builder..name = '';

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('specialisations');

  static Stream<SpecialisationsRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<SpecialisationsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then(
          (s) => serializers.deserializeWith(serializer, serializedData(s))!);

  SpecialisationsRecord._();
  factory SpecialisationsRecord(
          [void Function(SpecialisationsRecordBuilder) updates]) =
      _$SpecialisationsRecord;

  static SpecialisationsRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;
}

Map<String, dynamic> createSpecialisationsRecordData({
  String? name,
}) {
  final firestoreData = serializers.toFirestore(
    SpecialisationsRecord.serializer,
    SpecialisationsRecord(
      (s) => s..name = name,
    ),
  );

  return firestoreData;
}
