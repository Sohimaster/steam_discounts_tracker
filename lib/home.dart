import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:steam_discounts_tracker/settings.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _goto_settings() {
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
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.white),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear, color: Colors.white),
                  onPressed: () {
                    _searchController.clear();
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                  },
                ),
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.white, fontSize: 16),
              // Implement your search functionality here
              // For example, you could call your search method on submission:
              // onSubmitted: (query) => _search(query),
            ))),
        actions: <Widget>[
          IconButton(onPressed: _goto_settings, icon: const Icon(Icons.list))
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
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
