import 'dart:io';
import 'package:flutter/material.dart';

// Class for performing functionality for all users
class GeneralController {
  // Function for checking internet connectivity
  Future<bool> checkInternetConnection() async {
    try {
      // Attempt to retrieve internet connection
      List<InternetAddress> result =
          await InternetAddress.lookup('example.com');

      // If the address is found, return true
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty)
        return true;
      // Else, return false
      else
        return false;
    }
    // If exception caught,
    on Exception catch (_) {
      // Return false
      return false;
    }
  }

  // Function for displaying no internet connection dialog
  StatefulBuilder connectToInternetDialog() {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: new Text('Internet Connection Required'),
          content: Container(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                    'Cannot perform this action without an internet connection. Ensure your device has internet access via WiFi or mobile data is on.'),
              ),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
                key: Key('ConfirmNoInternet'),
                child: new Text('OK', style: TextStyle(color: Colors.deepPurple, fontSize: 18)),
                // When ok pressed,
                onPressed: () {
                  // Close the dialog
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }
}
