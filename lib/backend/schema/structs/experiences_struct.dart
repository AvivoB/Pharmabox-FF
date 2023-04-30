import 'dart:async';

import '../index.dart';
import '../serializers.dart';
import 'package:built_value/built_value.dart';

part 'experiences_struct.g.dart';

abstract class ExperiencesStruct
    implements Built<ExperiencesStruct, ExperiencesStructBuilder> {
  static Serializer<ExperiencesStruct> get serializer =>
      _$experiencesStructSerializer;

  String? get name;

  int? get anneDebut;

  int? get anneeFin;

  /// Utility class for Firestore updates
  FirestoreUtilData get firestoreUtilData;

  static void _initializeBuilder(ExperiencesStructBuilder builder) => builder
    ..name = ''
    ..anneDebut = 0
    ..anneeFin = 0
    ..firestoreUtilData = FirestoreUtilData();

  ExperiencesStruct._();
  factory ExperiencesStruct([void Function(ExperiencesStructBuilder) updates]) =
      _$ExperiencesStruct;
}

ExperiencesStruct createExperiencesStruct({
  String? name,
  int? anneDebut,
  int? anneeFin,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ExperiencesStruct(
      (e) => e
        ..name = name
        ..anneDebut = anneDebut
        ..anneeFin = anneeFin
        ..firestoreUtilData = FirestoreUtilData(
          clearUnsetFields: clearUnsetFields,
          create: create,
          delete: delete,
          fieldValues: fieldValues,
        ),
    );

ExperiencesStruct? updateExperiencesStruct(
  ExperiencesStruct? experiences, {
  bool clearUnsetFields = true,
}) =>
    experiences != null
        ? (experiences.toBuilder()
              ..firestoreUtilData =
                  FirestoreUtilData(clearUnsetFields: clearUnsetFields))
            .build()
        : null;

void addExperiencesStructData(
  Map<String, dynamic> firestoreData,
  ExperiencesStruct? experiences,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (experiences == null) {
    return;
  }
  if (experiences.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  if (!forFieldValue && experiences.firestoreUtilData.clearUnsetFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final experiencesData =
      getExperiencesFirestoreData(experiences, forFieldValue);
  final nestedData =
      experiencesData.map((k, v) => MapEntry('$fieldName.$k', v));

  final create = experiences.firestoreUtilData.create;
  firestoreData.addAll(create ? mergeNestedFields(nestedData) : nestedData);

  return;
}

Map<String, dynamic> getExperiencesFirestoreData(
  ExperiencesStruct? experiences, [
  bool forFieldValue = false,
]) {
  if (experiences == null) {
    return {};
  }
  final firestoreData =
      serializers.toFirestore(ExperiencesStruct.serializer, experiences);

  // Add any Firestore field values
  experiences.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getExperiencesListFirestoreData(
  List<ExperiencesStruct>? experiencess,
) =>
    experiencess?.map((e) => getExperiencesFirestoreData(e, true)).toList() ??
    [];
