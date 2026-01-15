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

    return Objet.fromJson(response as Map<String, dynamic>);
  }

  (List<Objet>,List<Objet>) CheckSalle(List<Objet> objetsPrevus, List<Objet> objetsScannes) {

    final idsPrevus = objetsPrevus.map((e) => e.id).toSet();
    final idsScannes = objetsScannes.map((e) => e.id).toSet();
    
    List<Objet> objetsManquants = [];
    List<Objet> objetsIntrus = [];
    print(idsScannes);
    print(idsPrevus);
    if(idsPrevus.length == idsScannes.length && idsPrevus.containsAll(idsScannes)){
      return (objetsManquants, objetsIntrus);
    }
   
    objetsManquants = objetsPrevus
      .where((objet) => !idsScannes.contains(objet.id))
      .toList();
    print(objetsManquants);
    objetsIntrus = objetsScannes
      .where((objet) => !idsPrevus.contains(objet.id))
      .toList();
    print(objetsIntrus);

    return (objetsManquants, objetsIntrus);

  }
}