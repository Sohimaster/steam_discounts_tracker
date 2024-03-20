import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

enum LoginStatus {
  idle,
  inProgress,
  success,
}

class LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  LoginStatus _loginStatus = LoginStatus.idle;

  Future<void> _signInWithGoogle() async {
    setState(() {
      _loginStatus = LoginStatus.inProgress;
    });

    try {
      await googleSignIn.signOut();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        await _auth.signInWithCredential(credential);
        setState(() {
          _loginStatus = LoginStatus.success;
        });
        // await Future.delayed(const Duration(seconds: 1));
        // Navigator.of(context).pushAndRemoveUntil(
        //   MaterialPageRoute(builder: (context) => const Home()),
        //       (Route<dynamic> route) => false,
        // );
      }
    } catch (error) {
      if (kDebugMode) {
        print("Sign in error: $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _loginStatus == LoginStatus.inProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _signInWithGoogle,
                child: const Text('Sign in with Google'),
              ),
      ),
    );
  }
}
