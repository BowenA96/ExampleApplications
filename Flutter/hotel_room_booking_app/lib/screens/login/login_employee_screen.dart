import 'package:flutter/material.dart';
import 'package:hotel_room_booking_app/controllers/employee_controller.dart';
import 'package:hotel_room_booking_app/controllers/general_controller.dart';
import 'package:hotel_room_booking_app/dtos/login/login_employee_dto.dart';
import 'package:hotel_room_booking_app/screens/employee/cleaning_employee_screen.dart';
import 'package:hotel_room_booking_app/screens/employee/maintenance_employee_screen.dart';
import 'package:hotel_room_booking_app/screens/employee/reception_employee_screen.dart';
import 'package:hotel_room_booking_app/user_data.dart';
import 'login_administrator_screen.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// Class for the employee login screen of the application
class LoginEmployeeScreen extends StatefulWidget {
  LoginEmployeeScreen({Key key}) : super(key: key);

  @override
  State createState() => new LoginEmployeeScreenState();
}

// Class for the state of the employee login screen
class LoginEmployeeScreenState extends State<LoginEmployeeScreen> {
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

  // Initialize instance of the employee controller
  EmployeeController employeeController = new EmployeeController();

  // Initialize instance of the general controller
  GeneralController generalController = new GeneralController();

  @override
  // Function for building the widget
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: new Scaffold(
        appBar: AppBar(
          key: Key('EmployeeLoginPage'),
          title: Text('Employee Login Page'),
          backgroundColor: Colors.deepPurple,
          actions: <Widget>[
            IconButton(
              key: Key('GoToAdministratorLogin'),
              icon: Icon(Icons.lock),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginAdministratorScreen()));
              },
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Employee Login:',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  key: Key('EmployeeUsername'),
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
                  key: Key('EmployeePassword'),
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
                // Button to login the employee
                child: RaisedButton(
                  key: Key('EmployeeLogin'),
                  color: Colors.deepPurpleAccent,
                  // When the button is pressed,
                  // When the button is pressed,
                  onPressed: () async {
                    // Set initial value for invalid data entry to false
                    bool invalid = false;

                    // Created regex of valid characters
                    final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');

                    setState(() {
                      // Set loading to true
                      loading = true;
                    });

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

                    setState(() {
                      // Set loading to true
                      loading = false;
                    });

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

                        setState(() {
                          // Set loading to true
                          loading = true;
                        });

                        // Retrieve result from attempting login
                        LoginEmployeeDTO login =
                            await employeeController.loginEmployee(
                                usernameController.text, digest3.toString());

                        setState(() {
                          // Set loading to true
                          loading = false;
                        });

                        // If login was not successful,
                        if (login == null) {
                          // Update the username error message
                          setState(() {
                            usernameInvalid = "Invalid username or password";
                            passwordInvalid = "Invalid username or password";
                          });
                        }
                        // Else, if this is not the first login of the employee,
                        else if (login.oneTimePassword == false) {
                          // Save the login details
                          UserData().loginEmployeeDTO = login;

                          // Clear the username text
                          usernameController.text = "";

                          // Clear the password text
                          passwordController.text = "";

                          // Perform navigation
                          navigateToEmployeePage();
                        }
                        // Else,
                        else {
                          // Show AlertDialog
                          showDialog(
                            context: context,
                            builder: (context) {
                              // Controller for password text field
                              final updatePasswordController =
                                  new TextEditingController();

                              // Password invalid error message
                              String updatePasswordInvalid = "";

                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    title: new Text('Update Password'),
                                    content: Container(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: TextField(
                                                key: Key('UpdateEmployeePassword'),
                                                controller:
                                                    updatePasswordController,
                                                obscureText: true,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Password',
                                                  errorText:
                                                      (updatePasswordInvalid !=
                                                              "")
                                                          ? updatePasswordInvalid
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
                                          key: Key('UpdatePasswordCancel'),
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
                                          key: Key('UpdatePasswordConfirm'),
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

                                            // If the password is not between 3 and 50 characters
                                            if (updatePasswordController
                                                        .text.length >
                                                    50 ||
                                                updatePasswordController
                                                        .text.length <
                                                    3) {
                                              // Set invalid to true and update password error message
                                              setState(() {
                                                invalid = true;
                                                updatePasswordInvalid =
                                                    "3-50 characters required";
                                              });
                                            }
                                            // Else, if password contains invalid characters,
                                            else if (!validCharacters.hasMatch(
                                                updatePasswordController
                                                    .text)) {
                                              // Set invalid to true and update password error message
                                              setState(() {
                                                invalid = true;
                                                updatePasswordInvalid =
                                                    "Cannot use symbols";
                                              });
                                            }
                                            // Else,
                                            else {
                                              // Update password error message
                                              setState(() {
                                                updatePasswordInvalid = "";
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
                                                var bytes1 = utf8.encode(
                                                    updatePasswordController
                                                        .text);
                                                var digest1 =
                                                    sha512.convert(bytes1);
                                                var bytes2 = utf8
                                                    .encode(digest1.toString());
                                                var digest2 =
                                                    sha256.convert(bytes2);
                                                var bytes3 = utf8
                                                    .encode(digest2.toString());
                                                var digest3 =
                                                    sha512.convert(bytes3);

                                                setState(() {
                                                  // Set loading to true
                                                  loading = true;
                                                });

                                                // Retrieve result from attempting login
                                                LoginEmployeeDTO login =
                                                    await employeeController
                                                        .updatePassword(
                                                            usernameController
                                                                .text,
                                                            digest3.toString());

                                                setState(() {
                                                  // Set loading to true
                                                  loading = false;
                                                });

                                                // If login was not successful,
                                                if (login == null) {
                                                  // Update the password error message
                                                  setState(() {
                                                    updatePasswordInvalid =
                                                        "Invalid password";
                                                  });
                                                }
                                                // Else,
                                                else {
                                                  // Save the login details
                                                  UserData().loginEmployeeDTO =
                                                      login;

                                                  // Pop the dialog
                                                  Navigator.pop(context);

                                                  // Perform navigation
                                                  navigateToEmployeePage();
                                                }
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
                        setState(() {
                          // Set loading to false
                          loading = false;
                        });
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
                  },
                  // The button text
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Function for performing navigation to the employees page / hub
  void navigateToEmployeePage() {
    if (UserData().loginEmployeeDTO.employeeType == "Maintenance") {
      // Replace the current screen with navigation to new employee screen
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MaintenanceEmployeeScreen()));
    } else if (UserData().loginEmployeeDTO.employeeType == "Cleaning") {
      // Replace the current screen with navigation to new employee screen
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CleaningEmployeeScreen()));
    } else {
      // Replace the current screen with navigation to new employee screen
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ReceptionEmployeeScreen()));
    }
  }
}
