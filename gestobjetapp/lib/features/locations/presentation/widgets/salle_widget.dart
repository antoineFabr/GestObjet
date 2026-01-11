import 'package:flutter/material.dart';
import 'package:gestobjetapp/features/locations/data/repositories/salle_controller.dart';
import 'package:gestobjetapp/features/inventory/presentation/pages/objet_page.dart';

class SalleWidget extends StatelessWidget {
  final Salle salle;
  const SalleWidget(this.salle, {super.key});

  @override
  Widget build(BuildContext context) {
    // Utilisation de Material pour gérer correctement l'élévation et l'effet 'InkWell'
    return Material(
      elevation: 8, // Ombre portée pour donner du relief
      borderRadius: BorderRadius.circular(24), // Bords très arrondis
      color: Colors.transparent, // Nécessaire pour voir le dégradé du Container
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => ObjetPage(SalleId: salle.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(24),
        splashColor: Colors.white24, // Effet de clique plus subtil
        child: Ink(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            // Un dégradé est souvent plus joli qu'une couleur unie
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF673AB7), // DeepPurple
                Color(0xFF9575CD), // DeepPurple[300] plus clair
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icône décorative
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.door_back_door_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // Numéro de la salle
              Text(
                "Salle ${salle.numero}",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              // Nom du bâtiment (Badge)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Bâtiment ${salle.batiment}",
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
