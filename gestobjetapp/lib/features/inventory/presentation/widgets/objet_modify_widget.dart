import 'package:flutter/material.dart';
import 'package:gestobjetapp/features/inventory/data/models/objet_model.dart';
import 'package:provider/provider.dart'; 
import 'package:gestobjetapp/features/inventory/presentation/notifiers/inventory_notifier.dart';

class ObjetModifyWidget extends StatefulWidget {
  final List<Objet> objets;
  const ObjetModifyWidget({super.key, required this.objets});

  @override
  State<ObjetModifyWidget> createState() => _ObjetModifyWidgetState();
}

class _ObjetModifyWidgetState extends State<ObjetModifyWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView.separated(
        itemCount: widget.objets.length,
        separatorBuilder: (ctx, index) =>
          const Divider(),
        
        itemBuilder: (context, index) {
          final objet = widget.objets[index];
          return ListTile(
            title: Text(objet.qrCode + " | " + objet.type!.libelle),
            trailing: Row(
              mainAxisSize: MainAxisSize.min, 
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                     // Action modifier
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final bool? confirme = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Supprimer l'objet ?"),
                          content: Text("Voulez-vous vraiment supprimer l'objet ${objet.qrCode} ?"),
                          actions: [
                            // Bouton ANNULER : On ferme avec 'false'
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Annuler"),
                            ),
                            // Bouton SUPPRIMER : On ferme avec 'true'
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              style: TextButton.styleFrom(foregroundColor: Colors.red),
                              child: const Text("Supprimer"),
                            ),
                          ],
                        );
                      },
                    );
                    if (confirme == true) {
                    
                    context.read<InventoryNotifier>().deleteObjet(objet.id);
                    
                    print("Objet supprimé !");
    }
                  },
                ),
              ],
            ),
            
            
          );
        },
      ),
    );
  }
}