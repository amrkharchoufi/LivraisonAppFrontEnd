class client {
  final String idClient;
  final String nom;
  final String ville;
  final double longtitude;
  final double latitude;
  final String adress;
  final String telephone;

  client(
      {required this.idClient,
      required this.nom,
      required this.ville,
      required this.longtitude,
      required this.latitude,
      required this.adress,
      required this.telephone});

  factory client.fromJson(Map<String, dynamic> json) {
    return client(
      idClient: json['idClient'] ?? '', // Ensure it is a string
      nom: json['nom'] ?? '',
      ville: json['ville'] ?? '',
      longtitude:
          (json['longtitude'] as num).toDouble(), // Convert to double safely
      latitude:
          (json['latitude'] as num).toDouble(), //  Convert to double safely
      adress: json['adress'] ?? '',
      telephone: json['telephone'] ?? '',
    );
  }
}
