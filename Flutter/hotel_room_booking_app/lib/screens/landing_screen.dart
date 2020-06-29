import 'package:flutter/material.dart';
import 'package:hotel_room_booking_app/screens/login/login_customer_screen.dart';
import 'package:hotel_room_booking_app/screens/login/login_employee_screen.dart';

// Class for the opening/landing screen of the application
class LandingScreen extends StatelessWidget {
  LandingScreen({Key key}) : super(key: key);

  @override
  // Function for building the widget
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Text(
                'Welcome To The Hotel Booking System',
                style: TextStyle(color: Colors.white, fontSize: 32),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(25),
            ),
            // Button to direct to the customer login screen
            RaisedButton(
              key: Key('GoToCustomerLogin'),
              color: Colors.deepPurpleAccent,
              // When the button is pressed,
              onPressed: () {
                // Navigate to the customer login screen
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginCustomerScreen()));
              },
              // The button text
              child: Text(
                'I Am A Customer',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
            ),
            // Button to direct to the employee login screen
            RaisedButton(
              key: Key('GoToEmployeeLogin'),
              color: Colors.deepPurpleAccent,
              // When the button is pressed,
              onPressed: () {
                // Navigate to the customer login screen
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginEmployeeScreen()));
              },
              // The button text
              child: Text(
                'I Am An Employee',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
