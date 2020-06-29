import 'package:flutter/material.dart';
import 'package:hotel_room_booking_app/controllers/customer/customer_controller.dart';
import 'package:hotel_room_booking_app/controllers/customer/customer_drawer_controller.dart';
import 'package:hotel_room_booking_app/controllers/general_controller.dart';
import 'package:hotel_room_booking_app/dtos/hotel/hotel_dto.dart';
import 'package:hotel_room_booking_app/screens/customer/customer_screen_hotel_details.dart';
import 'package:hotel_room_booking_app/user_data.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// Class for the customer screen
class CustomerScreen extends StatefulWidget {
  CustomerScreen({Key key}) : super(key: key);

  @override
  State createState() => new CustomerScreenState();
}

// Class for the customer screen state
class CustomerScreenState extends State<CustomerScreen> {
  // Variable for the state of loading
  bool loading = false;

  // Initialize listView object
  ListView listView = new ListView();

  // Initialize instance of the general controller
  GeneralController generalController = new GeneralController();

  // Initialize instance of the customer drawer controller
  CustomerDrawerController customerDrawerController =
      new CustomerDrawerController();

  // List of hotels
  List<HotelDTO> hotels;

  // Initialize location variable
  Location location = new Location();

  // If sorting by location distance
  bool sortByLocation = false;

  // Get the global key
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  // Function for the initial state
  void initState() {
    setState(() {
      // Set loading to true
      loading = true;
    });

    // Create the list of hotels then,
    getHotelList().then((result) {
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
    return new WillPopScope(
        onWillPop: () async => false,
        child: ModalProgressHUD(
          inAsyncCall: loading,
          child: new Scaffold(
            key: globalKey,
            drawer: customerDrawerController.createCustomerDrawer(context),
            appBar: AppBar(
              title: Text('Home'),
              backgroundColor: Colors.deepPurple,
              actions: <Widget>[
                IconButton(
                    key: Key('SortAlpha'),
                    icon: Icon(
                      Icons.sort_by_alpha,
                    ),
                    onPressed: () async {
                      print("Sort by location is " + sortByLocation.toString());
                      // If sorting by location,
                      if (sortByLocation == true) {
                        setState(() {
                          // Set loading to true
                          loading = true;
                        });

                        // Create list of hotels then,
                        createHotelListView().then((result) {
                          // Set the list view to the newly created list
                          setState(() {
                            listView = result;
                          });

                          setState(() {
                            // Set loading to false
                            loading = false;
                          });
                        });

                        // Do stuff the set sortByLocation to false
                        sortByLocation = false;
                      }
                      // Else,
                      else {
                        // Display snackbar
                        globalKey.currentState.showSnackBar(SnackBar(
                            content: Text(
                                'Hotels currently sorted alphabetically')));
                      }
                    }),
                IconButton(
                    key: Key('SortLocation'),
                    icon: Icon(Icons.location_on),
                    onPressed: () async {
                      print("Sort by location is " + sortByLocation.toString());
                      // If not sorting by location
                      if (sortByLocation == false) {
                        // If location can be used,
                        if (await checkLocationCanBeUsed()) {
                          // Retrieve the location data
                          final locationData = await location.getLocation();

                          setState(() {
                            // Set loading to true
                            loading = true;
                          });

                          // Create the hotels lists then,
                          createHotelListViewWithDistance(locationData)
                              .then((result) {
                            // Set the list view to the newly created list
                            setState(() {
                              listView = result;
                            });
                          });

                          setState(() {
                            // Set loading to false
                            loading = false;
                          });

                          // Set sorted by location to true
                          sortByLocation = true;
                        }
                        // Else,
                        else {
                          // Display snackbar
                          globalKey.currentState.showSnackBar(SnackBar(
                              content: Text(
                                  'Ensure location is turned on or check app permissions')));
                        }
                      }
                      // Else,
                      else {
                        // Display snackbar
                        globalKey.currentState.showSnackBar(SnackBar(
                            content:
                                Text('Hotels currently sorted by distance')));
                      }
                    })
              ],
            ),
            body: Center(child: listView),
          ),
        ));
  }

  // Function for checking location permissions
  Future<bool> checkLocationCanBeUsed() async {
    // If the location service is enabled,
    if (await location.serviceEnabled()) {
      // If the location service can be requested,
      if (await location.requestService()) {
        // Get the permission status
        PermissionStatus permission = await location.hasPermission();
        // If the permission status is granted, return true
        if (permission == PermissionStatus.GRANTED)
          return true;
        // Else, if the permission status is denied,
        else if (permission == PermissionStatus.DENIED) {
          // Request permission to use location
          permission = await location.requestPermission();
          // If the permission is now granted, return true
          if (permission == PermissionStatus.GRANTED) return true;
        }
      }
    }

    // In all other instances, return false
    return false;
  }

  // Function for getting all hotels
  Future<Widget> getHotelList() async {
    // Create instance of customer controller class
    CustomerController controller = new CustomerController();

    // Retrieve list of hotel objects
    hotels = await controller.getHotelList();

    // Return created list view
    return createHotelListView();
  }

  // Function for creating the listView of hotels
  Future<Widget> createHotelListView() async {
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
      // Sort the hotels list alphabetically
      hotels.sort((a, b) => a.hotelName.compareTo(b.hotelName));

      // Return listView with ListTile for each hotel object with dividers between them
      return ListView.separated(
        key: Key('HotelsListAlpha'),
        itemCount: hotels.length,
        itemBuilder: (context, index) {
          return ListTile(
            key: Key('hotel' + index.toString()),
            title: Text(hotels.elementAt(index).hotelName),
            // When ListTile is selected,
            onTap: () async {
              // If the there is an internet connection,
              if (await generalController.checkInternetConnection()) {
                // Update the hotel
                UserData().hotel = hotels.elementAt(index);

                // Navigate to the customer hotel details screen
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomerScreenHotelDetails()));
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

  // Function for creating the listView of hotels
  Future<Widget> createHotelListViewWithDistance(
      LocationData locationData) async {
    // Create distance object
    final distance = new Distance();

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
      // For each hotel in the list,
      for (HotelDTO h in hotels) {
        // Update the distance from the hotel
        h.distance = distance.as(
            LengthUnit.Kilometer,
            new LatLng(h.latitude, h.longitude),
            new LatLng(locationData.latitude, locationData.longitude));
      }

      // Sort the hotels list by distance
      hotels.sort((a, b) => a.distance.compareTo(b.distance));

      // Return listView with ListTile for each hotel object with dividers between them
      return ListView.separated(
        key: Key('HotelsListLocation'),
        itemCount: hotels.length,
        itemBuilder: (context, index) {
          return ListTile(
            key: Key('hotel' + index.toString()),
            title: Text(hotels.elementAt(index).hotelName),
            subtitle: Text(hotels.elementAt(index).distance.toString() +
                "km from your location"),
            // When ListTile is selected,
            onTap: () async {
              // If the there is an internet connection,
              if (await generalController.checkInternetConnection()) {
                // Update the hotel
                UserData().hotel = hotels.elementAt(index);

                // Navigate to the customer hotel details screen
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomerScreenHotelDetails()));
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
