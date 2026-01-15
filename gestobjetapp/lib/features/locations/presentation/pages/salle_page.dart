import 'package:flutter/material.dart';
import 'package:gestobjetapp/core/services/api_client.dart';
import 'package:gestobjetapp/features/locations/data/repositories/salle_controller.dart';
import 'package:gestobjetapp/features/locations/presentation/notifier/locations_notifier.dart';
import 'package:gestobjetapp/features/locations/presentation/widgets/salle_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static Widget wrapped() {
    return ChangeNotifierProvider(
      create: (context) => LocationsNotifier(SalleRepository(ApiClient())),
      child: HomePage(),
    );
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(mounted) {
        context.read<LocationsNotifier>().getAllSalle();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final salleNotifier = context.watch<LocationsNotifier>();
    return Scaffold(
      appBar: AppBar(title: const Text("Salles")),
      body: Builder(
        builder: (context) {
          if (salleNotifier.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Cas : Erreur
          if (salleNotifier.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Erreur: ${salleNotifier.errorMessage}"),
                  ElevatedButton(
                    onPressed: () => context.read<LocationsNotifier>().getAllSalle(),
                    child: const Text("Réessayer"),
                  )
                ],
              ),
            );
          }
          return Column(
            
            children: [
              Expanded(
                
                child: ListView.separated(
                  // 1. Ajoute de l'espace tout autour de la liste (haut, bas, gauche, droite)
                  padding: const EdgeInsets.all(20),
                  itemCount: salleNotifier.salles!.length,
                  // 2. Ajoute de l'espace entre chaque carte (ici 20 pixels verticalement)
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                    final salle = salleNotifier.salles![index];
                    // 3. Center permet de centrer votre carte de 300px au milieu de l'écran
                    return Center(child: SalleWidget(salle));
                  },
                ),
              ),
            ],
          );
        }
      )
    );
  }
}

