import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gestobjetapp/features/inventory/data/models/objet_model.dart';
import 'package:gestobjetapp/features/scanner/data/repository/scanner_repository.dart';


class ScannerNotifier extends ChangeNotifier {

  ScannerRepository _scannerRepository;
  bool isLoading = false;
  bool findQrCode = false;
  String? errorMessage;
  String salleId;
  List<Objet>? objets;
  List<Objet> objetsScan = [];
  ScannerNotifier(this._scannerRepository,this.salleId);

  Future<bool> scanObjet(String id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      Objet objet = await _scannerRepository.verifyObjet(id);
      objetsScan.add(objet);
      isLoading = false;
      notifyListeners();
      return true;
    } catch(e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<List<List<Objet>>> checkObjet() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    objets = await _scannerRepository.getObjetBySalle(salleId);
    List<List<Objet>> wrongObjets = _scannerRepository.CheckSalle(objets!, objetsScan);
    return wrongObjets;

  //TODO Afficher la réponse de la méthode

  }
  void toggleFindQrCode() {
    findQrCode = !findQrCode;
    notifyListeners();
  }
}