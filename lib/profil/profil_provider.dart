import 'package:flutter/material.dart';

class ProviderProfilUser extends ChangeNotifier {
  List _selectedSpecialisation = [];
  List _selectedLgo = [];
  List _selectedCompetences = [];
  List _selectedLangues = [];
  List _selectedExperiences = [];

  Map _searchSaved = {};

  // Getters qui permettent de recuperer les données dans les vues
  List get selectedLgo => _selectedLgo;
  List get selectedSpecialisation => _selectedSpecialisation;
  List get selectedCompetences => _selectedCompetences;
  List get selectedLangues => _selectedLangues;
  List get selectedExperiences => _selectedExperiences;
  Map get searchSaved => _searchSaved;

  void setSearchSaved (search) {
    
  }
  
  void setCompetence(competences) {
    _selectedCompetences = competences;
    // notifyListeners();
  }

  void updateCompetence(boolean, competence) {
    if (boolean) {
      _selectedCompetences.add(competence);
    } else {
      _selectedCompetences.remove(competence);
    }
    notifyListeners();
  }

/* Options Specialisations */
  void addSelectedSpecialisation(specialisation) {
    _selectedSpecialisation.add(specialisation);
    notifyListeners();
  }

  void deleteSelectedSpecialisation(specialisation) {
    _selectedSpecialisation.removeAt(specialisation);
    notifyListeners();
  }

  void setSpecialisation(specialisations) {
    _selectedSpecialisation = specialisations;
    // notifyListeners();
  }

/* Option LGO */
  void setLGO(lgo) {
    _selectedLgo = lgo;
    // notifyListeners();
  }

  void addSelectedLgo(lgo) {
    _selectedLgo.add(lgo);
    notifyListeners();
  }

  void updateSelectedLgo(index, niveau) {
    _selectedLgo[index]['niveau'] = niveau ?? 0;
    notifyListeners();
  }

  void deleteSelectedLgo(lgo) {
    _selectedLgo.removeAt(lgo);
    notifyListeners();
  }

  /* Option langues */
  void setLangues(langues) {
    _selectedLangues = langues;
    // notifyListeners();
  }

  void addLangues(langue) {
    _selectedLangues.add(langue);
    print(_selectedLangues);
    notifyListeners();
  }

  void updateLangues(index, int niveau) {
    _selectedLangues[index]['niveau'] = niveau;
    notifyListeners();
  }

  void deleteLangues(langue) {
    _selectedLangues.removeAt(langue);
    notifyListeners();
  }

  /* Option langues */
  void setExperiences(experiences) {
    _selectedExperiences = experiences;
    // notifyListeners();
  }

  void addExperiences(nom_pharmacie, annee_debut, annee_fin) {
    _selectedExperiences.add({
      "nom_pharmacie": nom_pharmacie,
      "annee_debut": annee_debut,
      "annee_fin": annee_fin
    });
    notifyListeners();
  }

  void deleteExperience(expercienceID) {
    _selectedExperiences.removeAt(expercienceID);
    notifyListeners();
  }
}
