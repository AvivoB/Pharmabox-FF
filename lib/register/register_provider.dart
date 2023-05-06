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


  void updateSelectedSpecialisation(specialisation) {
    _selectedSpecialisation.add(specialisation);
    notifyListeners();
  }

  void deleteSelectedSpecialisation(specialisation) {
    _selectedSpecialisation.remove(specialisation);
    notifyListeners();
  }


/* Option LGO */
  void addSelectedLgo(lgo) {
    _selectedLgo.add(lgo);
    notifyListeners();
  }


  void updateSelectedLgo(lgo) {
    _selectedLgo.add(lgo);
    notifyListeners();
  }

  void deleteSelectedLgo(lgo) {
    _selectedLgo.remove(lgo);
    notifyListeners();
  }



}
