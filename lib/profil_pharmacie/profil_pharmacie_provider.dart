import 'package:flutter/material.dart';

class ProviderPharmacieUser extends ChangeNotifier {
  List _selectedGroupement = [
    {"name": "Aucun groupement", "image": "Aucun.jpg"},
  ];
  List _selectedLgo = [
    {"image": "ActiPharm.jpg", "name": "ActiPharm"}
  ];

  List _selectedPharmacieLocation = [];
  String _selectedPharmacieAdresse = '';
  String _selectedPharmacieAdresseRue = '';
  List _selectedAdressePharma = [];
  List _tendences = [
    {'Ordonances': 0, 'Cosmétiques': 0, 'Phyto / aroma': 0, 'Nutrition': 0, 'Conseil': 0}
  ];

  List _selectedMissions = [];
  List _selectedConfort = [];
  String _selectedTypologie = '';
  var _selectedHoraires;

  // Getters qui permettent de recuperer les données dans les vues
  List get selectedGroupement => _selectedGroupement;
  List get selectedLgo => _selectedLgo;
  List get selectedPharmacieLocation => _selectedPharmacieLocation;
  List get tendences => _tendences;
  String get selectedPharmacieAdresse => _selectedPharmacieAdresse;
  String get selectedPharmacieAdresseRue => _selectedPharmacieAdresseRue;
  List get selectedAdressePharma => _selectedAdressePharma;
  List get selectedMissions => _selectedMissions;
  List get selectedConfort => _selectedConfort;
  String get selectedTypologie => _selectedTypologie;
  dynamic get selectedHoraires => _selectedHoraires;

/* Options Groupement */
  void selectGroupement(groupement) {
    _selectedGroupement[0] = groupement;
    notifyListeners();
  }

  void setGroupement(groupement) {
    _selectedGroupement = groupement;
    // notifyListeners();
  }

/* Option LGO */
  void selectLGO(lgo) {
    _selectedLgo[0] = lgo;
    notifyListeners();
  }

  void setLGO(lgo) {
    _selectedLgo = lgo;
    // notifyListeners();
  }

  /* Localisation de la pharmacie */
  void setPharmacieLocation(latitude, longitude) {
    _selectedPharmacieLocation = [latitude, longitude];
  }

  void setAdressePharmacie(adresse) {
    _selectedPharmacieAdresse = adresse;
    notifyListeners();
  }

  void setAdresseRue(adresse) {
    _selectedPharmacieAdresseRue = adresse;
  }

  void setAdresse(postcode, rue, ville, region, arrondissement) {
    _selectedAdressePharma = [
      {'rue': rue, 'postcode': postcode, 'ville': ville, 'region': region, 'arrondissement': arrondissement}
    ];
    notifyListeners();
  }

  void setTendences(index, type, value) {
    _tendences[0][type] = value;
    notifyListeners();
  }

  void setMissions(missions) {
    _selectedMissions = missions;
    // notifyListeners();
  }

  void setConfort(conforts) {
    _selectedConfort = conforts;
    // notifyListeners();
  }

  void updateConfort(boolean, confort) {
    if (boolean) {
      _selectedConfort.add(confort);
    } else {
      _selectedConfort.remove(confort);
    }
    notifyListeners();
  }

  void updateMissions(boolean, mission) {
    if (boolean) {
      _selectedMissions.add(mission);
    } else {
      _selectedMissions.remove(mission);
    }
    notifyListeners();
  }

  void setTypologie(typologie) {
    _selectedTypologie = typologie;
    // notifyListeners();
  }

  void updateTypologie(boolean, typologie) {
    if (boolean) {
      _selectedTypologie = '';
      print(boolean);
    } else {
      _selectedTypologie = '';
    }
    notifyListeners();
  }

  void setHoraire(listeHoraire) {
    _selectedHoraires = listeHoraire;
    // notifyListeners();
  }
}
