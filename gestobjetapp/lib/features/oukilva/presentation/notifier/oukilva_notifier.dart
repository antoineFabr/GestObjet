import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gestobjetapp/features/locations/data/models/salle_model.dart';
import 'package:gestobjetapp/features/oukilva/data/repositories/objet_repository.dart';


class OukilvaNotifier extends ChangeNotifier {
  final ObjetRepository _objetRepository;

  bool isLoading = false;
  String? errorMessage;
  Salle? salle;
  

  OukilvaNotifier(this._objetRepository);

  Future<bool> getSalle(String objetId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      salle = await _objetRepository.getSalle(objetId);
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
}