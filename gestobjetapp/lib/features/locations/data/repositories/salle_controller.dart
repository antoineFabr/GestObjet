import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gestobjetapp/features/inventory/data/models/objet_model.dart';

class Salle {
  final String id;
  final String numero;
  final String batiment;
  final List<String> objetsIds;

  const Salle({
    required this.id,
    required this.batiment,
    required this.numero,
    this.objetsIds = const [],
  });

  factory Salle.fromJson(Map<String, dynamic> json) {
    return Salle(
      id: json['_id'] as String,
      numero: json['numero'] as String,
      batiment: json['batiment'] as String,
      objetsIds:
          (json['objets'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
  Salle copyWith({List<String>? objetsIds}) {
    return Salle(
      id: this.id,
      numero: this.numero,
      batiment: this.batiment,
      objetsIds: objetsIds ?? this.objetsIds,
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

Future<List<Objet>> getObjetsBySalleId(String salleId) async {
  final response = await http.get(Uri.parse('$baseUrl/salle/$salleId/objets'));
  if (response.statusCode == 200) {
    final List<dynamic> jsonBody = jsonDecode(response.body);

    return jsonBody.map((json) => Objet.fromJson(json)).toList();
  } else {
    print("erreur chargement objets pour la salle $salleId");
    return [];
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
