import 'package:animate_do/animate_do.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodie2/backend.dart';
import 'package:foodie2/modele/commande.dart';
import 'package:foodie2/modele/product.dart';
import 'package:foodie2/orderdetail.dart';
import 'package:foodie2/widget/productcard.dart';
import 'package:provider/provider.dart';

class ClientSpace extends StatefulWidget {
  const ClientSpace({super.key});

  @override
  State<ClientSpace> createState() => _ClientSpaceState();
}

class _ClientSpaceState extends State<ClientSpace> {
  final _pageController = PageController(initialPage: 0);
  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 0);
  int maxCount = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartManager()),
      ],
      child: _ClientSpaceContent(
        pageController: _pageController,
        controller: _controller,
        maxCount: maxCount,
      ),
    );
  }
}

class _ClientSpaceContent extends StatelessWidget {
  final PageController pageController;
  final NotchBottomBarController controller;
  final int maxCount;

  const _ClientSpaceContent({
    required this.pageController,
    required this.controller,
    required this.maxCount,
  });

  @override
  Widget build(BuildContext context) {
    final cartManager = Provider.of<CartManager>(context);

    final List<Widget> bottomBarPages = [
      const Products(),
      const Cart(),
      const Delivery(),
    ];

    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: bottomBarPages,
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              notchBottomBarController: controller,
              color: Colors.white,
              showLabel: true,
              textOverflow: TextOverflow.visible,
              maxLine: 1,
              shadowElevation: 5,
              kBottomRadius: 28.0,
              notchColor: Colors.white,
              removeMargins: false,
              bottomBarWidth: double.infinity,
              showShadow: true,
              durationInMilliSeconds: 200,
              itemLabelStyle: const TextStyle(fontSize: 10),
              elevation: 1,
              bottomBarItems: [
                BottomBarItem(
                  inActiveItem:
                      const Icon(Icons.home_filled, color: Colors.blueGrey),
                  activeItem: const Icon(Icons.home_filled,
                      color: Color.fromARGB(255, 220, 33, 78)),
                ),
                BottomBarItem(
                  inActiveItem: _CartIconWithBadge(
                      cartManager: cartManager, isActive: false),
                  activeItem: _CartIconWithBadge(
                      cartManager: cartManager, isActive: true),
                ),
                BottomBarItem(
                  inActiveItem:
                      const Icon(FontAwesomeIcons.box, color: Colors.blueGrey),
                  activeItem: const Icon(FontAwesomeIcons.boxOpen,
                      color: Color.fromARGB(255, 220, 33, 78)),
                ),
              ],
              onTap: (index) => pageController.jumpToPage(index),
              kIconSize: 20.0,
            )
          : null,
    );
  }
}

class _CartIconWithBadge extends StatelessWidget {
  final CartManager cartManager;
  final bool isActive;

  const _CartIconWithBadge({required this.cartManager, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(
          isActive ? Icons.shopping_cart : Icons.shopping_cart_outlined,
          color: isActive
              ? const Color.fromARGB(255, 220, 33, 78)
              : Colors.blueGrey,
        ),
        if (cartManager.items.isNotEmpty)
          Positioned(
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
              child: Text(
                '${cartManager.items.length}',
                style: const TextStyle(color: Colors.white, fontSize: 8),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
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
  TextEditingController food = TextEditingController();
  List<String> categories = ["Pizza", "Burger", "Nugget", "Tacos"];

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartManager>(context);
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
            width: 220,
            height: 220,
            child: Image.asset("asset/images/minilogo.png")),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Color.fromARGB(188, 202, 24, 66),
              child: Icon(
                FontAwesomeIcons.user,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
          child: Column(
            children: [
              PhysicalModel(
                color: Colors.transparent,
                elevation: 7,
                shadowColor: Colors.black,
                borderRadius: BorderRadius.circular(30),
                child: SizedBox(
                  width: 300,
                  height: 50,
                  child: TextFormField(
                    controller: food,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black54,
                      ),
                      hintText: "Search Your Favorite Food...",
                      hintStyle: const TextStyle(
                        color: Colors.black54,
                        fontFamily: "Poppin",
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FadeInUp(
                duration: Duration(milliseconds: 500),
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Color.fromARGB(255, 202, 24, 66)),
                  child: Stack(
                    children: [
                      Positioned(
                          right: 0,
                          top: 0,
                          child: SizedBox(
                              width: 80,
                              height: 80,
                              child:
                                  Image.asset("asset/images/circlewhbig.png"))),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "The Fastest\nFood Delivery",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Monsterrat",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                    ),
                                    child: Text(
                                      "ORDER NOW",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                                width: 185,
                                height: 185,
                                child: Image.asset("asset/images/burger.png"))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              FadeInRight(
                duration: Duration(milliseconds: 700),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Categories",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text("View All",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 202, 24, 66),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < categories.length; i++) ...[
                      FadeInUp(
                        duration: Duration(milliseconds: (800 + (i * 200))),
                        child: GestureDetector(
                          onTap: () {
                            print("object");
                          },
                          child: Column(
                            children: [
                              PhysicalModel(
                                color: Colors.transparent,
                                elevation: 7,
                                shadowColor: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    width: 120,
                                    height: 120,
                                    child: Image.asset(
                                        "asset/images/categorie/${categories[i]}cat.png")),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                categories[i],
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      )
                    ]
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              FadeInRight(
                duration: Duration(milliseconds: 900),
                child: Row(
                  children: [
                    Text(
                      "Top Deals",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // Replace the existing Wrap widget with this:
              FutureBuilder<List<Product>>(
                future: futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No products found');
                  } else {
                    final products = snapshot.data!;
                    return Wrap(
                      // spacing: 20,
                      runSpacing: 20,
                      children: [
                        for (final product in products)
                          FadeInUp(
                            duration: Duration(milliseconds: 900),
                            child: Productcard(
                              onPressed: () {
                                final pr = Product(
                                    id: product.id,
                                    productName: product.productName,
                                    price: product.price,
                                    categorie: product.categorie,
                                    ImageUrl: product.ImageUrl);
                                cart.addToCart(pr);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(Icons.check_circle,
                                            color: Colors.white),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            '${product.productName} added to cart!',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: Colors
                                        .green, // Change to match your theme
                                    behavior: SnackBarBehavior
                                        .floating, // Makes it float like a toast
                                    margin:
                                        EdgeInsets.all(16), // Adds space around
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          12), // Rounded corners
                                    ),
                                    duration: Duration(
                                        seconds:
                                            2), // Auto dismiss after 2 seconds
                                  ),
                                );
                              },
                              nom: product.productName,
                              price: product.price,
                              image: AssetImage(product.ImageUrl),
                            ),
                          ),
                      ],
                    );
                  }
                },
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
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
    final cartManager = Provider.of<CartManager>(context);
    int i = 0;

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
            width: 220,
            height: 220,
            child: Image.asset("asset/images/minilogo.png")),
        centerTitle: true,
        actions: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Color.fromARGB(150, 202, 24, 66),
            child: Icon(
              FontAwesomeIcons.user,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Cart",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "(${cartManager.items.length})",
                    style: TextStyle(
                        color: Color.fromARGB(255, 220, 33, 78),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              cartManager.items.isNotEmpty
                  ? Column(
                      children: [
                        SizedBox(height: 20),
                        for (var item in cartManager.items) ...[
                          FadeInRight(
                            duration:
                                Duration(milliseconds: (500 + (i += 200))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: AssetImage(item.product.ImageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      item.product.productName,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            if (item.quantity > 1) {
                                              setState(() {
                                                item.quantity -= 1;
                                              });
                                            }
                                          },
                                          icon: Icon(Icons.remove),
                                        ),
                                        Text(
                                          item.quantity.toString(),
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              item.quantity += 1;
                                            });
                                          },
                                          icon: Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "\$ ${item.product.price.toStringAsFixed(2)}",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 15),
                                    Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 202, 24, 66),
                                            Color.fromARGB(166, 202, 24, 66),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.cancel_outlined,
                                            color: Colors.white),
                                        iconSize: 20,
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () {
                                          cartManager
                                              .removeFromCart(item.product.id);
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                        Divider(),
                        SizedBox(height: 15),
                        FadeInUp(
                          duration: Duration(milliseconds: (500 + (i += 200))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Total:",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black45),
                              ),
                              Text(
                                "\$ ${cartManager.totalAmount}",
                                style: TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        FadeInUp(
                          duration: Duration(milliseconds: (500 + (i += 200))),
                          child: ElevatedButton(
                            onPressed: () {
                              List<commandeItem> items = cartManager.items
                                  .map((item) => commandeItem(
                                        idProduit: item.product.id,
                                        quantity: item.quantity,
                                      ))
                                  .toList();
                              final commande = Commande(
                                  idCmd: generateRandomString(10),
                                  Items: items,
                                  idClient: "",
                                  idLivreur: "");
                              addCommande(context, commande);
                              setState(() {
                                cartManager.clearCart();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 220, 33, 78),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 80, vertical: 13),
                            ),
                            child: Text(
                              "CheckOut",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Text(
                        "Your cart is empty!",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class Delivery extends StatefulWidget {
  const Delivery({super.key});

  @override
  State<Delivery> createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  late Future<List<Commande>> futureCommandes;

  @override
  void initState() {
    super.initState();
    futureCommandes = fetchCommandes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
            width: 220,
            height: 220,
            child: Image.asset("asset/images/minilogo.png")),
        centerTitle: true,
        actions: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Color.fromARGB(150, 202, 24, 66),
            child: Icon(
              FontAwesomeIcons.user,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Column(
          children: [
            Text(
              "Your Orders",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            FutureBuilder<List<Commande>>(
              future: futureCommandes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No commandes found');
                } else {
                  final commandes = snapshot.data!;
                  return Wrap(
                    runSpacing: 20,
                    children: [
                      for (final commande in commandes)
                        FadeInRight(
                          duration: const Duration(milliseconds: 900),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OrderDetail(cmdId: commande.idCmd),
                                ),
                              );
                              
                            },
                            child: SizedBox(
                              width: double.infinity,
                              child: Card(
                                child: Text(commande.idCmd),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
