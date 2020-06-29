import 'package:flutter/material.dart';
import 'package:hotel_room_booking_app/controllers/customer/customer_controller.dart';
import 'package:hotel_room_booking_app/controllers/customer/customer_drawer_controller.dart';
import 'package:hotel_room_booking_app/controllers/customer/customer_login_controller.dart';
import 'package:hotel_room_booking_app/controllers/general_controller.dart';
import 'package:hotel_room_booking_app/dtos/customer/customer_booking_dto.dart';
import 'package:hotel_room_booking_app/user_data.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'customer_screen_bookings.dart';

// Class for the customer screen basket
class CustomerScreenBasket extends StatefulWidget {
  CustomerScreenBasket({Key key}) : super(key: key);

  @override
  State createState() => new CustomerScreenBasketState();
}

// Class for the customer screen basket state
class CustomerScreenBasketState extends State<CustomerScreenBasket> {
  // Variable for the state of loading
  bool loading = false;

  // Initialize listView object
  ListView listView = new ListView();

  // Initialize instance of the customer drawer controller
  CustomerDrawerController customerDrawerController =
      new CustomerDrawerController();

  // Initialize instance of the customer controller
  CustomerController customerController = new CustomerController();

  // Initialize instance of the customer login controller
  CustomerLoginController customerLoginController =
      new CustomerLoginController();

  // Initialize instance of the general controller
  GeneralController generalController = new GeneralController();

  @override
  // Function for the initial state
  void initState() {
    setState(() {
      // Set loading to true
      loading = true;
    });

    setState(() {
      // Create the list of bookings for the basket
      listView = createBasketListView();
    });

    setState(() {
      // Set loading to false
      loading = false;
    });
  }

  @override
  // Function for building the widget
  Widget build(BuildContext context) {
    // Initialize variable for is button is useable
    bool canBeUsed = true;

    // If the bookings list is null, set can be used to false
    if (UserData().bookings == null)
      canBeUsed = false;
    // Else, if the bookings list is empty, set can be used to false
    else if (UserData().bookings.isEmpty) canBeUsed = false;

    return new WillPopScope(
        onWillPop: () async => false,
        child: ModalProgressHUD(
          inAsyncCall: loading,
          child: new Scaffold(
            drawer: customerDrawerController.createCustomerDrawer(context),
            appBar: AppBar(
              title: Text('Basket'),
              backgroundColor: Colors.deepPurple,
            ),
            body: Center(child: listView),
            floatingActionButton: FloatingActionButton(
              key: Key('CheckoutBasket'),
              // When add button pressed,
              onPressed: canBeUsed
                  ? () {
                      checkoutBasketPressed();
                    }
                  : null,
              child: Icon(Icons.shopping_cart),
            ),
          ),
        ));
  }

  // Function for creating list view for the basket
  Widget createBasketListView() {
    // Retrieve list of customer booking objects
    List<CustomerBookingDTO> bookings = UserData().bookings;

    // If the list of rooms is empty,
    if (bookings == null || bookings.isEmpty) {
      // Return listView with only one object
      return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: 1,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("No bookings found in basket..."),
            );
          });
    }
    // Else,
    else {
      // Sort the bookings list alphabetically
      bookings.sort((a, b) {
        // Perform comparision of start dates
        int compare = a.startDateTime.compareTo(b.startDateTime);

        // If they are not the same date, return the result
        if (compare != 0)
          return compare;
        // Else, return comparison of the end dates
        else
          return a.endDateTime.compareTo(b.endDateTime);
      });

      // Set the format for date and time
      final format = DateFormat("dd-MM-yyyy");

      // Return listView with ListTile for each room object with dividers between them
      return ListView.separated(
        scrollDirection: Axis.vertical,
        key: Key('BookingsList'),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return ListTile(
              key: Key('booking' + index.toString()),
              title: Text('Hotel: ' +
                  bookings.elementAt(index).hotelName +
                  ', Room: ' +
                  bookings.elementAt(index).roomCode +
                  ', Total Cost: £' +
                  bookings.elementAt(index).totalCost.toString()),
              subtitle: Text('Dates: ' +
                  format.format(bookings.elementAt(index).startDateTime) +
                  ' - ' +
                  format.format(bookings.elementAt(index).endDateTime)),
              trailing: new IconButton(
                key: Key('removebooking' + index.toString()),
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Show new AlertDialog
                    showDialog(
                      context: context,
                      child: new AlertDialog(
                        title: new Text('Remove Booking'),
                        content: new Text(
                            'Are you sure you want to remove the booking from the basket?'),
                        actions: <Widget>[
                          new FlatButton(
                              child: new Text('Cancel',
                                  style: TextStyle(
                                      color: Colors.deepPurple, fontSize: 18)),
                              // When cancel pressed,
                              onPressed: () {
                                // Close the dialog
                                Navigator.pop(context);
                              }),
                          new FlatButton(
                              key: Key('RemoveBooking'),
                              child: new Text('OK',
                                  style: TextStyle(
                                      color: Colors.deepPurple, fontSize: 18)),
                              // When ok pressed,
                              onPressed: () async {
                                // Close the dialog
                                Navigator.pop(context);

                                // Remove the booking from the basket
                                UserData()
                                    .bookings
                                    .remove(bookings.elementAt(index));

                                // Update the data displayed
                                initState();
                              }),
                        ],
                      ),
                    );
                  }));
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      );
    }
  }

  // Function for when the checkout basket button is pressed
  Future<void> checkoutBasketPressed() async {
    // If the there is an internet connection,
    if (await generalController.checkInternetConnection()) {
      setState(() {
        // Set loading to true
        loading = true;
      });

      // Initialize bool value for availability
      bool available = true;

      // Initialize variable to contain an unavailable booking
      List<CustomerBookingDTO> unavailableBookings =
          new List<CustomerBookingDTO>();

      // Initialize bool value for if login is required
      bool loginRequired = false;

      // Get the current date time
      DateTime currentDateTime = new DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);

      // For each booking in the basket,
      for (CustomerBookingDTO booking in UserData().bookings) {
        // Format the start date time
        DateTime startDateTime = new DateTime(booking.startDateTime.year,
            booking.startDateTime.month, booking.startDateTime.day);

        // Format the end date time
        DateTime endDateTime = new DateTime(booking.endDateTime.year,
            booking.endDateTime.month, booking.endDateTime.day);

        // If the start date time is before the current time (booking in basket too long),
        if (startDateTime.isBefore(currentDateTime)) {
          // Set available to false
          available = false;

          // Update the unavailable booking
          unavailableBookings.add(booking);
        } else {
          // Check the room booking
          var result = await customerController.checkRoomBooking(
              booking.username,
              UserData().loginDTO.password,
              booking.roomId,
              startDateTime,
              endDateTime);

          // If the result was false
          if (result == false) {
            // Set available to false
            available = false;

            // Update the unavailable booking
            unavailableBookings.add(booking);
          }

          // Else, if the result was null, set login required to true
          else if (result == null) loginRequired = true;
        }

        // If relogin is required,
        if (loginRequired == true) {
          await showDialog(
              context: context,
              builder: (context) {
                return customerLoginController.forceReloginDialog(context);
              });

          // Rerun the method if login successful
          checkoutBasketPressed();
        }
        // If not all bookings available, set loading to false
        else if (available == false) {
          setState(() {
            // Set loading to false
            loading = false;
          });

          // Show AlertDialog
          showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      title: new Text('Booking No Longer Available'),
                      content: Container(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                                'At least one of the bookings in your basket is no longer available'),
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        new FlatButton(
                            key: Key('RemoveFromBasket'),
                            child: new Text('Remove',
                                style: TextStyle(
                                    color: Colors.deepPurple, fontSize: 18)),
                            // When ok pressed,
                            onPressed: () {
                              // For each unavailable customer booking, remove it from the list
                              for (CustomerBookingDTO cb in unavailableBookings)
                                UserData().bookings.remove(cb);

                              // Close the dialog
                              Navigator.pop(context);

                              initState();
                            }),
                      ],
                    );
                  },
                );
              });
        }
        // Else,
        else {
          // For each booking in the basket,
          for (CustomerBookingDTO booking in UserData().bookings) {
            // Complete the room booking
            await customerController.completeRoomBooking(
                booking.username,
                UserData().loginDTO.password,
                booking.roomId,
                booking.startDateTime,
                booking.endDateTime,
                booking.totalCost);
          }

          // Clear the list of bookings
          UserData().bookings.clear();

          setState(() {
            // Set loading to false
            loading = false;
          });

          // Pop the current screen
          Navigator.pop(context);

          // Navigate to the customer bookings screen
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CustomerScreenBookings()));
        }
      }
    }
    // Else (no internet connection),
    else {
      // Show AlertDialog
      showDialog(
          context: context,
          builder: (context) {
            return generalController.connectToInternetDialog();
          });
    }
  }
}
