import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PopupSpecialisationModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this component.

  // State field(s) for LgoFilter widget.
  TextEditingController? lgoFilterController;
  String? Function(BuildContext, String?)? lgoFilterControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    lgoFilterController?.dispose();
  }

  /// Additional helper methods are added here.

  getSpecialite() {
    List<String> listSpecialisation = [
      'Addictologie & Dopage',
      'Aromathérapie & Phytothérapie',
      'Autres DU',
      'Botanique & Mycologie',
      'Cancérologie',
      'Cosmétologie',
      'Digital',
      'Dispositifs Médicaux',
      'Douleurs & Soins',
      'Douleurs & soins palliatifs',
      'Endocrinologie',
      'Ethique',
      'Exercice Officinal',
      'Gestion & Management',
      'Grossesse & Pédiatrie',
      'Gériatrie',
      'Homéopathie',
      'Humanitaire & Santé Publique',
      'Hôpital et biologie médicale',
      'Immunologie et biothérapies',
      'Inféctiologie',
      'Maintien à Domicile',
      'Médicaments',
      'Nutrition',
      'Nutrition & Supplémentation',
      'Orthopédie',
      'Pharmacie Clinique',
      'Pharmacie Vétérinaire',
      'Pharmaco-économie',
      'Plaies & cicatrisation',
      'Qualitologie',
      'Recherche Clinique & Pharmacovigilance',
      'Reconversion officinale',
      'Sexualité Grossesse & Pédiatrie',
      'Sommeil',
      'Sommeil - sport & bien-être',
      'Sport & bien-être',
      'Stérilisation',
      'Éducation Thérapeutique'
    ];

    return listSpecialisation;
  }
}
