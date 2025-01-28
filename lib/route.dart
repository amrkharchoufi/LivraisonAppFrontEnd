import 'package:flutter/material.dart';
import 'package:foodie2/Livreur.dart';
import 'package:foodie2/Login.dart';
import 'package:foodie2/Loginn.dart';

final Map<String, WidgetBuilder> routes = {
  '/Login': (context) => const Login(),
  '/Loginn': (context) => const Loginn(),
  '/Livreur': (context) => const LivreurSpace()
};
