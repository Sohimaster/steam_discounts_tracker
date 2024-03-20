import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:steam_discounts_tracker/components/search.dart';
import 'package:steam_discounts_tracker/screens/settings.dart';
import 'package:steam_discounts_tracker/screens/subscriptions.dart';

import 'hot_offers.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  String _searchQuery = "";
  int _selectedIndex = 1;
  final TextEditingController _searchController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> get _widgetOptions => <Widget>[
        Search(searchQuery: _searchQuery),
        HotOffers(searchQuery: _searchQuery),
        Subscriptions(searchQuery: _searchQuery),
      ];

  void _gotoSettings() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return const Settings();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            height: 50, // Adjust the height to fit within AppBar if necessary
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.25), // Light white with opacity
              borderRadius: BorderRadius.circular(24), // Rounded corners
            ),
            child: Center(
                child: TextField(
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _searchQuery = "";
                    });
                    _searchController.clear();
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                  },
                ),
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.black, fontSize: 16),
              // Implement your search functionality here
              // For example, you could call your search method on submission:
              // onSubmitted: (query) => _search(query),
            ))),
        actions: <Widget>[
          IconButton(onPressed: _gotoSettings, icon: const Icon(Icons.list))
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department),
            label: 'Hot offers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_add_check_rounded),
            label: 'Subscriptions',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        selectedItemColor: Colors.red[300],
        onTap: _onItemTapped,
      ),
    );
  }
}
