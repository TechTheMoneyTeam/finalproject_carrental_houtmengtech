class Car {
  final String brand;
  final String name;
  final String imageUrl;
  final String description;
  final String speed;
  final String seats;
  final String engine;
  final String stars;
  final num price; 
  final bool isFeatured; 

  Car({
    required this.brand,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.speed,
    required this.seats,
    required this.engine,
    required this.stars,
    required this.price,
    this.isFeatured = false, 
  });

  
}