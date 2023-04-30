// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lgo_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<LgoRecord> _$lgoRecordSerializer = new _$LgoRecordSerializer();

class _$LgoRecordSerializer implements StructuredSerializer<LgoRecord> {
  @override
  final Iterable<Type> types = const [LgoRecord, _$LgoRecord];
  @override
  final String wireName = 'LgoRecord';

  @override
  Iterable<Object?> serialize(Serializers serializers, LgoRecord object,
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
  LgoRecord deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new LgoRecordBuilder();

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

class _$LgoRecord extends LgoRecord {
  @override
  final String? name;
  @override
  final String? image;
  @override
  final DocumentReference<Object?>? ffRef;

  factory _$LgoRecord([void Function(LgoRecordBuilder)? updates]) =>
      (new LgoRecordBuilder()..update(updates))._build();

  _$LgoRecord._({this.name, this.image, this.ffRef}) : super._();

  @override
  LgoRecord rebuild(void Function(LgoRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LgoRecordBuilder toBuilder() => new LgoRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LgoRecord &&
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
    return (newBuiltValueToStringHelper(r'LgoRecord')
          ..add('name', name)
          ..add('image', image)
          ..add('ffRef', ffRef))
        .toString();
  }
}

class LgoRecordBuilder implements Builder<LgoRecord, LgoRecordBuilder> {
  _$LgoRecord? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

  DocumentReference<Object?>? _ffRef;
  DocumentReference<Object?>? get ffRef => _$this._ffRef;
  set ffRef(DocumentReference<Object?>? ffRef) => _$this._ffRef = ffRef;

  LgoRecordBuilder() {
    LgoRecord._initializeBuilder(this);
  }

  LgoRecordBuilder get _$this {
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
  void replace(LgoRecord other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$LgoRecord;
  }

  @override
  void update(void Function(LgoRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LgoRecord build() => _build();

  _$LgoRecord _build() {
    final _$result =
        _$v ?? new _$LgoRecord._(name: name, image: image, ffRef: ffRef);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
