import 'package:flutter/material.dart';

class OukilvaPage extends StatefulWidget {
  // On ajoute une variable pour recevoir le numéro de la salle
  final String numeroSalle;

  const OukilvaPage({
    super.key, 
    required this.numeroSalle
  });

  @override
  State<OukilvaPage> createState() => _OukilvaPageState();
}

class _OukilvaPageState extends State<OukilvaPage> {
  
  // Fonction pour retourner à l'accueil
  void _retourAccueil() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Résultat"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icône décorative
              const Icon(
                Icons.meeting_room_rounded,
                size: 80,
                color: Colors.blueGrey,
              ),
              const SizedBox(height: 30),
              
              // Le texte principal
              const Text(
                "Cet objet va dans la salle :",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
              
              // Affichage dynamique du numéro de salle
              Text(
                widget.numeroSalle, // On accède à la variable du widget
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 50),

              // Bouton retour
              SizedBox(
                width: double.infinity, // Le bouton prend toute la largeur
                height: 50,
                child: ElevatedButton(
                  onPressed: _retourAccueil,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Retour à l'accueil",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}