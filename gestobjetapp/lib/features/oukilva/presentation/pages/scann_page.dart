import 'package:flutter/material.dart';
import 'package:gestobjetapp/features/oukilva/presentation/notifier/oukilva_notifier.dart';
import 'package:gestobjetapp/features/oukilva/data/repositories/objet_repository.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:gestobjetapp/core/services/api_client.dart';
import 'package:provider/provider.dart';
import 'package:gestobjetapp/features/oukilva/presentation/pages/oukilva_page.dart';


class ScanningPage extends StatefulWidget {
  const ScanningPage({super.key});

  static Widget wrapped() { 
    return ChangeNotifierProvider(
      create: (context) => OukilvaNotifier(ObjetRepository(ApiClient())),
      child: ScanningPage()
    );
  }
  @override
  State<ScanningPage> createState() => _ScanningPageState();
}

class _ScanningPageState extends State<ScanningPage> {
  // 1. Un verrou pour empêcher le scanner de lancer 50 requêtes à la seconde
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    // Note : On retire le 'watch' ici car on n'a pas besoin de reconstruire 
    // toute la page quand l'état change, on veut juste lire l'état au moment du scan.

    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) async {
              // 2. Si on est déjà en train de traiter un code, on arrête tout de suite
              if (_isProcessing) return;

              final List<Barcode> barcodes = capture.barcodes;

              for (final barcode in barcodes) {
                final String? code = barcode.rawValue;
                if (code == null) continue;

                // 3. On verrouille le scanner
                setState(() {
                  _isProcessing = true;
                });
                
                HapticFeedback.mediumImpact();
                print("Code détecté : $code");

                // 4. On fait l'appel API
                // Important : Utiliser context.read (pas watch) dans une callback
                final notifier = context.read<OukilvaNotifier>();
                final success = await notifier.getSalle(code);

                // 5. Vérifier si le widget est toujours actif après le await
                if (!mounted) return;

                if (success) {
                  // 6. ICI est la correction majeure :
                  // On relit la valeur fraîche directement depuis le notifier qu'on a lu plus haut
                  // ou via context.read() à nouveau.
                  final salleTrouvee = notifier.salle;

                  if (salleTrouvee != null) {
                    // On navigue
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OukilvaPage(
                          numeroSalle: salleTrouvee.numero
                        ),
                      ),
                    );
                  }
                } else {
                    // Optionnel : Afficher une erreur (SnackBar)
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Salle non trouvée ou erreur réseau"))
                    );
                }

                // 7. On déverrouille pour permettre un nouveau scan (après le retour de la page)
                if (mounted) {
                  setState(() {
                    _isProcessing = false;
                  });
                }
                
                // On break pour ne prendre que le premier code de la liste
                break;
              }
            },
          ),
          
          // Optionnel : Un petit indicateur de chargement visuel
          if (_isProcessing)
             Container(
               color: Colors.black54,
               child: const Center(child: CircularProgressIndicator()),
             ),
        ],
      ),
    );
  }
}