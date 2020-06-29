import 'package:flutter/material.dart';
import 'package:hotel_room_booking_app/controllers/customer/customer_controller.dart';
import 'package:hotel_room_booking_app/controllers/customer/customer_drawer_controller.dart';
import 'package:hotel_room_booking_app/controllers/general_controller.dart';
import 'package:hotel_room_booking_app/dtos/customer/customer_booking_dto.dart';
import 'package:hotel_room_booking_app/user_data.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:intl/intl.dart';

// Class for the customer screen bookings
class CustomerScreenBookings extends StatefulWidget {
  CustomerScreenBookings({Key key}) : super(key: key);

  @override
  State createState() => new CustomerScreenBookingsState();
}

// Class for the customer screen bookings state
class CustomerScreenBookingsState extends State<CustomerScreenBookings> {
  // Variable for the state of loading
  bool loading = false;

  // Initialize instance of the general controller
  GeneralController generalController = new GeneralController();

  // Initialize instance of the customer drawer controller
  CustomerDrawerController customerDrawerController =
      new CustomerDrawerController();

  // Initialize instance of the customer controller
  CustomerController customerController = new CustomerController();

  // Initialize listView object
  ListView listView = new ListView();

  @override
  // Function for the initial state
  void initState() {
    setState(() {
      // Set loading to true
      loading = true;
    });

    // Create the list of hotels then,
    createBookingsListView().then((result) {
      // Set the listView object to display the hotels
      setState(() {
        listView = result;
      });
    });

    setState(() {
      // Set loading to false
      loading = false;
    });
  }

  @override
  // Function for building the widget
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: ModalProgressHUD(
          inAsyncCall: loading,
          child: new Scaffold(
            drawer: customerDrawerController.createCustomerDrawer(context),
            appBar: AppBar(
              title: Text('Bookings'),
              backgroundColor: Colors.deepPurple,
            ),
            body: Center(child: listView),
          ),
        ));
  }

  // Function for creating the list view for all bookings
  Future<ListView> createBookingsListView() async {
    // Retrieve list of customer booking objects
    List<CustomerBookingDTO> bookings =
        await customerController.getCustomerBookings();

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

    return ListView.separated(
      scrollDirection: Axis.vertical,
      key: Key('HotelDetails'),
      itemCount: 6,
      itemBuilder: (context, index) {
        if (index == 0) {
          return ListTile(
            title: Text('Past Bookings:',
                style: TextStyle(fontWeight: FontWeight.bold)),
          );
        } else if (index == 1) {
          return createPastBookingsListView(bookings);
        } else if (index == 2) {
          return ListTile(
            title: Text('Current Bookings:',
                style: TextStyle(fontWeight: FontWeight.bold)),
          );
        } else if (index == 3) {
          return createCurrentBookingsListView(bookings);
        } else if (index == 4) {
          return ListTile(
            title: Text('Upcoming Bookings:',
                style: TextStyle(fontWeight: FontWeight.bold)),
          );
        } else {
          return createFutureBookingsListView(bookings);
        }
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  // Function for creating the listview for the past bookings
  ListView createPastBookingsListView(List<CustomerBookingDTO> bookings) {
    // Initialize list of bookings
    List<CustomerBookingDTO> pastBookings = new List<CustomerBookingDTO>();

    // If the list of bookings is not null,
    if (bookings != null) {
      // For each customer booking,
      for (CustomerBookingDTO cb in bookings) {
        if ((cb.endDateTime.isBefore(new DateTime(DateTime.now().year,
                DateTime.now().month, DateTime.now().day))) ||
            (cb.complete)) pastBookings.add(cb);
      }
    }

    // If the list of rooms is empty,
    if (pastBookings == null || pastBookings.isEmpty) {
      // Return listView with only one object
      return ListView.builder(
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("No past bookings found..."),
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
        key: Key('PastBookingsList'),
        itemCount: pastBookings.length,
        itemBuilder: (context, index) {
          return ListTile(
            key: Key('booking' + index.toString()),
            title: Text(pastBookings.elementAt(index).hotelName +
                ', Room: ' +
                pastBookings.elementAt(index).roomCode +
                ', Total Cost: £' +
                pastBookings.elementAt(index).totalCost.toString()),
            subtitle: Text('Dates: ' +
                format.format(pastBookings.elementAt(index).startDateTime) +
                ' - ' +
                format.format(pastBookings.elementAt(index).endDateTime)),
            trailing: IconButton(
              key:
                  Key('CreateReview' + index.toString()),
              icon: Icon(Icons.rate_review),
              // When delete icon is pressed,
              onPressed:
                  (pastBookings.elementAt(index).review.description != null)
                      ? () {
                          editDeleteReviewDialog(pastBookings, index);
                        }
                      : () {
                          createReviewDialog(pastBookings, index);
                        },
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      );
    }
  }

  // Function for creating the listview for the current bookings
  ListView createCurrentBookingsListView(List<CustomerBookingDTO> bookings) {
    // Initialize list of bookings
    List<CustomerBookingDTO> currentBookings = new List<CustomerBookingDTO>();
    DateTime currentDateTime = new DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);

    // If the list of bookings is not null,
    if (bookings != null) {
      // For each customer booking,
      for (CustomerBookingDTO cb in bookings) {
        // If the end date is the at the same moment or after now,
        if ((cb.endDateTime.isAtSameMomentAs(currentDateTime)) ||
            (cb.endDateTime.isAfter(currentDateTime))) {
          // If the start date is at the same moment or before now, add the booking to the list
          if ((cb.startDateTime.isAtSameMomentAs(currentDateTime)) ||
              (cb.startDateTime.isBefore(currentDateTime))) {
            if (cb.complete == false) currentBookings.add(cb);
          }
        }
      }
    }

    // If the list of rooms is empty,
    if (currentBookings == null || currentBookings.isEmpty) {
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
      // Set the format for date and time
      final format = DateFormat("dd-MM-yyyy");

      // Return listView with ListTile for each room object with dividers between them
      return ListView.separated(
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        key: Key('CurrentBookingsList'),
        itemCount: currentBookings.length,
        itemBuilder: (context, index) {
          return ListTile(
            key: Key('booking' + index.toString()),
            title: Text(currentBookings.elementAt(index).hotelName +
                ', Room: ' +
                currentBookings.elementAt(index).roomCode +
                ', Total Cost: £' +
                currentBookings.elementAt(index).totalCost.toString()),
            subtitle: Text('Dates: ' +
                format.format(currentBookings.elementAt(index).startDateTime) +
                ' - ' +
                format.format(currentBookings.elementAt(index).endDateTime)),
            trailing: IconButton(
              key: Key('CreateMaintenanceRequest' + index.toString()),
              icon: Icon(Icons.restore),
              // When restore icon is pressed,
              onPressed: () {
                // If the booking already has a maintenance request,
                if (currentBookings.elementAt(index).hasMaintenanceRequest) {
                  // Show new AlertDialog
                  showDialog(
                    context: context,
                    child: new AlertDialog(
                      key: new Key('MaintenanceRequestActive'),
                      title: new Text('Maintenance Request In Progress'),
                      content: new Text(
                          'The maintenance request is being processed and an employee will deal with the request shortly'),
                      actions: <Widget>[
                        new FlatButton(
                            key: Key('ConfirmButton'),
                            child: new Text('OK',
                                style: TextStyle(
                                    color: Colors.deepPurple, fontSize: 18)),
                            // When ok pressed,
                            onPressed: () async {
                              // Close the dialog
                              Navigator.pop(context);
                            }),
                      ],
                    ),
                  );
                }
                // Else, if the booking has not been made active yet,
                else if (currentBookings.elementAt(index).active == false) {
                  // Show new AlertDialog
                  showDialog(
                    context: context,
                    child: new AlertDialog(
                      title: new Text('Booking Not Yet Active'),
                      content: new Text(
                          'Maintenance requests can only be made once the booking is activated at reception'),
                      actions: <Widget>[
                        new FlatButton(
                            child: new Text('OK',
                                style: TextStyle(
                                    color: Colors.deepPurple, fontSize: 18)),
                            // When ok pressed,
                            onPressed: () async {
                              // Close the dialog
                              Navigator.pop(context);
                            }),
                      ],
                    ),
                  );
                } else {
                  // Show AlertDialog
                  showDialog(
                    context: context,
                    builder: (context) {
                      // Controller for description text field
                      final descriptionController = new TextEditingController();

                      // Description invalid error message
                      String descriptionInvalid = "";

                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            key: new Key('CreateMaintenanceRequest'),
                            title: new Text('Create New Maintenance Request'),
                            content: Container(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: TextField(
                                        key: Key(
                                            'MaintenanceRequestDescription'),
                                        controller: descriptionController,
                                        obscureText: false,
                                        keyboardType: TextInputType.multiline,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Description',
                                          errorText: (descriptionInvalid != "")
                                              ? descriptionInvalid
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            actions: <Widget>[
                              new FlatButton(
                                  key: Key('CreateMaintenanceRequestCancel'),
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
                                  key: Key('CreateMaintenanceRequestConfirm'),
                                  child: new Text('OK',
                                      style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 18)),
                                  // When ok pressed,
                                  onPressed: () async {
                                    // Set initial value for invalid data entry to false
                                    bool invalid = false;

                                    // Created regex of valid characters
                                    final validCharacters =
                                        RegExp(r'^[a-zA-Z0-9]+$');

                                    // If the description is not between 3 and 150 characters
                                    if (descriptionController.text.length < 3 ||
                                        descriptionController.text.length >
                                            150) {
                                      // Set invalid to true and update error message
                                      setState(() {
                                        invalid = true;
                                        descriptionInvalid =
                                            "Must be between 3 and 150 characters";
                                      });
                                    }
                                    // Else, if description contains invalid characters,
                                    else if (!validCharacters
                                        .hasMatch(descriptionController.text)) {
                                      // Set invalid to true and update description error message
                                      setState(() {
                                        invalid = true;
                                        descriptionInvalid =
                                            "Cannot use symbols";
                                      });
                                    }
                                    // Else,
                                    else {
                                      // Update description error message
                                      setState(() {
                                        descriptionInvalid = "";
                                      });
                                    }

                                    // If any of the inputted values is invalid, do nothing
                                    if (invalid) {
                                    }
                                    // Else,
                                    else {
                                      // If the there is an internet connection,
                                      if (await generalController
                                          .checkInternetConnection()) {
                                        setState(() {
                                          // Set loading to true
                                          loading = true;
                                        });

                                        // Retrieve result from creating hotel review
                                        bool result = await customerController
                                            .createMaintenanceRequest(
                                                UserData().loginDTO.username,
                                                UserData().loginDTO.password,
                                                currentBookings
                                                    .elementAt(index)
                                                    .bookingId,
                                                descriptionController.text);

                                        setState(() {
                                          // Set loading to false
                                          loading = false;
                                        });

                                        // Close the dialog
                                        Navigator.pop(context);

                                        // Update the data displayed
                                        initState();

                                        // if successful,
                                        if (result == true) {
                                          // Show AlertDialog
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return AlertDialog(
                                                      title: new Text(
                                                          'Maintenance Request Submitted'),
                                                      content: Container(
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: Text(
                                                                'Your maintenance request has been submitted.'),
                                                          ),
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        new FlatButton(
                                                            key: Key(
                                                                'ConfirmButton'),
                                                            child: new Text(
                                                                'OK',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .deepPurple,
                                                                    fontSize:
                                                                        18)),
                                                            // When ok pressed,
                                                            onPressed: () {
                                                              // Close the dialog
                                                              Navigator.pop(
                                                                  context);
                                                            }),
                                                      ],
                                                    );
                                                  },
                                                );
                                              });
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
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      );
    }
  }

  // Function for creating the listview for the future bookings
  ListView createFutureBookingsListView(List<CustomerBookingDTO> bookings) {
    // Initialize list of bookings
    List<CustomerBookingDTO> futureBookings = new List<CustomerBookingDTO>();

    // If the list of bookings is not null,
    if (bookings != null) {
      // For each customer booking,
      for (CustomerBookingDTO cb in bookings) {
        if (cb.startDateTime.isAfter(new DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day)))
          futureBookings.add(cb);
      }
    }

    // If the list of rooms is empty,
    if (futureBookings == null || futureBookings.isEmpty) {
      // Return listView with only one object
      return ListView.builder(
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("No upcoming bookings found..."),
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
        key: Key('FutureBookingsList'),
        itemCount: futureBookings.length,
        itemBuilder: (context, index) {
          return ListTile(
            key: Key('booking' + index.toString()),
            title: Text(futureBookings.elementAt(index).hotelName +
                ', Room: ' +
                futureBookings.elementAt(index).roomCode +
                ', Total Cost: £' +
                futureBookings.elementAt(index).totalCost.toString()),
            subtitle: Text('Dates: ' +
                format.format(futureBookings.elementAt(index).startDateTime) +
                ' - ' +
                format.format(futureBookings.elementAt(index).endDateTime)),
            trailing: IconButton(
              key: Key('CancelBooking' + index.toString()),
              icon: Icon(Icons.cancel),
              // When delete icon is pressed,
              onPressed: () {
                // Show new AlertDialog
                showDialog(
                  context: context,
                  child: new AlertDialog(
                    title: new Text('Cancel Booking'),
                    content: new Text(
                        'Are you sure you want to cancel this booking?'),
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
                          key: Key('CancelBooking'),
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
                                  await customerController.cancelBooking(
                                      UserData().loginDTO.username,
                                      UserData().loginDTO.password,
                                      futureBookings
                                          .elementAt(index)
                                          .bookingId);

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
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      );
    }
  }

  // Function for the create review dialog
  void createReviewDialog(List<CustomerBookingDTO> bookings, int index) {
    // Show AlertDialog
    showDialog(
      context: context,
      builder: (context) {
        // Controller for rating text field
        final ratingController = new TextEditingController();

        // Rating invalid error message
        String ratingInvalid = "";

        // Controller for descrption text field
        final descriptionController = new TextEditingController();

        // Description invalid error message
        String descriptionInvalid = "";

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: new Text('Review Hotel'),
              key: Key('CreateReview'),
              content: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          key: Key('ReviewRating'),
                          controller: ratingController,
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Rating /100',
                            errorText:
                                (ratingInvalid != "") ? ratingInvalid : null,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          key: Key('ReviewDescription'),
                          controller: descriptionController,
                          obscureText: false,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Description',
                            errorText: (descriptionInvalid != "")
                                ? descriptionInvalid
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                    key: Key('CreateReviewCancel'),
                    child: new Text('Cancel',
                        style:
                            TextStyle(color: Colors.deepPurple, fontSize: 18)),
                    // When cancel pressed,
                    onPressed: () {
                      // Close the dialog
                      Navigator.pop(context);
                    }),
                new FlatButton(
                    key: Key('CreateReviewConfirm'),
                    child: new Text('OK',
                        style:
                            TextStyle(color: Colors.deepPurple, fontSize: 18)),
                    // When ok pressed,
                    onPressed: () async {
                      // Set initial value for invalid data entry to false
                      bool invalid = false;

                      // Created regex of valid characters
                      final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');

                      // Initialize int value for rating
                      int rating;

                      // If the value is not an int,
                      if (int.tryParse(ratingController.text) == null) {
                        // Set invalid to true and update error message
                        setState(() {
                          invalid = true;
                          ratingInvalid = "A whole number must be entered";
                        });
                      } else {
                        // Retrieve the rating as an int
                        rating = int.parse(ratingController.text);

                        // If rating is not in the scale,
                        if (rating < 1 || rating > 100) {
                          // Set invalid to true and update error message
                          setState(() {
                            invalid = true;
                            ratingInvalid = "Rating must be between 1 and 100";
                          });
                        }
                        // Else,
                        else {
                          // Update username error message
                          setState(() {
                            ratingInvalid = "";
                          });
                        }
                      }

                      // If the description is not between 3 and 150 characters
                      if (descriptionController.text.length < 3 ||
                          descriptionController.text.length > 150) {
                        // Set invalid to true and update error message
                        setState(() {
                          invalid = true;
                          descriptionInvalid =
                              "Must be between 3 and 150 characters";
                        });
                      }
                      // Else, if description contains invalid characters,
                      else if (!validCharacters
                          .hasMatch(descriptionController.text)) {
                        // Set invalid to true and update description error message
                        setState(() {
                          invalid = true;
                          descriptionInvalid = "Cannot use symbols";
                        });
                      }
                      // Else,
                      else {
                        // Update description error message
                        setState(() {
                          descriptionInvalid = "";
                        });
                      }

                      // If any of the inputted values is invalid, do nothing
                      if (invalid) {
                      }
                      // Else,
                      else {
                        // If the there is an internet connection,
                        if (await generalController.checkInternetConnection()) {
                          setState(() {
                            // Set loading to true
                            loading = true;
                          });

                          // Retrieve result from creating hotel review
                          bool result = await customerController.createReview(
                              UserData().loginDTO.username,
                              UserData().loginDTO.password,
                              bookings.elementAt(index).bookingId,
                              rating,
                              descriptionController.text);

                          setState(() {
                            // Set loading to false
                            loading = false;
                          });

                          // Close the dialog
                          Navigator.pop(context);

                          // Update the data displayed
                          initState();

                          // if successful,
                          if (result == true) {
                            // Show AlertDialog
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return AlertDialog(
                                        title: new Text('Review Submitted'),
                                        content: Container(
                                          child: SingleChildScrollView(
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                  'Your review for this booking has been submitted.'),
                                            ),
                                          ),
                                        ),
                                        actions: <Widget>[
                                          new FlatButton(
                                              key: Key('ConfirmButton'),
                                              child: new Text('OK',
                                                  style: TextStyle(
                                                      color: Colors.deepPurple,
                                                      fontSize: 18)),
                                              // When ok pressed,
                                              onPressed: () {
                                                // Close the dialog
                                                Navigator.pop(context);
                                              }),
                                        ],
                                      );
                                    },
                                  );
                                });
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
            );
          },
        );
      },
    );
  }

  // Create edit or delete review dialog
  void editDeleteReviewDialog(List<CustomerBookingDTO> bookings, int index) {
    // Show AlertDialog
    showDialog(
      context: context,
      builder: (context) {
        // Controller for rating text field
        final ratingController = new TextEditingController();

        // Set the current rating
        ratingController.text =
            bookings.elementAt(index).review.rating.toString();

        // Rating invalid error message
        String ratingInvalid = "";

        // Controller for description text field
        final descriptionController = new TextEditingController();

        // Set the current description
        descriptionController.text =
            bookings.elementAt(index).review.description;

        // Description invalid error message
        String descriptionInvalid = "";

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: new Text('Update Hotel Review'),
              key: Key('UpdateReview'),
              content: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          key: Key('ReviewRating'),
                          controller: ratingController,
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Rating /100',
                            errorText:
                                (ratingInvalid != "") ? ratingInvalid : null,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          key: Key('ReviewDescription'),
                          controller: descriptionController,
                          obscureText: false,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Description',
                            errorText: (descriptionInvalid != "")
                                ? descriptionInvalid
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  key: Key('CancelButton'),
                    child: new Text('Cancel',
                        style:
                            TextStyle(color: Colors.deepPurple, fontSize: 18)),
                    // When cancel pressed,
                    onPressed: () {
                      // Close the dialog
                      Navigator.pop(context);
                    }),
                new FlatButton(
                    key: Key('DeleteReviewConfirm'),
                    child: new Text('Delete',
                        style:
                            TextStyle(color: Colors.deepPurple, fontSize: 18)),
                    // When cancel pressed,
                    onPressed: () async {
                      // If the there is an internet connection,
                      if (await generalController.checkInternetConnection()) {
                        setState(() {
                          // Set loading to true
                          loading = true;
                        });

                        // Retrieve result from creating hotel review
                        bool result = await customerController.deleteReview(
                            UserData().loginDTO.username,
                            UserData().loginDTO.password,
                            bookings.elementAt(index).bookingId);

                        setState(() {
                          // Set loading to false
                          loading = false;
                        });

                        // Close the dialog
                        Navigator.pop(context);

                        // Update the data displayed
                        initState();

                        // if successful,
                        if (result == true) {
                          // Show AlertDialog
                          showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: new Text('Review Deleted'),
                                      content: Container(
                                        child: SingleChildScrollView(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                                'Your review for this hotel has been deleted.'),
                                          ),
                                        ),
                                      ),
                                      actions: <Widget>[
                                        new FlatButton(
                                            key: Key('ConfirmButton'),
                                            child: new Text('OK',
                                                style: TextStyle(
                                                    color: Colors.deepPurple,
                                                    fontSize: 18)),
                                            // When ok pressed,
                                            onPressed: () {
                                              // Close the dialog
                                              Navigator.pop(context);
                                            }),
                                      ],
                                    );
                                  },
                                );
                              });
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
                    }),
                new FlatButton(
                    key: Key('UpdateReviewConfirm'),
                    child: new Text('Update',
                        style:
                            TextStyle(color: Colors.deepPurple, fontSize: 18)),
                    // When ok pressed,
                    onPressed: () async {
                      // Set initial value for invalid data entry to false
                      bool invalid = false;

                      // Created regex of valid characters
                      final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');

                      // Initialize int value for rating
                      int rating;

                      // If the value is not an int,
                      if (int.tryParse(ratingController.text) == null) {
                        // Set invalid to true and update error message
                        setState(() {
                          invalid = true;
                          ratingInvalid = "A whole number must be entered";
                        });
                      } else {
                        // Retrieve the rating as an int
                        rating = int.parse(ratingController.text);

                        // If rating is not in the scale,
                        if (rating < 1 || rating > 100) {
                          // Set invalid to true and update error message
                          setState(() {
                            invalid = true;
                            ratingInvalid = "Rating must be between 1 and 100";
                          });
                        }
                        // Else,
                        else {
                          // Update username error message
                          setState(() {
                            ratingInvalid = "";
                          });
                        }
                      }

                      // If the description is not between 3 and 150 characters
                      if (descriptionController.text.length < 3 ||
                          descriptionController.text.length > 150) {
                        // Set invalid to true and update error message
                        setState(() {
                          invalid = true;
                          descriptionInvalid =
                              "Must be between 3 and 150 characters";
                        });
                      }
                      // Else, if description contains invalid characters,
                      else if (!validCharacters
                          .hasMatch(descriptionController.text)) {
                        // Set invalid to true and update description error message
                        setState(() {
                          invalid = true;
                          descriptionInvalid = "Cannot use symbols";
                        });
                      }
                      // Else,
                      else {
                        // Update description error message
                        setState(() {
                          descriptionInvalid = "";
                        });
                      }

                      // If the review information is unchanged,
                      if ((rating == bookings.elementAt(index).review.rating) &&
                          (descriptionController.text ==
                              bookings.elementAt(index).review.description)) {
                        // Set invalid to true and update description error message
                        setState(() {
                          invalid = true;
                          ratingInvalid = "No changes made";
                          descriptionInvalid = "No changes made";
                        });
                      }

                      // If any of the inputted values is invalid, do nothing
                      if (invalid) {
                      }
                      // Else,
                      else {
                        // If the there is an internet connection,
                        if (await generalController.checkInternetConnection()) {
                          setState(() {
                            // Set loading to true
                            loading = true;
                          });

                          // Retrieve result from creating hotel review
                          bool result = await customerController.editReview(
                              UserData().loginDTO.username,
                              UserData().loginDTO.password,
                              bookings.elementAt(index).bookingId,
                              rating,
                              descriptionController.text);

                          setState(() {
                            // Set loading to false
                            loading = false;
                          });

                          // Close the dialog
                          Navigator.pop(context);

                          // Update the data displayed
                          initState();

                          // if successful,
                          if (result == true) {
                            // Show AlertDialog
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return AlertDialog(
                                        title: new Text('Review Updated'),
                                        content: Container(
                                          child: SingleChildScrollView(
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                  'Your review for this booking has been updated.'),
                                            ),
                                          ),
                                        ),
                                        actions: <Widget>[
                                          new FlatButton(
                                              key: Key('ConfirmButton'),
                                              child: new Text('OK',
                                                  style: TextStyle(
                                                      color: Colors.deepPurple,
                                                      fontSize: 18)),
                                              // When ok pressed,
                                              onPressed: () {
                                                // Close the dialog
                                                Navigator.pop(context);
                                              }),
                                        ],
                                      );
                                    },
                                  );
                                });
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
            );
          },
        );
      },
    );
  }
}
