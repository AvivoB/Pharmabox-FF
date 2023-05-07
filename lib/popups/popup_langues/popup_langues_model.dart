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
          {"name": "Afrikaans"},
          {"name": "Albanais"},
          {"name": "Allemand"},
          {"name": "Amharique"},
          {"name": "Anglais"},
          {"name": "Arabe"},
          {"name": "Arménien"},
          {"name": "Azéri"},
          {"name": "Basque"},
          {"name": "Bengali"},
          {"name": "Biélorusse"},
          {"name": "Birman"},
          {"name": "Bosniaque"},
          {"name": "Bulgare"},
          {"name": "Catalan"},
          {"name": "Cebuano"},
          {"name": "Chichewa"},
          {"name": "Chinois"},
          {"name": "Cingalais"},
          {"name": "Coréen"},
          {"name": "Corse"},
          {"name": "Créole"},
          {"name": "Croate"},
          {"name": "Danois"},
          {"name": "Espagnol"},
          {"name": "Espéranto"},
          {"name": "Estonien"},
          {"name": "Finnois"},
          {"name": "Français"},
          {"name": "Frison"},
          {"name": "Galicien"},
          {"name": "Gallois"},
          {"name": "Géorgien"},
          {"name": "Grec"},
          {"name": "Gujarati"},
          {"name": "Haoussa"},
          {"name": "Hawaïen"},
          {"name": "Hébreu"},
          {"name": "Hindi"},
          {"name": "Hmong"},
          {"name": "Hongrois"},
          {"name": "Igbo"},
          {"name": "Indonésien"},
          {"name": "Irlandais"},
          {"name": "Islandais"},
          {"name": "Italien"},
          {"name": "Japonais"},
          {"name": "Javanais"},
          {"name": "Kannada"},
          {"name": "Kazakh"},
          {"name": "Khmer"},
          {"name": "Kirghize"},
          {"name": "Kirundi"},
          {"name": "Kinyarwanda"},
          {"name": "Kurde"},
          {"name": "Laotien"},
          {"name": "Latin"},
          {"name": "Letton"},
          {"name": "Lituanien"},
          {"name": "Luxembourgeois"},
          {"name": "Macédonien"},
          {"name": "Malais"},
          {"name": "Malayalam"},
          {"name": "Malgache"},
          {"name": "Maltais"},
          {"name": "Maori"},
          {"name": "Marathi"},
          {"name": "Mongol"},
          {"name": "Néerlandais"},
          {"name": "Népalais"},
          {"name": "Norvégien"},
          {"name": "Ouzbek"},
          {"name": "Pachtô"},
          {"name": "Panjabi"},
          {"name": "Persan"},
          {"name": "Polonais"},
          {"name": "Portugais"},
          {"name": "Roumain"},
          {"name": "Russe"},
          {"name": "Samoan"},
          {"name": "Serbe"},
          {"name": "Sesotho"},
          {"name": "Shona"},
          {"name": "Sindhi"},
          {"name": "Slovaque"},
          {"name": "Slovène"},
          {"name": "Somali"},
          {"name": "Sotho du Sud"},
          {"name": "Soundanais"},
          {"name": "Suédois"},
          {"name": "Swahili"},
          {"name": "Tadjik"},
          {"name": "Tagalog"},
          {"name": "Tamoul"},
          {"name": "Tchèque"},
          {"name": "Telugu"},
          {"name": "Thaï"},
          {"name": "Turc"},
          {"name": "Ukrainien"},
          {"name": "Urdu"},
          {"name": "Vietnamien"},
          {"name": "Xhosa"},
          {"name": "Yiddish"},
          {"name": "Yorouba"},
          {"name": "Zoulou"}
        ];

    return listLangues.toList(


    );
  }

  /// Additional helper methods are added here.

}
