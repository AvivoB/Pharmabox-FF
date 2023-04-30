// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groupements_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GroupementsRecord> _$groupementsRecordSerializer =
    new _$GroupementsRecordSerializer();

class _$GroupementsRecordSerializer
    implements StructuredSerializer<GroupementsRecord> {
  @override
  final Iterable<Type> types = const [GroupementsRecord, _$GroupementsRecord];
  @override
  final String wireName = 'GroupementsRecord';

  @override
  Iterable<Object?> serialize(Serializers serializers, GroupementsRecord object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
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
    value = object.ffRef;
    if (value != null) {
      result
        ..add('Document__Reference__Field')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                DocumentReference, const [const FullType.nullable(Object)])));
    }
    return result;
  }

  @override
  GroupementsRecord deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new GroupementsRecordBuilder();

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
        case 'Document__Reference__Field':
          result.ffRef = serializers.deserialize(value,
              specifiedType: const FullType(DocumentReference, const [
                const FullType.nullable(Object)
              ])) as DocumentReference<Object?>?;
          break;
      }
    }

    return result.build();
  }
}

class _$GroupementsRecord extends GroupementsRecord {
  @override
  final String? name;
  @override
  final String? image;
  @override
  final DocumentReference<Object?>? ffRef;

  factory _$GroupementsRecord(
          [void Function(GroupementsRecordBuilder)? updates]) =>
      (new GroupementsRecordBuilder()..update(updates))._build();

  _$GroupementsRecord._({this.name, this.image, this.ffRef}) : super._();

  @override
  GroupementsRecord rebuild(void Function(GroupementsRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GroupementsRecordBuilder toBuilder() =>
      new GroupementsRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GroupementsRecord &&
        name == other.name &&
        image == other.image &&
        ffRef == other.ffRef;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jc(_$hash, ffRef.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GroupementsRecord')
          ..add('name', name)
          ..add('image', image)
          ..add('ffRef', ffRef))
        .toString();
  }
}

class GroupementsRecordBuilder
    implements Builder<GroupementsRecord, GroupementsRecordBuilder> {
  _$GroupementsRecord? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

  DocumentReference<Object?>? _ffRef;
  DocumentReference<Object?>? get ffRef => _$this._ffRef;
  set ffRef(DocumentReference<Object?>? ffRef) => _$this._ffRef = ffRef;

  GroupementsRecordBuilder() {
    GroupementsRecord._initializeBuilder(this);
  }

  GroupementsRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _image = $v.image;
      _ffRef = $v.ffRef;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GroupementsRecord other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GroupementsRecord;
  }

  @override
  void update(void Function(GroupementsRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GroupementsRecord build() => _build();

  _$GroupementsRecord _build() {
    final _$result = _$v ??
        new _$GroupementsRecord._(name: name, image: image, ffRef: ffRef);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
