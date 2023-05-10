import 'package:flutter/material.dart';
import 'package:pharmabox/backend/backend.dart';

class ProviderPharmacieRegister extends ChangeNotifier {
  List _selectedGroupement = [
    {"name": "Aelia", "image": "Aelia.jpg"}
  ];
  List _selectedLgo = [
    {"image": "ActiPharm.jpg", "name": "ActiPharm"}
  ];

  List _selectedPharmacieLocation = [];
  String _selectedPharmacieAdresse = '';
  String _selectedPharmacieVille = '';
  String _selectedPharmacieCodePostal = '';

  // Getters qui permettent de recuperer les données dans les vues
  List get selectedGroupement => _selectedGroupement;
  List get selectedLgo => _selectedLgo;
  List get selectedPharmacieLocation => _selectedPharmacieLocation;
  String get selectedPharmacieAdresse => _selectedPharmacieAdresse;
  String get selectedPharmacieVille => _selectedPharmacieVille;
  String get selectedPharmacieCodePostal => _selectedPharmacieCodePostal;

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
    _selectedPharmacieLocation[0] = latitude;
    _selectedPharmacieLocation[1] = longitude;
  }

  void setAdressePharmacie(adresse, ville, codePostal) {
    _selectedPharmacieAdresse = adresse;
    _selectedPharmacieVille = ville;
    _selectedPharmacieCodePostal = codePostal;
  }
}
