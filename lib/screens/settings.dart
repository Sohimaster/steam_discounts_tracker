import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../const.dart';
import '../components/logout_button.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<StatefulWidget> createState() => SettingsState();
}

class LocationService {
  static Future<void> updateCountry(String country) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('country', country);
  }

  static Future<String> getCountryName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedCountry = prefs.getString('country');
    if (savedCountry != null) {
      return savedCountry; // Return saved country if found
    }

    final url = Uri.parse('https://ipapi.co/json/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final country = data['country'];
      await updateCountry(country);
      return country;
    } else {
      return "US";
    }
  }
}

class SettingsState extends State<Settings> {
  late String userEmail;

  @override
  void initState() {
    super.initState();
    getCurrentUserEmail();
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _sendFeedbackEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: devEmail, // Replace with your email address
      query: encodeQueryParameters(<String, String>{
        'subject': 'Feedback',
      }),
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      // Show error or message if unable to open the mail app
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Unable to open the mail app. You can send an email to $devEmail"),
        ),
      );
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  void getCurrentUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // If the user is signed in
      setState(() {
        userEmail = user.email!;
      });
    } else {
      setState(() {
        userEmail = 'NO USER';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        // Use Column to layout your widgets vertically.
        mainAxisSize:
            MainAxisSize.min, // Use min to fit content in the space needed.
        children: [
          // ListTile(
          //   title: const Text('Choose your country'),
          //   trailing: FutureBuilder<String>(
          //     future: LocationService.getCountryName(),
          //     builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          //       Widget child;
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         child = const Center(child: CircularProgressIndicator());
          //       } else if (snapshot.hasError) {
          //         child = Text('Error: ${snapshot.error}');
          //       } else {
          //         // Use snapshot.data which contains your country name
          //         child = CountryCodePicker(
          //           flagDecoration:
          //               BoxDecoration(borderRadius: BorderRadius.circular(3)),
          //           onChanged: (CountryCode countryCode) {
          //             LocationService.updateCountry(countryCode.code as String);
          //           },
          //           initialSelection: snapshot.data,
          //           showCountryOnly: true,
          //           showOnlyCountryWhenClosed: true,
          //           alignLeft: false,
          //         );
          //       }
          //       // Wrap the child with a SizedBox to constrain its width
          //       return SizedBox(
          //           width: 200, child: child); // Adjust the width as needed
          //     },
          //   ),
          // ),
          ListTile(
            title: const Text('Support Developers'),
            subtitle: const Text(
                'If you enjoyed using the app, make a donation to support further development.'),
            trailing: ElevatedButton(
              onPressed: () {
                // Replace the URL with your donation link
                _launchURL(
                    Uri.parse('https://www.example.com/donate') as String);
              },
              child: const Text('Donate'),
            ),
          ),
          ListTile(
            title: const Text('Contact the developers to leave feedback'),
            trailing: ElevatedButton(
              onPressed: () {
                _sendFeedbackEmail();
              },
              child: const Text('Feedback'),
            ),
          ),
          ListTile(
            title: Text('Logged in as: $userEmail'),
            trailing: const LogoutButton(),
          )
        ],
      ),
    );
  }
}
