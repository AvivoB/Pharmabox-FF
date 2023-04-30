// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groupement_struct.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GroupementStruct> _$groupementStructSerializer =
    new _$GroupementStructSerializer();

class _$GroupementStructSerializer
    implements StructuredSerializer<GroupementStruct> {
  @override
  final Iterable<Type> types = const [GroupementStruct, _$GroupementStruct];
  @override
  final String wireName = 'GroupementStruct';

  @override
  Iterable<Object?> serialize(Serializers serializers, GroupementStruct object,
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
    value = object.image;
    if (value != null) {
      result
        ..add('image')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  GroupementStruct deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new GroupementStructBuilder();

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
        case 'image':
          result.image = serializers.deserialize(value,
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

class _$GroupementStruct extends GroupementStruct {
  @override
  final String? name;
  @override
  final String? image;
  @override
  final FirestoreUtilData firestoreUtilData;

  factory _$GroupementStruct(
          [void Function(GroupementStructBuilder)? updates]) =>
      (new GroupementStructBuilder()..update(updates))._build();

  _$GroupementStruct._({this.name, this.image, required this.firestoreUtilData})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        firestoreUtilData, r'GroupementStruct', 'firestoreUtilData');
  }

  @override
  GroupementStruct rebuild(void Function(GroupementStructBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GroupementStructBuilder toBuilder() =>
      new GroupementStructBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GroupementStruct &&
        name == other.name &&
        image == other.image &&
        firestoreUtilData == other.firestoreUtilData;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jc(_$hash, firestoreUtilData.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GroupementStruct')
          ..add('name', name)
          ..add('image', image)
          ..add('firestoreUtilData', firestoreUtilData))
        .toString();
  }
}

class GroupementStructBuilder
    implements Builder<GroupementStruct, GroupementStructBuilder> {
  _$GroupementStruct? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

  FirestoreUtilData? _firestoreUtilData;
  FirestoreUtilData? get firestoreUtilData => _$this._firestoreUtilData;
  set firestoreUtilData(FirestoreUtilData? firestoreUtilData) =>
      _$this._firestoreUtilData = firestoreUtilData;

  GroupementStructBuilder() {
    GroupementStruct._initializeBuilder(this);
  }

  GroupementStructBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _image = $v.image;
      _firestoreUtilData = $v.firestoreUtilData;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GroupementStruct other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GroupementStruct;
  }

  @override
  void update(void Function(GroupementStructBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GroupementStruct build() => _build();

  _$GroupementStruct _build() {
    final _$result = _$v ??
        new _$GroupementStruct._(
            name: name,
            image: image,
            firestoreUtilData: BuiltValueNullFieldError.checkNotNull(
                firestoreUtilData, r'GroupementStruct', 'firestoreUtilData'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
