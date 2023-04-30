// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_type_langues_struct.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<DataTypeLanguesStruct> _$dataTypeLanguesStructSerializer =
    new _$DataTypeLanguesStructSerializer();

class _$DataTypeLanguesStructSerializer
    implements StructuredSerializer<DataTypeLanguesStruct> {
  @override
  final Iterable<Type> types = const [
    DataTypeLanguesStruct,
    _$DataTypeLanguesStruct
  ];
  @override
  final String wireName = 'DataTypeLanguesStruct';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, DataTypeLanguesStruct object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'firestoreUtilData',
      serializers.serialize(object.firestoreUtilData,
          specifiedType: const FullType(FirestoreUtilData)),
    ];
    Object? value;
    value = object.langue;
    if (value != null) {
      result
        ..add('langue')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.niveau;
    if (value != null) {
      result
        ..add('niveau')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    return result;
  }

  @override
  DataTypeLanguesStruct deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DataTypeLanguesStructBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'langue':
          result.langue = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'niveau':
          result.niveau = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
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

class _$DataTypeLanguesStruct extends DataTypeLanguesStruct {
  @override
  final String? langue;
  @override
  final double? niveau;
  @override
  final FirestoreUtilData firestoreUtilData;

  factory _$DataTypeLanguesStruct(
          [void Function(DataTypeLanguesStructBuilder)? updates]) =>
      (new DataTypeLanguesStructBuilder()..update(updates))._build();

  _$DataTypeLanguesStruct._(
      {this.langue, this.niveau, required this.firestoreUtilData})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        firestoreUtilData, r'DataTypeLanguesStruct', 'firestoreUtilData');
  }

  @override
  DataTypeLanguesStruct rebuild(
          void Function(DataTypeLanguesStructBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DataTypeLanguesStructBuilder toBuilder() =>
      new DataTypeLanguesStructBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DataTypeLanguesStruct &&
        langue == other.langue &&
        niveau == other.niveau &&
        firestoreUtilData == other.firestoreUtilData;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, langue.hashCode);
    _$hash = $jc(_$hash, niveau.hashCode);
    _$hash = $jc(_$hash, firestoreUtilData.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DataTypeLanguesStruct')
          ..add('langue', langue)
          ..add('niveau', niveau)
          ..add('firestoreUtilData', firestoreUtilData))
        .toString();
  }
}

class DataTypeLanguesStructBuilder
    implements Builder<DataTypeLanguesStruct, DataTypeLanguesStructBuilder> {
  _$DataTypeLanguesStruct? _$v;

  String? _langue;
  String? get langue => _$this._langue;
  set langue(String? langue) => _$this._langue = langue;

  double? _niveau;
  double? get niveau => _$this._niveau;
  set niveau(double? niveau) => _$this._niveau = niveau;

  FirestoreUtilData? _firestoreUtilData;
  FirestoreUtilData? get firestoreUtilData => _$this._firestoreUtilData;
  set firestoreUtilData(FirestoreUtilData? firestoreUtilData) =>
      _$this._firestoreUtilData = firestoreUtilData;

  DataTypeLanguesStructBuilder() {
    DataTypeLanguesStruct._initializeBuilder(this);
  }

  DataTypeLanguesStructBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _langue = $v.langue;
      _niveau = $v.niveau;
      _firestoreUtilData = $v.firestoreUtilData;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DataTypeLanguesStruct other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DataTypeLanguesStruct;
  }

  @override
  void update(void Function(DataTypeLanguesStructBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DataTypeLanguesStruct build() => _build();

  _$DataTypeLanguesStruct _build() {
    final _$result = _$v ??
        new _$DataTypeLanguesStruct._(
            langue: langue,
            niveau: niveau,
            firestoreUtilData: BuiltValueNullFieldError.checkNotNull(
                firestoreUtilData,
                r'DataTypeLanguesStruct',
                'firestoreUtilData'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
