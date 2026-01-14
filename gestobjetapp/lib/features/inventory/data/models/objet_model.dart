import 'package:gestobjetapp/features/inventory/data/models/type_model.dart';

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
