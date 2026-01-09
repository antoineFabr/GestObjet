import 'package:http/http.dart' as http;
import 'dart:convert';

class Type {
  final String id;
  final String libelle;

  Type({required this.id, required this.libelle});

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(
      id: json['_id'] as String, // Toujours '_id' avec Mongo
      libelle: json['libelle'] as String,
    );
  }
}
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
}
