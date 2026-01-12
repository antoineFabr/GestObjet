import 'package:gestobjetapp/core/services/api_client.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gestobjetapp/features/inventory/data/models/objet_model.dart';


class ObjetRepository {
  final ApiClient _apiClient;

  ObjetRepository(this._apiClient);

  Future<List<Objet>> getObjetBySalle(String id) async {
    final response = await _apiClient.get('/salle/$id/objets');
    
    

    return (response as List)
        .map((data) => Objet.fromJson(data as Map<String, dynamic>))
        .toList();
  }

  Future<void> postObjet(
    String qrCode,
    String typeId,
    String salleId,
  ) async {
    final response = await _apiClient.post(
      '/objet/',
      body: {'qrCode': qrCode, 'type': typeId, 'salles': salleId},
    );
  }

  Future<void> deleteObjet(String objetId) async {
    final response = await _apiClient.delete('/objet/$objetId');
  }
}
