import 'package:flutter/material.dart';

class ProviderUserRegister extends ChangeNotifier {
  List _selectedSpecialisation = [];
  List _selectedLgo = [];
  List _selectedCompetences = [];
  List _selectedLangues = [];
  List _selectedExperiences = [];

  // Getters qui permettent de recuperer les données dans les vues
  List get selectedLgo => _selectedLgo;
  List get selectedSpecialisation => _selectedSpecialisation;
  List get selectedCompetences => _selectedCompetences;
  List get selectedLangues => _selectedLangues;
  List get selectedExperiences => _selectedExperiences;

/* Options Specialisations */
  void addSelectedSpecialisation(specialisation) {
    _selectedSpecialisation.add(specialisation);
    notifyListeners();
  }

  void deleteSelectedSpecialisation(specialisation) {
    _selectedSpecialisation.removeAt(specialisation);
    notifyListeners();
  }

/* Option LGO */
  void addSelectedLgo(lgo) {
    _selectedLgo.add(lgo);
    notifyListeners();
  }

  void updateSelectedLgo(index, niveau) {
    _selectedLgo[index]['niveau'] = niveau;
    notifyListeners();
  }

  void deleteSelectedLgo(lgo) {
    _selectedLgo.removeAt(lgo);
    notifyListeners();
  }


  /* Option langues */
  void addLangues(langue) {
    _selectedLangues.add(langue);
    notifyListeners();
  }

  void updateLangues(index, niveau) {
    _selectedLangues[index]['niveau'] = niveau;
    notifyListeners();
  }

  void deleteLangues(langue) {
    _selectedLangues.removeAt(langue);
    notifyListeners();
  }
}
