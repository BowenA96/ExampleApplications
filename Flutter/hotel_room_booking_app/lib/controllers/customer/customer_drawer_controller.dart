import 'package:flutter/material.dart';
import 'package:hotel_room_booking_app/controllers/customer/customer_login_controller.dart';
import 'package:hotel_room_booking_app/screens/customer/customer_screen.dart';
import 'package:hotel_room_booking_app/screens/customer/customer_screen_basket.dart';
import 'package:hotel_room_booking_app/screens/customer/customer_screen_bookings.dart';
import 'package:hotel_room_booking_app/user_data.dart';

// Class for performing customer drawer functionality
class CustomerDrawerController {
  // Create instance of the login controller
  CustomerLoginController customerLoginController =
      new CustomerLoginController();

  // Function for creating the customer drawer
  Drawer createCustomerDrawer(BuildContext context) {
    // Initialize number of bookings variable
    int bookings = 0;

    // If the bookings list is not null
    if (UserData().bookings != null) bookings = UserData().bookings.length;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 90,
            child: DrawerHeader(
              child: Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              decoration: BoxDecoration(color: Colors.deepPurple),
            ),
          ),
          Container(
            height: 90,
            child: Card(
              child: ListTile(
                trailing: Icon(Icons.hotel),
                title: Text('Home'),
                onTap: () {
                  // Call navigation button pressed function
                  navigationButtonPressed("Home", context);
                },
              ),
            ),
          ),
          Container(
            height: 90,
            child: Card(
              child: ListTile(
                trailing: Icon(Icons.shopping_basket),
                title: Row(
                  children: <Widget>[
                    Text('Basket'),
                    MaterialButton(
                      onPressed: () {
                        // Call navigation button pressed function
                        navigationButtonPressed("Basket", context);
                      },
                      color: Colors.deepPurpleAccent,
                      textColor: Colors.white,
                      child: Text(bookings.toString()),
                      padding: EdgeInsets.all(0),
                      shape: CircleBorder(),
                      minWidth: 50,
                    ),
                  ],
                ),
                onTap: () {
                  // Call navigation button pressed function
                  navigationButtonPressed("Basket", context);
                },
              ),
            ),
          ),
          Container(
            height: 90,
            child: Card(
              child: ListTile(
                trailing: Icon(Icons.bookmark),
                title: Text('Bookings'),
                key: Key('Bookings'),
                onTap: () {
                  // Call navigation button pressed function
                  navigationButtonPressed("Bookings", context);
                },
              ),
            ),
          ),
          Container(
            height: 90,
            child: Card(
              child: ListTile(
                trailing: Icon(Icons.exit_to_app),
                title: Text('Logout / Exit'),
                key: Key('Logout'),
                onTap: () {
                  // Clear the user data
                  UserData().loginDTO = null;
                  UserData().hotel = null;
                  UserData().bookings = null;

                  // Close the menu
                  Navigator.pop(context);

                  // Pop navigation twice
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  // Function for a navigation button being pressed
  Future<void> navigationButtonPressed(
      String type, BuildContext context) async {
    if (type == "Basket") {
      // Close the menu
      Navigator.pop(context);

      // If currently on the customer basket screen, do nothing
      if (context.widget is CustomerScreenBasket) {
      }
      // Else,
      else {
        // While the login info is null,
        if (UserData().loginDTO == null) {
          // Show AlertDialog
          await showDialog(
              context: context,
              builder: (context) {
                return customerLoginController.loginRegisterDialog(context);
              });

          // If the login info is no longer null, retry button press
          if (UserData().loginDTO != null)
            navigationButtonPressed(type, context);
        } else {
          // Pop the current screen
          Navigator.pop(context);

          // Navigate to the customer basket screen
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CustomerScreenBasket()));
        }
      }
    } else if (type == "Bookings") {
      // Close the menu
      Navigator.pop(context);

      // If currently on the customer bookings screen, do nothing
      if (context.widget is CustomerScreenBookings) {
      }
      // Else,
      else {
        // While the login info is null,
        if (UserData().loginDTO == null) {
          // Show AlertDialog
          await showDialog(
              context: context,
              builder: (context) {
                return customerLoginController.loginRegisterDialog(context);
              });

          // If the login info is no longer null, retry button press
          if (UserData().loginDTO != null)
            navigationButtonPressed(type, context);
        } else {
          // Pop the current screen
          Navigator.pop(context);

          // Navigate to the customer bookings screen
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CustomerScreenBookings()));
        }
      }
    } else {
      // Close the menu
      Navigator.pop(context);

      // If currently on the customer home screen, do nothing
      if (context.widget is CustomerScreen) {
      }
      // Else,
      else {
        // Pop the current screen
        Navigator.pop(context);

        // Navigate to the customer home screen
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CustomerScreen()));
      }
    }
  }
}
