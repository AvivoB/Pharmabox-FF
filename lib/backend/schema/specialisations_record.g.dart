// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specialisations_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SpecialisationsRecord> _$specialisationsRecordSerializer =
    new _$SpecialisationsRecordSerializer();

class _$SpecialisationsRecordSerializer
    implements StructuredSerializer<SpecialisationsRecord> {
  @override
  final Iterable<Type> types = const [
    SpecialisationsRecord,
    _$SpecialisationsRecord
  ];
  @override
  final String wireName = 'SpecialisationsRecord';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, SpecialisationsRecord object,
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
  SpecialisationsRecord deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SpecialisationsRecordBuilder();

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

class _$SpecialisationsRecord extends SpecialisationsRecord {
  @override
  final String? name;
  @override
  final DocumentReference<Object?>? ffRef;

  factory _$SpecialisationsRecord(
          [void Function(SpecialisationsRecordBuilder)? updates]) =>
      (new SpecialisationsRecordBuilder()..update(updates))._build();

  _$SpecialisationsRecord._({this.name, this.ffRef}) : super._();

  @override
  SpecialisationsRecord rebuild(
          void Function(SpecialisationsRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SpecialisationsRecordBuilder toBuilder() =>
      new SpecialisationsRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SpecialisationsRecord &&
        name == other.name &&
        ffRef == other.ffRef;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, ffRef.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SpecialisationsRecord')
          ..add('name', name)
          ..add('ffRef', ffRef))
        .toString();
  }
}

class SpecialisationsRecordBuilder
    implements Builder<SpecialisationsRecord, SpecialisationsRecordBuilder> {
  _$SpecialisationsRecord? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  DocumentReference<Object?>? _ffRef;
  DocumentReference<Object?>? get ffRef => _$this._ffRef;
  set ffRef(DocumentReference<Object?>? ffRef) => _$this._ffRef = ffRef;

  SpecialisationsRecordBuilder() {
    SpecialisationsRecord._initializeBuilder(this);
  }

  SpecialisationsRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _ffRef = $v.ffRef;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SpecialisationsRecord other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SpecialisationsRecord;
  }

  @override
  void update(void Function(SpecialisationsRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SpecialisationsRecord build() => _build();

  _$SpecialisationsRecord _build() {
    final _$result =
        _$v ?? new _$SpecialisationsRecord._(name: name, ffRef: ffRef);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
