import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PopupLanguesModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this component.

  // State field(s) for LgoFilter widget.
  TextEditingController? lgoFilterController;
  String? Function(BuildContext, String?)? lgoFilterControllerValidator;

  /// Initialization and disposal methods.
  TextEditingController? langueFilterController;
  String? Function(BuildContext, String?)? langueFilterControllerValidator;

  void initState(BuildContext context) {}

  void dispose() {
    lgoFilterController?.dispose();
  }

  static selectLangues() {
    List<Map> listLangues = [
      {"name": "Afrikaans", "niveau": 0},
      {"name": "Albanais", "niveau": 0},
      {"name": "Allemand", "niveau": 0},
      {"name": "Amharique", "niveau": 0},
      {"name": "Anglais", "niveau": 0},
      {"name": "Arabe", "niveau": 0},
      {"name": "Arménien", "niveau": 0},
      {"name": "Azéri", "niveau": 0},
      {"name": "Basque", "niveau": 0},
      {"name": "Bengali", "niveau": 0},
      {"name": "Biélorusse", "niveau": 0},
      {"name": "Birman", "niveau": 0},
      {"name": "Bosniaque", "niveau": 0},
      {"name": "Bulgare", "niveau": 0},
      {"name": "Catalan", "niveau": 0},
      {"name": "Cebuano", "niveau": 0},
      {"name": "Chichewa", "niveau": 0},
      {"name": "Chinois", "niveau": 0},
      {"name": "Cingalais", "niveau": 0},
      {"name": "Coréen", "niveau": 0},
      {"name": "Corse", "niveau": 0},
      {"name": "Créole", "niveau": 0},
      {"name": "Croate", "niveau": 0},
      {"name": "Danois", "niveau": 0},
      {"name": "Espagnol", "niveau": 0},
      {"name": "Espéranto", "niveau": 0},
      {"name": "Estonien", "niveau": 0},
      {"name": "Finnois", "niveau": 0},
      {"name": "Français", "niveau": 0},
      {"name": "Frison", "niveau": 0},
      {"name": "Galicien", "niveau": 0},
      {"name": "Gallois", "niveau": 0},
      {"name": "Géorgien", "niveau": 0},
      {"name": "Grec", "niveau": 0},
      {"name": "Gujarati", "niveau": 0},
      {"name": "Haoussa", "niveau": 0},
      {"name": "Hawaïen", "niveau": 0},
      {"name": "Hébreu", "niveau": 0},
      {"name": "Hindi", "niveau": 0},
      {"name": "Hmong", "niveau": 0},
      {"name": "Hongrois", "niveau": 0},
      {"name": "Igbo", "niveau": 0},
      {"name": "Indonésien", "niveau": 0},
      {"name": "Irlandais", "niveau": 0},
      {"name": "Islandais", "niveau": 0},
      {"name": "Italien", "niveau": 0},
      {"name": "Japonais", "niveau": 0},
      {"name": "Javanais", "niveau": 0},
      {"name": "Kannada", "niveau": 0},
      {"name": "Kazakh", "niveau": 0},
      {"name": "Khmer", "niveau": 0},
      {"name": "Kirghize", "niveau": 0},
      {"name": "Kirundi", "niveau": 0},
      {"name": "Kinyarwanda", "niveau": 0},
      {"name": "Kurde", "niveau": 0},
      {"name": "Laotien", "niveau": 0},
      {"name": "Latin", "niveau": 0},
      {"name": "Letton", "niveau": 0},
      {"name": "Lituanien", "niveau": 0},
      {"name": "Luxembourgeois", "niveau": 0},
      {"name": "Macédonien", "niveau": 0},
      {"name": "Malais", "niveau": 0},
      {"name": "Malayalam", "niveau": 0},
      {"name": "Malgache", "niveau": 0},
      {"name": "Maltais", "niveau": 0},
      {"name": "Maori", "niveau": 0},
      {"name": "Marathi", "niveau": 0},
      {"name": "Mongol", "niveau": 0},
      {"name": "Néerlandais", "niveau": 0},
      {"name": "Népalais", "niveau": 0},
      {"name": "Norvégien", "niveau": 0},
      {"name": "Ouzbek", "niveau": 0},
      {"name": "Pachtô", "niveau": 0},
      {"name": "Panjabi", "niveau": 0},
      {"name": "Persan", "niveau": 0},
      {"name": "Polonais", "niveau": 0},
      {"name": "Portugais", "niveau": 0},
      {"name": "Roumain", "niveau": 0},
      {"name": "Russe", "niveau": 0},
      {"name": "Samoan", "niveau": 0},
      {"name": "Serbe", "niveau": 0},
      {"name": "Sesotho", "niveau": 0},
      {"name": "Shona", "niveau": 0},
      {"name": "Sindhi", "niveau": 0},
      {"name": "Slovaque", "niveau": 0},
      {"name": "Slovène", "niveau": 0},
      {"name": "Somali", "niveau": 0},
      {"name": "Sotho du Sud", "niveau": 0},
      {"name": "Soundanais", "niveau": 0},
      {"name": "Suédois", "niveau": 0},
      {"name": "Swahili", "niveau": 0},
      {"name": "Tadjik", "niveau": 0},
      {"name": "Tagalog", "niveau": 0},
      {"name": "Tamoul", "niveau": 0},
      {"name": "Tchèque", "niveau": 0},
      {"name": "Telugu", "niveau": 0},
      {"name": "Thaï", "niveau": 0},
      {"name": "Turc", "niveau": 0},
      {"name": "Ukrainien", "niveau": 0},
      {"name": "Urdu", "niveau": 0},
      {"name": "Vietnamien", "niveau": 0},
      {"name": "Xhosa", "niveau": 0},
      {"name": "Yiddish", "niveau": 0},
      {"name": "Yorouba", "niveau": 0},
      {"name": "Zoulou", "niveau": 0},
    ];

    return listLangues.toList();
  }

  /// Additional helper methods are added here.
}
