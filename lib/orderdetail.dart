import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodie2/backend.dart';
import 'package:foodie2/modele/commande.dart';

class OrderDetail extends StatefulWidget {
  final String cmdId;
  const OrderDetail({super.key, required this.cmdId});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  String status(String st) {
    String code = "";
    switch (st) {
      case "CommandeStatus.PENDING":
        code = "PENDING";
        break;
      case "CommandeStatus.PICKEDUP":
        code = "PICKEDUP";
        break;
      case "CommandeStatus.ONTHEWAY":
        code = "ONTHEWAY";
        break;
      case "CommandeStatus.DELIVERED":
        code = "DELIVERED";
        break;
    }
    return code;
  }

  Future<Commande?>? _commandeFuture;
  Future<String?>? _mapLinkFuture;

  @override
  void initState() {
    super.initState();
    _commandeFuture = fetchCommande(widget.cmdId);
    _mapLinkFuture = _getMapLink();
  }

  Future<String?> _getMapLink() async {
    final data = await _commandeFuture;
    if (data == null || data.livreur == null || data.clt == null) return null;

    return await fetchmap(
      data.livreur!.latitude,
      data.livreur!.longtitude,
      data.clt!.latitude,
      data.clt!.longtitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Track Order",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          SizedBox(
            child: Image.asset(
              "asset/images/minilogobig.png",
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Future.wait([
          _commandeFuture ?? Future.value(null),
          _mapLinkFuture ?? Future.value(null)
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading data: ${snapshot.error}'));
          }

          final data = snapshot.data![0] as Commande?;
          final link = snapshot.data![1] as String?;

          if (data == null || link == null) {
            return const Center(child: Text('Data or map link unavailable'));
          }

          final controller = WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(
              NavigationDelegate(
                onWebResourceError: (error) {
                  print('WebView Error: ${error.description}');
                },
              ),
            )
            ..loadRequest(Uri.parse(link));

          return _buildContent(data, controller);
        },
      ),
    );
  }

  Widget _buildContent(Commande data, WebViewController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 450,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: WebViewWidget(controller: controller),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 202, 24, 66),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      child: Icon(
                        FontAwesomeIcons.user,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      data.livreur!.nom,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.call,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.clock,
                      color: Colors.white,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "20-25 min",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const Text(
                          "Delivery time",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Order status : ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                status(data.status.toString()),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          PhysicalModel(
            color: Colors.transparent,
            elevation: 7,
            shadowColor: Colors.black,
            borderRadius: BorderRadius.circular(30),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    const Color.fromARGB(255, 220, 33, 78),
                  ),
                ),
                child: const Text(
                  "Download Invoice",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderDetailliv extends StatefulWidget {
  final String cmdId;
  const OrderDetailliv({super.key, required this.cmdId});

  @override
  State<OrderDetailliv> createState() => _OrderDetaillivState();
}

class _OrderDetaillivState extends State<OrderDetailliv> {
  String status(String st) {
    String code = "";
    switch (st) {
      case "CommandeStatus.PENDING":
        code = "PICKEDUP";
        break;
      case "CommandeStatus.PICKEDUP":
        code = "ONTHEWAY";
        break;
      case "CommandeStatus.ONTHEWAY":
        code = "DELIVERED";
        break;
    }
    return code;
  }

  Future<Commande?>? _commandeFuture;
  Future<String?>? _mapLinkFuture;

  @override
  void initState() {
    super.initState();
    _commandeFuture = fetchCommande(widget.cmdId);
    _mapLinkFuture = _getMapLink();
  }

  CommandeStatus? getCommandeStatusFromString(String status) {
    try {
      return CommandeStatus.values.firstWhere(
        (e) => e.toString().split('.').last == status,
      );
    } catch (e) {
      return null; // Return null if the status is invalid
    }
  }

  Future<String?> _getMapLink() async {
    final data = await _commandeFuture;
    if (data == null || data.livreur == null || data.clt == null) return null;

    return await fetchmap(
      data.livreur!.latitude,
      data.livreur!.longtitude,
      data.clt!.latitude,
      data.clt!.longtitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Track Order",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          SizedBox(
            child: Image.asset(
              "asset/images/minilogobig.png",
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Future.wait([
          _commandeFuture ?? Future.value(null),
          _mapLinkFuture ?? Future.value(null)
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading data: ${snapshot.error}'));
          }

          final data = snapshot.data![0] as Commande?;
          final link = snapshot.data![1] as String?;

          if (data == null || link == null) {
            return const Center(child: Text('Data or map link unavailable'));
          }

          final controller = WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(
              NavigationDelegate(
                onWebResourceError: (error) {
                  print('WebView Error: ${error.description}');
                },
              ),
            )
            ..loadRequest(Uri.parse(link));

          return _buildContent(data, controller);
        },
      ),
    );
  }

  Widget _buildContent(Commande data, WebViewController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 450,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: WebViewWidget(controller: controller),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 202, 24, 66),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      child: Icon(
                        FontAwesomeIcons.user,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      data.clt!.nom,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.call,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.clock,
                      color: Colors.white,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "20-25 min",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const Text(
                          "Delivery time",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Order status : ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                status(data.status.toString()),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (status(data.status.toString()) != "DELIVERED")
            PhysicalModel(
              color: Colors.transparent,
              elevation: 7,
              shadowColor: Colors.black,
              borderRadius: BorderRadius.circular(30),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    CommandeStatus cd = getCommandeStatusFromString(
                        status(data.status.toString()))!;
                    updatecommandestatus(data.idCmd, cd);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      const Color.fromARGB(255, 220, 33, 78),
                    ),
                  ),
                  child: Text(
                    "Set ${status(data.status.toString())}",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
