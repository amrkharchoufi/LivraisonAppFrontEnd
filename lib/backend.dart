import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodie2/Client.dart';
import 'package:foodie2/Livreur.dart';
import 'package:foodie2/modele/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding/decoding

login(BuildContext context, String email, String passwd, String type) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: passwd);
  } on FirebaseAuthException {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Sign in probleme',
      desc: "E-mail or Password incorrect",
      btnOkOnPress: () {},
    ).show();
    return;
  }

  String userid = FirebaseAuth.instance.currentUser!.uid;
  DocumentSnapshot<Map<String, dynamic>> user =
      await FirebaseFirestore.instance.collection('Users').doc(userid).get();
  String role = user.data()?["role"];
  if (role != type) {
    FirebaseAuth.instance.signOut();
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'user unfound',
      desc: "wrong email or password",
      btnOkOnPress: () {},
    ).show();
  } else {
    if (type == "Livreur") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LivreurSpace()),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ClientSpace()),
        (Route<dynamic> route) => false,
      );
    }
  }
}

Future<List<Product>> fetchProducts() async {
  final url = Uri.parse("http://10.0.2.2:8083/produits");
  final response = await http.get(url);

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((item) => Product.fromJson(item)).toList();
  } else {
    print("Failed to load products: ${response.statusCode}");
    throw Exception("Failed to load products");
  }
}
