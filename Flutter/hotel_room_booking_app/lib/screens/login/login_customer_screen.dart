import 'package:flutter/material.dart';
import 'package:hotel_room_booking_app/controllers/customer/customer_login_controller.dart';
import 'package:hotel_room_booking_app/controllers/general_controller.dart';
import 'package:hotel_room_booking_app/dtos/login/login_dto.dart';
import 'package:hotel_room_booking_app/screens/customer/customer_screen.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:hotel_room_booking_app/user_data.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// Class for the customer login screen of the application
class LoginCustomerScreen extends StatefulWidget {
  LoginCustomerScreen({Key key}) : super(key: key);

  @override
  State createState() => new LoginCustomerScreenState();
}

// Class for the state of the customer login screen
class LoginCustomerScreenState extends State<LoginCustomerScreen> {
  // Variable for the state of loading
  bool loading = false;

  // Controller for username text field
  final usernameController = new TextEditingController();

  // Username invalid error message
  String usernameInvalid = "";

  // Controller for password text field
  final passwordController = new TextEditingController();

  // Password invalid error message
  String passwordInvalid = "";

  // Initialize instance of the customer controller
  CustomerLoginController customerLoginController =
      new CustomerLoginController();

  // Initialize instance of the general controller
  GeneralController generalController = new GeneralController();

  @override
  // Function for building the widget
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: new Scaffold(
        key: Key('CustomerLoginPage'),
        appBar: AppBar(
          title: Text('Customer Login Page'),
          backgroundColor: Colors.deepPurple,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Customer Login:',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  key: Key('CustomerUsername'),
                  controller: usernameController,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    errorText: (usernameInvalid != "") ? usernameInvalid : null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  key: Key('CustomerPassword'),
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    errorText: (passwordInvalid != "") ? passwordInvalid : null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                // Button to login the customer
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                        key: Key('CustomerLogin'),
                        color: Colors.deepPurpleAccent,
                        // The button text
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        // When the button is pressed,
                        onPressed: () async {
                          // Set initial value for invalid data entry to false
                          bool invalid = false;

                          // Created regex of valid characters
                          final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');

                          // If the username is not between 3 and 50 characters
                          if (usernameController.text.length > 50 ||
                              usernameController.text.length < 3) {
                            // Set invalid to true and update username error message
                            setState(() {
                              invalid = true;
                              usernameInvalid = "3-50 characters required";
                            });
                          }
                          // Else, if username contains invalid characters,
                          else if (!validCharacters
                              .hasMatch(usernameController.text)) {
                            // Set invalid to true and update username error message
                            setState(() {
                              invalid = true;
                              usernameInvalid = "Cannot use symbols";
                            });
                          }
                          // Else,
                          else {
                            // Update username error message
                            setState(() {
                              usernameInvalid = "";
                            });
                          }

                          // If the password is not between 3 and 50 characters
                          if (passwordController.text.length > 50 ||
                              passwordController.text.length < 3) {
                            // Set invalid to true and update password error message
                            setState(() {
                              invalid = true;
                              passwordInvalid = "3-50 characters required";
                            });
                          }
                          // Else, if password contains invalid characters,
                          else if (!validCharacters
                              .hasMatch(passwordController.text)) {
                            // Set invalid to true and update password error message
                            setState(() {
                              invalid = true;
                              passwordInvalid = "Cannot use symbols";
                            });
                          }
                          // Else,
                          else {
                            // Update password error message
                            setState(() {
                              passwordInvalid = "";
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
                              // Perform hashing on the password
                              var bytes1 = utf8.encode(passwordController.text);
                              var digest1 = sha512.convert(bytes1);
                              var bytes2 = utf8.encode(digest1.toString());
                              var digest2 = sha256.convert(bytes2);
                              var bytes3 = utf8.encode(digest2.toString());
                              var digest3 = sha512.convert(bytes3);

                              setState(() {
                                // Set loading to true
                                loading = true;
                              });

                              // Retrieve result from attempting login
                              LoginDTO login =
                                  await customerLoginController.loginCustomer(
                                      usernameController.text,
                                      digest3.toString());

                              setState(() {
                                // Set loading to false
                                loading = false;
                              });

                              // If login was not successful,
                              if (login == null) {
                                // Update the username error message
                                setState(() {
                                  usernameInvalid =
                                      "Invalid username or password";
                                  passwordInvalid =
                                      "Invalid username or password";
                                });
                              }
                              // Else,
                              else {
                                // Set the user login data
                                UserData().loginDTO = login;

                                // Clear the username text
                                usernameController.text = "";

                                // Clear the password text
                                passwordController.text = "";

                                // Replace the current screen with navigation to new customer screen
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CustomerScreen()));
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
                    RaisedButton(
                        key: Key('CustomerRegistration'),
                        color: Colors.deepPurpleAccent,
                        // The button text
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        // When the button is pressed,
                        onPressed: () async {
                          // Set initial value for invalid data entry to false
                          bool invalid = false;

                          // Created regex of valid characters
                          final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');

                          // If the username is not between 3 and 50 characters
                          if (usernameController.text.length > 50 ||
                              usernameController.text.length < 3) {
                            // Set invalid to true and update username error message
                            setState(() {
                              invalid = true;
                              usernameInvalid = "3-50 characters required";
                            });
                          }
                          // Else, if username contains invalid characters,
                          else if (!validCharacters
                              .hasMatch(usernameController.text)) {
                            // Set invalid to true and update username error message
                            setState(() {
                              invalid = true;
                              usernameInvalid = "Cannot use symbols";
                            });
                          }
                          // Else,
                          else {
                            // Update username error message
                            setState(() {
                              usernameInvalid = "";
                            });
                          }

                          // If the password is not between 3 and 50 characters
                          if (passwordController.text.length > 50 ||
                              passwordController.text.length < 3) {
                            // Set invalid to true and update password error message
                            setState(() {
                              invalid = true;
                              passwordInvalid = "3-50 characters required";
                            });
                          }
                          // Else, if password contains invalid characters,
                          else if (!validCharacters
                              .hasMatch(passwordController.text)) {
                            // Set invalid to true and update password error message
                            setState(() {
                              invalid = true;
                              passwordInvalid = "Cannot use symbols";
                            });
                          }
                          // Else,
                          else {
                            // Update password error message
                            setState(() {
                              passwordInvalid = "";
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
                              // Perform hashing on the password
                              var bytes1 = utf8.encode(passwordController.text);
                              var digest1 = sha512.convert(bytes1);
                              var bytes2 = utf8.encode(digest1.toString());
                              var digest2 = sha256.convert(bytes2);
                              var bytes3 = utf8.encode(digest2.toString());
                              var digest3 = sha512.convert(bytes3);

                              setState(() {
                                // Set loading to true
                                loading = true;
                              });

                              // Retrieve result from attempting login
                              LoginDTO login = await customerLoginController
                                  .registerCustomer(usernameController.text,
                                      digest3.toString());

                              setState(() {
                                // Set loading to false
                                loading = false;
                              });

                              // If login was not successful,
                              if (login == null) {
                                // Update the username error message
                                setState(() {
                                  usernameInvalid = "Username unavailable";
                                });
                              }
                              // Else,
                              else {
                                // Set the user login data
                                UserData().loginDTO = login;

                                // Clear the username text
                                usernameController.text = "";

                                // Clear the password text
                                passwordController.text = "";

                                // Replace the current screen with navigation to new customer screen
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CustomerScreen()));
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
                        })
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: InkWell(
                  key: Key('GuestLogin'),
                  child: Text(
                    'Continue as guest (login required for basket and checkout)',
                    style: TextStyle(color: Colors.deepPurple, fontSize: 14),
                  ),
                  onTap: () async {
                    // If the there is an internet connection,
                    if (await generalController.checkInternetConnection()) {
                      // Set the login data to null
                      UserData().loginDTO = null;

                      // Replace the current screen with navigation to new customer screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomerScreen()));
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
