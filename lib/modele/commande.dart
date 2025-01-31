class Commande {
  final String idCmd;
  final List<commandeItem> Items;
  final String idClient;
  final String idLivreur;
  final CommandeStatus status = CommandeStatus.PENDING;

  Commande({
    required this.idCmd,
    required this.Items,
    required this.idClient,
    required this.idLivreur,
  });
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
}
