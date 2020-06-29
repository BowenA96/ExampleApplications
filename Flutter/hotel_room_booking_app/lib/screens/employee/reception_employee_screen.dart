import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:hotel_room_booking_app/controllers/employee_controller.dart';
import 'package:hotel_room_booking_app/controllers/general_controller.dart';
import 'package:hotel_room_booking_app/dtos/customer/customer_booking_dto.dart';
import 'package:hotel_room_booking_app/user_data.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

// Class for the reception employee screen
class ReceptionEmployeeScreen extends StatefulWidget {
  ReceptionEmployeeScreen({Key key}) : super(key: key);

  @override
  State createState() => new ReceptionEmployeeScreenState();
}

// Class for the reception employee screen state
class ReceptionEmployeeScreenState extends State<ReceptionEmployeeScreen> {
  // Variable for the state of loading
  bool loading = false;

  // Initialize listView object
  ListView listView;

  // Initialize instance of the general controller
  GeneralController generalController = new GeneralController();

  // Create instance of the employee controller class
  EmployeeController employeeController = new EmployeeController();

  // Initialize variable to store a dateTime
  DateTime dateTime;

  // Datetime invalid error message
  String dateTimeInvalid = "";

  @override
  // Function for the initial state
  void initState() {
    setState(() {
      // Set loading to true
      loading = true;
    });

    // Create the list of cleaning details then,
    createBookingsListView(context).then((result) {
      // Set the listView object to display all the customer booking details
      setState(() {
        listView = result;
      });

      setState(() {
        // Set loading to false
        loading = false;
      });
    });
  }

  @override
  // Function for building the widget
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: new Scaffold(
        appBar: AppBar(
          title: Text('Reception Employee Page'),
          backgroundColor: Colors.deepPurple,
        ),
        // Display the listView
        body: Center(child: listView),
      ),
    );
  }

  // Function for creating list view
  Future<ListView> createBookingsListView(BuildContext context) async {
    // Retrieve the maintenance bookings
    List<CustomerBookingDTO> bookings = await employeeController.getBookings(
        UserData().loginEmployeeDTO.username,
        UserData().loginEmployeeDTO.hotelName);

    // Create list of bookings which are assigned to the employee
    List<CustomerBookingDTO> activeBookings = new List<CustomerBookingDTO>();

    // Create list of bookings which are unassigned to the employee
    List<CustomerBookingDTO> inActiveBookings = new List<CustomerBookingDTO>();

    // For each of the bookings,
    for (CustomerBookingDTO customerBookingDTO in bookings) {
      // If the username is for the employee, add it to the assigned list
      if (customerBookingDTO.active == true)
        activeBookings.add(customerBookingDTO);
      // Else, add it to the unassigned list
      else if (customerBookingDTO.complete == false)
        inActiveBookings.add(customerBookingDTO);
    }

    return ListView.separated(
      scrollDirection: Axis.vertical,
      key: Key('HotelDetails'),
      itemCount: 4,
      itemBuilder: (context, index) {
        if (index == 0) {
          return ListTile(
            title: Text('Active Customer Bookings:',
                style: TextStyle(fontWeight: FontWeight.bold)),
          );
        } else if (index == 1) {
          return createActiveBookingsList(activeBookings);
        } else if (index == 2) {
          return ListTile(
            title: Text('InActive Customer Bookings:',
                style: TextStyle(fontWeight: FontWeight.bold)),
          );
        } else {
          return createInActiveBookingsList(inActiveBookings);
        }
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  // Function for creating the listview for the unassigned bookings
  ListView createInActiveBookingsList(List<CustomerBookingDTO> bookings) {
    // If the list of bookings is empty,
    if (bookings == null || bookings.isEmpty) {
      // Return listView with only one object
      return ListView.builder(
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("No currently inactive bookings found..."),
            );
          });
    }
    // Else,
    else {
      // Set the format for date and time
      final format = DateFormat("dd-MM-yyyy");

      // Return listView with ListTile for each room object with dividers between them
      return ListView.separated(
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        key: Key('InActiveBookingsList'),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return ListTile(
              key: Key('InActiveBooking' + index.toString()),
              title: Text('Room: ' + bookings.elementAt(index).roomCode),
              subtitle: Text(
                  format.format(bookings.elementAt(index).startDateTime) +
                      ' - ' +
                      format.format(bookings.elementAt(index).endDateTime)),
              trailing: IconButton(
                key: Key('ActivateBooking' + index.toString()),
                icon: Icon(Icons.vpn_key),
                onPressed: () {
                  // Show new AlertDialog
                  showDialog(
                    context: context,
                    child: new AlertDialog(
                      title: new Text('Activate Customer Booking'),
                      content: new Text(
                          'Are you sure you want activate the customers booking for room: ' +
                              bookings.elementAt(index).roomCode +
                              '?'),
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
                            key: Key('ActivateBooking'),
                            child: new Text('OK',
                                style: TextStyle(
                                    color: Colors.deepPurple, fontSize: 18)),
                            // When ok pressed,
                            onPressed: () async {
                              // If the there is an internet connection,
                              if (await generalController
                                  .checkInternetConnection()) {
                                setState(() {
                                  // Set loading to true
                                  loading = true;
                                });

                                // Retrieve result from attempted delete of employee
                                bool result =
                                    await employeeController.bookingStarted(
                                        bookings.elementAt(index).bookingId,
                                        UserData().loginEmployeeDTO.username);

                                setState(() {
                                  // Set loading to false
                                  loading = false;
                                });

                                // Close the dialog
                                Navigator.pop(context);

                                // Update the data displayed
                                initState();
                              }
                              // Else (no internet connection),
                              else {
                                // Show AlertDialog
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return generalController
                                          .connectToInternetDialog();
                                    });
                              }
                            }),
                      ],
                    ),
                  );
                },
              ));
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      );
    }
  }

  // Function for creating the listview for the active bookings
  ListView createActiveBookingsList(List<CustomerBookingDTO> bookings) {
    // If the list of bookings is empty,
    if (bookings == null || bookings.isEmpty) {
      // Return listView with only one object
      return ListView.builder(
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("No active bookings found..."),
            );
          });
    }
    // Else,
    else {
      // Return listView with ListTile for each room object with dividers between them
      return ListView.separated(
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        key: Key('ActiveBookingsList'),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          // Set the format for date and time
          final format = DateFormat("dd-MM-yyyy");

          // Create variable for the latest possible date of the booking
          DateTime lastDate = bookings.elementAt(index).startDateTime.add(
              Duration(days: bookings.elementAt(index).maximumBookingLength));

          return ListTile(
            key: Key('ActiveBooking' + index.toString()),
            title: Text('Room: ' + bookings.elementAt(index).roomCode),
            subtitle: Text(
                format.format(bookings.elementAt(index).startDateTime) +
                    ' - ' +
                    format.format(bookings.elementAt(index).endDateTime)),
            trailing: Wrap(
              children: <Widget>[
                IconButton(
                  key: Key('CompleteBooking' + index.toString()),
                  icon: Icon(Icons.vpn_key),
                  onPressed: () {
                    // Show new AlertDialog
                    showDialog(
                      context: context,
                      child: new AlertDialog(
                        title: new Text('Complete Booking'),
                        content: new Text(
                            'Complete the customer booking for room: ' +
                                bookings.elementAt(index).roomCode),
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
                              key: Key('CompleteBooking'),
                              child: new Text('OK',
                                  style: TextStyle(
                                      color: Colors.deepPurple, fontSize: 18)),
                              // When ok pressed,
                              onPressed: () async {
                                // If the there is an internet connection,
                                if (await generalController
                                    .checkInternetConnection()) {
                                  setState(() {
                                    // Set loading to true
                                    loading = true;
                                  });

                                  // Retrieve result from attempted start maintenance progress
                                  bool result =
                                      await employeeController.bookingCompleted(
                                          bookings.elementAt(index).bookingId,
                                          UserData().loginEmployeeDTO.username);

                                  setState(() {
                                    // Set loading to false
                                    loading = false;
                                  });

                                  // Close the dialog
                                  Navigator.pop(context);

                                  // Update the data displayed
                                  initState();
                                }
                                // Else (no internet connection),
                                else {
                                  // Show AlertDialog
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return generalController
                                            .connectToInternetDialog();
                                      });
                                }
                              }),
                        ],
                      ),
                    );
                  },
                ),
                IconButton(
                  key: Key('ExtendBooking' + index.toString()),
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // If the end date is the same or later than the last possible date,
                    if (bookings
                            .elementAt(index)
                            .endDateTime
                            .isAfter(lastDate) ||
                        bookings
                            .elementAt(index)
                            .endDateTime
                            .isAtSameMomentAs(lastDate)) {
                      // Show new AlertDialog
                      showDialog(
                        context: context,
                        child: new AlertDialog(
                          title: new Text('Booking Can Not Be Extended'),
                          content: new Text(
                              'This booking can not be extended as it meets the maximum time for a booking at this hotel'),
                          actions: <Widget>[
                            new FlatButton(
                                child: new Text('OK',
                                    style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 18)),
                                // When ok pressed,
                                onPressed: () async {
                                  // Close the dialog
                                  Navigator.pop(context);
                                }),
                          ],
                        ),
                      );
                    } else {
                      // Show new AlertDialog
                      showDialog(
                        context: context,
                        child: new AlertDialog(
                          title: new Text('Extend Booking From ' +
                              format.format(
                                  bookings.elementAt(index).endDateTime)),
                          content: DateTimeField(
                            key: Key('DateTimeField'),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Date To Extend To',
                              errorText: (dateTimeInvalid != "")
                                  ? dateTimeInvalid
                                  : null,
                            ),
                            format: format,
                            onShowPicker: (context, currentValue) async {
                              final date = await showDatePicker(
                                  context: context,
                                  initialDate: currentValue ?? lastDate,
                                  firstDate: new DateTime(
                                      bookings
                                          .elementAt(index)
                                          .endDateTime
                                          .year,
                                      bookings
                                          .elementAt(index)
                                          .endDateTime
                                          .month,
                                      bookings
                                              .elementAt(index)
                                              .endDateTime
                                              .day +
                                          1),
                                  lastDate: lastDate);
                              if (date != null) {
                                dateTime = date;
                                return date;
                              } else {
                                return currentValue;
                              }
                            },
                          ),
                          actions: <Widget>[
                            new FlatButton(
                                child: new Text('Cancel',
                                    style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 18)),
                                // When cancel pressed,
                                onPressed: () {
                                  // Close the dialog
                                  Navigator.pop(context);
                                }),
                            new FlatButton(
                                key: Key('ExtendBooking'),
                                child: new Text('OK',
                                    style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 18)),
                                // When ok pressed,
                                onPressed: () async {
                                  // If date is not selected,
                                  if (dateTime == null) {
                                    setState(() {
                                      dateTimeInvalid =
                                          "Date to extend to must be selected";
                                    });
                                  } else {
                                    // Get the actual date
                                    DateTime actualDateTime = new DateTime(
                                        dateTime.year,
                                        dateTime.month,
                                        dateTime.day);

                                    // If the there is an internet connection,
                                    if (await generalController
                                        .checkInternetConnection()) {
                                      setState(() {
                                        // Set loading to true
                                        loading = true;
                                      });

                                      // Check if the booking can be extended
                                      bool extendable = await employeeController
                                          .checkBookingCanBeExtended(
                                              bookings
                                                  .elementAt(index)
                                                  .bookingId,
                                              UserData()
                                                  .loginEmployeeDTO
                                                  .username,
                                              actualDateTime);

                                      // If the room was not available,
                                      if (extendable == false) {
                                        setState(() {
                                          dateTimeInvalid =
                                              "The room is unavailable to be extended to the selected date";
                                        });

                                        setState(() {
                                          // Set loading to false
                                          loading = false;
                                        });
                                      } else {
                                        // Retrieve result from attempted delete of employee
                                        bool result = await employeeController
                                            .extendBooking(
                                                bookings
                                                    .elementAt(index)
                                                    .bookingId,
                                                UserData()
                                                    .loginEmployeeDTO
                                                    .username,
                                                actualDateTime);

                                        setState(() {
                                          // Set loading to false
                                          loading = false;
                                        });

                                        // Close the dialog
                                        Navigator.pop(context);

                                        // Update the data displayed
                                        initState();
                                      }
                                    }
                                    // Else (no internet connection),
                                    else {
                                      // Show AlertDialog
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return generalController
                                                .connectToInternetDialog();
                                          });
                                    }
                                  }
                                }),
                          ],
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      );
    }
  }
}
