import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_rental/models/car.dart';
import 'package:car_rental/models/booking.dart';
import 'package:car_rental/screens/detail.dart';
import 'package:car_rental/screens/bookingscreen.dart';
import 'package:car_rental/screens/searchscreen.dart';
import 'package:car_rental/screens/rented.dart';
import 'package:car_rental/providers/car_provider.dart';
import 'package:car_rental/providers/booking_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            _buildTabBar(),
            _buildSearchSection(),
            _buildCategoryChips(),
            _buildFeaturedCarsSection(),
            _buildRecentRentalsSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        
          final availableCars =
              Provider.of<CarProvider>(context, listen: false).availableCars;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingScreen(
                availableCars: availableCars,
                        onBookingCreated: () {
          Navigator.pop(context); 
        },
              ),
            ),
          );
        },
        child: const Icon(Icons.bookmark_border),
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      floating: true,
      snap: true,
      title: const Text(
        'Car Rental',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
          
          },
        ),
        IconButton(
          icon: const Icon(Icons.account_circle_outlined),
          onPressed: () {
            
          },
        ),
      ],
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
    );
  }

  SliverToBoxAdapter _buildTabBar() {
    return SliverToBoxAdapter(
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Home'),
          Tab(text: 'Search'),
          Tab(text: 'Rented'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
       
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
              break;
case 2:
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return Consumer<BookingProvider>(
          builder: (context, bookingProvider, child) {
            final bookings = bookingProvider.bookings; 
            return RecentlyRented(bookings: bookings); 
          },
        );
      },
    ),
  );
  break;
          }
        },
      ),
    );
  }

  SliverPadding _buildSearchSection() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      sliver: SliverToBoxAdapter(
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search for cars...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.tune),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          onSubmitted: (value) {
            
          },
        ),
      ),
    );
  }

  SliverPadding _buildCategoryChips() {
    final List<String> categories = [
      'All',
      'Luxury',
      'Economy',
      'SUV',
      'Sports'
    ];

    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      sliver: SliverToBoxAdapter(
        child: SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 16 : 8,
                  right: index == categories.length - 1 ? 16 : 8,
                ),
                child: ChoiceChip(
                  label: Text(categories[index]),
                  selected: selectedCategory == categories[index],
                  onSelected: (bool selected) {
                    setState(() {
                      selectedCategory = categories[index];
                    });
                  },
                  selectedColor: Colors.blue[100],
                  backgroundColor: Colors.grey[200],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  SliverPadding _buildFeaturedCarsSection() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Featured Cars',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SearchScreen()),
                      );
                    },
                    child: const Text('See All'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 250,
              child: Consumer<CarProvider>(
                builder: (context, carProvider, child) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: carProvider.featuredCars.length,
                    itemBuilder: (context, index) {
                      final car = carProvider.featuredCars[index];
                      return _buildFeaturedCarCard(car);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCarCard(Car car) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailScreen(car: car)),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                car.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${car.price}/day',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text(car.stars),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverPadding _buildRecentRentalsSection() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Rentals',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      final bookings =
                          Provider.of<BookingProvider>(context, listen: false)
                              .bookings;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RecentlyRented(bookings: bookings),
                        ),
                      );
                    },
                    child: const Text('See All'),
                  ),
                ],
              ),
            ),
            Consumer<BookingProvider>(
              builder: (context, bookingProvider, child) {
                return Column(
                  children: bookingProvider.recentBookings
                      .map((booking) => _buildRecentRentalItem(booking))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentRentalItem(Booking booking) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailScreen(car: booking.car)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                booking.car.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.car.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Booked on ${booking.startDate}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Duration: ${booking.duration} days',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}