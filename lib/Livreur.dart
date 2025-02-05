import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodie2/backend.dart';
import 'package:foodie2/modele/commande.dart';
import 'package:foodie2/orderdetail.dart';

class LivreurSpace extends StatefulWidget {
  const LivreurSpace({super.key});

  @override
  State<LivreurSpace> createState() => _LivreurSpaceState();
}

class _LivreurSpaceState extends State<LivreurSpace> {
  late Future<List<Commande>> futureCommandes;

  @override
  void initState() {
    super.initState();
    futureCommandes = fetchCommandesliv();
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
                                      OrderDetailliv(cmdId: commande.idCmd),
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
