import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodie2/modele/product.dart';

List<Product> cart = [];

class ClientSpace extends StatefulWidget {
  const ClientSpace({super.key});

  @override
  State<ClientSpace> createState() => _ClientSpaceState();
}

class _ClientSpaceState extends State<ClientSpace> {
  int _currentIndex = 0;
  final List<Widget> _pages = [Products(), Cart(), Delivery()];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _pages[_currentIndex],
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle, // The convex shape
        backgroundColor: Colors.black, // Bottom bar color
        activeColor: Colors.white, // Active icon color
        color: Colors.white70, // Inactive icon color
        items: [
          TabItem(icon: Icons.search, title: ""),
          TabItem(icon: Icons.favorite_border, title: ""),
          TabItem(icon: FontAwesomeIcons.houseChimney, title: ""),
          TabItem(icon: Icons.shopping_cart_outlined, title: ""),
          TabItem(icon: Icons.person_outline, title: ""),
        ],
        initialActiveIndex: _currentIndex, // Default selected index
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("data"),
    );
  }
}

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cart.length,
      itemBuilder: (context, index) {
        final product = cart[index];
        return SizedBox(
          child: ListTile(
            leading: Image.asset("asset/${index + 1}.jpg"),
            title: Text(
              product.productName,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              "Price: ${product.price}",
              style: TextStyle(color: Colors.grey),
            ),
            trailing: Text(
              "Quantity: ${product.quantite}",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}

class Delivery extends StatefulWidget {
  const Delivery({super.key});

  @override
  State<Delivery> createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("delivery"),
    );
  }
}
