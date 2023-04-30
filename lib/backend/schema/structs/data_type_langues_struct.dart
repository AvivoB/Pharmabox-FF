import 'dart:async';

import '../index.dart';
import '../serializers.dart';
import 'package:built_value/built_value.dart';

part 'data_type_langues_struct.g.dart';

abstract class DataTypeLanguesStruct
    implements Built<DataTypeLanguesStruct, DataTypeLanguesStructBuilder> {
  static Serializer<DataTypeLanguesStruct> get serializer =>
      _$dataTypeLanguesStructSerializer;

  String? get langue;

  double? get niveau;

  /// Utility class for Firestore updates
  FirestoreUtilData get firestoreUtilData;

  static void _initializeBuilder(DataTypeLanguesStructBuilder builder) =>
      builder
        ..langue = ''
        ..niveau = 0.0
        ..firestoreUtilData = FirestoreUtilData();

  DataTypeLanguesStruct._();
  factory DataTypeLanguesStruct(
          [void Function(DataTypeLanguesStructBuilder) updates]) =
      _$DataTypeLanguesStruct;
}

DataTypeLanguesStruct createDataTypeLanguesStruct({
  String? langue,
  double? niveau,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    DataTypeLanguesStruct(
      (d) => d
        ..langue = langue
        ..niveau = niveau
        ..firestoreUtilData = FirestoreUtilData(
          clearUnsetFields: clearUnsetFields,
          create: create,
          delete: delete,
          fieldValues: fieldValues,
        ),
    );

DataTypeLanguesStruct? updateDataTypeLanguesStruct(
  DataTypeLanguesStruct? dataTypeLangues, {
  bool clearUnsetFields = true,
}) =>
    dataTypeLangues != null
        ? (dataTypeLangues.toBuilder()
              ..firestoreUtilData =
                  FirestoreUtilData(clearUnsetFields: clearUnsetFields))
            .build()
        : null;

void addDataTypeLanguesStructData(
  Map<String, dynamic> firestoreData,
  DataTypeLanguesStruct? dataTypeLangues,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (dataTypeLangues == null) {
    return;
  }
  if (dataTypeLangues.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  if (!forFieldValue && dataTypeLangues.firestoreUtilData.clearUnsetFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final dataTypeLanguesData =
      getDataTypeLanguesFirestoreData(dataTypeLangues, forFieldValue);
  final nestedData =
      dataTypeLanguesData.map((k, v) => MapEntry('$fieldName.$k', v));

  final create = dataTypeLangues.firestoreUtilData.create;
  firestoreData.addAll(create ? mergeNestedFields(nestedData) : nestedData);

  return;
}

Map<String, dynamic> getDataTypeLanguesFirestoreData(
  DataTypeLanguesStruct? dataTypeLangues, [
  bool forFieldValue = false,
]) {
  if (dataTypeLangues == null) {
    return {};
  }
  final firestoreData = serializers.toFirestore(
      DataTypeLanguesStruct.serializer, dataTypeLangues);

  // Add any Firestore field values
  dataTypeLangues.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getDataTypeLanguesListFirestoreData(
  List<DataTypeLanguesStruct>? dataTypeLanguess,
) =>
    dataTypeLanguess
        ?.map((d) => getDataTypeLanguesFirestoreData(d, true))
        .toList() ??
    [];
