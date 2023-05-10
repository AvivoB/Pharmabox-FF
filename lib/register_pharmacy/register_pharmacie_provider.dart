import 'package:flutter/material.dart';

class ProviderPharmacieRegister extends ChangeNotifier {
  List _selectedGroupement = [{"name": "Aelia", "image": "Aelia.jpg"}];
  List _selectedLgo = [{"image": "ActiPharm.jpg", "name": "ActiPharm"}];

  // Getters qui permettent de recuperer les données dans les vues
  List get selectedGroupement => _selectedGroupement;
  List get selectedLgo => _selectedLgo;

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
}
