import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:steam_discounts_tracker/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(context) {
    return MaterialApp(
        theme: ThemeData(
            textTheme: TextTheme(
              displayLarge: GoogleFonts.montserrat(
                fontSize: 72,
                fontWeight: FontWeight.bold,
              ),
              // ···
              titleLarge: GoogleFonts.montserrat(
                fontSize: 30,
              ),
              bodyMedium: GoogleFonts.montserrat(),
              displaySmall: GoogleFonts.montserrat(),
            ),
        ), home: const Home());
  }
}
