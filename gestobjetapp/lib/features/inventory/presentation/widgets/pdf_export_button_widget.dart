import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw; // On renomme pour éviter les confusions avec les widgets Flutter
import 'package:printing/printing.dart';
import 'package:gestobjetapp/features/inventory/data/models/objet_model.dart';

class PdfExportButton extends StatelessWidget {
  final List<Objet> objets;

  const PdfExportButton({super.key, required this.objets});

  /// Fonction qui génère le PDF
  Future<void> _generatePdf(BuildContext context) async {
    final pdf = pw.Document();

    // On utilise MultiPage pour gérer automatiquement plusieurs pages si la liste est longue
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32), // Marge de la feuille
        build: (pw.Context context) {
          // GridView pour faire une grille d'étiquettes (3 colonnes)
          return [
            pw.GridView(
              crossAxisCount: 3, // 3 QR codes par ligne
              childAspectRatio: 1, // Carré
              crossAxisSpacing: 10,
              mainAxisSpacing: 20,
              children: objets.map((objet) {
                return _buildQrItem(objet);
              }).toList(),
            )
          ];
        },
      ),
    );

    // Ouvre l'aperçu avant impression/partage
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  /// Design d'une seule étiquette (Nom + QR)
  pw.Widget _buildQrItem(Objet objet) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300), // Petit cadre gris (optionnel)
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          // 1. Le Nom en haut
          pw.Text(
            objet.qrCode,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              fontSize: 12, 
              fontWeight: pw.FontWeight.bold,
            ),
            maxLines: 2,
            overflow: pw.TextOverflow.clip,
          ),
          
          pw.SizedBox(height: 10),

          // 2. Le QR Code
          // Note : Le package 'pdf' a son propre générateur de Barcode vectoriel !
          pw.BarcodeWidget(
            barcode: pw.Barcode.qrCode(),
            data: objet.id, // Les données du QR
            width: 80,
            height: 80,
            drawText: false, // Si on veut afficher le code brut en dessous ou non
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: const Icon(Icons.print),
      label: const Text("Exporter QrCode"),
      
      onPressed: () => _generatePdf(context),
    );
    
  }
}