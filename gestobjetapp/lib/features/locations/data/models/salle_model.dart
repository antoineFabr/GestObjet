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