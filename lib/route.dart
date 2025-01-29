import 'package:flutter/material.dart';
import 'package:foodie2/Livreur.dart';
import 'package:foodie2/Login.dart';

final Map<String, WidgetBuilder> routes = {
  '/Login': (context) => const Login(),
  '/Livreur': (context) => const LivreurSpace()
};
