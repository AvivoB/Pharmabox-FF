// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_type_lgo_struct.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<DataTypeLgoStruct> _$dataTypeLgoStructSerializer =
    new _$DataTypeLgoStructSerializer();

class _$DataTypeLgoStructSerializer
    implements StructuredSerializer<DataTypeLgoStruct> {
  @override
  final Iterable<Type> types = const [DataTypeLgoStruct, _$DataTypeLgoStruct];
  @override
  final String wireName = 'DataTypeLgoStruct';

  @override
  Iterable<Object?> serialize(Serializers serializers, DataTypeLgoStruct object,
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
    value = object.niveau;
    if (value != null) {
      result
        ..add('niveau')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.imageName;
    if (value != null) {
      result
        ..add('image_name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  DataTypeLgoStruct deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DataTypeLgoStructBuilder();

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
        case 'niveau':
          result.niveau = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
        case 'image_name':
          result.imageName = serializers.deserialize(value,
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

class _$DataTypeLgoStruct extends DataTypeLgoStruct {
  @override
  final String? name;
  @override
  final double? niveau;
  @override
  final String? imageName;
  @override
  final FirestoreUtilData firestoreUtilData;

  factory _$DataTypeLgoStruct(
          [void Function(DataTypeLgoStructBuilder)? updates]) =>
      (new DataTypeLgoStructBuilder()..update(updates))._build();

  _$DataTypeLgoStruct._(
      {this.name, this.niveau, this.imageName, required this.firestoreUtilData})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        firestoreUtilData, r'DataTypeLgoStruct', 'firestoreUtilData');
  }

  @override
  DataTypeLgoStruct rebuild(void Function(DataTypeLgoStructBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DataTypeLgoStructBuilder toBuilder() =>
      new DataTypeLgoStructBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DataTypeLgoStruct &&
        name == other.name &&
        niveau == other.niveau &&
        imageName == other.imageName &&
        firestoreUtilData == other.firestoreUtilData;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, niveau.hashCode);
    _$hash = $jc(_$hash, imageName.hashCode);
    _$hash = $jc(_$hash, firestoreUtilData.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DataTypeLgoStruct')
          ..add('name', name)
          ..add('niveau', niveau)
          ..add('imageName', imageName)
          ..add('firestoreUtilData', firestoreUtilData))
        .toString();
  }
}

class DataTypeLgoStructBuilder
    implements Builder<DataTypeLgoStruct, DataTypeLgoStructBuilder> {
  _$DataTypeLgoStruct? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  double? _niveau;
  double? get niveau => _$this._niveau;
  set niveau(double? niveau) => _$this._niveau = niveau;

  String? _imageName;
  String? get imageName => _$this._imageName;
  set imageName(String? imageName) => _$this._imageName = imageName;

  FirestoreUtilData? _firestoreUtilData;
  FirestoreUtilData? get firestoreUtilData => _$this._firestoreUtilData;
  set firestoreUtilData(FirestoreUtilData? firestoreUtilData) =>
      _$this._firestoreUtilData = firestoreUtilData;

  DataTypeLgoStructBuilder() {
    DataTypeLgoStruct._initializeBuilder(this);
  }

  DataTypeLgoStructBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _niveau = $v.niveau;
      _imageName = $v.imageName;
      _firestoreUtilData = $v.firestoreUtilData;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DataTypeLgoStruct other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DataTypeLgoStruct;
  }

  @override
  void update(void Function(DataTypeLgoStructBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DataTypeLgoStruct build() => _build();

  _$DataTypeLgoStruct _build() {
    final _$result = _$v ??
        new _$DataTypeLgoStruct._(
            name: name,
            niveau: niveau,
            imageName: imageName,
            firestoreUtilData: BuiltValueNullFieldError.checkNotNull(
                firestoreUtilData, r'DataTypeLgoStruct', 'firestoreUtilData'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
