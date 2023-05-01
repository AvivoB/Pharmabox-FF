import 'dart:async';

import '../index.dart';
import '../serializers.dart';
import 'package:built_value/built_value.dart';

part 'data_type_lgo_struct.g.dart';

abstract class DataTypeLgoStruct
    implements Built<DataTypeLgoStruct, DataTypeLgoStructBuilder> {
  static Serializer<DataTypeLgoStruct> get serializer =>
      _$dataTypeLgoStructSerializer;

  String? get name;

  double? get niveau;

  @BuiltValueField(wireName: 'image_name')
  String? get imageName;

  /// Utility class for Firestore updates
  FirestoreUtilData get firestoreUtilData;

  static void _initializeBuilder(DataTypeLgoStructBuilder builder) => builder
    ..name = ''
    ..niveau = 0.0
    ..imageName = ''
    ..firestoreUtilData = FirestoreUtilData();

  DataTypeLgoStruct._();
  factory DataTypeLgoStruct([void Function(DataTypeLgoStructBuilder) updates]) =
      _$DataTypeLgoStruct;
}

DataTypeLgoStruct createDataTypeLgoStruct({
  String? name,
  double? niveau,
  String? imageName,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    DataTypeLgoStruct(
      (d) => d
        ..name = name
        ..niveau = niveau
        ..imageName = imageName
        ..firestoreUtilData = FirestoreUtilData(
          clearUnsetFields: clearUnsetFields,
          create: create,
          delete: delete,
          fieldValues: fieldValues,
        ),
    );

DataTypeLgoStruct? updateDataTypeLgoStruct(
  DataTypeLgoStruct? dataTypeLgo, {
  bool clearUnsetFields = true,
}) =>
    dataTypeLgo != null
        ? (dataTypeLgo.toBuilder()
              ..firestoreUtilData =
                  FirestoreUtilData(clearUnsetFields: clearUnsetFields))
            .build()
        : null;

void addDataTypeLgoStructData(
  Map<String, dynamic> firestoreData,
  DataTypeLgoStruct? dataTypeLgo,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (dataTypeLgo == null) {
    return;
  }
  if (dataTypeLgo.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  if (!forFieldValue && dataTypeLgo.firestoreUtilData.clearUnsetFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final dataTypeLgoData =
      getDataTypeLgoFirestoreData(dataTypeLgo, forFieldValue);
  final nestedData =
      dataTypeLgoData.map((k, v) => MapEntry('$fieldName.$k', v));

  final create = dataTypeLgo.firestoreUtilData.create;
  firestoreData.addAll(create ? mergeNestedFields(nestedData) : nestedData);

  return;
}

Map<String, dynamic> getDataTypeLgoFirestoreData(
  DataTypeLgoStruct? dataTypeLgo, [
  bool forFieldValue = false,
]) {
  if (dataTypeLgo == null) {
    return {};
  }
  final firestoreData =
      serializers.toFirestore(DataTypeLgoStruct.serializer, dataTypeLgo);

  // Add any Firestore field values
  dataTypeLgo.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getDataTypeLgoListFirestoreData(
  List<DataTypeLgoStruct>? dataTypeLgos,
) =>
    dataTypeLgos?.map((d) => getDataTypeLgoFirestoreData(d, true)).toList() ??
    [];
