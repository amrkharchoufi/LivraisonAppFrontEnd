import 'dart:math';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodie2/modele/product.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
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
    return const Scaffold(
      body: Text("delivery"),
    );
  }
}
