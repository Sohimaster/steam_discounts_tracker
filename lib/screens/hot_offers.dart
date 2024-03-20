import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/game.dart';
import '../mock_data/hot_games.dart';

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
        return game.title
            .toLowerCase()
            .contains(widget.searchQuery.toLowerCase());
      }).toList();
    }
    setState(() {});
  }

  void fetchGames() async {
    // Simulated API response

    final jsonResponse = hotGamesMock;

    List<Game> fetchedGames =
        jsonResponse.map((gameJson) => Game.fromJson(gameJson)).toList();

    setState(() {
      games = fetchedGames;
      filteredGames = games;
    });
  }

  void showGameDetail(BuildContext context, Game game) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor:
                Colors.black.withOpacity(0.8), // Darkened background
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () =>
                    Navigator.of(context).pop(), // Closes the modal
              ),
            ),
            body: Column(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context)
                      .pop(), // Closes the widget when the image is tapped
                  child: AspectRatio(
                    // Use AspectRatio for the image
                    aspectRatio:
                        4 / 5, // Adjust based on your image's aspect ratio
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        game.imageLink,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  // Use Expanded for the remaining content
                  child: SingleChildScrollView(
                    // Allows scrolling for overflow content
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Add your subscription logic here
                                },
                                child: Text('Subscribe'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Add your logic to open the game's store page here
                                },
                                child: Text('Store Page'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        return InkWell(
            onTap: () => showGameDetail(context, game),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8), // Rounded corners
              child: Stack(
                children: [
                  Image.network(
                    game.imageLink,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit
                        .cover, // Cover the area without distorting the aspect ratio
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.black
                          .withOpacity(0.8), // Semi-transparent overlay
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
            ));
      },
    );
  }
}
