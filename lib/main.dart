import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_rental/screens/login.dart';
import 'package:car_rental/providers/car_provider.dart';
import 'package:car_rental/providers/booking_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CarProvider()),
        ChangeNotifierProvider(create: (context) => BookingProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Rental App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginScreen(), 
      debugShowCheckedModeBanner: false,
    );
  }
}