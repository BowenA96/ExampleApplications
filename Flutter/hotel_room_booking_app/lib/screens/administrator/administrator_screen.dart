import 'package:flutter/material.dart';
import 'package:hotel_room_booking_app/controllers/administrator_controller.dart';
import 'package:hotel_room_booking_app/controllers/general_controller.dart';
import 'package:hotel_room_booking_app/dtos/hotel/hotel_dto.dart';
import 'package:hotel_room_booking_app/user_data.dart';
import 'administrator_screen_employees.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// Class for the administrator screen
class AdministratorScreen extends StatefulWidget {
  AdministratorScreen({Key key}) : super(key: key);

  @override
  State createState() => new AdministratorScreenState();
}

// Class for the administrator screen state
class AdministratorScreenState extends State<AdministratorScreen> {
  // Variable for the state of loading
  bool loading = false;

  // Initialize listView object
  ListView listView = new ListView();

  // Initialize instance of the general controller
  GeneralController generalController = new GeneralController();

  @override
  // Function for the initial state
  void initState() {
    setState(() {
      // Set loading to true
      loading = true;
    });

    // Create the list of hotels then,
    createAdminHotelListView(context).then((result) {
      // Set the listView object to display the hotels
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
          title: Text('Administrator Page'),
          backgroundColor: Colors.deepPurple,
        ),
        // Display the listView
        body: Center(child: listView),
      ),
    );
  }

  // Function for creating the listView of hotels
  Future<Widget> createAdminHotelListView(BuildContext context) async {
    // Create instance of administrator controller class
    AdministratorController controller = new AdministratorController();

    // Retrieve list of hotel objects
    List<HotelDTO> hotels = await controller.createListOfHotels(
        UserData().loginDTO.username, UserData().loginDTO.password);

    // If the list of hotels is empty,
    if (hotels == null || hotels.isEmpty) {
      // Return listView with only one object
      return ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("No hotels found..."),
            );
          });
    }
    // Else,
    else {
      // Return listView with ListTile for each hotel object with dividers between them
      return ListView.separated(
        key: Key('HotelsList'),
        itemCount: hotels.length,
        itemBuilder: (context, index) {
          return ListTile(
            key: Key('hotel' + index.toString()),
            title: Text(hotels.elementAt(index).hotelName),
            // When ListTile is selected,
            onTap: () async {
              // If the there is an internet connection,
              if (await generalController.checkInternetConnection()) {
                // Set the hotel
                UserData().hotelName = hotels.elementAt(index).hotelName;

                // Navigate to the administrator employees screen
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdministratorScreenEmployees()));
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
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      );
    }
  }
}
