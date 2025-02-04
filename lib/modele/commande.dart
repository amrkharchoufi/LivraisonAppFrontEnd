import 'package:foodie2/modele/Clientmodel.dart';
import 'package:foodie2/modele/Livreur.dart';
import 'package:foodie2/modele/product.dart';

class Commande {
  final String idCmd;
  final List<commandeItem> Items;
  final String idClient;
  final String idLivreur;
  final CommandeStatus status;
  final Livreur? livreur;
  final List<Productcmd>? products;
  final client? clt;

  Commande(
      {required this.idCmd,
      required this.Items,
      required this.idClient,
      required this.idLivreur,
      this.status = CommandeStatus.PENDING,
      this.livreur,
      this.products,
      this.clt});

  factory Commande.fromJson(Map<String, dynamic> json) {
    return Commande(
      idCmd: json['idCmd'] ?? '', // Default to empty string if null
      Items: json['items'] != null
          ? (json['items'] as List)
              .map((i) => commandeItem.fromJson(i))
              .toList()
          : [], // Default to empty list
      idClient: json['idClient'] ?? '',
      idLivreur: json['idLivreur'] ?? '',
      status: json['status'] != null
          ? CommandeStatus.values.firstWhere(
              (e) => e.name == json['status'],
              orElse: () => CommandeStatus.PENDING,
            )
          : CommandeStatus.PENDING,
      livreur:
          json['livreur'] != null ? Livreur.fromJson(json['livreur']) : null,

      products: json['products'] != null
          ? (json['products'] as List)
              .map((p) => Productcmd.fromJson(p))
              .toList()
          : null,
      clt: json['client'] != null ? client.fromJson(json['client']) : null,
    );
  }
}

enum CommandeStatus {
  PENDING,
  PICKEDUP,
  ONTHEWAY,
  DELIVERED;
}

class commandeItem {
  final String idProduit;
  final int quantity;

  commandeItem({
    required this.idProduit,
    required this.quantity,
  });
  Map<String, dynamic> toJson() {
    return {
      'idProduit': idProduit,
      'quantity': quantity,
    };
  }

  factory commandeItem.fromJson(Map<String, dynamic> json) {
    return commandeItem(
        idProduit: json['idProduit'], quantity: json['quantity']);
  }
}
