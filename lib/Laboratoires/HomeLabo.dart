import 'package:flutter/material.dart';

class HomeLabo extends StatefulWidget {
  const HomeLabo({Key? key}) : super(key: key);

  @override
  State<HomeLabo> createState() => _HomeLaboState();
}

class _HomeLaboState extends State<HomeLabo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laboratoires'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bienvenue dans votre espace Laboratoire',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildMenuCard(
                    context,
                    'Produits',
                    Icons.medication,
                    () {
                      // Navigation vers la page des produits
                    },
                  ),
                  _buildMenuCard(
                    context,
                    'Commandes',
                    Icons.shopping_cart,
                    () {
                      // Navigation vers la page des commandes
                    },
                  ),
                  _buildMenuCard(
                    context,
                    'Statistiques',
                    Icons.bar_chart,
                    () {
                      // Navigation vers la page des statistiques
                    },
                  ),
                  _buildMenuCard(
                    context,
                    'Profil',
                    Icons.person,
                    () {
                      // Navigation vers la page de profil
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}