// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'horaire_ouverture_struct.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<HoraireOuvertureStruct> _$horaireOuvertureStructSerializer =
    new _$HoraireOuvertureStructSerializer();

class _$HoraireOuvertureStructSerializer
    implements StructuredSerializer<HoraireOuvertureStruct> {
  @override
  final Iterable<Type> types = const [
    HoraireOuvertureStruct,
    _$HoraireOuvertureStruct
  ];
  @override
  final String wireName = 'HoraireOuvertureStruct';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, HoraireOuvertureStruct object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'firestoreUtilData',
      serializers.serialize(object.firestoreUtilData,
          specifiedType: const FullType(FirestoreUtilData)),
    ];
    Object? value;
    value = object.open;
    if (value != null) {
      result
        ..add('open')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.startHour;
    if (value != null) {
      result
        ..add('startHour')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.closeHour;
    if (value != null) {
      result
        ..add('closeHour')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    return result;
  }

  @override
  HoraireOuvertureStruct deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new HoraireOuvertureStructBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'open':
          result.open = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'startHour':
          result.startHour = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'closeHour':
          result.closeHour = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
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

class _$HoraireOuvertureStruct extends HoraireOuvertureStruct {
  @override
  final bool? open;
  @override
  final DateTime? startHour;
  @override
  final DateTime? closeHour;
  @override
  final FirestoreUtilData firestoreUtilData;

  factory _$HoraireOuvertureStruct(
          [void Function(HoraireOuvertureStructBuilder)? updates]) =>
      (new HoraireOuvertureStructBuilder()..update(updates))._build();

  _$HoraireOuvertureStruct._(
      {this.open,
      this.startHour,
      this.closeHour,
      required this.firestoreUtilData})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        firestoreUtilData, r'HoraireOuvertureStruct', 'firestoreUtilData');
  }

  @override
  HoraireOuvertureStruct rebuild(
          void Function(HoraireOuvertureStructBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HoraireOuvertureStructBuilder toBuilder() =>
      new HoraireOuvertureStructBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HoraireOuvertureStruct &&
        open == other.open &&
        startHour == other.startHour &&
        closeHour == other.closeHour &&
        firestoreUtilData == other.firestoreUtilData;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, open.hashCode);
    _$hash = $jc(_$hash, startHour.hashCode);
    _$hash = $jc(_$hash, closeHour.hashCode);
    _$hash = $jc(_$hash, firestoreUtilData.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HoraireOuvertureStruct')
          ..add('open', open)
          ..add('startHour', startHour)
          ..add('closeHour', closeHour)
          ..add('firestoreUtilData', firestoreUtilData))
        .toString();
  }
}

class HoraireOuvertureStructBuilder
    implements Builder<HoraireOuvertureStruct, HoraireOuvertureStructBuilder> {
  _$HoraireOuvertureStruct? _$v;

  bool? _open;
  bool? get open => _$this._open;
  set open(bool? open) => _$this._open = open;

  DateTime? _startHour;
  DateTime? get startHour => _$this._startHour;
  set startHour(DateTime? startHour) => _$this._startHour = startHour;

  DateTime? _closeHour;
  DateTime? get closeHour => _$this._closeHour;
  set closeHour(DateTime? closeHour) => _$this._closeHour = closeHour;

  FirestoreUtilData? _firestoreUtilData;
  FirestoreUtilData? get firestoreUtilData => _$this._firestoreUtilData;
  set firestoreUtilData(FirestoreUtilData? firestoreUtilData) =>
      _$this._firestoreUtilData = firestoreUtilData;

  HoraireOuvertureStructBuilder() {
    HoraireOuvertureStruct._initializeBuilder(this);
  }

  HoraireOuvertureStructBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _open = $v.open;
      _startHour = $v.startHour;
      _closeHour = $v.closeHour;
      _firestoreUtilData = $v.firestoreUtilData;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HoraireOuvertureStruct other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$HoraireOuvertureStruct;
  }

  @override
  void update(void Function(HoraireOuvertureStructBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HoraireOuvertureStruct build() => _build();

  _$HoraireOuvertureStruct _build() {
    final _$result = _$v ??
        new _$HoraireOuvertureStruct._(
            open: open,
            startHour: startHour,
            closeHour: closeHour,
            firestoreUtilData: BuiltValueNullFieldError.checkNotNull(
                firestoreUtilData,
                r'HoraireOuvertureStruct',
                'firestoreUtilData'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
