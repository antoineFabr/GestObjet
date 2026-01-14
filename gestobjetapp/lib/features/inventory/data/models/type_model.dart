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