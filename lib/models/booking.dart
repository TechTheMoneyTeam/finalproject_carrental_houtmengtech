import 'car.dart';
class Booking {

  final Car car;
  final String startDate;
  final String duration;
  final String phoneNumber;
  final String pickupLocation;

  Booking({
    required this.car,
    required this.startDate,
    required this.duration,
    required this.phoneNumber,
    required this.pickupLocation,
  });
}