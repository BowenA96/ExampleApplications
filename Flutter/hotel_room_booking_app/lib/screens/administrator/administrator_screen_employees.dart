import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:hotel_room_booking_app/controllers/administrator_controller.dart';
import 'package:hotel_room_booking_app/controllers/general_controller.dart';
import 'package:hotel_room_booking_app/dtos/employee/employee_dto.dart';
import 'package:hotel_room_booking_app/user_data.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// Class for the administrator employees screen
class AdministratorScreenEmployees extends StatefulWidget {
  AdministratorScreenEmployees({Key key}) : super(key: key);

  @override
  State createState() => new AdministratorScreenEmployeesState();
}

// Class for the state of the administrator employees screen
class AdministratorScreenEmployeesState
    extends State<AdministratorScreenEmployees> {
  // Variable for the state of loading
  bool loading = false;

  // Initialize listView object
  ListView listView = new ListView();

  // Initialize instance of the administrator controller
  AdministratorController administratorController =
      new AdministratorController();

  // Initialize instance of the general controller
  GeneralController generalController = new GeneralController();

  @override
  // Function for the initial state
  void initState() {
    setState(() {
      // Set loading to true
      loading = true;
    });

    // Create the listView for employees then,
    createAdminEmployeeListView(context, UserData().hotelName).then((result) {
      // Update the listView for the screen
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
        body: Center(
          child: listView,
        ),
        floatingActionButton: FloatingActionButton(
          key: Key('CreateEmployee'),
          // When add button pressed,
          onPressed: () {
            // Show AlertDialog
            showDialog(
              context: context,
              builder: (context) {
                // Controller for username text field
                final usernameController = new TextEditingController();

                // Username invalid error message
                String usernameInvalid = "";

                // Controller for firstName text field
                final firstNameController = new TextEditingController();

                // First name invalid error message
                String firstNameInvalid = "";

                // Controller for lastName text field
                final lastNameController = new TextEditingController();

                // Last name invalid error message
                String lastNameInvalid = "";

                // Controller for password text field
                final passwordController = new TextEditingController();

                // Password invalid error message
                String passwordInvalid = "";

                // Default value for dropdown
                String dropdownValue = "Cleaning";

                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      title: new Text('Create New Employee'),
                      content: Container(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextField(
                                  key: Key('EmployeeUsername'),
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
                                  key: Key('EmployeeFirstName'),
                                  controller: firstNameController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'First Name',
                                    errorText: (firstNameInvalid != "")
                                        ? firstNameInvalid
                                        : null,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextField(
                                  key: Key('EmployeeLastName'),
                                  controller: lastNameController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Last Name',
                                    errorText: (lastNameInvalid != "")
                                        ? lastNameInvalid
                                        : null,
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
                                    errorText: (passwordInvalid != "")
                                        ? passwordInvalid
                                        : null,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Role',
                                  ),
                                  value: dropdownValue,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dropdownValue = newValue;
                                    });
                                  },
                                  items: <String>[
                                    'Cleaning',
                                    'Maintenance',
                                    'Reception'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        new FlatButton(
                            key: Key('CreateEmployeeCancel'),
                            child: new Text('Cancel',
                                style: TextStyle(
                                    color: Colors.deepPurple, fontSize: 18)),
                            // When cancel pressed,
                            onPressed: () {
                              // Close the dialog
                              Navigator.pop(context);
                            }),
                        new FlatButton(
                            key: Key('CreateEmployeeConfirm'),
                            child: new Text('OK',
                                style: TextStyle(
                                    color: Colors.deepPurple, fontSize: 18)),
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

                              // If the firstName is not between 3 and 50 characters
                              if (firstNameController.text.length > 50 ||
                                  firstNameController.text.length < 3) {
                                // Set invalid to true and update firstName error message
                                setState(() {
                                  invalid = true;
                                  firstNameInvalid = "3-50 characters required";
                                });
                              }
                              // Else, if firstName contains invalid characters,
                              else if (!validCharacters
                                  .hasMatch(firstNameController.text)) {
                                // Set invalid to true and update firstName error message
                                setState(() {
                                  invalid = true;
                                  firstNameInvalid = "Cannot use symbols";
                                });
                              }
                              // Else,
                              else {
                                // Update firstName error message
                                setState(() {
                                  firstNameInvalid = "";
                                });
                              }

                              // If the lastName is not between 3 and 50 characters
                              if (lastNameController.text.length > 50 ||
                                  lastNameController.text.length < 3) {
                                // Set invalid to true and update lastName error message
                                setState(() {
                                  invalid = true;
                                  lastNameInvalid = "3-50 characters required";
                                });
                              }
                              // Else, if lastName contains invalid characters,
                              else if (!validCharacters
                                  .hasMatch(lastNameController.text)) {
                                // Set invalid to true and update lastName error message
                                setState(() {
                                  invalid = true;
                                  lastNameInvalid = "Cannot use symbols";
                                });
                              }
                              // Else,
                              else {
                                // Update lastName error message
                                setState(() {
                                  lastNameInvalid = "";
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
                                  var bytes1 =
                                      utf8.encode(passwordController.text);
                                  var digest1 = sha512.convert(bytes1);
                                  var bytes2 = utf8.encode(digest1.toString());
                                  var digest2 = sha256.convert(bytes2);
                                  var bytes3 = utf8.encode(digest2.toString());
                                  var digest3 = sha512.convert(bytes3);

                                  setState(() {
                                    // Set loading to true
                                    loading = true;
                                  });

                                  // Retrieve result from creating the employee
                                  bool result = await administratorController
                                      .createEmployee(
                                          UserData().loginDTO.username,
                                          UserData().loginDTO.password,
                                          usernameController.text,
                                          firstNameController.text,
                                          lastNameController.text,
                                          digest3.toString(),
                                          dropdownValue,
                                          UserData().hotelName);

                                  setState(() {
                                    // Set loading to false
                                    loading = false;
                                  });

                                  // If the employee was created successfully,
                                  if (result) {
                                    // Close the dialog
                                    Navigator.pop(context);

                                    // Update the data displayed
                                    initState();
                                  }
                                  // Else,
                                  else {
                                    // Update the username error message
                                    setState(() {
                                      usernameInvalid =
                                          "Username not available";
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
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blueGrey,
        ),
      ),
    );
  }

  // Function for creating the employee listView
  Future<Widget> createAdminEmployeeListView(
      BuildContext context, String hotelName) async {
    // Retrieve list of employee objects
    List<EmployeeDTO> employees =
        await administratorController.createListOfEmployees(
            UserData().loginDTO.username,
            UserData().loginDTO.password,
            hotelName);

    // If the list of employee objects is empty,
    if (employees == null || employees.isEmpty) {
      // Return ListView with one default ListTile
      return ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("No employees found for hotel..."),
            );
          });
    }
    // Else,
    else {
      // Return listView with ListTile for each employee object with dividers between
      return ListView.separated(
        key: Key('EmployeesList'),
        itemCount: employees.length,
        itemBuilder: (context, index) {
          return ListTile(
            key: Key('Employee-' + employees.elementAt(index).username),
            title: Text(employees.elementAt(index).username +
                " - " +
                employees.elementAt(index).firstName +
                " " +
                employees.elementAt(index).lastName),
            subtitle: Text(employees.elementAt(index).employeeType +
                ", " +
                employees.elementAt(index).hotelName),
            trailing: IconButton(
              key: Key('DeleteEmployee-' + employees.elementAt(index).username),
              icon: Icon(Icons.delete),
              // When delete icon is pressed,
              onPressed: () {
                // Show new AlertDialog
                showDialog(
                  context: context,
                  child: new AlertDialog(
                    title: new Text('Delete Employee'),
                    content: new Text(
                        'Are you sure you want to delete employee: ' +
                            employees.elementAt(index).username + '?'),
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
                          key: Key('DeleteEmployee'),
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
                                  await administratorController.deleteEmployee(
                                      UserData().loginDTO.username,
                                      UserData().loginDTO.password,
                                      employees.elementAt(index).username);

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
}
