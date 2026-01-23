import 'package:gestobjetapp/core/services/api_client.dart';
import 'package:gestobjetapp/features/inventory/data/models/objet_model.dart';
import 'package:gestobjetapp/features/locations/data/models/salle_model.dart';


class ObjetRepository {
  final ApiClient _apiClient;

  ObjetRepository(this._apiClient);

  Future<Salle> getSalle(String ObjetId) async {
    final response = await _apiClient.get('/objet/$ObjetId/salle');
    print(response);
    return  Salle.fromJson(response[0] as Map<String, dynamic>);
  }
}
