import 'package:flutter/material.dart';
import 'package:foodie2/modele/product.dart';
import 'package:r_nav_n_sheet/r_nav_n_sheet.dart';

List<Product> cart = [];

class ClientSpace extends StatefulWidget {
  const ClientSpace({super.key});

  @override
  State<ClientSpace> createState() => _ClientSpaceState();
}

class _ClientSpaceState extends State<ClientSpace> {
  int _currentIndex = 0;
  final List<Widget> _pages = [/*Products()*/ Cart(), Delivery()];

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
        bottomNavigationBar: RNavNSheet(
          sheet: BottomSheet(
              onClosing: () {},
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.share),
                        title: const Text('Share'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.copy),
                        title: const Text('Copy link'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text('Edit'),
                        onTap: () {},
                      ),
                    ],
                  ),
                );
              }), //Replace MySheet with your own bottom sheet
          items: const [
            RNavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: "Home",
            ),
            RNavItem(
              icon: Icons.search_outlined,
              activeIcon: Icons.search,
              label: "Search",
            ),
            RNavItem(
              icon: Icons.shopping_cart_outlined,
              activeIcon: Icons.shopping_cart,
              label: "Cart",
            ),
            RNavItem(
              icon: Icons.person,
              activeIcon: Icons.person_outline,
              label: "Account",
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ));
  }
}
/*
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
    futureProducts = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: SizedBox(
          width: 250,
          height: 250,
          child: Image.asset("asset/foodielogo.png"),
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          } else if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No products found",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          } else {
            List<Product> products = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Top Deals",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < products.length; i++) ...[
                        Container(
                          width: 150,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18))),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset("asset/${i + 1}.jpg"),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      products[i].productName,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${products[i].price}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (cart.any(
                                      (item) => item.id == products[i].id)) {
                                    // Find the product in the cart using its ID
                                    int ind = cart.indexWhere(
                                        (item) => item.id == products[i].id);
                                    cart[ind].quantite =
                                        (cart[ind].quantite ?? 0) + 1;
                                    cart[ind].price = (cart[ind].price ?? 0) +
                                        (cart[ind].price ??
                                            0); // Ensure quantite is not null
                                  } else {
                                    // Add the product to the cart with an initial quantity
                                    products[i].quantite =
                                        1; // Initialize the quantity if not already set
                                    cart.add(products[i]);
                                  }
                                },
                                style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(
                                        Colors.amberAccent)),
                                child: Text(
                                  "Add to Cart",
                                  style: TextStyle(color: Colors.black),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ]
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}*/

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
