
import 'package:flutter/material.dart';
import 'package:car_rental/models/car.dart';
import 'package:car_rental/screens/bookingscreen.dart';


class DetailScreen extends StatelessWidget {
  final Car car;

  const DetailScreen({Key? key, required this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                _buildTopNavigation(context, size),
                _buildCarHeader(),
                _buildCarImage(),
                _buildDescriptionSection(),
                _buildSpecsSection(),
                _buildPricesSection(size),
                const SizedBox(height: 100),
              ],
            ),
            _buildRentButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavigation(BuildContext context, Size size) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavigationButton(
            context,
            'assets/images/back-arrow.png',
            () => Navigator.of(context).pop(),
          ),
          _buildNavigationButton(
            context,
            'assets/images/active-saved.png',
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton(BuildContext context, String imagePath, VoidCallback onTap) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: size.width * 0.1,
        width: size.width * 0.1,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Image.asset(imagePath),
        ),
      ),
    );
  }

  Widget _buildCarHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 0, 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 5),
          Text(
            car.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarImage() {
    return Center(
      child: Hero(
        tag: car.imageUrl,
        child: Image.asset(car.imageUrl),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 49, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(car.description),
        ],
      ),
    );
  }

  Widget _buildSpecsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Specs',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSpecItem('assets/images/speed.png', car.speed, 'Max. Speed'),
              _buildSpecItem('assets/images/seat.png', car.seats, 'Seats'),
              _buildSpecItem('assets/images/engine.png', car.engine, 'Engine'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecItem(String imagePath, String value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(imagePath),
        const SizedBox(height: 3),
        Text(value),
        const SizedBox(height: 3),
        Text(label),
      ],
    );
  }

  Widget _buildPricesSection(Size size) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Prices',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPriceContainer(size, car.price * 120, '/year'),
              _buildPriceContainer(size, car.price * 30, '/month'),
              _buildPriceContainer(size, car.price, '/day'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceContainer(Size size, num price, String period) {
    return Container(
      height: size.height * 0.1,
      width: size.width * 0.28,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('\$${price.toStringAsFixed(2)}'),
          const SizedBox(height: 2),
          Text(period),
        ],
      ),
    );
  }

  Widget _buildRentButton(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        height: 53,
        width: MediaQuery.of(context).size.width - 32,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: ElevatedButton(
          onPressed: () => _navigateToBooking(context),
          child: const Text('Rent This Car'),
        ),
      ),
    );
  }

  void _navigateToBooking(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(
          
          availableCars: [car],
                  onBookingCreated: () {
          Navigator.pop(context); 
        },
     
        ),
        
      ),
    );
  }
}