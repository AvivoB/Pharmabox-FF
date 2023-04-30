// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<UsersRecord> _$usersRecordSerializer = new _$UsersRecordSerializer();

class _$UsersRecordSerializer implements StructuredSerializer<UsersRecord> {
  @override
  final Iterable<Type> types = const [UsersRecord, _$UsersRecord];
  @override
  final String wireName = 'UsersRecord';

  @override
  Iterable<Object?> serialize(Serializers serializers, UsersRecord object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.email;
    if (value != null) {
      result
        ..add('email')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.photoUrl;
    if (value != null) {
      result
        ..add('photo_url')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.uid;
    if (value != null) {
      result
        ..add('uid')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.createdTime;
    if (value != null) {
      result
        ..add('created_time')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.phoneNumber;
    if (value != null) {
      result
        ..add('phone_number')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.nom;
    if (value != null) {
      result
        ..add('nom')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.prenom;
    if (value != null) {
      result
        ..add('prenom')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.ville;
    if (value != null) {
      result
        ..add('ville')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.codePostal;
    if (value != null) {
      result
        ..add('code_postal')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.presentation;
    if (value != null) {
      result
        ..add('presentation')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.dateNaissance;
    if (value != null) {
      result
        ..add('date_naissance')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.poste;
    if (value != null) {
      result
        ..add('poste')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.specialisations;
    if (value != null) {
      result
        ..add('specialisations')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    value = object.lgo;
    if (value != null) {
      result
        ..add('lgo')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    value = object.faculteEcole;
    if (value != null) {
      result
        ..add('faculte_ecole')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    value = object.experiences;
    if (value != null) {
      result
        ..add('experiences')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    value = object.competences;
    if (value != null) {
      result
        ..add('competences')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    value = object.isTitulaire;
    if (value != null) {
      result
        ..add('IsTitulaire')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.likes;
    if (value != null) {
      result
        ..add('likes')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.displayName;
    if (value != null) {
      result
        ..add('display_name')
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
  UsersRecord deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UsersRecordBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'photo_url':
          result.photoUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'uid':
          result.uid = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'created_time':
          result.createdTime = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'phone_number':
          result.phoneNumber = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'nom':
          result.nom = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'prenom':
          result.prenom = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'ville':
          result.ville = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'code_postal':
          result.codePostal = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'presentation':
          result.presentation = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'date_naissance':
          result.dateNaissance = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'poste':
          result.poste = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'specialisations':
          result.specialisations.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'lgo':
          result.lgo.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'faculte_ecole':
          result.faculteEcole.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'experiences':
          result.experiences.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'competences':
          result.competences.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'IsTitulaire':
          result.isTitulaire = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'likes':
          result.likes = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'display_name':
          result.displayName = serializers.deserialize(value,
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

class _$UsersRecord extends UsersRecord {
  @override
  final String? email;
  @override
  final String? photoUrl;
  @override
  final String? uid;
  @override
  final DateTime? createdTime;
  @override
  final String? phoneNumber;
  @override
  final String? nom;
  @override
  final String? prenom;
  @override
  final String? ville;
  @override
  final int? codePostal;
  @override
  final String? presentation;
  @override
  final String? dateNaissance;
  @override
  final String? poste;
  @override
  final BuiltList<String>? specialisations;
  @override
  final BuiltList<String>? lgo;
  @override
  final BuiltList<String>? faculteEcole;
  @override
  final BuiltList<String>? experiences;
  @override
  final BuiltList<String>? competences;
  @override
  final bool? isTitulaire;
  @override
  final int? likes;
  @override
  final String? displayName;
  @override
  final DocumentReference<Object?>? ffRef;

  factory _$UsersRecord([void Function(UsersRecordBuilder)? updates]) =>
      (new UsersRecordBuilder()..update(updates))._build();

  _$UsersRecord._(
      {this.email,
      this.photoUrl,
      this.uid,
      this.createdTime,
      this.phoneNumber,
      this.nom,
      this.prenom,
      this.ville,
      this.codePostal,
      this.presentation,
      this.dateNaissance,
      this.poste,
      this.specialisations,
      this.lgo,
      this.faculteEcole,
      this.experiences,
      this.competences,
      this.isTitulaire,
      this.likes,
      this.displayName,
      this.ffRef})
      : super._();

  @override
  UsersRecord rebuild(void Function(UsersRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UsersRecordBuilder toBuilder() => new UsersRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UsersRecord &&
        email == other.email &&
        photoUrl == other.photoUrl &&
        uid == other.uid &&
        createdTime == other.createdTime &&
        phoneNumber == other.phoneNumber &&
        nom == other.nom &&
        prenom == other.prenom &&
        ville == other.ville &&
        codePostal == other.codePostal &&
        presentation == other.presentation &&
        dateNaissance == other.dateNaissance &&
        poste == other.poste &&
        specialisations == other.specialisations &&
        lgo == other.lgo &&
        faculteEcole == other.faculteEcole &&
        experiences == other.experiences &&
        competences == other.competences &&
        isTitulaire == other.isTitulaire &&
        likes == other.likes &&
        displayName == other.displayName &&
        ffRef == other.ffRef;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, photoUrl.hashCode);
    _$hash = $jc(_$hash, uid.hashCode);
    _$hash = $jc(_$hash, createdTime.hashCode);
    _$hash = $jc(_$hash, phoneNumber.hashCode);
    _$hash = $jc(_$hash, nom.hashCode);
    _$hash = $jc(_$hash, prenom.hashCode);
    _$hash = $jc(_$hash, ville.hashCode);
    _$hash = $jc(_$hash, codePostal.hashCode);
    _$hash = $jc(_$hash, presentation.hashCode);
    _$hash = $jc(_$hash, dateNaissance.hashCode);
    _$hash = $jc(_$hash, poste.hashCode);
    _$hash = $jc(_$hash, specialisations.hashCode);
    _$hash = $jc(_$hash, lgo.hashCode);
    _$hash = $jc(_$hash, faculteEcole.hashCode);
    _$hash = $jc(_$hash, experiences.hashCode);
    _$hash = $jc(_$hash, competences.hashCode);
    _$hash = $jc(_$hash, isTitulaire.hashCode);
    _$hash = $jc(_$hash, likes.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, ffRef.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UsersRecord')
          ..add('email', email)
          ..add('photoUrl', photoUrl)
          ..add('uid', uid)
          ..add('createdTime', createdTime)
          ..add('phoneNumber', phoneNumber)
          ..add('nom', nom)
          ..add('prenom', prenom)
          ..add('ville', ville)
          ..add('codePostal', codePostal)
          ..add('presentation', presentation)
          ..add('dateNaissance', dateNaissance)
          ..add('poste', poste)
          ..add('specialisations', specialisations)
          ..add('lgo', lgo)
          ..add('faculteEcole', faculteEcole)
          ..add('experiences', experiences)
          ..add('competences', competences)
          ..add('isTitulaire', isTitulaire)
          ..add('likes', likes)
          ..add('displayName', displayName)
          ..add('ffRef', ffRef))
        .toString();
  }
}

class UsersRecordBuilder implements Builder<UsersRecord, UsersRecordBuilder> {
  _$UsersRecord? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _photoUrl;
  String? get photoUrl => _$this._photoUrl;
  set photoUrl(String? photoUrl) => _$this._photoUrl = photoUrl;

  String? _uid;
  String? get uid => _$this._uid;
  set uid(String? uid) => _$this._uid = uid;

  DateTime? _createdTime;
  DateTime? get createdTime => _$this._createdTime;
  set createdTime(DateTime? createdTime) => _$this._createdTime = createdTime;

  String? _phoneNumber;
  String? get phoneNumber => _$this._phoneNumber;
  set phoneNumber(String? phoneNumber) => _$this._phoneNumber = phoneNumber;

  String? _nom;
  String? get nom => _$this._nom;
  set nom(String? nom) => _$this._nom = nom;

  String? _prenom;
  String? get prenom => _$this._prenom;
  set prenom(String? prenom) => _$this._prenom = prenom;

  String? _ville;
  String? get ville => _$this._ville;
  set ville(String? ville) => _$this._ville = ville;

  int? _codePostal;
  int? get codePostal => _$this._codePostal;
  set codePostal(int? codePostal) => _$this._codePostal = codePostal;

  String? _presentation;
  String? get presentation => _$this._presentation;
  set presentation(String? presentation) => _$this._presentation = presentation;

  String? _dateNaissance;
  String? get dateNaissance => _$this._dateNaissance;
  set dateNaissance(String? dateNaissance) =>
      _$this._dateNaissance = dateNaissance;

  String? _poste;
  String? get poste => _$this._poste;
  set poste(String? poste) => _$this._poste = poste;

  ListBuilder<String>? _specialisations;
  ListBuilder<String> get specialisations =>
      _$this._specialisations ??= new ListBuilder<String>();
  set specialisations(ListBuilder<String>? specialisations) =>
      _$this._specialisations = specialisations;

  ListBuilder<String>? _lgo;
  ListBuilder<String> get lgo => _$this._lgo ??= new ListBuilder<String>();
  set lgo(ListBuilder<String>? lgo) => _$this._lgo = lgo;

  ListBuilder<String>? _faculteEcole;
  ListBuilder<String> get faculteEcole =>
      _$this._faculteEcole ??= new ListBuilder<String>();
  set faculteEcole(ListBuilder<String>? faculteEcole) =>
      _$this._faculteEcole = faculteEcole;

  ListBuilder<String>? _experiences;
  ListBuilder<String> get experiences =>
      _$this._experiences ??= new ListBuilder<String>();
  set experiences(ListBuilder<String>? experiences) =>
      _$this._experiences = experiences;

  ListBuilder<String>? _competences;
  ListBuilder<String> get competences =>
      _$this._competences ??= new ListBuilder<String>();
  set competences(ListBuilder<String>? competences) =>
      _$this._competences = competences;

  bool? _isTitulaire;
  bool? get isTitulaire => _$this._isTitulaire;
  set isTitulaire(bool? isTitulaire) => _$this._isTitulaire = isTitulaire;

  int? _likes;
  int? get likes => _$this._likes;
  set likes(int? likes) => _$this._likes = likes;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  DocumentReference<Object?>? _ffRef;
  DocumentReference<Object?>? get ffRef => _$this._ffRef;
  set ffRef(DocumentReference<Object?>? ffRef) => _$this._ffRef = ffRef;

  UsersRecordBuilder() {
    UsersRecord._initializeBuilder(this);
  }

  UsersRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _photoUrl = $v.photoUrl;
      _uid = $v.uid;
      _createdTime = $v.createdTime;
      _phoneNumber = $v.phoneNumber;
      _nom = $v.nom;
      _prenom = $v.prenom;
      _ville = $v.ville;
      _codePostal = $v.codePostal;
      _presentation = $v.presentation;
      _dateNaissance = $v.dateNaissance;
      _poste = $v.poste;
      _specialisations = $v.specialisations?.toBuilder();
      _lgo = $v.lgo?.toBuilder();
      _faculteEcole = $v.faculteEcole?.toBuilder();
      _experiences = $v.experiences?.toBuilder();
      _competences = $v.competences?.toBuilder();
      _isTitulaire = $v.isTitulaire;
      _likes = $v.likes;
      _displayName = $v.displayName;
      _ffRef = $v.ffRef;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UsersRecord other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UsersRecord;
  }

  @override
  void update(void Function(UsersRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UsersRecord build() => _build();

  _$UsersRecord _build() {
    _$UsersRecord _$result;
    try {
      _$result = _$v ??
          new _$UsersRecord._(
              email: email,
              photoUrl: photoUrl,
              uid: uid,
              createdTime: createdTime,
              phoneNumber: phoneNumber,
              nom: nom,
              prenom: prenom,
              ville: ville,
              codePostal: codePostal,
              presentation: presentation,
              dateNaissance: dateNaissance,
              poste: poste,
              specialisations: _specialisations?.build(),
              lgo: _lgo?.build(),
              faculteEcole: _faculteEcole?.build(),
              experiences: _experiences?.build(),
              competences: _competences?.build(),
              isTitulaire: isTitulaire,
              likes: likes,
              displayName: displayName,
              ffRef: ffRef);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'specialisations';
        _specialisations?.build();
        _$failedField = 'lgo';
        _lgo?.build();
        _$failedField = 'faculteEcole';
        _faculteEcole?.build();
        _$failedField = 'experiences';
        _experiences?.build();
        _$failedField = 'competences';
        _competences?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'UsersRecord', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
