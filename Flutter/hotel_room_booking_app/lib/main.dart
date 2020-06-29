import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_room_booking_app/screens/administrator/administrator_screen.dart';
import 'package:hotel_room_booking_app/screens/administrator/administrator_screen_employees.dart';
import 'package:hotel_room_booking_app/screens/customer/customer_screen.dart';
import 'package:hotel_room_booking_app/screens/customer/customer_screen_basket.dart';
import 'package:hotel_room_booking_app/screens/customer/customer_screen_bookings.dart';
import 'package:hotel_room_booking_app/screens/customer/customer_screen_hotel_details.dart';
import 'package:hotel_room_booking_app/screens/customer/customer_screen_rooms.dart';
import 'package:hotel_room_booking_app/screens/employee/cleaning_employee_screen.dart';
import 'package:hotel_room_booking_app/screens/employee/maintenance_employee_screen.dart';
import 'package:hotel_room_booking_app/screens/employee/reception_employee_screen.dart';
import 'package:hotel_room_booking_app/screens/landing_screen.dart';
import 'package:hotel_room_booking_app/screens/login/login_administrator_screen.dart';
import 'package:hotel_room_booking_app/screens/login/login_customer_screen.dart';
import 'package:hotel_room_booking_app/screens/login/login_employee_screen.dart';

// Run the application
void main() => runApp(HotelBookingApp());

// Class for the application
class HotelBookingApp extends StatelessWidget {
  @override
  // Function for building the widget
  Widget build(BuildContext context) {
    // Set the device orientation to portrait only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // Return application with set routes
    return MaterialApp(
        theme: new ThemeData(
            primaryColor: Colors.deepPurple,
            accentColor: Colors.deepPurpleAccent),
        title: 'Hotel Booking System',
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => new LandingScreen(),
          '/login/customer': (BuildContext context) =>
              new LoginCustomerScreen(),
          '/login/employee': (BuildContext context) =>
              new LoginEmployeeScreen(),
          '/login/administrator': (BuildContext context) =>
              new LoginAdministratorScreen(),
          '/administrator': (BuildContext context) => new AdministratorScreen(),
          '/administrator/employees': (BuildContext context) =>
              new AdministratorScreenEmployees(),
          '/maintenance': (BuildContext context) =>
              new MaintenanceEmployeeScreen(),
          '/cleaning': (BuildContext context) => new CleaningEmployeeScreen(),
          '/reception': (BuildContext context) => new ReceptionEmployeeScreen(),
          '/customer': (BuildContext context) => new CustomerScreen(),
          '/customer/hotel/details': (BuildContext context) =>
              new CustomerScreenHotelDetails(),
          '/customer/hotel/rooms': (BuildContext context) =>
              new CustomerScreenRooms(),
          '/customer/basket': (BuildContext context) =>
              new CustomerScreenBasket(),
          '/customer/bookings': (BuildContext context) =>
              new CustomerScreenBookings(),
        });
  }
}
