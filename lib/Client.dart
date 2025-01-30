import 'package:animate_do/animate_do.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
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
  final _pageController = PageController(initialPage: 0);

  /// Controller to handle bottom nav bar and also handles initial page
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
    /// widget list
    final List<Widget> bottomBarPages = [
      const Products(),
      const Cart(),
      const Delivery(),
    ];
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              /// Provide NotchBottomBarController
              notchBottomBarController: _controller,
              color: Colors.white,
              showLabel: true,
              textOverflow: TextOverflow.visible,
              maxLine: 1,
              shadowElevation: 5,
              kBottomRadius: 28.0,

              // notchShader: const SweepGradient(
              //   startAngle: 0,
              //   endAngle: pi / 2,
              //   colors: [Colors.red, Colors.green, Colors.orange],
              //   tileMode: TileMode.mirror,
              // ).createShader(Rect.fromCircle(center: Offset.zero, radius: 8.0)),
              notchColor: Colors.white,

              /// restart app if you change removeMargins
              removeMargins: false,
              bottomBarWidth: double.infinity,
              showShadow: true,
              durationInMilliSeconds: 200,

              itemLabelStyle: const TextStyle(fontSize: 10),

              elevation: 1,
              bottomBarItems: const [
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home_filled,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.home_filled,
                    color: Color.fromARGB(255, 220, 33, 78),
                  ),
                ),
                BottomBarItem(
                  inActiveItem: Icon(Icons.shopping_cart_outlined,
                      color: Colors.blueGrey),
                  activeItem: Icon(
                    Icons.shopping_cart,
                    color: Color.fromARGB(255, 220, 33, 78),
                  ),
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    FontAwesomeIcons.box,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    FontAwesomeIcons.boxOpen,
                    color: Color.fromARGB(255, 220, 33, 78),
                  ),
                ),
              ],
              onTap: (index) {
                _pageController.jumpToPage(index);
              },
              kIconSize: 20.0,
            )
          : null,
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      borderRadius: BorderRadius.circular(10.0),
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
          ],
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
    return const Scaffold(
      body: Text("delivery"),
    );
  }
}
