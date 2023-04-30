import 'dart:async';

import '../index.dart';
import '../serializers.dart';
import 'package:built_value/built_value.dart';

part 'groupement_struct.g.dart';

abstract class GroupementStruct
    implements Built<GroupementStruct, GroupementStructBuilder> {
  static Serializer<GroupementStruct> get serializer =>
      _$groupementStructSerializer;

  String? get name;

  String? get image;

  /// Utility class for Firestore updates
  FirestoreUtilData get firestoreUtilData;

  static void _initializeBuilder(GroupementStructBuilder builder) => builder
    ..name = ''
    ..image = ''
    ..firestoreUtilData = FirestoreUtilData();

  GroupementStruct._();
  factory GroupementStruct([void Function(GroupementStructBuilder) updates]) =
      _$GroupementStruct;
}

GroupementStruct createGroupementStruct({
  String? name,
  String? image,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    GroupementStruct(
      (g) => g
        ..name = name
        ..image = image
        ..firestoreUtilData = FirestoreUtilData(
          clearUnsetFields: clearUnsetFields,
          create: create,
          delete: delete,
          fieldValues: fieldValues,
        ),
    );

GroupementStruct? updateGroupementStruct(
  GroupementStruct? groupement, {
  bool clearUnsetFields = true,
}) =>
    groupement != null
        ? (groupement.toBuilder()
              ..firestoreUtilData =
                  FirestoreUtilData(clearUnsetFields: clearUnsetFields))
            .build()
        : null;

void addGroupementStructData(
  Map<String, dynamic> firestoreData,
  GroupementStruct? groupement,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (groupement == null) {
    return;
  }
  if (groupement.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  if (!forFieldValue && groupement.firestoreUtilData.clearUnsetFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final groupementData = getGroupementFirestoreData(groupement, forFieldValue);
  final nestedData = groupementData.map((k, v) => MapEntry('$fieldName.$k', v));

  final create = groupement.firestoreUtilData.create;
  firestoreData.addAll(create ? mergeNestedFields(nestedData) : nestedData);

  return;
}

Map<String, dynamic> getGroupementFirestoreData(
  GroupementStruct? groupement, [
  bool forFieldValue = false,
]) {
  if (groupement == null) {
    return {};
  }
  final firestoreData =
      serializers.toFirestore(GroupementStruct.serializer, groupement);

  // Add any Firestore field values
  groupement.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getGroupementListFirestoreData(
  List<GroupementStruct>? groupements,
) =>
    groupements?.map((g) => getGroupementFirestoreData(g, true)).toList() ?? [];
