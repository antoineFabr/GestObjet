import 'package:flutter/material.dart';
import 'package:gestobjetapp/core/services/api_client.dart';
import 'package:gestobjetapp/features/inventory/data/repositories/type_controller.dart';
import 'package:provider/provider.dart';
import 'package:gestobjetapp/features/inventory/data/repositories/objet_controller.dart';
import 'package:gestobjetapp/features/inventory/presentation/notifiers/inventory_notifier.dart';
import 'package:gestobjetapp/features/inventory/data/models/objet_model.dart';
import 'package:gestobjetapp/features/inventory/presentation/widgets/objet_filter_widget.dart';
import 'package:gestobjetapp/features/inventory/presentation/pages/objet_add_page.dart';
import 'package:gestobjetapp/features/inventory/presentation/widgets/objet_modify_widget.dart';

class ObjetPage extends StatefulWidget {
  final String SalleId;
  const ObjetPage({super.key, required this.SalleId});

  static Widget wrapped({ required String salleId}) {
    return ChangeNotifierProvider(
      create: (context) => InventoryNotifier(ObjetRepository(ApiClient()),TypeRepository(ApiClient()),salleId),
      child: ObjetPage(SalleId: salleId,)
    );
  }
  @override
  State<ObjetPage> createState() => _ObjetPageState();
}

class _ObjetPageState extends State<ObjetPage> {
  late Future<List<Objet>> futureObjets;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
       context.read<InventoryNotifier>().getObjetBySalle(widget.SalleId);
    }
    });
  }

  Widget build(BuildContext context) {
    final inventoryNotifier = context.watch<InventoryNotifier>();
  
   return Scaffold(
      appBar: AppBar(title: const Text("Objets de la salle")),
      body: Builder(
        builder: (context) {

          if (inventoryNotifier.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Cas : Erreur
          if (inventoryNotifier.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Erreur: ${inventoryNotifier.errorMessage}"),
                  ElevatedButton(
                    onPressed: () => context.read<InventoryNotifier>().getObjetBySalle(widget.SalleId),
                    child: const Text("Réessayer"),
                  )
                ],
              ),
            );
          }
          // 4. Cas : Affichage des données
          
          return Column(
            children: [
              if (inventoryNotifier.objets!.isEmpty) 
                const Expanded( // J'ajoute Expanded pour que le message soit bien centré au milieu de l'écran
                  child: Center(
                    child: Text("Aucun objet trouvé dans cette salle."),
                  ),
                )
              else 

                Expanded(
                  child: Selector<InventoryNotifier,bool>(
                    selector: (context, notifier) => notifier.isModify,
                    builder: (context, isModifyMode, child) {
                      final listeObjets = context.read<InventoryNotifier>().objets;
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),

                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                        child: isModifyMode
                          ? ObjetModifyWidget(
                            key: const ValueKey('ModifyWidget'),
                            objets: listeObjets!,
                          ) 
                          : ObjetFilterWidget(
                              key: const ValueKey("FilterWidget"),
                              objets: listeObjets!,
                          )
                      );
                    
                    }
                  )
                ),
              
              // Vos boutons d'action
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.check),
                      label: const Text("Vérifier"),
                    ),
                    TextButton.icon(
                      onPressed: () {
                         Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return ChangeNotifierProvider.value(
                                value: inventoryNotifier,
                                child: ObjetAddPage(SalleId: widget.SalleId),
                              );
                            }
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Ajouter"),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        context.read<InventoryNotifier>().toggleModifyMode();
                      },
                      icon: context.read<InventoryNotifier>().isModify ? const Icon(Icons.close): const Icon(Icons.edit),
                      label: context.read<InventoryNotifier>().isModify ? const Text("Annuler") : const Text("Modifier"),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
