import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gestobjetapp/features/inventory/data/models/objet_model.dart';
import 'package:gestobjetapp/features/inventory/data/repositories/objet_controller.dart';
import 'package:gestobjetapp/features/inventory/data/models/type_model.dart';
import 'package:gestobjetapp/features/inventory/data/repositories/type_controller.dart';


class InventoryNotifier extends ChangeNotifier {
  final ObjetRepository _objetRepository;
  final TypeRepository _typeRepository;

  bool isLoading = false;
  bool isModify = false;
  bool isCreatingType = false;
  String? errorMessage;
  List<Objet>? objets;
  String salleId;
  List<Type>? types;
  Type? newType;

  InventoryNotifier(this._objetRepository,this._typeRepository,this.salleId);

  Future<bool> createObjet(String qrCode, String typeId, String salleId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _objetRepository.postObjet(qrCode, typeId, salleId);
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
      objets = await _objetRepository.getObjetBySalle(salleId);

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
      await _objetRepository.deleteObjet(objetId);
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

  Future<bool> getAllType() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      types = await _typeRepository.getAllType();
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
  Future<Type?> createType(String type) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      newType = await _typeRepository.createType(type);
      print(newType);
      isLoading = false;
      notifyListeners();
      return newType;
    } catch(e) {
      print(e);
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  void toggleModifyMode() {
    isModify = !isModify;
    notifyListeners();
  }
  void toggleCreateType() {
    isCreatingType = !isCreatingType;
    notifyListeners();
  }
}
