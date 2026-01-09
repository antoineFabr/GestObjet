import 'package:flutter/material.dart';
import 'package:gestobjetapp/services/objet_controller.dart';

class ObjetFilterWidget extends StatelessWidget {
  final List<Objet> objets;
  const ObjetFilterWidget({super.key, required this.objets});

  Map<String, int> get categories => _filterCategoriesObjet(objets);

   Map<String, int> _filterCategoriesObjet(List<Objet> objects) {
    final  Map<String, int> categories = {};
    for (final e in objects) {
      final lib = e.type?.libelle;
      if (lib != null) {
      // 1. Si 'lib' existe déjà, elle exécute (value) => value + 1
      // 2. Si 'lib' n'existe pas (ifAbsent), elle initialise à 1
      categories.update(lib, (value) => value + 1, ifAbsent: () => 1);
    }
    }
    return categories;
  }
  

  Widget build(BuildContext context) {
    // 1. On transforme la Map en une Liste d'entrées pour pouvoir l'afficher
    // ex: [{'Meuble': 3}, {'Info': 5}]
    final categoryList = categories.entries.toList();

    return Material(
      child: ListView.separated(
        itemCount: categoryList.length,
        separatorBuilder: (ctx, index) => const Divider(), // Ligne entre chaque item
        itemBuilder: (context, index) {
          
          // 2. On récupère la clé (nom) et la valeur (nombre)
          final entry = categoryList[index];
          final String nomCategorie = entry.key;
          final int nombreObjets = entry.value;

          // 3. Affichage
          return ListTile(
            title: Text(nomCategorie),           // Le nom de la catégorie
            trailing: CircleAvatar(              // Un cercle avec le nombre à droite
              radius: 15,
              child: Text(
                nombreObjets.toString(),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}