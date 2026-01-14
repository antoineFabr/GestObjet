import 'package:flutter/material.dart';
import 'package:gestobjetapp/features/scanner/data/repository/scanner_repository.dart';
import 'package:gestobjetapp/features/scanner/presentation/notifier/scanner_notifier.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:gestobjetapp/core/services/api_client.dart';
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
                if (code != null) {
                  // Important : Mettez à jour votre notifier ici pour passer findQrCode à true
                  // scannerNotifier.setQrCodeFound(true); 
                  scannerNotifier.toggleFindQrCode();
                  
                  print('QR Code trouvé ! Contenu : $code');
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
                  onPressed: () {
                    // Action de vérification
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