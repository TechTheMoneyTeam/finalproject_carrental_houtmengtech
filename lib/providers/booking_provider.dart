import 'package:flutter/foundation.dart';
import 'package:car_rental/models/booking.dart';
import 'package:car_rental/models/car.dart';

class BookingProvider with ChangeNotifier {
  final List<Booking> _bookings = [];

  List<Booking> get bookings => _bookings;

 
  List<Booking> get recentBookings => _bookings.take(3).toList();

  void addBooking(Booking booking) {
    _bookings.add(booking);
    notifyListeners();
  }


  void createBooking({
    required Car car,
    required String startDate,
    required String duration,
    required String phoneNumber,
    required String pickupLocation,
  }) {
    final newBooking = Booking(
      car: car,
      startDate: startDate,
      duration: duration,
      phoneNumber: phoneNumber,
      pickupLocation: pickupLocation,
    );
    addBooking(newBooking);
  }


  void updateBooking({
    required int index,
    String? newStartDate,
    String? newDuration,
    String? newPhoneNumber,
    String? newPickupLocation,
  }) {
    if (index >= 0 && index < _bookings.length) {
      final oldBooking = _bookings[index];
      final updatedBooking = Booking(
        car: oldBooking.car,
        startDate: newStartDate ?? oldBooking.startDate,
        duration: newDuration ?? oldBooking.duration,
        phoneNumber: newPhoneNumber ?? oldBooking.phoneNumber,
        pickupLocation: newPickupLocation ?? oldBooking.pickupLocation,
      );
      
      _bookings[index] = updatedBooking;
      notifyListeners();
    } else {
      print('Error: Index $index out of bounds for bookings list.');
    }
  }


  void deleteBooking(int index) {
    if (index >= 0 && index < _bookings.length) {
      _bookings.removeAt(index);
      notifyListeners();
    } else {
      print('Error: Index $index out of bounds for bookings list.');
    }
  }


  List<Booking> getBookingsForCar(Car car) {
    return _bookings.where((booking) => booking.car == car).toList();
  }


  List<Booking> getBookingsByPhoneNumber(String phoneNumber) {
    return _bookings
        .where((booking) => booking.phoneNumber == phoneNumber)
        .toList();
  }


  List<Booking> getBookingsByLocation(String location) {
    return _bookings
        .where((booking) => booking.pickupLocation == location)
        .toList();
  }
}