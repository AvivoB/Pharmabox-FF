import 'dart:async';

import '../index.dart';
import '../serializers.dart';
import 'package:built_value/built_value.dart';

part 'horaire_ouverture_struct.g.dart';

abstract class HoraireOuvertureStruct
    implements Built<HoraireOuvertureStruct, HoraireOuvertureStructBuilder> {
  static Serializer<HoraireOuvertureStruct> get serializer =>
      _$horaireOuvertureStructSerializer;

  bool? get open;

  DateTime? get startHour;

  DateTime? get closeHour;

  /// Utility class for Firestore updates
  FirestoreUtilData get firestoreUtilData;

  static void _initializeBuilder(HoraireOuvertureStructBuilder builder) =>
      builder
        ..open = false
        ..firestoreUtilData = FirestoreUtilData();

  HoraireOuvertureStruct._();
  factory HoraireOuvertureStruct(
          [void Function(HoraireOuvertureStructBuilder) updates]) =
      _$HoraireOuvertureStruct;
}

HoraireOuvertureStruct createHoraireOuvertureStruct({
  bool? open,
  DateTime? startHour,
  DateTime? closeHour,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    HoraireOuvertureStruct(
      (h) => h
        ..open = open
        ..startHour = startHour
        ..closeHour = closeHour
        ..firestoreUtilData = FirestoreUtilData(
          clearUnsetFields: clearUnsetFields,
          create: create,
          delete: delete,
          fieldValues: fieldValues,
        ),
    );

HoraireOuvertureStruct? updateHoraireOuvertureStruct(
  HoraireOuvertureStruct? horaireOuverture, {
  bool clearUnsetFields = true,
}) =>
    horaireOuverture != null
        ? (horaireOuverture.toBuilder()
              ..firestoreUtilData =
                  FirestoreUtilData(clearUnsetFields: clearUnsetFields))
            .build()
        : null;

void addHoraireOuvertureStructData(
  Map<String, dynamic> firestoreData,
  HoraireOuvertureStruct? horaireOuverture,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (horaireOuverture == null) {
    return;
  }
  if (horaireOuverture.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  if (!forFieldValue && horaireOuverture.firestoreUtilData.clearUnsetFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final horaireOuvertureData =
      getHoraireOuvertureFirestoreData(horaireOuverture, forFieldValue);
  final nestedData =
      horaireOuvertureData.map((k, v) => MapEntry('$fieldName.$k', v));

  final create = horaireOuverture.firestoreUtilData.create;
  firestoreData.addAll(create ? mergeNestedFields(nestedData) : nestedData);

  return;
}

Map<String, dynamic> getHoraireOuvertureFirestoreData(
  HoraireOuvertureStruct? horaireOuverture, [
  bool forFieldValue = false,
]) {
  if (horaireOuverture == null) {
    return {};
  }
  final firestoreData = serializers.toFirestore(
      HoraireOuvertureStruct.serializer, horaireOuverture);

  // Add any Firestore field values
  horaireOuverture.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getHoraireOuvertureListFirestoreData(
  List<HoraireOuvertureStruct>? horaireOuvertures,
) =>
    horaireOuvertures
        ?.map((h) => getHoraireOuvertureFirestoreData(h, true))
        .toList() ??
    [];
