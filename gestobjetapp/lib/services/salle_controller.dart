import 'dart:convert';
import 'package:http/http.dart' as http;

class Salle {
  final String id;
  final String numero;
  final String batiment;

  const Salle({required this.id, required this.batiment, required this.numero});

  factory Salle.fromJson(Map<String, dynamic> json) {
    return Salle(
      id: json['_id'] as String,
      numero: json['numero'] as String,
      batiment: json['batiment'] as String,
    );
  }
}

const baseUrl = "http://localhost:3333/api";
Future<List<Salle>> getAllSalle() async {
  final response = await http.get(Uri.parse('$baseUrl/salle/'));
  print(response);
  if (response.statusCode == 200) {
    final List<dynamic> jsonBody = jsonDecode(response.body);
    print(jsonBody);
    return jsonBody.map((json) => Salle.fromJson(json)).toList();
  } else {
    print("failed to load salles");

    throw Exception('failed to load Salles');
  }
}

Future<Salle> getSalleById(String id) async {
  final response = await http.get(Uri.parse('$baseUrl/salle/$id'));
  if (response.statusCode == 200) {
    final dynamic body = jsonDecode(response.body);
    return Salle.fromJson(body);
  } else {
    throw Exception('failed to load classes');
  }
}
