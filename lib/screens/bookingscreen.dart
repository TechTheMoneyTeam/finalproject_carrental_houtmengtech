import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/car.dart';
import '../providers/booking_provider.dart';

class BookingScreen extends StatefulWidget {
  final List<Car> availableCars;
  final VoidCallback onBookingCreated; 

  const BookingScreen({
    Key? key,
    required this.availableCars, required this.onBookingCreated,
  }) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _startDateController = TextEditingController();
  final _durationController = TextEditingController();
  final _phoneController = TextEditingController();
  Car? selectedCar;
  String? selectedLocation;

  final List<String> locations = ['Orrusey Branch', 'Prekleap Branch'];

  @override
  void dispose() {
    _startDateController.dispose();
    _durationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Booking'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCarSelection(),
              const SizedBox(height: 16),
              _buildBookingDetails(),
              const SizedBox(height: 24),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Car',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.availableCars.length,
                itemBuilder: (context, index) {
                  final car = widget.availableCars[index];
                  final isSelected = selectedCar == car;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCar = car;
                      });
                    },
                    child: Container(
                      width: 160,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                            child: Image.asset(
                              car.imageUrl,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              car.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.blue,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Booking Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildPhoneNumberField(),
            const SizedBox(height: 16),
            _buildPickupLocationDropdown(),
            const SizedBox(height: 16),
            _buildStartDateField(),
            const SizedBox(height: 16),
            _buildDurationField(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return TextFormField(
      controller: _phoneController,
      decoration: const InputDecoration(
        labelText: 'Phone Number',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.phone),
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a phone number';
        }
        // final phoneRegExp = RegExp(r'^(0|855)[0-9]{8}$');
        // if (!phoneRegExp.hasMatch(value)) {
        //   return 'Please enter a valid phone number';
        // }
        return null;
      },
    );
  }

  Widget _buildPickupLocationDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Pickup Location',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.location_on),
      ),
      value: selectedLocation,
      items: locations.map((location) {
        return DropdownMenuItem(
          value: location,
          child: Text(location),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedLocation = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a pickup location';
        }
        return null;
      },
    );
  }

  Widget _buildStartDateField() {
    return TextFormField(
      controller: _startDateController,
      decoration: const InputDecoration(
        labelText: 'Start Date',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: () async {
        FocusScope.of(context).unfocus();
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );
        if (picked != null) {
          setState(() {
            _startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
          });
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a start date';
        }
        return null;
      },
    );
  }

  Widget _buildDurationField() {
    return TextFormField(
      controller: _durationController,
      decoration: const InputDecoration(
        labelText: 'Duration (days)',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.timer),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter duration';
        }
        if (int.tryParse(value) == null || int.parse(value) <= 0) {
          return 'Please enter a valid duration';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitForm,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Create Booking',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  void _submitForm() {
    if (selectedCar == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a car'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      // Use the provider to create a new booking
      Provider.of<BookingProvider>(context, listen: false).createBooking(
        car: selectedCar!,
        startDate: _startDateController.text,
        duration: _durationController.text,
        phoneNumber: _phoneController.text,
        pickupLocation: selectedLocation!,
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking created successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear form
      setState(() {
        selectedCar = null;
        _startDateController.clear();
        _durationController.clear();
        _phoneController.clear();
        selectedLocation = null;
      });
    }
  }
}