import 'package:flutter/material.dart';
import 'package:gestobjetapp/features/locations/data/repositories/salle_controller.dart';
import 'package:gestobjetapp/features/locations/presentation/widgets/salle_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Salle>> futureSalles;
  @override
  void initState() {
    super.initState();
    futureSalles = getAllSalle();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Salle>>(
      future: futureSalles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print('snapshot.data = ${snapshot.data}');
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('erreur : ${snapshot.error}');

          return Center(
            child: Text('Impossible de récupérer les informations'),
          );
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          print('snapshot.data = ${snapshot.data}');
          return const Center(child: Text('Aucune salle dispo'));
        } else {
          List<Salle> salles = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  // 1. Ajoute de l'espace tout autour de la liste (haut, bas, gauche, droite)
                  padding: const EdgeInsets.all(20),

                  itemCount: salles.length,

                  // 2. Ajoute de l'espace entre chaque carte (ici 20 pixels verticalement)
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),

                  itemBuilder: (context, index) {
                    final salle = salles[index];
                    // 3. Center permet de centrer votre carte de 300px au milieu de l'écran
                    return Center(child: SalleWidget(salle));
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
