import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:steam_discounts_tracker/home.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          displayLarge: GoogleFonts.montserrat(fontSize: 72, fontWeight: FontWeight.bold),
          titleLarge: GoogleFonts.montserrat(fontSize: 20),
          bodyMedium: GoogleFonts.montserrat(),
          displaySmall: GoogleFonts.montserrat(),
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // User is signed in
            return const Home();
          } else {
            // User is not signed in
            return const SignInPage();
          }
        },
      )
    );
  }
}