import 'package:flutter/material.dart';
import 'package:pharmabox/backend/backend.dart';

class ProviderPharmacieRegister extends ChangeNotifier {
  List _selectedGroupement = [
    {"name": "Aucun groupement", "image": "Aucun.jpg"},
  ];
  List _selectedLgo = [
    {"image": "ActiPharm.jpg", "name": "ActiPharm"}
  ];

  List _selectedPharmacieLocation = [];
  String _selectedPharmacieAdresse = '';
  String _selectedPharmacieAdresseRue = '';
  List _tendences = [
    {'Ordonances': ''},
    {'Cosmétiques': ''},
    {'Phyto / aroma': ''},
    {'Nutrition': ''},
    {'Conseil': ''},
  ];

  // Getters qui permettent de recuperer les données dans les vues
  List get selectedGroupement => _selectedGroupement;
  List get selectedLgo => _selectedLgo;
  List get selectedPharmacieLocation => _selectedPharmacieLocation;
  List get tendences => _tendences;
  String get selectedPharmacieAdresse => _selectedPharmacieAdresse;
  String get selectedPharmacieAdresseRue => _selectedPharmacieAdresseRue;

/* Options Groupement */
  void selectGroupement(groupement) {
    _selectedGroupement[0] = groupement;
    notifyListeners();
  }

/* Option LGO */
  void selectLGO(lgo) {
    _selectedLgo[0] = lgo;
    notifyListeners();
  }

  /* Localisation de la pharmacie */
  void setPharmacieLocation(latitude, longitude) {
    _selectedPharmacieLocation = [latitude, longitude];
    notifyListeners();
  }

  void setAdressePharmacie(adresse) {
    _selectedPharmacieAdresse = adresse;
    notifyListeners();
  }

  void setAdresseRue(adresse) {
    _selectedPharmacieAdresseRue = adresse;
  }

  void setTendences(index, type, value) {
    _tendences[index][type] = value;
    print(value);
    notifyListeners();
  }
}
