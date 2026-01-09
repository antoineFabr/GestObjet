import 'package:gestobjetapp/services/type_controller.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Objet {
  final String id;
  final String qrCode;
  // On stocke l'objet complet TypeObjet, pas juste l'ID
  final Type? type;
  final DateTime? createdAt;

  Objet({required this.id, required this.qrCode, this.type, this.createdAt});

  factory Objet.fromJson(Map<String, dynamic> json) {
    return Objet(
      // Mongoose renvoie '_id', on le map vers 'id'
      id: json['_id'] as String,

      qrCode: json['qrCode'] as String,

      // Gestion intelligente du Type :
      // On vérifie si 'type' est présent et n'est pas null
      type: json['type'] != null && json['type'] is Map<String, dynamic>
          ? Type.fromJson(json['type'])
          : null, // Si le backend n'a pas envoyé le type ou juste un ID string
      // Bonus : Gestion de la date
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }
}

const baseUrl = "http://localhost:3333/api";

Future<List<Objet>> getObjetBySalle(String id) async {
  final response = await http.get(Uri.parse('$baseUrl/salle/$id/objets'));
  if (response.statusCode == 200) {
    final dynamic jsonBody = jsonDecode(response.body);
    if (jsonBody is List) {
        return jsonBody.map((json) => Objet.fromJson(json)).toList();
      } else if (jsonBody is Map && jsonBody.containsKey('data')) {
        // Au cas où le backend changerait pour renvoyer { data: [...] }
        return (jsonBody['data'] as List).map((json) => Objet.fromJson(json)).toList();
      } else {
        throw Exception("Format JSON inattendu : Ce n'est pas une liste.");
      }
  } else {
    throw Exception('failed to load classes');
  }
}
