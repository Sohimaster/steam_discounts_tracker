import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:steam_discounts_tracker/main.dart';

import 'loading_screen.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  Future<void> _signOut(BuildContext context) async {
    Navigator.of(context)
        .push(NoAnimationPageRoute(builder: (_) => const LoadingScreen()));
    await Future.delayed(const Duration(seconds: 1));

    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();

      // Use NoAnimationPageRoute to navigate without animations
      Navigator.of(context)
          .pushReplacement(NoAnimationPageRoute(builder: (_) => const MyApp()));
    } catch (e) {
      Navigator.of(context).pushReplacement(NoAnimationPageRoute(
          builder: (_) => const MyApp())); // Pop LoadingScreen
      if (kDebugMode) {
        print('Error signing out: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error signing out. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _signOut(context),
      child: const Text('Logout'),
    );
  }
}
