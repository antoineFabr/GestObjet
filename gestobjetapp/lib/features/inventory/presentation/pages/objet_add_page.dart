import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gestobjetapp/features/inventory/data/repositories/type_controller.dart';
import 'package:gestobjetapp/features/inventory/data/repositories/objet_controller.dart';
import 'package:gestobjetapp/features/inventory/data/models/objet_model.dart';
import 'package:gestobjetapp/features/inventory/presentation/notifiers/inventory_notifier.dart';

class ObjetAddPage extends StatefulWidget {
  final String SalleId;

  const ObjetAddPage({super.key, required this.SalleId});

  @override
  State<ObjetAddPage> createState() => _ObjetAddPageState();
}

class _ObjetAddPageState extends State<ObjetAddPage> {
  final _formKey = GlobalKey<FormState>();
  late Future<List<Type>> futureType;
  Map<String, String> listLibelles = {};
  String? _qrCode;
  String? selectedType;
  @override
  void initState() {
    super.initState();
    futureType = getAllType(); // TODO: a changer par nouvel api call
    futureType.then((list) {
      if (mounted) {
        setState(() {
          listLibelles = {for (var obj in list) obj.libelle: obj.id};
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final inventoryNotifier = context.watch<InventoryNotifier>();
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
                items: listLibelles.keys.map((String label) {
                  return DropdownMenuItem<String>(
                    value: listLibelles[label],
                    child: Text(label),
                  );
                }).toList(),

                // La logique quand on sélectionne un élément
                onChanged: (String? newValue) {
                  setState(() {
                    selectedType = newValue;
                  });
                },

                // Validation : Oblige l'utilisateur à choisir un type
                validator: (value) =>
                    value == null ? "Veuillez choisir un type" : null,
              ),
              const SizedBox(height: 20), // Espace entre le champ et le bouton

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
                    final success = await context
                        .read<InventoryNotifier>()
                        .createObjet(_qrCode!, selectedType!, widget.SalleId);
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
