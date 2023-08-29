import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PopupGroupementModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this component.

  // State field(s) for GroupementFilter widget.
  TextEditingController? groupementFilterController;
  String? Function(BuildContext, String?)? groupementFilterControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    groupementFilterController?.dispose();
  }

  /// Additional helper methods are added here.

  static selectGroupement() {
    List<Map> listGroupement = [
      {"name": "Aucun groupement", "image": "Aucun.jpg"},
      {"name": "Aelia", "image": "Aelia.jpg"},
      {"name": "Agir Pharma", "image": "Agir Pharma.jpg"},
      {"name": "AGPF", "image": "AGPF.jpg"},
      {"name": "Alphega Pharmacie", "image": "Alphega Pharmacie.jpg"},
      {"name": "Altapharm", "image": "Altapharm.jpg"},
      {"name": "Anton & Willem", "image": "Anton & Willem.jpg"},
      {"name": "APM", "image": "APM.jpg"},
      {"name": "Apothicoop", "image": "Apothicoop.jpg"},
      {"name": "Aprium Pharmacie", "image": "Aprium Pharmacie.jpg"},
      {"name": "Apsara", "image": "Apsara.jpg"},
      {"name": "Aptiphar", "image": "Aptiphar.jpg"},
      {"name": "Boticinal", "image": "Boticinal.jpg"},
      {"name": "Bretagne Santé Référence", "image": "Bretagne Santé Référence.jpg"},
      {"name": "CABG Pharmacie", "image": "CABG Pharmacie.jpg"},
      {"name": "Cali Pharma", "image": "Cali Pharma.jpg"},
      {"name": "Cap’Unipharm", "image": "Cap’Unipharm.jpg"},
      {"name": "Ceido", "image": "Ceido.jpg"},
      {"name": "Centrale des Pharmaciens - Astera", "image": "Centrale des Pharmaciens - Astera.jpg"},
      {"name": "Cofisanté", "image": "Cofisanté.jpg"},
      {"name": "Directlabo", "image": "Directlabo.jpg"},
      {"name": "DPGS", "image": "DPGS.jpg"},
      {"name": "Dynamis", "image": "Dynamis.jpg"},
      {"name": "Dynaphar", "image": "Dynaphar.jpg"},
      {"name": "Elitpharma", "image": "Elitpharma.jpg"},
      {"name": "Elsie Groupe", "image": "Elsie Groupe.jpg"},
      {"name": "Escale Santé", "image": "Escale Santé.jpg"},
      {"name": "Evolupharm", "image": "Evolupharm.jpg"},
      {"name": "Excel Pharma", "image": "Excel Pharma.jpg"},
      {"name": "ExpansionPharma", "image": "ExpansionPharma.jpg"},
      {"name": "Familia", "image": "Familia.jpg"},
      {"name": "Farmax", "image": "Farmax.jpg"},
      {"name": "Forum Santé", "image": "Forum Santé.jpg"},
      {"name": "G-Pharm", "image": "G-Pharm.jpg"},
      {"name": "G1000-Pharma", "image": "G1000-Pharma.jpg"},
      {"name": "Giphar", "image": "Giphar.jpg"},
      {"name": "Giropharm", "image": "Giropharm.jpg"},
      {"name": "Global Pharmacie", "image": "Global Pharmacie.jpg"},
      {"name": "Grap", "image": "Grap.jpg"},
      {"name": "Gripamel Pro Santé", "image": "Gripamel Pro Santé.jpg"},
      {"name": "Groupe Rocade", "image": "Groupe Rocade.jpg"},
      {"name": "Groupe Univers Pharmacie", "image": "Groupe Univers Pharmacie.jpg"},
      {"name": "Hello Pharmacie", "image": "Hello Pharmacie.jpg"},
      {"name": "HexaPharm", "image": "HexaPharm.jpg"},
      {"name": "HPI Totum", "image": "HPI Totum.jpg"},
      {"name": "IFMO", "image": "IFMO.jpg"},
      {"name": "iPharm", "image": "iPharm.jpg"},
      {"name": "Leadersanté", "image": "Leadersanté.jpg"},
      {"name": "Les Nouvelles Pharmacies", "image": "Les Nouvelles Pharmacies.jpg"},
      {"name": "Les Pharmaciens Associés", "image": "Les Pharmaciens Associés.jpg"},
      {"name": "Les pharmaciens d’Armor", "image": "Les pharmaciens d’Armor.jpg"},
      {"name": "Les Pharmaciens Unis", "image": "Les Pharmaciens Unis.jpg"},
      {"name": "Mediprix", "image": "Mediprix.jpg"},
      {"name": "Multipharma", "image": "Multipharma.jpg"},
      {"name": "Mutualpharm", "image": "Mutualpharm.jpg"},
      {"name": "Népenthès", "image": "Népenthès.jpg"},
      {"name": "Norpharma", "image": "Norpharma.jpg"},
      {"name": "Objectif Pharma", "image": "Objectif Pharma.jpg"},
      {"name": "OmnesPharma", "image": "OmnesPharma.jpg"},
      {"name": "Optipharm", "image": "Optipharm.jpg"},
      {"name": "OriginSanté", "image": "OriginSanté.jpg"},
      {"name": "Ospharea", "image": "Ospharea.jpg"},
      {"name": "Oté Pharma", "image": "Oté Pharma.jpg"},
      {"name": "Paraph", "image": "Paraph.jpg"},
      {"name": "Paris Pharma", "image": "Paris Pharma.jpg"},
      {"name": "Pharm & Price", "image": "Pharm & Price.jpg"},
      {"name": "Pharm & You", "image": "Pharm & You.jpg"},
      {"name": "Pharm Avenir", "image": "Pharm Avenir.jpg"},
      {"name": "Pharm O’naturel", "image": "Pharm O’naturel.jpg"},
      {"name": "Pharm-Upp", "image": "Pharm-Upp.jpg"},
      {"name": "Pharm'Indep", "image": "Pharm'Indep.jpg"},
      {"name": "Pharm&Free", "image": "Pharm&Free.jpg"},
      {"name": "Pharma 10", "image": "Pharma 10.jpg"},
      {"name": "Pharma Direct", "image": "Pharma Direct.jpg"},
      {"name": "Pharma XV", "image": "Pharma XV.jpg"},
      {"name": "Pharmabest", "image": "Pharmabest.jpg"},
      {"name": "Pharmacie Lafayette", "image": "Pharmacie Lafayette.jpg"},
      {"name": "Pharmacie Populaire", "image": "Pharmacie Populaire.jpg"},
      {"name": "Pharmacies Le Gall", "image": "Pharmacies Le Gall.jpg"},
      {"name": "PharmaCorp", "image": "PharmaCorp.jpg"},
      {"name": "Pharmactiv", "image": "Pharmactiv.jpg"},
      {"name": "Pharmacyal", "image": "Pharmacyal.jpg"},
      {"name": "Pharmadinina", "image": "Pharmadinina.jpg"},
      {"name": "PharmaGroupSanté", "image": "PharmaGroupSanté.jpg"},
      {"name": "PharmaPlatinum", "image": "PharmaPlatinum.jpg"},
      {"name": "Pharmarket", "image": "Pharmarket.jpg"},
      {"name": "Pharmasud", "image": "Pharmasud.jpg"},
      {"name": "PharmAvance", "image": "PharmAvance.jpg"},
      {"name": "Pharmavie", "image": "Pharmavie.jpg"},
      {"name": "PharmICI", "image": "PharmICI.jpg"},
      {"name": "Pharmodel", "image": "Pharmodel.jpg"},
      {"name": "PHR Référence", "image": "PHR Référence.jpg"},
      {"name": "PUC Pharma", "image": "PUC Pharma.jpg"},
      {"name": "Réseau P&P", "image": "Réseau P&P.jpg"},
      {"name": "Réseau Santé", "image": "Réseau Santé.jpg"},
      {"name": "Resofficine", "image": "Resofficine.jpg"},
      {"name": "Résonor", "image": "Résonor.jpg"},
      {"name": "Simplypharma", "image": "Simplypharma.jpg"},
      {"name": "Socopharm", "image": "Socopharm.jpg"},
      {"name": "SocoPharma", "image": "SocoPharma.jpg"},
      {"name": "Sofiadis", "image": "Sofiadis.jpg"},
      {"name": "Sopharef", "image": "Sopharef.jpg"},
      {"name": "Sud Aquitaine Pharmaceutique", "image": "Sud Aquitaine Pharmaceutique.jpg"},
      {"name": "Sunipharma", "image": "Sunipharma.jpg"},
      {"name": "Suprapharm", "image": "Suprapharm.jpg"},
      {"name": "SynergiPhar", "image": "SynergiPhar.jpg"},
      {"name": "Union des Grandes Pharmacies (UGP)", "image": "Union des Grandes Pharmacies (UGP).jpg"},
      {"name": "Unipharm", "image": "Unipharm.jpg"},
      {"name": "Unipharm 33", "image": "Unipharm 33.jpg"},
      {"name": "Unipharm Loire Océan", "image": "Unipharm Loire Océan.jpg"},
      {"name": "UPIE", "image": "UPIE.jpg"},
      {"name": "Upsem", "image": "Upsem.jpg"},
      {"name": "Vitapharma", "image": "Vitapharma.jpg"},
      {"name": "VPharma", "image": "VPharma.jpg"},
      {"name": "Well&well les Pharmaciens", "image": "Well&well les Pharmaciens.jpg"},
      {"name": "Wellpharma", "image": "Wellpharma.jpg"}
    ];

    return listGroupement;
  }
}
