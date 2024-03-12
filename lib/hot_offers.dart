import 'package:flutter/material.dart';

class HotOffers extends StatefulWidget {
  const HotOffers({super.key});

  @override
  State<StatefulWidget> createState() => HotOffersState();
}

class HotOffersState extends State<HotOffers> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SingleChildScrollView(
          child: ListBody(children: [
            ListTile(
              title: Text("Cyberpunk 2077"),
              subtitle: Text("-20% OFF"),
              trailing: Icon(Icons.cyclone),
            ),
            ListTile(
              title: Text("Witcher 3"),
              subtitle: Text("-50% OFF"),
              trailing: Icon(Icons.cyclone),
            ),
            ListTile(
              title: Text("Red Dead Redemption 2"),
              subtitle: Text("-30% OFF"),
              trailing: Icon(Icons.cyclone),
            ),
            ListTile(
              title: Text("Minecraft"),
              subtitle: Text("-10% OFF"),
              trailing: Icon(Icons.cyclone),
            ),
          ]),
        ));
  }

}
