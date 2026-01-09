import 'package:flutter/material.dart';

class ObjetAddPage extends StatefulWidget {
  const ObjetAddPage({super.key});

  @override
  State<ObjetAddPage> createState() => _ObjetAddPageState();
}

class _ObjetAddPageState extends State<ObjetAddPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              if(value == null || value.isEmpty) {
                return "Il faut entrer du texte ici";
              }
              return null;
            },
          ),
          ElevatedButton(onPressed: () {
            if (_formKey.currentState!.validate()) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("processing Data")),
              );
            }
          }, child: const Text("Ajouter"))
        ]
      )
    );
  }
}