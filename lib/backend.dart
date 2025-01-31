// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodie2/Client.dart';
import 'package:foodie2/Livreur.dart';
import 'package:foodie2/modele/commande.dart';
import 'package:foodie2/modele/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding/decoding

Future<void> login(BuildContext context, String email, String password) async {
  late AwesomeDialog loadingDialog;
  try {
    // Show loading dialog
    loadingDialog = AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.bottomSlide,
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Signing in...'),
          ],
        ),
      ),
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
    )..show();

    // Authenticate user
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Get user data
    final String userId = userCredential.user!.uid;
    final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();

    // Handle user data
    if (!userSnapshot.exists) {
      loadingDialog.dismiss();
      _showErrorDialog(context, 'User account not found');
      await FirebaseAuth.instance.signOut();
      return;
    }

    final userData = userSnapshot.data();
    final String role = userData?['role'] ?? '';

    if (role.isEmpty) {
      loadingDialog.dismiss();
      _showErrorDialog(context, 'User role not defined');
      await FirebaseAuth.instance.signOut();
      return;
    }

    // Navigate based on role
    loadingDialog.dismiss();
    _navigateBasedOnRole(context, role);
  } on FirebaseAuthException catch (e) {
    loadingDialog.dismiss();
    _handleAuthError(context, e);
  } on FirebaseException catch (e) {
    loadingDialog.dismiss();
    _showErrorDialog(context, 'Database error: ${e.message}');
  } catch (e) {
    loadingDialog.dismiss();
    _showErrorDialog(context, 'Unexpected error: ${e.toString()}');
  }
}

void checklogin(BuildContext context) {
  String user = FirebaseAuth.instance.currentUser!.uid;
  if (user.isNotEmpty) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(user)
        .get()
        .then((value) {
      if (value.exists) {
        final userData = value.data();
        final String role = userData?['role'] ?? '';
        if (role.isNotEmpty) {
          _navigateBasedOnRole(context, role);
        }
      }
    });
  } else {
    Navigator.of(context).pushNamed("/Login");
  }
}

void _navigateBasedOnRole(BuildContext context, String role) {
  final Widget route =
      role == "Livreur" ? const LivreurSpace() : const ClientSpace();

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => route),
    (Route<dynamic> route) => false,
  );
}

void _handleAuthError(BuildContext context, FirebaseAuthException e) {
  String message = 'Sign in failed';
  switch (e.code) {
    case 'invalid-email':
      message = 'Invalid email format';
      break;
    case 'user-disabled':
      message = 'This account has been disabled';
      break;
    case 'user-not-found':
    case 'wrong-password':
      message = 'Invalid email or password';
      break;
    case 'network-request-failed':
      message = 'Network error. Please check your connection';
      break;
  }
  _showErrorDialog(context, message);
}

void _showErrorDialog(BuildContext context, String message) {
  if (!context.mounted) return;

  AwesomeDialog(
    context: context,
    dialogType: DialogType.error,
    animType: AnimType.rightSlide,
    title: 'Sign In Problem',
    desc: message,
    btnOkOnPress: () {},
    btnOkColor: Colors.red,
  ).show();
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

String generateRandomString(int length) {
  const String chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  Random random = Random();

  return List.generate(length, (index) => chars[random.nextInt(chars.length)])
      .join();
}

Future<void> addCommande(BuildContext context, Commande commande) async {
  final url = Uri.parse(
      "http://10.0.2.2:8082/commandes"); // API URL for Android Emulator

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'idCmd': commande.idCmd,
        'items': commande.Items.map((item) => item.toJson()).toList(),
        'idClient': commande.idClient,
        'idLivreur': commande.idLivreur,
        'status': commande.status.toString().split('.').last,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'order added succesfully!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green, // Change to match your theme
          behavior: SnackBarBehavior.floating, // Makes it float like a toast
          margin: EdgeInsets.all(16), // Adds space around
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          duration: Duration(seconds: 2), // Auto dismiss after 2 seconds
        ),
      );
    } else {
      throw Exception("Failed to add product: ${response.body}");
    }
  } catch (e) {
    print("Error: $e");
  }
}
