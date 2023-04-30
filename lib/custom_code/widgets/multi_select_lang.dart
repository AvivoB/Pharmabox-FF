// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Set your widget name, define your parameter, and then add the
// boilerplate code using the button on the right!

class MultiSelectLang extends StatefulWidget {
  const MultiSelectLang({
    Key? key,
    this.width,
    this.height,
    this.action,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Future<dynamic> Function()? action;

  @override
  _MultiSelectLangState createState() => _MultiSelectLangState();
}

class _MultiSelectLangState extends State<MultiSelectLang> {
  List<String> selectedLanguages = [];
  List<String> availableLanguages = [
    "Afrikaans",
    "Albanais",
    "Allemand",
    "Amharique",
    "Anglais",
    "Arabe",
    "Arménien",
    "Azéri",
    "Basque",
    "Bengali",
    "Biélorusse",
    "Birman",
    "Bosniaque",
    "Bulgare",
    "Catalan",
    "Cebuano",
    "Chichewa",
    "Chinois (simplifié)",
    "Chinois (traditionnel)",
    "Cingalais",
    "Coréen",
    "Corse",
    "Créole haïtien",
    "Croate",
    "Danois",
    "Espagnol",
    "Espéranto",
    "Estonien",
    "Finnois",
    "Français",
    "Frison",
    "Gaélique écossais",
    "Galicien",
    "Gallois",
    "Géorgien",
    "Grec",
    "Gujarati",
    "Haoussa",
    "Hawaïen",
    "Hébreu",
    "Hindi",
    "Hmong",
    "Hongrois",
    "Igbo",
    "Indonésien",
    "Irlandais",
    "Islandais",
    "Italien",
    "Japonais",
    "Javanais",
    "Kannada",
    "Kazakh",
    "Khmer",
    "Kirghize",
    "Kirundi",
    "Kinyarwanda",
    "Kurde",
    "Laotien",
    "Latin",
    "Letton",
    "Lituanien",
    "Luxembourgeois",
    "Macédonien",
    "Malais",
    "Malayalam",
    "Malgache",
    "Maltais",
    "Maori",
    "Marathi",
    "Mongol",
    "Néerlandais",
    "Népalais",
    "Norvégien",
    "Ouzbek",
    "Pachtô",
    "Panjabi",
    "Persan",
    "Polonais",
    "Portugais",
    "Roumain",
    "Russe",
    "Samoan",
    "Serbe",
    "Sesotho",
    "Shona",
    "Sindhi",
    "Slovaque",
    "Slovène",
    "Somali",
    "Sotho du Sud",
    "Soundanais",
    "Suédois",
    "Swahili",
    "Tadjik",
    "Tagalog",
    "Tamoul",
    "Tchèque",
    "Telugu",
    "Thaï",
    "Turc",
    "Ukrainien",
    "Urdu",
    "Vietnamien",
    "Xhosa",
    "Yiddish",
    "Yorouba",
    "Zoulou"
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: availableLanguages.length,
              itemBuilder: (BuildContext context, int index) {
                String language = availableLanguages[index];
                return CheckboxListTile(
                  title: Text(language),
                  value: selectedLanguages.contains(language),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value!) {
                        selectedLanguages.add(language);
                        FFAppState().listLangRegister.add(language);
                      } else {
                        selectedLanguages.remove(language);
                        FFAppState().listLangRegister.remove(language);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
