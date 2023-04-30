// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_type_specialisations_struct.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<DataTypeSpecialisationsStruct>
    _$dataTypeSpecialisationsStructSerializer =
    new _$DataTypeSpecialisationsStructSerializer();

class _$DataTypeSpecialisationsStructSerializer
    implements StructuredSerializer<DataTypeSpecialisationsStruct> {
  @override
  final Iterable<Type> types = const [
    DataTypeSpecialisationsStruct,
    _$DataTypeSpecialisationsStruct
  ];
  @override
  final String wireName = 'DataTypeSpecialisationsStruct';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, DataTypeSpecialisationsStruct object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'firestoreUtilData',
      serializers.serialize(object.firestoreUtilData,
          specifiedType: const FullType(FirestoreUtilData)),
    ];
    Object? value;
    value = object.name;
    if (value != null) {
      result
        ..add('name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  DataTypeSpecialisationsStruct deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DataTypeSpecialisationsStructBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'firestoreUtilData':
          result.firestoreUtilData = serializers.deserialize(value,
                  specifiedType: const FullType(FirestoreUtilData))!
              as FirestoreUtilData;
          break;
      }
    }

    return result.build();
  }
}

class _$DataTypeSpecialisationsStruct extends DataTypeSpecialisationsStruct {
  @override
  final String? name;
  @override
  final FirestoreUtilData firestoreUtilData;

  factory _$DataTypeSpecialisationsStruct(
          [void Function(DataTypeSpecialisationsStructBuilder)? updates]) =>
      (new DataTypeSpecialisationsStructBuilder()..update(updates))._build();

  _$DataTypeSpecialisationsStruct._(
      {this.name, required this.firestoreUtilData})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(firestoreUtilData,
        r'DataTypeSpecialisationsStruct', 'firestoreUtilData');
  }

  @override
  DataTypeSpecialisationsStruct rebuild(
          void Function(DataTypeSpecialisationsStructBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DataTypeSpecialisationsStructBuilder toBuilder() =>
      new DataTypeSpecialisationsStructBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DataTypeSpecialisationsStruct &&
        name == other.name &&
        firestoreUtilData == other.firestoreUtilData;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, firestoreUtilData.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DataTypeSpecialisationsStruct')
          ..add('name', name)
          ..add('firestoreUtilData', firestoreUtilData))
        .toString();
  }
}

class DataTypeSpecialisationsStructBuilder
    implements
        Builder<DataTypeSpecialisationsStruct,
            DataTypeSpecialisationsStructBuilder> {
  _$DataTypeSpecialisationsStruct? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  FirestoreUtilData? _firestoreUtilData;
  FirestoreUtilData? get firestoreUtilData => _$this._firestoreUtilData;
  set firestoreUtilData(FirestoreUtilData? firestoreUtilData) =>
      _$this._firestoreUtilData = firestoreUtilData;

  DataTypeSpecialisationsStructBuilder() {
    DataTypeSpecialisationsStruct._initializeBuilder(this);
  }

  DataTypeSpecialisationsStructBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _firestoreUtilData = $v.firestoreUtilData;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DataTypeSpecialisationsStruct other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DataTypeSpecialisationsStruct;
  }

  @override
  void update(void Function(DataTypeSpecialisationsStructBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DataTypeSpecialisationsStruct build() => _build();

  _$DataTypeSpecialisationsStruct _build() {
    final _$result = _$v ??
        new _$DataTypeSpecialisationsStruct._(
            name: name,
            firestoreUtilData: BuiltValueNullFieldError.checkNotNull(
                firestoreUtilData,
                r'DataTypeSpecialisationsStruct',
                'firestoreUtilData'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
