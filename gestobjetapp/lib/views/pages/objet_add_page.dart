import 'package:flutter/material.dart';
import 'package:gestobjetapp/services/type_controller.dart';

class ObjetAddPage extends StatefulWidget {
  const ObjetAddPage({super.key});

  @override
  State<ObjetAddPage> createState() => _ObjetAddPageState();
}

class _ObjetAddPageState extends State<ObjetAddPage> {
  final _formKey = GlobalKey<FormState>();
  late Future<List<Type>> futureType;
  List<String> listLibelles = [];
  String? selectedType;
  @override
  void initState() {
    super.initState();
    futureType = getAllType();
    futureType.then((list) {
      if (mounted) {
        setState(() {
          listLibelles = list
            .map((obj) => obj.libelle).toList();
        });
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un objet"),
      ),
      // On ajoute un Padding pour que le formulaire ne colle pas aux bords
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(decoration: const InputDecoration(
                  labelText: "Type d'objet",
                  border: OutlineInputBorder(),
                ),
                value: selectedType, // La valeur actuelle sélectionnée
                hint: const Text("Sélectionnez un type"),
                
                // On transforme la List<String> en List<DropdownMenuItem>
                items: listLibelles.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                
                // La logique quand on sélectionne un élément
                onChanged: (String? newValue) {
                  setState(() {
                    selectedType = newValue;
                  });
                },
                
                // Validation : Oblige l'utilisateur à choisir un type
                validator: (value) => value == null ? "Veuillez choisir un type" : null,
              ),

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
              ),
              const SizedBox(height: 20), // Espace entre le champ et le bouton
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Envoi des données...")),
                    );
                    // Ici, vous mettrez plus tard votre appel API pour créer l'objet
                  }
                },
                child: const Text("Ajouter"),
              )
            ],
          ),
        ),
      ),
    );
  }
}