import 'package:flutter/foundation.dart';
import 'package:car_rental/models/car.dart';

class CarProvider extends ChangeNotifier {
  List<Car> _cars = [
    Car(
      brand: 'Porsche',
      name: 'Porsche Panamera',
      imageUrl: 'assets/images/panamera.png',
      description: 'The Porsche Panamera is a mid/full-sized luxury vehicle...',
      speed: '315 km/h',
      seats: '5',
      engine: '4.0 L V8',
      stars: '4.5',
      price: 700,
      isFeatured: true,
    ),
    Car(
      brand: 'Lamborghini',
      name: 'Lamborghini Huracan',
      imageUrl: 'assets/images/huracan.png',
      description:
          'The Lamborghini Huracan is a high-performance sports car...',
      speed: '325 km/h',
      seats: '2',
      engine: '5.2 L V10',
      stars: '4.7',
      price: 900,
      isFeatured: true,
    ),
    Car(
      brand: 'Lexus',
      name: 'Rx 330',
      imageUrl: 'assets/images/330.png',
      description: 'The Lexus Rx330 is a family-sized sport SUV...',
      speed: '220 km/h',
      seats: '5',
      engine: '3.3 L V6',
      stars: '4.7',
      price: 200,
      isFeatured: true,
    ),
    Car(
      brand: 'Toyota',
      name: 'Toyota Camry',
      imageUrl: 'assets/images/camry.png',
      description: 'The Toyota Camry is a fuel-saving sedan car...',
      speed: '170 km/h',
      seats: '4',
      engine: '2.2 L I4',
      stars: '4.7',
      price: 100,
      isFeatured: true,
    ),
    Car(
      brand: 'Toyota',
      name: 'Toyota Highlander',
      imageUrl: 'assets/images/highlander.png',
      description: 'The Toyota Highlander is a fuel-saving SUV...',
      speed: '200 km/h',
      seats: '4',
      engine: '2.2 L I4',
      stars: '4.7',
      price: 100,
      isFeatured: true,
    ),
  ];

  List<Car> get cars => _cars;

  List<Car> get featuredCars => _cars.where((car) => car.isFeatured).toList();
  List<Car> get availableCars => _cars;

  void addCar(Car car) {
    _cars.add(car);
    notifyListeners();
  }

  void loadInitialCars(List<Car> initialCars) {
    _cars = initialCars;
    notifyListeners();
  }
}
