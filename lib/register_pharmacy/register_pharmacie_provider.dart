import 'package:flutter/material.dart';

class ProviderPharmacieRegister extends ChangeNotifier {
  List _selectedGroupement = [];
  List _selectedLgo = [];

  // Getters qui permettent de recuperer les données dans les vues
  List get selectedLgo => _selectedLgo;
  List get selectedGroupemnt => _selectedGroupement;

/* Options Groupement */
  void selectGroupement(groupement) {
    _selectedGroupement = groupement;
    notifyListeners();
  }

/* Option LGO */
  void selectLGO(lgo) {
    _selectedLgo = lgo;
    notifyListeners();
  }
}
