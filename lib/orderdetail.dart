import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
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
  late WebViewController _webViewController;
  late Future<Commande?> _commandeFuture;
  late Future<String?> _mapLinkFuture;
  bool _isLoading = true;
  String? _errorMessage;
  String? _currentUrl;

  String status(String st) {
    switch (st) {
      case "CommandeStatus.PENDING":
        return "PENDING";
      case "CommandeStatus.PICKEDUP":
        return "PICKEDUP";
      case "CommandeStatus.ONTHEWAY":
        return "ONTHEWAY";
      case "CommandeStatus.DELIVERED":
        return "DELIVERED";
      default:
        return "UNKNOWN";
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeDependencies();
  }

  void _initializeDependencies() {
    _commandeFuture = fetchCommande(widget.cmdId);
    _mapLinkFuture = _getMapLink();
    _initializeWebView();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadWebViewContent();
    });
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(onNavigationRequest: (request) {
          if (request.url.startsWith('https://www.google.com/maps')) {
            _launchExternalMap(request.url);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        }, onWebResourceError: (error) {
          if (error is WebResourceError &&
              error.errorCode == -2 /* DNS resolution error */) {
            setState(() {
              _errorMessage = "Network error. Check your connection.";
            });
          }
        }),
      )
      ..loadRequest(Uri.parse("about:blank")); // Initial empty load
  }

  Future<void> _loadWebViewContent() async {
    try {
      final link = await _mapLinkFuture;
      if (link != null && Uri.parse(link).isAbsolute) {
        if (_currentUrl != link) {
          await _webViewController.loadRequest(Uri.parse(link));
        }
      } else {
        setState(() => _errorMessage = "Invalid map coordinates");
        await _webViewController.loadRequest(Uri.parse('about:blank'));
      }
    } catch (e) {
      setState(() => _errorMessage = "Error loading map: ${e.toString()}");
      await _webViewController.loadRequest(Uri.parse('about:blank'));
    }
  }

  Future<void> _launchExternalMap(String url) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      setState(() => _errorMessage = "Failed to open maps: ${e.toString()}");
    }
  }

  Future<String?> _getMapLink() async {
    try {
      final data = await _commandeFuture;
      if (data == null || data.livreur == null || data.clt == null) {
        throw Exception('Invalid order data');
      }

      final livreurLat = data.livreur!.latitude;
      final livreurLng = data.livreur!.longtitude;
      final clientLat = data.clt!.latitude;
      final clientLng = data.clt!.longtitude;

      if (livreurLat == null ||
          livreurLng == null ||
          clientLat == null ||
          clientLng == null) {
        throw Exception('Missing coordinates');
      }

      final link = await fetchmap(livreurLat, livreurLng, clientLat, clientLng);
      if (kDebugMode) print('Map URL: $link');
      return link;
    } catch (e) {
      if (kDebugMode) print('Map link error: $e');
      return null;
    }
  }

  Widget _buildWebView() {
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 50),
            const SizedBox(height: 20),
            Text(_errorMessage!),
            TextButton(
              onPressed: _loadWebViewContent,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        WebViewWidget(
          controller: _webViewController,
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
            Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer()
                ..onDown = (DragDownDetails details) {},
            ),
          },
        ),
        if (_isLoading) const Center(child: CircularProgressIndicator()),
      ],
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
          Image.asset("asset/images/minilogobig.png", width: 40),
        ],
      ),
      body: FutureBuilder<List<Object?>>(
        future: Future.wait<Object?>([_commandeFuture, _mapLinkFuture]),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data?[0] as Commande?;
          final link = snapshot.data?[1] as String?;

          if (data == null) {
            return const Center(child: Text('Order data not found'));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _buildWebView(),
                  ),
                ),
                const SizedBox(height: 10),
                _buildDeliveryInfo(data),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDeliveryInfo(Commande data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 202, 24, 66),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: Icon(FontAwesomeIcons.user, color: Colors.black),
              ),
              Text(
                data.livreur?.nom ?? 'Unknown Driver',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.call, color: Colors.white, size: 30),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Icon(FontAwesomeIcons.clock, color: Colors.white, size: 30),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "20-25 min",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    "Delivery time",
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "Order Status: ${status(data.status.toString())}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {},
              child: const Text(
                "Download Invoice",
                style: TextStyle(
                  color: Color.fromARGB(255, 202, 24, 66),
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
