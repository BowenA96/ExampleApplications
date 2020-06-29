import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hotel_room_booking_app/controllers/general_controller.dart';
import 'package:hotel_room_booking_app/dtos/login/login_dto.dart';
import 'package:hotel_room_booking_app/screens/login/login_customer_screen.dart';
import 'package:hotel_room_booking_app/user_data.dart';
import 'package:hotel_room_booking_app/web_service_request.dart';
import 'package:http/http.dart';
import 'package:random_string/random_string.dart';
import 'package:crypto/crypto.dart';

// Class for performing customer login functionality
class CustomerLoginController {
  // Create instance of the web service request class
  WebServiceRequest webServiceRequest = new WebServiceRequest();

  // Create instance of the general controller
  GeneralController generalController = new GeneralController();

  // Function for logging in as customer
  Future<LoginDTO> loginCustomer(String username, String password) async {
    // Retrieve response from get web service request
    Response response = await webServiceRequest
        .getRequest("customer/login/$username/$password");

    // If the response is null, return null
    if (response.body == null || response.body == "null") return null;

    // Perform first decode of the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to create map object
    Map<String, dynamic> secondDecode = jsonDecode(firstDecode);

    // Get login details from Json
    LoginDTO login = LoginDTO.fromJson(secondDecode);

    // Return the login details
    return login;
  }

  // Function for registering a customer
  Future<LoginDTO> registerCustomer(String username, String password) async {
    // Create map for web request headers
    Map<String, String> content = new Map<String, String>();

    // Add username header
    content['username'] = username;

    // Add password header
    content['password'] = password;

    // Add loggedInCode header
    content['loggedInCode'] = randomAlphaNumeric(64);

    // Retrieve response from the post web service request
    Response response =
        await webServiceRequest.postRequest("customer/register", content);

    // If the response is null, return null
    if (response.body == null || response.body == "null") return null;

    // Perform first decode of the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to create map object
    Map<String, dynamic> secondDecode = jsonDecode(firstDecode);

    // Get login details from Json
    LoginDTO login = LoginDTO.fromJson(secondDecode);

    // Return the login details
    return login;
  }

  // Function for displaying login/register dialog
  StatefulBuilder loginRegisterDialog(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        // Controller for username text field
        final usernameController = new TextEditingController();

        // Username invalid error message
        String usernameInvalid = "";

        // Controller for password text field
        final passwordController = new TextEditingController();

        // Password invalid error message
        String passwordInvalid = "";

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: new Text('Login / Register'),
              content: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          key: Key('CustomerUsername'),
                          controller: usernameController,
                          obscureText: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Username',
                            errorText: (usernameInvalid != "")
                                ? usernameInvalid
                                : null,
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
                            errorText: (passwordInvalid != "")
                                ? passwordInvalid
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
                    key: Key('CancelLogin'),
                    child: new Text('Cancel',
                        style:
                            TextStyle(color: Colors.deepPurple, fontSize: 18)),
                    // When cancel pressed,
                    onPressed: () {
                      // Close the dialog
                      Navigator.pop(context);
                    }),
                new FlatButton(
                    key: Key('CustomerRegistration'),
                    child: new Text('Register',
                        style:
                            TextStyle(color: Colors.deepPurple, fontSize: 18)),
                    // When cancel pressed,
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
                        if (await generalController.checkInternetConnection()) {
                          // Perform hashing on the password
                          var bytes1 = utf8.encode(passwordController.text);
                          var digest1 = sha512.convert(bytes1);
                          var bytes2 = utf8.encode(digest1.toString());
                          var digest2 = sha256.convert(bytes2);
                          var bytes3 = utf8.encode(digest2.toString());
                          var digest3 = sha512.convert(bytes3);

                          // Retrieve result from attempting login
                          LoginDTO login = await registerCustomer(
                              usernameController.text, digest3.toString());

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

                            // Close the dialog
                            Navigator.pop(context);
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
                new FlatButton(
                    key: Key('CustomerLogin'),
                    child: new Text('Login',
                        style:
                            TextStyle(color: Colors.deepPurple, fontSize: 18)),
                    // When ok pressed,
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
                        if (await generalController.checkInternetConnection()) {
                          // Perform hashing on the password
                          var bytes1 = utf8.encode(passwordController.text);
                          var digest1 = sha512.convert(bytes1);
                          var bytes2 = utf8.encode(digest1.toString());
                          var digest2 = sha256.convert(bytes2);
                          var bytes3 = utf8.encode(digest2.toString());
                          var digest3 = sha512.convert(bytes3);

                          // Retrieve result from attempting login
                          LoginDTO login = await loginCustomer(
                              usernameController.text, digest3.toString());

                          // If login was not successful,
                          if (login == null) {
                            // Update the username error message
                            setState(() {
                              usernameInvalid = "Invalid username or password";
                              passwordInvalid = "Invalid username or password";
                            });
                          }
                          // Else,
                          else {
                            // Set the user login data
                            UserData().loginDTO = login;

                            // Close the dialog
                            Navigator.pop(context);
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

  // Function for forcing relogin
  StatefulBuilder forceReloginDialog(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        // Controller for password text field
        final passwordController = new TextEditingController();

        // Password invalid error message
        String passwordInvalid = "";

        return StatefulBuilder(
          builder: (context, setState) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: new Text('Session Expired - Login Required'),
                content: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            key: Key('CustomerPassword'),
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                              errorText: (passwordInvalid != "")
                                  ? passwordInvalid
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
                      key: Key('CustomerExitRelogin'),
                      child: new Text('Exit',
                          style: TextStyle(
                              color: Colors.deepPurple, fontSize: 18)),
                      // When cancel pressed,
                      onPressed: () {
                        // Clear the login info
                        UserData().loginDTO = null;

                        // Get the route
                        var route = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new LoginCustomerScreen());

                        // Navigate to the customer login screen
                        Navigator.popUntil(context, ((route) => route.isFirst));
                      }),
                  new FlatButton(
                      key: Key('CustomerLogin'),
                      child: new Text('Login',
                          style: TextStyle(
                              color: Colors.deepPurple, fontSize: 18)),
                      // When cancel pressed,
                      onPressed: () async {
                        // Set initial value for invalid data entry to false
                        bool invalid = false;

                        // Created regex of valid characters
                        final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');

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

                            // Retrieve result from attempting login
                            LoginDTO login = await loginCustomer(
                                UserData().loginDTO.username,
                                digest3.toString());

                            // If login was not successful,
                            if (login == null) {
                              // Update the username error message
                              setState(() {
                                passwordInvalid =
                                    "Invalid username or password";
                              });
                            }
                            // Else,
                            else {
                              // Set the user login data
                              UserData().loginDTO = login;
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
          },
        );
      },
    );
  }
}
