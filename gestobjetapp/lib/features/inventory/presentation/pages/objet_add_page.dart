import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gestobjetapp/features/inventory/presentation/notifiers/inventory_notifier.dart';

class ObjetAddPage extends StatefulWidget {
  final String SalleId;

  const ObjetAddPage({super.key, required this.SalleId});

  @override
  State<ObjetAddPage> createState() => _ObjetAddPageState();
}

class _ObjetAddPageState extends State<ObjetAddPage> {
  final _formKey = GlobalKey<FormState>();
  Map<String, String> listLibelles = {};
  String? _qrCode;
  String? selectedType;
  String? newType;
  String? type;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<InventoryNotifier>().getAllType();
    });
  }

  @override
  Widget build(BuildContext context) {
    final inventoryNotifier = context.watch<InventoryNotifier>();

    final typesList = inventoryNotifier.types ?? [];
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter un objet")),
      // On ajoute un Padding pour que le formulaire ne colle pas aux bords
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Type d'objet",
                  border: OutlineInputBorder(),
                ),
                value:
                    selectedType, // La valeur actuelle sélectionnée (ID du type)
                hint: const Text("Sélectionnez un type"),

                // On transforme la Map<String, String> en List<DropdownMenuItem>
                items: typesList.map((type) {
                  return DropdownMenuItem<String>(
                    value: type.id, // La valeur stockée (ID)
                    child: Text(type.libelle), // Ce qu'on affiche (Libellé)
                  );
                }).toList(),

                // La logique quand on sélectionne un élément
                onChanged: (String? newValue) {
                  setState(() {
                    selectedType = newValue;
                  });
                },

                // Validation : Oblige l'utilisateur à choisir un type
                validator: (value){
                    if (value == null && !inventoryNotifier.isCreatingType){
                      return "Veuillez choisir un type";
                    } 
                    return null;
                }
              ),

              TextButton.icon(
                onPressed: (){
                  context.read<InventoryNotifier>().toggleCreateType();
                },
                label: inventoryNotifier.isCreatingType ? const Text("Annuler") : const Text("Ajouter un type d'objet"),
                icon: inventoryNotifier.isCreatingType ? const Icon(Icons.close) : const Icon(Icons.add),
                
              ),
              const SizedBox(height: 20),


              if (inventoryNotifier.isCreatingType) 
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Nom du type",
                    border: OutlineInputBorder()
                  ),
                  validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Il faut entrer le type";
                  }
                  return null;
                },
                onChanged: (String? value) {
                  setState(() {
                    newType = value;
                  });
                },
              ),
                
                const SizedBox(height: 20), 
               

              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Code de l'objet", // Ajout d'un label pour l'UX
                  border: OutlineInputBorder(), // Ajout d'une bordure
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Il faut entrer le code de l'objet";
                  }
                  return null;
                },
                onChanged: (String? value) {
                  setState(() {
                    _qrCode = value;
                  });
                },
              ),
              const SizedBox(height: 20), // Espace entre le champ et le bouton
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Création de l'objet"))
                    );
                    type = selectedType;
                    if(context.read<InventoryNotifier>().isCreatingType){
                      final createdType = await context
                          .read<InventoryNotifier>()
                          .createType(newType!);

                      if(createdType != null) {
                        type = createdType.id;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Erreur lors de la création du type"))
                        );
                        return;
                      }
                    }
                    if (type == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Aucun type sélectionné"))
                        );
                        return;
                    }
                    final success = await context
                        .read<InventoryNotifier>()
                        .createObjet(_qrCode!, type!, widget.SalleId);
                    if (success && mounted) {
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Objet créer avec succès !"),
                        ),
                      );
                    } else if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            inventoryNotifier.errorMessage ?? "Erreur",
                          ),
                        ),
                      );
                    }
                  }
                },
                child: inventoryNotifier.isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Ajouter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
