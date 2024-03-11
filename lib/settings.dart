import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<StatefulWidget> createState() => SettingsState();
}

class SettingsState extends State<Settings> {

  Future<String> getCountry() async{
    Network n = new Network("http://ip-api.com/json");
    locationSTR = (await n.getData());
    locationx = jsonDecode(locationSTR);
    return locationx["country"];
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext builder, StateSetter setState) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListBody(
          children: [CountryCodePicker(
            onChanged: print,
            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
            initialSelection: 'IT',
            favorite: ['+39','FR'],
            // optional. Shows only country name and flag
            showCountryOnly: false,
            // optional. Shows only country name and flag when popup is closed.
            showOnlyCountryWhenClosed: false,
            // optional. aligns the flag and the Text left
            alignLeft: false,
          )],
        ),
      );
    });
  }
}
