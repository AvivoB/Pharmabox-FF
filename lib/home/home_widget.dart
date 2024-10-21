import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmabox/composants/header_app/header_app_widget.dart';
import 'package:pharmabox/constant.dart';
import 'package:pharmabox/flutter_flow/flutter_flow_model.dart';
import 'package:pharmabox/flutter_flow/flutter_flow_theme.dart';
import 'package:pharmabox/flutter_flow/flutter_flow_util.dart';
import 'package:pharmabox/flutter_flow/flutter_flow_widgets.dart';
import 'package:pharmabox/home/home_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late HomeModel _model;
  bool isTitulaire = false;
  var userData = '';

  @override
  void initState() {
    super.initState();
    checkIsTitulaire().then((value) {
      setState(() {
        isTitulaire = value;
      });
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              HeaderAppWidget(),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Bonjour, dès aujourd\'hui', style: FlutterFlowTheme.of(context).bodyMedium.override(color: blackColor, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                  Text('Prenez le contrôle de votre réseau', style: FlutterFlowTheme.of(context).bodyMedium.override(color: blackColor, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                  SizedBox(height: 20),
                  ItemAccueil(
                    color1: Color(0xFF7F7FD5),
                    color2: Color(0xFF91EAE4),
                    title: 'Jobs, pour trouver une opportunité',
                    description: 'Déposez une offre ou une recherche d’emploi, définissez les critères qui vous intéressent et trouvez de nouvelles opportunités.',
                    btnText: 'Commencer',
                    icon: Icons.campaign_outlined,
                    onTap: () {
                      context.pushNamed('PharmaJob');
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.43,
                        child: ItemAccueil(
                          color1: Color(0xFFF89999),
                          color2: Color(0xFFFFDEAC),
                          title: 'Annuaire Labo',
                          description: 'La liste de tous les laboratoires avec leurs coordonnées.',
                          btnText: 'Accéder',
                          icon: Icons.sort_outlined,
                          onTap: () {
                            context.pushNamed('Annuaire');
                          },
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.43,
                        child: ItemAccueil(
                          color1: Color(0xFF42D2FF),
                          color2: Color(0xFF42D2FF),
                          title: 'Blabla, discutez',
                          description: 'Prenez part aux discussions et posez vos questions.',
                          btnText: 'Participer',
                          icon: Icons.forum_outlined,
                          onTap: () {
                            context.pushNamed('PharmaBlabla');
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ItemAccueil(
                    color1: blueColor,
                    color2: greenColor,
                    title: 'Mon réseau',
                    description: 'Connectez vous aux autres membres, lancez une discussion privée, gérez vos contacts et parcourez la liste des pharmacies.',
                    btnText: 'Voir mon réseau',
                    icon: Icons.group_outlined,
                    onTap: () {
                      context.pushNamed('Reseau');
                    },
                  ),
                  SizedBox(height: 20),
                  ItemAccueil(
                    color1: blueColor,
                    color2: greyColor,
                    title: 'Gérer mon profil, pour être visible',
                    description: 'Enrichissez votre profil, démontrez vos compétences et faites-vous remarquer. Gérez votre pharmacie pour augmenter sa visibilité, renseignez les informations essentielles.',
                    btnText: 'Mon profil',
                    icon: Icons.account_circle_outlined,
                    onTap: () {
                      context.pushNamed('Profil');
                    },
                    btnText2: 'Ma pharmacie',
                    icon2: Icons.medication_outlined,
                    onTap2: () {
                      context.pushNamed('PharmacieProfil');
                    },
                    isTitulaire: isTitulaire,
                  ),
                  SizedBox(height: 20),
                  ItemAccueil(
                    color1: greenColor,
                    color2: greyColor,
                    title: 'Centre d\'aide',
                    description: 'Retrouvez les réponses à vos questions, consultez les tutoriels et les guides pour vous aider à utiliser l\'application.',
                    btnText: 'Accéder au centre d\'aide',
                    icon: Icons.help_outline,
                    onTap: () {
                      context.pushNamed('HelperCenter');
                    },
                    
                    onTap2: () {
                      
                    },
                    isTitulaire: isTitulaire,
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ItemAccueil extends StatelessWidget {
  final String title;
  final String description;
  final String btnText;
  final IconData icon;
  final Function onTap;
  final Color color1;
  final Color color2;

  final String? btnText2;
  final IconData? icon2;
  final Function? onTap2;

  final bool? isTitulaire;
  const ItemAccueil({
    required this.color1,
    required this.color2,
    required this.title,
    required this.description,
    required this.btnText,
    required this.icon,
    required this.onTap,
    this.btnText2,
    this.icon2,
    this.onTap2,
    this.isTitulaire,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [color1, color2],
          stops: [0, 1],
          begin: AlignmentDirectional(1, -1),
          end: AlignmentDirectional(-1, 1),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x301F5C67),
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                  ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                FFButtonWidget(
                  onPressed: () => onTap(),
                  text: btnText,
                  icon: Icon(icon, color: greyColor),
                  options: FFButtonOptions(
                    color: Colors.white,
                    textStyle: FlutterFlowTheme.of(context).bodyText1.override(
                          color: greyColor,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                    borderSide: BorderSide(color: Colors.transparent, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                // Affichage du deuxième bouton seulement si les valeurs sont définies
                if (btnText2 != null && icon2 != null && onTap2 != null)
                  SizedBox(width: 10), // Espacement entre les deux boutons
                if (btnText2 != null && icon2 != null && onTap2 != null && isTitulaire == true)
                  FFButtonWidget(
                    onPressed: () => onTap2!(),
                    text: btnText2!,
                    icon: Icon(icon2, color: greyColor),
                    options: FFButtonOptions(
                      color: Colors.white,
                      textStyle:
                          FlutterFlowTheme.of(context).bodyText1.override(
                                color: greyColor,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                              ),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

