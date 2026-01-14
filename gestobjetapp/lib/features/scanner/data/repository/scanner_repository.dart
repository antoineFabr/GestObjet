import 'package:gestobjetapp/core/services/api_client.dart';
import 'package:gestobjetapp/features/inventory/data/models/objet_model.dart';

class ScannerRepository {

  final ApiClient _apiClient;

  ScannerRepository(this._apiClient);

  Future<List<Objet>> getObjetBySalle(String id) async {
    final response = await _apiClient.get('/salle/$id/objets');
    
    

    return (response as List)
        .map((data) => Objet.fromJson(data as Map<String, dynamic>))
        .toList();
  }

  Future<Objet> verifyObjet(String id) async {
    final response = await _apiClient.get('/verify/$id');

    return response.map((data) => Objet.fromJson(data as Map<String, dynamic>));
  }

  String CheckSalle(List<Objet> objets, List<Objet> objetsVerify) {
    if (objets == objetsVerify) {
      return "Tout est là";
    }
    return "Il manque des choses";
  }
}