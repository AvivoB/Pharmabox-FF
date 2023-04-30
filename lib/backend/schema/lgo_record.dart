import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'lgo_record.g.dart';

abstract class LgoRecord implements Built<LgoRecord, LgoRecordBuilder> {
  static Serializer<LgoRecord> get serializer => _$lgoRecordSerializer;

  String? get name;

  String? get image;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(LgoRecordBuilder builder) => builder
    ..name = ''
    ..image = '';

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('lgo');

  static Stream<LgoRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<LgoRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  LgoRecord._();
  factory LgoRecord([void Function(LgoRecordBuilder) updates]) = _$LgoRecord;

  static LgoRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;
}

Map<String, dynamic> createLgoRecordData({
  String? name,
  String? image,
}) {
  final firestoreData = serializers.toFirestore(
    LgoRecord.serializer,
    LgoRecord(
      (l) => l
        ..name = name
        ..image = image,
    ),
  );

  return firestoreData;
}
