import 'dart:async';

import '../index.dart';
import '../serializers.dart';
import 'package:built_value/built_value.dart';

part 'lgo_struct.g.dart';

abstract class LgoStruct implements Built<LgoStruct, LgoStructBuilder> {
  static Serializer<LgoStruct> get serializer => _$lgoStructSerializer;

  String? get name;

  String? get image;

  /// Utility class for Firestore updates
  FirestoreUtilData get firestoreUtilData;

  static void _initializeBuilder(LgoStructBuilder builder) => builder
    ..name = ''
    ..image = ''
    ..firestoreUtilData = FirestoreUtilData();

  LgoStruct._();
  factory LgoStruct([void Function(LgoStructBuilder) updates]) = _$LgoStruct;
}

LgoStruct createLgoStruct({
  String? name,
  String? image,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    LgoStruct(
      (l) => l
        ..name = name
        ..image = image
        ..firestoreUtilData = FirestoreUtilData(
          clearUnsetFields: clearUnsetFields,
          create: create,
          delete: delete,
          fieldValues: fieldValues,
        ),
    );

LgoStruct? updateLgoStruct(
  LgoStruct? lgo, {
  bool clearUnsetFields = true,
}) =>
    lgo != null
        ? (lgo.toBuilder()
              ..firestoreUtilData =
                  FirestoreUtilData(clearUnsetFields: clearUnsetFields))
            .build()
        : null;

void addLgoStructData(
  Map<String, dynamic> firestoreData,
  LgoStruct? lgo,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (lgo == null) {
    return;
  }
  if (lgo.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  if (!forFieldValue && lgo.firestoreUtilData.clearUnsetFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final lgoData = getLgoFirestoreData(lgo, forFieldValue);
  final nestedData = lgoData.map((k, v) => MapEntry('$fieldName.$k', v));

  final create = lgo.firestoreUtilData.create;
  firestoreData.addAll(create ? mergeNestedFields(nestedData) : nestedData);

  return;
}

Map<String, dynamic> getLgoFirestoreData(
  LgoStruct? lgo, [
  bool forFieldValue = false,
]) {
  if (lgo == null) {
    return {};
  }
  final firestoreData = serializers.toFirestore(LgoStruct.serializer, lgo);

  // Add any Firestore field values
  lgo.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getLgoListFirestoreData(
  List<LgoStruct>? lgos,
) =>
    lgos?.map((l) => getLgoFirestoreData(l, true)).toList() ?? [];
