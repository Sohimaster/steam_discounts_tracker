import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'game.dart';
import '../mock_data/hot_games.dart';

class Search extends StatefulWidget {
  final String searchQuery;
  const Search({super.key, required this.searchQuery});

  @override
  State<StatefulWidget> createState() => SearchState();
}

class SearchState extends State<Search> {
  List<Game> games = [];
  List<Game> filteredGames = [];

  @override
  void initState() {
    super.initState();
    fetchGames();
  }

  @override
  void didUpdateWidget(covariant Search oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      fetchGames();
    }
  }

  void fetchGames() async {
    // Simulated API response

    final jsonResponse = hotGamesMock;

    List<Game> fetchedGames =
        []; //jsonResponse.map((gameJson) => Game.fromJson(gameJson)).toList();

    setState(() {
      games = fetchedGames;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (games.isEmpty) {
      // Display a message when there are no subscriptions
      return Center(
        child: Text(
          "Start typing...",
          style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two items per row
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio:
            0.75, // Adjust based on your image aspect ratio and text height
      ),
      itemCount: filteredGames.length,
      itemBuilder: (BuildContext context, int index) {
        final game = filteredGames[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(8), // Rounded corners
          child: Stack(
            children: [
              Image.network(
                game.imageLink,
                width: double.infinity, // Take full width of the container
                height: double.infinity, // Make sure the image covers the stack
                fit: BoxFit
                    .cover, // Cover the area without distorting the aspect ratio
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color:
                      Colors.black.withOpacity(0.8), // Semi-transparent overlay
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(game.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.white)),
                      Text(
                          "${game.discountedPrice}${game.currency} (${game.discount}% OFF)",
                          style: GoogleFonts.montserrat(
                              color: Colors.red[300],
                              fontSize: 13,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
