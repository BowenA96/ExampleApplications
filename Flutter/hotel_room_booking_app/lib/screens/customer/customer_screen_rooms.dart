import 'package:flutter/material.dart';
import 'package:hotel_room_booking_app/controllers/customer/customer_controller.dart';
import 'package:hotel_room_booking_app/controllers/customer/customer_login_controller.dart';
import 'package:hotel_room_booking_app/dtos/customer/customer_booking_dto.dart';
import 'package:hotel_room_booking_app/dtos/hotel/hotel_room_dto.dart';
import 'package:hotel_room_booking_app/screens/customer/customer_screen_basket.dart';
import 'package:hotel_room_booking_app/screens/login/login_customer_screen.dart';
import 'package:hotel_room_booking_app/user_data.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// Class for the customer rooms screen
class CustomerScreenRooms extends StatefulWidget {
  CustomerScreenRooms({Key key}) : super(key: key);

  @override
  State createState() => new CustomerScreenRoomsState();
}

// Class for the customer room screen state
class CustomerScreenRoomsState extends State<CustomerScreenRooms> {
  // Variable for the state of loading
  bool loading = false;

  // Initialize listView object
  ListView listView = new ListView();

  // Initialize instance of the customer controller
  CustomerController customerController = new CustomerController();

  // Initialize instance of the customer login controller
  CustomerLoginController customerLoginController =
      new CustomerLoginController();

  @override
  // Function for the initial state
  void initState() {
    setState(() {
      // Set loading to true
      loading = true;
    });

    // Create the list of rooms then,
    createRoomListView().then((result) {
      // Set the listView object to display the rooms
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
            key: Key('CustomerRoomsPage'),
            title: Text('Hotel Rooms'),
            backgroundColor: Colors.deepPurple,
          ),
          body: Center(child: listView)),
    );
  }

  // Function for creating the listView of rooms
  Future<Widget> createRoomListView() async {
    // Create instance of customer controller class
    CustomerController controller = new CustomerController();

    // Retrieve list of room objects
    List<HotelRoomDTO> rooms = await controller.getHotelRooms(
        UserData().hotel.hotelName,
        UserData().startDateTime,
        UserData().endDateTime);

    // List of rooms to remove from list
    List<HotelRoomDTO> roomsToRemove = new List<HotelRoomDTO>();

    // For each room,
    for (HotelRoomDTO hotelRoomDTO in rooms) {
      // If flagged as unavailable, remove from list
      if (hotelRoomDTO.available == false)
        roomsToRemove.add(hotelRoomDTO);
      // Else,
      else {
        // If there are bookings in the basket
        if (UserData().bookings != null) {
          // Initialize bool for if in basket
          bool inBasket = false;

          // For each booking in basket,
          for (CustomerBookingDTO customerBookingDTO in UserData().bookings) {
            // If the booking is for the room selected,
            if ((customerBookingDTO.hotelName == UserData().hotel.hotelName) &&
                (customerBookingDTO.roomCode == hotelRoomDTO.roomCode)) {
              // If dates overlap, set in basket to true
              if (UserData()
                      .startDateTime
                      .isBefore(customerBookingDTO.endDateTime) ||
                  UserData()
                      .startDateTime
                      .isAtSameMomentAs(customerBookingDTO.endDateTime)) {
                if (UserData()
                        .endDateTime
                        .isAfter(customerBookingDTO.startDateTime) ||
                    UserData()
                        .endDateTime
                        .isAtSameMomentAs(customerBookingDTO.startDateTime))
                  inBasket = true;
              }
            }
          }

          // If there is a booking in the basket for the room, remove the room from the list
          if (inBasket) roomsToRemove.add(hotelRoomDTO);
        }
      }
    }

    // For each room to remove, remove the room from the list
    for (HotelRoomDTO room in roomsToRemove) rooms.remove(room);

    // If the list of rooms is empty,
    if (rooms == null || rooms.isEmpty) {
      // Return listView with only one object
      return ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("No rooms found..."),
            );
          });
    }
    // Else,
    else {
      // Sort the rooms list alphabetically
      rooms.sort((a, b) => a.roomCode.compareTo(b.roomCode));

      // Return listView with ListTile for each room object with dividers between them
      return ListView.separated(
        key: Key('RoomsList'),
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          // Create default string for disability access
          String disabilityString = "";

          // If room has disability access, update string
          if (rooms.elementAt(index).disabilityAccess)
            disabilityString = "Has Wheelchair Access, ";

          return ListTile(
              key: Key('room' + index.toString()),
              title: Text('Room: ' +
                  rooms.elementAt(index).roomCode +
                  ', Price Per Day: £' +
                  rooms.elementAt(index).price.toString()),
              subtitle: Text(disabilityString +
                  'No. Of Beds: ' +
                  rooms.elementAt(index).numberOfBeds.toString()),
              trailing: new IconButton(
                  key: Key('AddRoom' + index.toString()),
                  icon: Icon(Icons.add_circle),
                  onPressed: () => addRoomPressed(rooms, index)));
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      );
    }
  }

  // Function for when the add room button is pressed
  Future<void> addRoomPressed(List<HotelRoomDTO> rooms, int index) async {
    // While the login info is null,
    if (UserData().loginDTO == null) {
      // Show AlertDialog
      await showDialog(
          context: context,
          builder: (context) {
            return customerLoginController.loginRegisterDialog(context);
          });

      // If the login info is no longer null, retry button press
      if (UserData().loginDTO != null) addRoomPressed(rooms, index);
    } else {
      // If the bookings variable is null, initialize it as a new list
      if (UserData().bookings == null)
        UserData().bookings = new List<CustomerBookingDTO>();

      // Find the difference between the start and the end date
      var difference =
          UserData().endDateTime.difference(UserData().startDateTime);

      // Add the booking to the basket
      UserData().bookings.add(new CustomerBookingDTO(
          bookingId: 0,
          username: UserData().loginDTO.username,
          startDateTime: UserData().startDateTime,
          endDateTime: UserData().endDateTime,
          hotelName: UserData().hotel.hotelName,
          roomCode: rooms.elementAt(index).roomCode,
          roomId: rooms.elementAt(index).roomId,
          totalCost: (rooms.elementAt(index).price * (difference.inDays))));

      // Show AlertDialog
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: new Text('Added To Basket'),
                  content: Container(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text('Continue to your basket?'),
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                        key: Key('NoButton'),
                        child: new Text('No',
                            style: TextStyle(
                                color: Colors.deepPurple, fontSize: 18)),
                        // When ok pressed,
                        onPressed: () {
                          // Close the dialog
                          Navigator.pop(context);

                          // Update the data displayed
                          initState();
                        }),
                    new FlatButton(
                        key: Key('YesButton'),
                        child: new Text('Yes',
                            style: TextStyle(
                                color: Colors.deepPurple, fontSize: 18)),
                        // When ok pressed,
                        onPressed: () {
                          // Get the route
                          var route = new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new LoginCustomerScreen());

                          // Navigate to the customer login screen
                          Navigator.popUntil(
                              context, ((route) => route.isFirst));

                          // Navigate to the customer basket screen
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CustomerScreenBasket()));
                        }),
                  ],
                );
              },
            );
          });
    }
  }
}
