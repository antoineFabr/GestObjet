import 'package:gestobjetapp/core/services/api_client.dart';
import 'package:gestobjetapp/features/locations/data/models/salle_model.dart';

class SalleRepository {
  final ApiClient _apiClient;

  SalleRepository(this._apiClient);

  Future<List<Salle>> getAllSalle() async {
    final response = await _apiClient.get('/salle/');
    return (response as List)
        .map((data) => Salle.fromJson(data as Map<String, dynamic>))
        .toList();
  }
}