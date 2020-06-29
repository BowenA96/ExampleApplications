import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hotel_room_booking_app/controllers/customer/customer_controller.dart';
import 'package:hotel_room_booking_app/controllers/general_controller.dart';
import 'package:hotel_room_booking_app/dtos/hotel/hotel_attraction_dto.dart';
import 'package:hotel_room_booking_app/dtos/hotel/hotel_review_dto.dart';
import 'package:hotel_room_booking_app/screens/customer/customer_screen_rooms.dart';
import 'package:hotel_room_booking_app/user_data.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// Class for the customer hotel details screen
class CustomerScreenHotelDetails extends StatefulWidget {
  CustomerScreenHotelDetails({Key key}) : super(key: key);

  @override
  State createState() => new CustomerScreenHotelDetailsState();
}

// Class for the customer hotel details screen state
class CustomerScreenHotelDetailsState
    extends State<CustomerScreenHotelDetails> {
  // Variable for the state of loading
  bool loading = false;

  // Initialize widget
  Widget details;

  // Create instance of customer controller class
  CustomerController customerController = new CustomerController();

  // Initialize instance of the general controller
  GeneralController generalController = new GeneralController();

  // List of reviews
  ListView reviews;

  // List of attractions
  ListView attractions;

  // Initialize variable to store the start date time
  DateTime startDateTime;

  // Initialize variable to store the end date time
  DateTime endDateTime;

  // Start date invalid error message
  String startDateInvalid = "";

  // End date invalid error message
  String endDateInvalid = "";

  @override
  // Function for the initial state
  void initState() {
    setState(() {
      // Set loading to true
      loading = true;
    });

    // Create the list of hotels then,
    getHotelDetails().then((result) {
      // Set the listView object to display the hotels
      setState(() {
        details = result;
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
          title: Text('Hotel Details'),
          backgroundColor: Colors.deepPurple,
        ),
        body: Center(child: details),
      ),
    );
  }

  Future<Widget> getHotelDetails() async {
    // Retrieve the hotels reviews
    reviews = await createHotelReviewsListView();

    // Retrieve the hotels attractions
    attractions = await createHotelAttractionsListView();

    return createHotelDetails();
  }

  // Function for displaying hotel details information
  Future<Widget> createHotelDetails() async {
    // Set the format for date and time
    final format = DateFormat("dd-MM-yyyy");

    // Retrieve the current time
    DateTime currentTime = DateTime.now();

    // Set the latest possible booking time
    DateTime lastDate = new DateTime(currentTime.year,
        currentTime.month + UserData().hotel.maximumLeadTime, currentTime.day);

    return ListView.separated(
      scrollDirection: Axis.vertical,
      key: Key('HotelDetails'),
      itemCount: 8,
      itemBuilder: (context, index) {
        if (index == 0) {
          return ListTile(
            title: Center(child: Text(UserData().hotel.hotelName.toString())),
            subtitle: Center(
              child: Text(UserData().hotel.maximumLeadTime.toString() +
                  ' months max lead time, ' +
                  UserData().hotel.maximumBookingLength.toString() +
                  ' days max booking length.'),
            ),
          );
        } else if (index == 1) {
          return ListTile(
            title: DateTimeField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Start Date',
                errorText: (startDateInvalid != "") ? startDateInvalid : null,
              ),
              format: format,
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                    context: context,
                    initialDate: currentValue ?? DateTime.now(),
                    firstDate: currentTime,
                    lastDate: lastDate);
                if (date != null) {
                  startDateTime = date;
                  return date;
                } else {
                  return currentValue;
                }
              },
            ),
            key: Key('StartDate'),
          );
        } else if (index == 2) {
          return ListTile(
            title: DateTimeField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'End Date',
                errorText: (endDateInvalid != "") ? endDateInvalid : null,
              ),
              format: format,
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                    context: context,
                    initialDate:
                        currentValue ?? DateTime.now().add(Duration(days: 1)),
                    firstDate: currentTime,
                    lastDate: lastDate);
                if (date != null) {
                  endDateTime = date;
                  return date;
                } else {
                  return currentValue;
                }
              },
            ),
            key: Key('EndDate'),
          );
        } else if (index == 3) {
          return ListTile(
            title: RaisedButton(
              key: Key('CheckRooms'),
              color: Colors.deepPurpleAccent,
              // When the button is pressed,
              onPressed: () async {
                // If either date is not selected,
                if (endDateTime == null || startDateTime == null) {
                  setState(() {
                    startDateInvalid =
                        "Both a start date and end date must be selected";
                    endDateInvalid =
                        "Both a start date and end date must be selected";
                    createHotelDetails().then((result) {
                      // Set the listView object to display the hotels
                      setState(() {
                        details = result;
                      });
                    });
                  });
                } else {
                  // Format the start date time
                  DateTime actualStartDateTime = new DateTime(
                      startDateTime.year,
                      startDateTime.month,
                      startDateTime.day);

                  // Format the end date time
                  DateTime actualEndDateTime = new DateTime(
                      endDateTime.year, endDateTime.month, endDateTime.day);

                  // If the there is an internet connection,
                  if (await generalController.checkInternetConnection()) {
                    // If the start date and end date are not eligible,
                    if (actualEndDateTime.isBefore(actualStartDateTime) ||
                        actualEndDateTime
                            .isAtSameMomentAs(actualStartDateTime)) {
                      createHotelDetails().then((result) {
                        // Set the listView object to display the hotels
                        setState(() {
                          startDateInvalid =
                              "Start date must be before end date";
                          endDateInvalid = "End date must be after start date";
                          details = result;
                        });
                      });
                    } else if ((actualEndDateTime
                            .difference(actualStartDateTime)
                            .inDays) >
                        UserData().hotel.maximumLeadTime) {
                      createHotelDetails().then((result) {
                        // Set the listView object to display the hotels
                        setState(() {
                          startDateInvalid =
                              "Start date must be within the maximum lead time of the end date";
                          endDateInvalid =
                              "End date must be within the maximum lead time of the start date";
                          details = result;
                        });
                      });
                    } else {
                      // Update the start date time stored
                      UserData().startDateTime = actualStartDateTime;

                      // Update the end date time stored
                      UserData().endDateTime = actualEndDateTime;

                      // Navigate to the customer hotel details screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomerScreenRooms()));
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
              },
              // The button text
              child: Text('Check Rooms',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          );
        } else if (index == 4) {
          return ListTile(
            title: Text('Attractions:',
                style: TextStyle(fontWeight: FontWeight.bold)),
          );
        } else if (index == 5) {
          return attractions;
        } else if (index == 6) {
          return ListTile(
            title:
                Text('Reviews:', style: TextStyle(fontWeight: FontWeight.bold)),
          );
        } else {
          return reviews;
        }
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  Future<ListView> createHotelReviewsListView() async {
    // List of hotel reviews
    List<HotelReviewDTO> reviews =
        await customerController.getHotelReviews(UserData().hotel.hotelName);

    // If the list of reviews is empty,
    if (reviews == null || reviews.isEmpty) {
      // Return listView with only one object
      return ListView.builder(
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("Hotel currently has no reviews."),
            );
          });
    }
    // Else,
    else {
      // Return listView with ListTile for each attractions object with dividers between them
      return ListView.separated(
        key: Key('ReviewsList'),
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          return ListTile(
            key: Key('attraction' + index.toString()),
            title: Text(reviews.elementAt(index).rating.toString()),
            subtitle: Text(reviews.elementAt(index).description),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      );
    }
  }

  Future<ListView> createHotelAttractionsListView() async {
    // List of hotel attractions
    List<HotelAttractionDTO> attractions = await customerController
        .getHotelAttractions(UserData().hotel.hotelName);

    // If the list of attractions is empty,
    if (attractions == null || attractions.isEmpty) {
      // Return listView with only one object
      return ListView.builder(
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("Hotel has no nearby attractions."),
            );
          });
    }
    // Else,
    else {
      // Return listView with ListTile for each attractions object with dividers between them
      return ListView.separated(
        key: Key('AttractionsList'),
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: attractions.length,
        itemBuilder: (context, index) {
          return ListTile(
            key: Key('attraction' + index.toString()),
            title: Text(attractions.elementAt(index).attractionName),
            subtitle: Text(attractions.elementAt(index).description +
                " - up to " +
                attractions.elementAt(index).distance.toString() +
                "km from hotel"),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      );
    }
  }
}
