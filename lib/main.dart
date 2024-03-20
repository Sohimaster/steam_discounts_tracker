import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:steam_discounts_tracker/home.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseAuth.instance.authStateChanges().listen((User? user) {
  //   if (user == null) {
  //     if (kDebugMode) {
  //       print('User is currently signed out!');
  //     }
  //   } else {
  //     if (kDebugMode) {
  //       print('User is signed in!');
  //     }
  //     // Navigate to your main app screen
  //   }
  // });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          displayLarge:
              GoogleFonts.montserrat(fontSize: 72, fontWeight: FontWeight.bold),
          titleLarge: GoogleFonts.montserrat(fontSize: 20),
          bodyMedium: GoogleFonts.montserrat(),
          displaySmall: GoogleFonts.montserrat(),
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Log the connection state and data
          print('StreamBuilder connection state: ${snapshot.connectionState}');
          if (snapshot.connectionState == ConnectionState.active) {
            print(
                'StreamBuilder has data: ${snapshot.hasData}, User: ${snapshot.data?.uid}');
          }

          if (snapshot.hasData) {
            print('Rendering HomePage');
            return const Home();
          } else {
            print('Rendering LoginPage');
            return const Login();
          }
        },
      ),
    );
  }
}
