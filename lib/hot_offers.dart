import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'game.dart';
import 'mock_data/hot_games.dart';

class HotOffers extends StatefulWidget {
  final String searchQuery;
  const HotOffers({super.key, required this.searchQuery});

  @override
  State<StatefulWidget> createState() => HotOffersState();
}

class HotOffersState extends State<HotOffers> {
  List<Game> games = [];
  List<Game> filteredGames = [];

  @override
  void initState() {
    super.initState();
    fetchGames();
  }

  @override
  void didUpdateWidget(covariant HotOffers oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      filterGames();
    }
  }

  void filterGames() {
    if (widget.searchQuery.isEmpty) {
      filteredGames = games;
    } else {
      filteredGames = games.where((game) {
        return game.title.toLowerCase().contains(widget.searchQuery.toLowerCase());
      }).toList();
    }
    setState(() {});
  }

  void fetchGames() async {
    // Simulated API response

    final jsonResponse = hotGamesMock;

    List<Game> fetchedGames = jsonResponse.map((gameJson) => Game.fromJson(gameJson)).toList();

    setState(() {
      games = fetchedGames;
      filteredGames = games;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.separated(
        itemCount: filteredGames.length,
        itemBuilder: (BuildContext context, int index) {
          final game = filteredGames[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8), // Rounded corners
                child: Image.network(
                  game.imageLink,
                  width: double.infinity, // Take full width of the container
                  height: 200, // Fixed height, adjust according to your need
                  fit: BoxFit.cover, // Cover the area without distorting the aspect ratio
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                  children: [
                    Text(game.title, style: Theme.of(context).textTheme.titleLarge),
                    Text("${game.discountedPrice}${game.currency} (${game.discount}% OFF)", style: GoogleFonts.montserrat(color: Colors.red[300])),
                  ],
                ),
              ),
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10), // Add space between rows
      ),
    );
  }
}
