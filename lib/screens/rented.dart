import 'package:flutter/material.dart';
import 'package:car_rental/models/booking.dart';
import 'package:provider/provider.dart';
import 'package:car_rental/providers/booking_provider.dart';

class RecentlyRented extends StatelessWidget {
    final List<Booking> bookings;

  const RecentlyRented({Key? key, required this.bookings}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recently Rented"),
      ),
      body: Consumer<BookingProvider>(
        builder: (context, bookingProvider, child) {
          final bookings = bookingProvider.recentBookings; 
          return bookings.isNotEmpty
              ? ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return _buildRentalItem(context, booking, index, bookingProvider);
                  },
                )
              : const Center(
                  child: Text("No recent rentals."),
                );
        },
      ),
    );
  }

  Widget _buildRentalItem(BuildContext context, Booking booking, int index, BookingProvider bookingProvider) {
    return Dismissible(
      key: Key(booking.car.name + booking.startDate + index.toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm Delete"),
              content: const Text("Are you sure you want to delete this booking?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Delete"),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        bookingProvider.deleteBooking(index);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking deleted'),
            backgroundColor: Colors.red,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => _showEditDialog(context, booking, index, bookingProvider),
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
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text('Booked on: ${booking.startDate}', style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    Text('Duration: ${booking.duration} days', style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    Text('Phone: ${booking.phoneNumber}', style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    Text('Pickup: ${booking.pickupLocation}', style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showEditDialog(context, booking, index, bookingProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Booking booking, int index, BookingProvider bookingProvider) {
    final startDateController = TextEditingController(text: booking.startDate);
    final durationController = TextEditingController(text: booking.duration);
    final phoneController = TextEditingController(text: booking.phoneNumber);
    String selectedLocation = booking.pickupLocation;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Booking"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: startDateController,
                  decoration: const InputDecoration(labelText: 'Start Date'),
                  readOnly: true,
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) {
                      startDateController.text = "${picked.toLocal()}".split(' ')[0];
                    }
                  },
                ),
                TextField(
                  controller: durationController,
                  decoration: const InputDecoration(labelText: 'Duration (days)'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedLocation,
                  decoration: const InputDecoration(labelText: 'Pickup Location'),
                  items: ['Orrusey Branch', 'Prekleap Branch'].map((location) {
                    return DropdownMenuItem(
                      value: location,
                      child: Text(location),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedLocation = value;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                bookingProvider.updateBooking(
                  index: index,
                  newStartDate: startDateController.text,
                  newDuration: durationController.text,
                  newPhoneNumber: phoneController.text,
                  newPickupLocation: selectedLocation,
                );
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Booking updated successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}