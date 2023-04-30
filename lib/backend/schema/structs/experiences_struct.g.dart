// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experiences_struct.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ExperiencesStruct> _$experiencesStructSerializer =
    new _$ExperiencesStructSerializer();

class _$ExperiencesStructSerializer
    implements StructuredSerializer<ExperiencesStruct> {
  @override
  final Iterable<Type> types = const [ExperiencesStruct, _$ExperiencesStruct];
  @override
  final String wireName = 'ExperiencesStruct';

  @override
  Iterable<Object?> serialize(Serializers serializers, ExperiencesStruct object,
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
    value = object.anneDebut;
    if (value != null) {
      result
        ..add('anneDebut')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.anneeFin;
    if (value != null) {
      result
        ..add('anneeFin')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  ExperiencesStruct deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ExperiencesStructBuilder();

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
        case 'anneDebut':
          result.anneDebut = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'anneeFin':
          result.anneeFin = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
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

class _$ExperiencesStruct extends ExperiencesStruct {
  @override
  final String? name;
  @override
  final int? anneDebut;
  @override
  final int? anneeFin;
  @override
  final FirestoreUtilData firestoreUtilData;

  factory _$ExperiencesStruct(
          [void Function(ExperiencesStructBuilder)? updates]) =>
      (new ExperiencesStructBuilder()..update(updates))._build();

  _$ExperiencesStruct._(
      {this.name,
      this.anneDebut,
      this.anneeFin,
      required this.firestoreUtilData})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        firestoreUtilData, r'ExperiencesStruct', 'firestoreUtilData');
  }

  @override
  ExperiencesStruct rebuild(void Function(ExperiencesStructBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExperiencesStructBuilder toBuilder() =>
      new ExperiencesStructBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExperiencesStruct &&
        name == other.name &&
        anneDebut == other.anneDebut &&
        anneeFin == other.anneeFin &&
        firestoreUtilData == other.firestoreUtilData;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, anneDebut.hashCode);
    _$hash = $jc(_$hash, anneeFin.hashCode);
    _$hash = $jc(_$hash, firestoreUtilData.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExperiencesStruct')
          ..add('name', name)
          ..add('anneDebut', anneDebut)
          ..add('anneeFin', anneeFin)
          ..add('firestoreUtilData', firestoreUtilData))
        .toString();
  }
}

class ExperiencesStructBuilder
    implements Builder<ExperiencesStruct, ExperiencesStructBuilder> {
  _$ExperiencesStruct? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _anneDebut;
  int? get anneDebut => _$this._anneDebut;
  set anneDebut(int? anneDebut) => _$this._anneDebut = anneDebut;

  int? _anneeFin;
  int? get anneeFin => _$this._anneeFin;
  set anneeFin(int? anneeFin) => _$this._anneeFin = anneeFin;

  FirestoreUtilData? _firestoreUtilData;
  FirestoreUtilData? get firestoreUtilData => _$this._firestoreUtilData;
  set firestoreUtilData(FirestoreUtilData? firestoreUtilData) =>
      _$this._firestoreUtilData = firestoreUtilData;

  ExperiencesStructBuilder() {
    ExperiencesStruct._initializeBuilder(this);
  }

  ExperiencesStructBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _anneDebut = $v.anneDebut;
      _anneeFin = $v.anneeFin;
      _firestoreUtilData = $v.firestoreUtilData;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExperiencesStruct other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ExperiencesStruct;
  }

  @override
  void update(void Function(ExperiencesStructBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExperiencesStruct build() => _build();

  _$ExperiencesStruct _build() {
    final _$result = _$v ??
        new _$ExperiencesStruct._(
            name: name,
            anneDebut: anneDebut,
            anneeFin: anneeFin,
            firestoreUtilData: BuiltValueNullFieldError.checkNotNull(
                firestoreUtilData, r'ExperiencesStruct', 'firestoreUtilData'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
