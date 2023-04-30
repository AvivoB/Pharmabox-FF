import 'package:flutter/material.dart';
import 'backend/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static final FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal() {
    initializePersistedState();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _searchField = '';
  String get searchField => _searchField;
  set searchField(String _value) {
    _searchField = _value;
  }

  List<String> _listSpecialisationRegister = [];
  List<String> get listSpecialisationRegister => _listSpecialisationRegister;
  set listSpecialisationRegister(List<String> _value) {
    _listSpecialisationRegister = _value;
  }

  void addToListSpecialisationRegister(String _value) {
    _listSpecialisationRegister.add(_value);
  }

  void removeFromListSpecialisationRegister(String _value) {
    _listSpecialisationRegister.remove(_value);
  }

  void removeAtIndexFromListSpecialisationRegister(int _index) {
    _listSpecialisationRegister.removeAt(_index);
  }

  List<String> _listLgoRegister = [];
  List<String> get listLgoRegister => _listLgoRegister;
  set listLgoRegister(List<String> _value) {
    _listLgoRegister = _value;
  }

  void addToListLgoRegister(String _value) {
    _listLgoRegister.add(_value);
  }

  void removeFromListLgoRegister(String _value) {
    _listLgoRegister.remove(_value);
  }

  void removeAtIndexFromListLgoRegister(int _index) {
    _listLgoRegister.removeAt(_index);
  }

  List<String> _listLangRegister = [];
  List<String> get listLangRegister => _listLangRegister;
  set listLangRegister(List<String> _value) {
    _listLangRegister = _value;
  }

  void addToListLangRegister(String _value) {
    _listLangRegister.add(_value);
  }

  void removeFromListLangRegister(String _value) {
    _listLangRegister.remove(_value);
  }

  void removeAtIndexFromListLangRegister(int _index) {
    _listLangRegister.removeAt(_index);
  }

  List<String> _listTitulaireRegisterPharmacie = [];
  List<String> get listTitulaireRegisterPharmacie =>
      _listTitulaireRegisterPharmacie;
  set listTitulaireRegisterPharmacie(List<String> _value) {
    _listTitulaireRegisterPharmacie = _value;
  }

  void addToListTitulaireRegisterPharmacie(String _value) {
    _listTitulaireRegisterPharmacie.add(_value);
  }

  void removeFromListTitulaireRegisterPharmacie(String _value) {
    _listTitulaireRegisterPharmacie.remove(_value);
  }

  void removeAtIndexFromListTitulaireRegisterPharmacie(int _index) {
    _listTitulaireRegisterPharmacie.removeAt(_index);
  }
}

LatLng? _latLngFromString(String? val) {
  if (val == null) {
    return null;
  }
  final split = val.split(',');
  final lat = double.parse(split.first);
  final lng = double.parse(split.last);
  return LatLng(lat, lng);
}
