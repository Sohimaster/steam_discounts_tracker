class Game {
  final int id;
  final String title;
  final String imageLink;
  final double originalPrice;
  final double discountedPrice;
  final String currency;
  final int discount;
  final String storeLink;

  Game(
      {required this.title,
      required this.discount,
      required this.imageLink,
      required this.discountedPrice,
      required this.originalPrice,
      required this.currency,
      required this.storeLink,
      required this.id});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
        title: json['title'],
        imageLink: json['image_link'],
        originalPrice: (json['original_price'] as num).toDouble(),
        discountedPrice: (json['discounted_price'] as num).toDouble(),
        currency: json['currency'],
        storeLink: json['store_link'],
        discount: (json['discount'] as num).toInt(),
        id: json['id']);
  }
}
