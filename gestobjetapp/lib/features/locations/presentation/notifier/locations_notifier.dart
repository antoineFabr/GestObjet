import 'package:flutter/material.dart';
import 'package:gestobjetapp/features/locations/data/models/salle_model.dart';
import 'package:gestobjetapp/features/locations/data/repositories/salle_controller.dart';

class LocationsNotifier extends ChangeNotifier {
  final SalleRepository _salleRepository;

  bool isLoading = false;
  String? errorMessage;
  List<Salle>? salles;
  
  LocationsNotifier(this._salleRepository);

  Future<bool> getAllSalle() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      salles = await _salleRepository.getAllSalle();
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
}