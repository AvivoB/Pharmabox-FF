import 'package:flutter/material.dart';
import 'package:pharmabox/backend/backend.dart';

class ProviderPharmacieRegister extends ChangeNotifier {
  List _selectedGroupement = [
    {"name": "Aelia", "image": "Aelia.jpg"},
  ];
  List _selectedLgo = [
    {"image": "ActiPharm.jpg", "name": "ActiPharm"}
  ];

  List _selectedPharmacieLocation = [];
  String _selectedPharmacieAdresse = '';
  String _selectedPharmacieAdresseRue = '';
  String _selectedAdressFromName = '';
  List _selectedAdressePharma = [];
  List _tendences = [
    {'Ordonances': 0, 'Cosmétiques': 0, 'Phyto / aroma': 0, 'Nutrition': 0, 'Conseil': 0}
  ];

  dynamic _selectedHoraires;

  // Getters qui permettent de recuperer les données dans les vues
  List get selectedGroupement => _selectedGroupement;
  List get selectedLgo => _selectedLgo;
  List get selectedPharmacieLocation => _selectedPharmacieLocation;
  List get tendences => _tendences;
  String get selectedPharmacieAdresse => _selectedPharmacieAdresse;
  String get selectedPharmacieAdresseRue => _selectedPharmacieAdresseRue;
  String get selectedAdressFromName => _selectedAdressFromName;
  List get selectedAdressePharma => _selectedAdressePharma;
  dynamic get selectedHoraires => _selectedHoraires;

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

  void setAdresse(postcode, rue, ville, region, arrondissement, country) {
    _selectedAdressePharma = [
      {'rue': rue, 'postcode': postcode, 'ville': ville, 'region': region, 'arrondissement': arrondissement, 'country': country}
    ];
    notifyListeners();
  }

  void setAdresseFromName(adresse) {
    _selectedAdressFromName = adresse;
    notifyListeners();
  }

  void setTendences(index, type, value) {
    _tendences[0][type] = value;
    notifyListeners();
  }

  void setHoraire(listHoraire) {
    _selectedHoraires = listHoraire;
  }
}
