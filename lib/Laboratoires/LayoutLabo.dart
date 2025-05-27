import 'package:flutter/material.dart';
import 'package:pharmabox/Laboratoires/LoginLabo.dart';
import 'package:pharmabox/Laboratoires/RegisterLabo.dart';

class LayoutLabo extends StatelessWidget {
  final Widget child;
  final String title;
  
  const LayoutLabo({
    Key? key,
    required this.child,
    this.title = 'Laboratoire',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Text(
                'Pharmabox',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Accueil'),
              onTap: () {
                Navigator.pop(context);
                // Add navigation to home page
              },
            ),
            ListTile(
              leading: const Icon(Icons.science),
              title: const Text('Laboratoires'),
              onTap: () {
                Navigator.pop(context);
                // Add navigation to laboratories page
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Paramètres'),
              onTap: () {
                Navigator.pop(context);
                // Add navigation to settings page
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: RegisterLabo(),
      ),
    );
  }
}