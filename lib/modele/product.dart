class Product {
  final String id;
  final String productName;
  double price;
  int? quantite;

  Product(
      {required this.id,
      required this.productName,
      required this.price,
      this.quantite});

  // Factory method to create a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['idProduit'], // Map from 'idProduit'
      productName: json['productName'], // Map from 'productName'
      price: json['price'].toDouble(), // Ensure 'price' is a double
    );
  }
}
