import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodie2/Login.dart';
import 'package:foodie2/route.dart';
import 'package:foodie2/firebase_options.dart';
import 'package:foodie2/welcome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Foodie());
}

class Foodie extends StatelessWidget {
  const Foodie({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: routes,
      home: Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}
