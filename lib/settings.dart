import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<StatefulWidget> createState() => SettingsState();
}

class LocationService {
  static Future<String> getCountryName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Try to get the country from shared preferences
    final savedCountry = prefs.getString('country');
    if (savedCountry != null) {
      return savedCountry; // Return saved country if found
    }

    final url = Uri.parse('https://ipapi.co/json/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final country = data['country'];
      await prefs.setString('country', country);
      return country;
    } else {
      return "US";
    }
  }
}

class SettingsState extends State<Settings> {
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
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
          ListTile(
            title: Text('Choose your country'),
            trailing: FutureBuilder<String>(
              future: LocationService.getCountryName(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Use snapshot.data which contains your country name
                  return CountryCodePicker(
                    onChanged: print, // Handle country change
                    initialSelection: snapshot.data,
                    showCountryOnly: true,
                    showOnlyCountryWhenClosed: true,
                    alignLeft: false,
                  );
                }
              },
            ),
          ),
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
        ],
      ),
    );
  }
}
