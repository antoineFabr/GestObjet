import 'package:gestobjetapp/features/inventory/data/models/type_model.dart';
import 'package:gestobjetapp/core/services/api_client.dart';


class TypeRepository {
  final ApiClient _apiClient;

  TypeRepository(this._apiClient);

  Future<List<Type>> getAllType() async {
    final response = await _apiClient.get('/type/');

    return (response as List)
        .map((data) => Type.fromJson(data as Map<String, dynamic>))
        .toList();
  }

}
/*
const baseUrl = "http://localhost:3333/api";
Future<List<Type>> getAllType() async {
  final response = await http.get(Uri.parse('$baseUrl/type/'));
  print(response);
  if (response.statusCode == 200) {
    final List<dynamic> jsonBody = jsonDecode(response.body);
    print(jsonBody);
    return jsonBody.map((json) => Type.fromJson(json)).toList();
  } else {
    print("failed to load salles");

    throw Exception('failed to load Salles');
  }
}*/
