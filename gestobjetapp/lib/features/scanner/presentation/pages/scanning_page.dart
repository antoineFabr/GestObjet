import 'package:flutter/material.dart';
import 'package:gestobjetapp/features/scanner/data/repository/scanner_repository.dart';
import 'package:gestobjetapp/features/scanner/presentation/notifier/scanner_notifier.dart';
import 'package:gestobjetapp/features/scanner/presentation/pages/result_scanning_page.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:gestobjetapp/core/services/api_client.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


class ScanningPage extends StatefulWidget {
  const ScanningPage({super.key});

  static Widget wrapped({ required String salleId}) { 
    return ChangeNotifierProvider(
      create: (context) => ScannerNotifier(ScannerRepository(ApiClient()), salleId),
      child: ScanningPage()
    );
  }
  @override
  State<ScanningPage> createState() => _ScanningPageState();
}

class _ScanningPageState extends State<ScanningPage> {
  @override
  Widget build(BuildContext context) {
  final scannerNotifier = context.watch<ScannerNotifier>();
    
    final bool isFound = scannerNotifier.findQrCode; 

    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              
              for (final barcode in barcodes) {
                final String? code = barcode.rawValue;

                // Vérification de base
                if (code == null) continue;

                // CAS 1 : L'objet est DÉJÀ dans la liste
                // On veut quand même un feedback visuel pour dire "Je l'ai vu"
                bool alreadyScanned = scannerNotifier.objetsScan.any((obj) => obj.id == code);
                
                if (alreadyScanned) {
                  // On affiche le vert seulement si ce n'est pas déjà vert (pour éviter le clignotement fou)
                  if (!scannerNotifier.findQrCode) {
                    print("Objet déjà scanné : $code");
                    scannerNotifier.toggleFindQrCode();
                    Future.delayed(const Duration(milliseconds: 500), () {
                      scannerNotifier.toggleFindQrCode();
                    });
                  }
                  return; // On arrête là, pas besoin d'appeler l'API
                }

                // CAS 2 : C'est un NOUVEL objet
                if (!scannerNotifier.isLoading) {
                  print("Tentative de scan API pour : $code");
                  
                  scannerNotifier.scanObjet(code).then((success) {
                    if (success) {
                      print("Succès API !");
                      //vibrations du téléphone Quand c'est un nouveau qrCode
                      HapticFeedback.mediumImpact();

                      // Feedback visuel (Succès)
                      if (!scannerNotifier.findQrCode) {
                          scannerNotifier.toggleFindQrCode();
                          Future.delayed(const Duration(seconds: 1), () {
                            scannerNotifier.toggleFindQrCode();
                          });
                      }
                    } else {
                      // L'API a renvoyé false (Erreur)
                      print("Erreur lors du scan API (scanObjet a renvoyé false)");
                      // Idée : Vous pourriez afficher une Snackbar ici pour afficher l'erreur
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Erreur: ${scannerNotifier.errorMessage ?? 'Objet inconnu'}")),
                      );
                    }
                  });
                }
              }
            },
          ),
          IgnorePointer(
            // IgnorePointer est CRUCIAL : il permet aux clics de passer à travers
            // la bordure pour atteindre le scanner ou les boutons derrière.
            ignoring: true, 
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300), 
              decoration: BoxDecoration(
                border: Border.all(
                  
                  color: isFound ? Colors.green : Colors.transparent, 
                  width: 8.0, // Épaisseur de la bordure
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await scannerNotifier.checkObjet();
                    Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return ResultScanningPage(objets_intrus: scannerNotifier.objetsIntrus, objets_manquant: scannerNotifier.objetsManquants,);
                            }
                          ),
                        );
                    
                    print("Bouton vérifier cliqué");
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text(
                    "Vérifier",
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}