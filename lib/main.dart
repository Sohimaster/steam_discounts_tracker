import 'package:flutter/material.dart';
import 'package:steam_discounts_tracker/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(context) {
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.purple[900]), home: const Home());
  }
}
