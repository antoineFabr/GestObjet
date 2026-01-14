import 'package:flutter/material.dart';
import 'package:gestobjetapp/features/inventory/data/models/objet_model.dart';

class ResultScanningPage extends StatelessWidget {
  final List<Objet> objets_manquant;
  final List<Objet> objets_intrus;

  const ResultScanningPage({
    super.key, 
    required this.objets_intrus, 
    required this.objets_manquant
  });

  @override
  Widget build(BuildContext context) {
    // J'utilise Scaffold c'est plus propre que Material pour une page entière
    return Scaffold(
      appBar: AppBar(title: const Text("Résultat du scan")),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Objet manquant", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const Text("Il manque :"),
          
          // SOLUTION : On enveloppe la ListView dans Expanded
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: objets_manquant.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final objet = objets_manquant[index];
                return Card( // Un peu de style pour mieux voir
                  child: ListTile(
                    title: Text(objet.qrCode ?? "Sans code"),
                    subtitle: Text("Type: ${objet.type?.libelle ?? 'Inconnu'}"),
                    leading: const Icon(Icons.warning, color: Colors.orange),
                  ),
                );
              },
            ),
          ),

          const Divider(thickness: 2), // Une ligne pour séparer les deux zones

          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Objet en trop", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const Text("Il y a en trop :"),

          // SOLUTION : On enveloppe la deuxième ListView dans Expanded aussi
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: objets_intrus.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final objet = objets_intrus[index];
                return Card(
                  child: ListTile(
                    title: Text(objet.qrCode ?? "Sans code"),
                    subtitle: Text("Type: ${objet.type?.libelle ?? 'Inconnu'}"),
                    leading: const Icon(Icons.error_outline, color: Colors.red),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}