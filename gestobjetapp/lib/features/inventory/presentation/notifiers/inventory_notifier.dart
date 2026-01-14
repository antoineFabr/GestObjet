import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gestobjetapp/features/inventory/data/models/objet_model.dart';
import 'package:gestobjetapp/features/inventory/data/repositories/objet_controller.dart';

class InventoryNotifier extends ChangeNotifier {
  final ObjetRepository _repository;

  bool isLoading = false;
  bool isModify = false;
  String? errorMessage;
  List<Objet>? objets;
  String salleId;

  InventoryNotifier(this._repository,this.salleId);

  Future<bool> createObjet(String qrCode, String typeId, String salleId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.postObjet(qrCode, typeId, salleId);
      await getObjetBySalle(salleId);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      print(errorMessage);
      notifyListeners();
      return false;
    }
  }

  Future<bool> getObjetBySalle(String salleId) async {
    isLoading = true;

    errorMessage = null;
    notifyListeners();
    try {
      objets = await _repository.getObjetBySalle(salleId);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  Future<bool> deleteObjet(String objetId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _repository.deleteObjet(objetId);
      await getObjetBySalle(salleId);
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

  void toggleModifyMode() {
    isModify = !isModify;
    notifyListeners();
  }
}
