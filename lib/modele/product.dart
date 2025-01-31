import 'package:flutter/material.dart';

class Product {
  final String id;
  final String productName;
  double price;
  final String categorie;
  final String ImageUrl;

  Product({
    required this.id,
    required this.productName,
    required this.price,
    required this.categorie,
    required this.ImageUrl,
  });

  // Factory method to create a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['idProduit'], // Map from 'idProduit'
      productName: json['productName'], // Map from 'productName'
      price: json['price'].toDouble(), // Ensure 'price' is a double
      categorie: json['categorie'],
      ImageUrl: "asset/images/products/${json['idProduit']}.jpg",
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class CartItem {
  final Product product;
  int quantity;

  double get totalPrice => product.price * quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });
}

class CartManager extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      // Product exists - increment quantity
      _items[index] = CartItem(
        product: _items[index].product,
        quantity: _items[index].quantity + 1,
      );
    } else {
      // New product - add to cart
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      // Remove item completely
      _items.removeAt(index);
    }
  }

  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  void clearCart() {
    _items.clear();
  }
}
