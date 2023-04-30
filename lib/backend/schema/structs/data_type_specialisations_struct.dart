import 'dart:async';

import '../index.dart';
import '../serializers.dart';
import 'package:built_value/built_value.dart';

part 'data_type_specialisations_struct.g.dart';

abstract class DataTypeSpecialisationsStruct
    implements
        Built<DataTypeSpecialisationsStruct,
            DataTypeSpecialisationsStructBuilder> {
  static Serializer<DataTypeSpecialisationsStruct> get serializer =>
      _$dataTypeSpecialisationsStructSerializer;

  String? get name;

  /// Utility class for Firestore updates
  FirestoreUtilData get firestoreUtilData;

  static void _initializeBuilder(
          DataTypeSpecialisationsStructBuilder builder) =>
      builder
        ..name = ''
        ..firestoreUtilData = FirestoreUtilData();

  DataTypeSpecialisationsStruct._();
  factory DataTypeSpecialisationsStruct(
          [void Function(DataTypeSpecialisationsStructBuilder) updates]) =
      _$DataTypeSpecialisationsStruct;
}

DataTypeSpecialisationsStruct createDataTypeSpecialisationsStruct({
  String? name,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    DataTypeSpecialisationsStruct(
      (d) => d
        ..name = name
        ..firestoreUtilData = FirestoreUtilData(
          clearUnsetFields: clearUnsetFields,
          create: create,
          delete: delete,
          fieldValues: fieldValues,
        ),
    );

DataTypeSpecialisationsStruct? updateDataTypeSpecialisationsStruct(
  DataTypeSpecialisationsStruct? dataTypeSpecialisations, {
  bool clearUnsetFields = true,
}) =>
    dataTypeSpecialisations != null
        ? (dataTypeSpecialisations.toBuilder()
              ..firestoreUtilData =
                  FirestoreUtilData(clearUnsetFields: clearUnsetFields))
            .build()
        : null;

void addDataTypeSpecialisationsStructData(
  Map<String, dynamic> firestoreData,
  DataTypeSpecialisationsStruct? dataTypeSpecialisations,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (dataTypeSpecialisations == null) {
    return;
  }
  if (dataTypeSpecialisations.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  if (!forFieldValue &&
      dataTypeSpecialisations.firestoreUtilData.clearUnsetFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final dataTypeSpecialisationsData = getDataTypeSpecialisationsFirestoreData(
      dataTypeSpecialisations, forFieldValue);
  final nestedData =
      dataTypeSpecialisationsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final create = dataTypeSpecialisations.firestoreUtilData.create;
  firestoreData.addAll(create ? mergeNestedFields(nestedData) : nestedData);

  return;
}

Map<String, dynamic> getDataTypeSpecialisationsFirestoreData(
  DataTypeSpecialisationsStruct? dataTypeSpecialisations, [
  bool forFieldValue = false,
]) {
  if (dataTypeSpecialisations == null) {
    return {};
  }
  final firestoreData = serializers.toFirestore(
      DataTypeSpecialisationsStruct.serializer, dataTypeSpecialisations);

  // Add any Firestore field values
  dataTypeSpecialisations.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getDataTypeSpecialisationsListFirestoreData(
  List<DataTypeSpecialisationsStruct>? dataTypeSpecialisationss,
) =>
    dataTypeSpecialisationss
        ?.map((d) => getDataTypeSpecialisationsFirestoreData(d, true))
        .toList() ??
    [];
