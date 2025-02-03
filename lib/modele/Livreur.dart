class Livreur {
  final String idLivreur;
  final String nom;
  final double longtitude;
  final double latitude;
  final String telephone;

  Livreur(
      {required this.idLivreur,
      required this.nom,
      required this.longtitude,
      required this.latitude,
      required this.telephone});

  factory Livreur.fromJson(Map<String, dynamic> json) {
    return Livreur(
      idLivreur: json['idLivreur'] ?? '',
      nom: json['nom'] ?? '',
      longtitude: (json['longtitude'] as num).toDouble(), //  Convert safely
      latitude: (json['latitude'] as num).toDouble(), //  Convert safely
      telephone: json['telephone'] ?? '',
    );
  }
}
