import 'package:flutter/material.dart';
import 'package:hotel_room_booking_app/controllers/employee_controller.dart';
import 'package:hotel_room_booking_app/controllers/general_controller.dart';
import 'package:hotel_room_booking_app/dtos/customer/maintenance_request_dto.dart';
import 'package:hotel_room_booking_app/dtos/employee/maintenance_checkup_dto.dart';
import 'package:hotel_room_booking_app/user_data.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// Class for the maintenance employee screen
class MaintenanceEmployeeScreen extends StatefulWidget {
  MaintenanceEmployeeScreen({Key key}) : super(key: key);

  @override
  State createState() => new MaintenanceEmployeeScreenState();
}

// Class for the maintenance employee screen state
class MaintenanceEmployeeScreenState extends State<MaintenanceEmployeeScreen> {
  // Variable for the state of loading
  bool loading = false;

  // Initialize listView object
  ListView listView;

  // Initialize instance of the general controller
  GeneralController generalController = new GeneralController();

  // Create instance of the employee controller class
  EmployeeController employeeController = new EmployeeController();

  @override
  // Function for the initial state
  void initState() {
    setState(() {
      // Set loading to true
      loading = true;
    });

    // Create the list of maintenance details then,
    createMaintenanceListView(context).then((result) {
      // Set the listView object to display all the maintenance details
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
          title: Text('Maintenance Employee Page'),
          backgroundColor: Colors.deepPurple,
        ),
        // Display the listView
        body: Center(child: listView),
      ),
    );
  }

  // Function for creating list view
  Future<ListView> createMaintenanceListView(BuildContext context) async {
    // Retrieve the maintenance checkups
    List<MaintenanceCheckupDTO> checkups =
        await employeeController.getMaintenanceCheckups(
            UserData().loginEmployeeDTO.username,
            UserData().loginEmployeeDTO.hotelName);

    // Retrieve the maintenance requests
    List<MaintenanceRequestDTO> requests =
        await employeeController.getMaintenanceRequests(
            UserData().loginEmployeeDTO.username,
            UserData().loginEmployeeDTO.hotelName);

    // Create list of checkups which are assigned to the employee
    List<MaintenanceCheckupDTO> assignedCheckups = new List<MaintenanceCheckupDTO>();

    // Create list of checkups which are unassigned to the employee
    List<MaintenanceCheckupDTO> unAssignedCheckups = new List<MaintenanceCheckupDTO>();

    // For each of the checkups,
    for (MaintenanceCheckupDTO maintenanceCheckupDTO in checkups) {
      // If the username is for the employee, add it to the assigned list
      if (maintenanceCheckupDTO.username ==
          UserData().loginEmployeeDTO.username)
        assignedCheckups.add(maintenanceCheckupDTO);
      // Else, add it to the unassigned list
      else
        unAssignedCheckups.add(maintenanceCheckupDTO);
    }

    // Create list of requests which are assigned to the employee
    List<MaintenanceRequestDTO> assignedRequests = new List<MaintenanceRequestDTO>();

    // Create list of requests which are assigned to the employee
    List<MaintenanceRequestDTO> unAssignedRequests = new List<MaintenanceRequestDTO>();

    // For each of the checkups,
    for (MaintenanceRequestDTO maintenanceRequestDTO in requests) {
      // If the username is for the employee, add it to the assigned list
      if (maintenanceRequestDTO.username ==
          UserData().loginEmployeeDTO.username)
        assignedRequests.add(maintenanceRequestDTO);
      // Else, add it to the unassigned list
      else
        unAssignedRequests.add(maintenanceRequestDTO);
    }

    return ListView.separated(
      scrollDirection: Axis.vertical,
      key: Key('HotelDetails'),
      itemCount: 6,
      itemBuilder: (context, index) {
        if (index == 0) {
          return ListTile(
            title: Text('Assigned Maintenance Requests And Checkups:',
                style: TextStyle(fontWeight: FontWeight.bold)),
          );
        } else if (index == 1) {
          return createAssignedCheckupsList(assignedCheckups);
        } else if (index == 2) {
          return createAssignedRequestsList(assignedRequests);
        } else if (index == 3) {
          return ListTile(
            title: Text('Un-Assigned Maintenance Requests And Checkups:',
                style: TextStyle(fontWeight: FontWeight.bold)),
          );
        } else if (index == 4) {
          return createUnAssignedCheckupsList(unAssignedCheckups);
        } else {
          return createUnAssignedRequestsList(unAssignedRequests);
        }
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  // Function for creating the listview for the unassigned checkups
  ListView createUnAssignedCheckupsList(List<MaintenanceCheckupDTO> checkups) {
    // If the list of checkups is empty,
    if (checkups == null || checkups.isEmpty) {
      // Return listView with only one object
      return ListView.builder(
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (context, index) {
            return ListTile(
              title:
                  Text("No maintenance checkups un-assigned for today found..."),
            );
          });
    }
    // Else,
    else {
      // Return listView with ListTile for each room object with dividers between them
      return ListView.separated(
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        key: Key('UnAssignedCheckupsList'),
        itemCount: checkups.length,
        itemBuilder: (context, index) {
          return ListTile(
              key: Key('UnAssignedCheckup' + index.toString()),
              title: Text('Room: ' + checkups.elementAt(index).roomCode),
              trailing: IconButton(
                key: Key('AssignCheckup' + index.toString()),
                icon: Icon(Icons.add),
                onPressed: () {
                  // Show new AlertDialog
                  showDialog(
                    context: context,
                    child: new AlertDialog(
                      title: new Text('Assign To Maintenance Checkup'),
                      content: new Text(
                          'Are you sure you want to be assigned to the maintenance checkup for room: ' +
                              checkups.elementAt(index).roomCode + '?'),
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
                            key: Key('AssignCheckup'),
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
                                bool result = await employeeController
                                    .assignUnassignEmployeeFromMaintenance(
                                        checkups
                                            .elementAt(index)
                                            .roomMaintenanceCheckupId,
                                        true,
                                        UserData().loginEmployeeDTO.username);

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
              ));
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      );
    }
  }

  // Function for creating the listview for unassigned requests
  ListView createUnAssignedRequestsList(List<MaintenanceRequestDTO> requests) {
    // If the list of requests is empty,
    if (requests == null || requests.isEmpty) {
      // Return listView with only one object
      return ListView.builder(
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (context, index) {
            return ListTile(
              title:
                  Text("No maintenance requests un-assigned for today found..."),
            );
          });
    }
    // Else,
    else {
      // Return listView with ListTile for each room object with dividers between them
      return ListView.separated(
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        key: Key('UnAssignedRequestsList'),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          return ListTile(
              key: Key('UnAssignedRequest' + index.toString()),
              title: Text('Room: ' + requests.elementAt(index).roomCode),
              subtitle: Text(requests.elementAt(index).description),
              trailing: IconButton(
                key: Key('AssignRequest' + index.toString()),
                icon: Icon(Icons.add),
                onPressed: () {
                  // Show new AlertDialog
                  showDialog(
                    context: context,
                    child: new AlertDialog(
                      title: new Text('Assign To Maintenance Request'),
                      content: new Text(
                          'Are you sure you want to be assigned to the maintenance request for room: ' +
                              requests.elementAt(index).roomCode + '?'),
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
                            key: Key('AssignRequest'),
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
                                bool result = await employeeController
                                    .assignUnassignEmployeeFromMaintenance(
                                        requests
                                            .elementAt(index)
                                            .maintenanceRequestId,
                                        false,
                                        UserData().loginEmployeeDTO.username);

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
              ));
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      );
    }
  }

  // Function for creating the listview for the unassigned checkups
  ListView createAssignedCheckupsList(List<MaintenanceCheckupDTO> checkups) {
    // If the list of checkups is empty,
    if (checkups == null || checkups.isEmpty) {
      // Return listView with only one object
      return ListView.builder(
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("No maintenance checkups assigned..."),
            );
          });
    }
    // Else,
    else {
      // Return listView with ListTile for each room object with dividers between them
      return ListView.separated(
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        key: Key('AssignedCheckupsList'),
        itemCount: checkups.length,
        itemBuilder: (context, index) {
          // If the checkup in in progress,
          if (checkups.elementAt(index).inProgress) {
            return ListTile(
                key: Key('AssignedCheckup' + index.toString()),
                title: Text('Room: ' + checkups.elementAt(index).roomCode),
                trailing: IconButton(
                  key: Key('CompleteCheckup' + index.toString()),
                  icon: Icon(Icons.stop),
                  onPressed: () {
                    // Show new AlertDialog
                    showDialog(
                      context: context,
                      child: new AlertDialog(
                        title: new Text('Complete Maintenance Checkup'),
                        content: new Text(
                            'Has the maintenance request for room: ' +
                                checkups.elementAt(index).roomCode +
                                ' been completed?'),
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
                              key: Key('CompleteCheckup'),
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

                                  // Retrieve result from attempted start maintenance progress
                                  bool result = await employeeController
                                      .completeMaintenanceProgress(
                                          checkups
                                              .elementAt(index)
                                              .roomMaintenanceCheckupId,
                                          true,
                                          UserData().loginEmployeeDTO.username);

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
                ));
          }
          // Else,
          else {
            return ListTile(
              key: Key('AssignedCheckup' + index.toString()),
              title: Text('Room: ' + checkups.elementAt(index).roomCode),
              trailing: Wrap(
                children: <Widget>[
                  IconButton(
                    key: Key('StartCheckup' + index.toString()),
                    icon: Icon(Icons.play_arrow),
                    onPressed: () {
                      // Show new AlertDialog
                      showDialog(
                        context: context,
                        child: new AlertDialog(
                          title: new Text('Start Maintenance Checkup'),
                          content: new Text(
                              'Are you sure you want to start the maintenance checkup for room: ' +
                                  checkups.elementAt(index).roomCode + '?'),
                          actions: <Widget>[
                            new FlatButton(
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
                                key: Key('StartCheckup'),
                                child: new Text('OK',
                                    style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 18)),
                                // When ok pressed,
                                onPressed: () async {
                                  // If the there is an internet connection,
                                  if (await generalController
                                      .checkInternetConnection()) {
                                    setState(() {
                                      // Set loading to true
                                      loading = true;
                                    });

                                    // Retrieve result from attempted start maintenance progress
                                    bool result = await employeeController
                                        .startMaintenanceProgress(
                                            checkups
                                                .elementAt(index)
                                                .roomMaintenanceCheckupId,
                                            true,
                                            UserData()
                                                .loginEmployeeDTO
                                                .username);

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
                  IconButton(
                    key: Key('UnAssignCheckup' + index.toString()),
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      // Show new AlertDialog
                      showDialog(
                        context: context,
                        child: new AlertDialog(
                          title: new Text('UnAssign Maintenance Checkup'),
                          content: new Text(
                              'Are you sure you want to be un-assigned from the maintenance checkup for room: ' +
                                  checkups.elementAt(index).roomCode + '?'),
                          actions: <Widget>[
                            new FlatButton(
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
                                key: Key('UnAssignCheckup'),
                                child: new Text('OK',
                                    style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 18)),
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
                                    bool result = await employeeController
                                        .assignUnassignEmployeeFromMaintenance(
                                            checkups
                                                .elementAt(index)
                                                .roomMaintenanceCheckupId,
                                            true,
                                            UserData()
                                                .loginEmployeeDTO
                                                .username);

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
                  )
                ],
              ),
            );
          }
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      );
    }
  }

  // Function for creating the listview for assigned requests
  ListView createAssignedRequestsList(List<MaintenanceRequestDTO> requests) {
    // If the list of requests is empty,
    if (requests == null || requests.isEmpty) {
      // Return listView with only one object
      return ListView.builder(
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("No maintenance requests assigned..."),
            );
          });
    }
    // Else,
    else {
      // Return listView with ListTile for each room object with dividers between them
      return ListView.separated(
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        key: Key('AssignedRequestsList'),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          // If the request in in progress,
          if (requests.elementAt(index).inProgress) {
            return ListTile(
                key: Key('AssignedRequest' + index.toString()),
                title: Text('Room: ' + requests.elementAt(index).roomCode),
                subtitle: Text(requests.elementAt(index).description),
                trailing: IconButton(
                  key: Key('CompleteRequest' + index.toString()),
                  icon: Icon(Icons.stop),
                  onPressed: () {
                    // Show new AlertDialog
                    showDialog(
                      context: context,
                      child: new AlertDialog(
                        title: new Text('Complete Maintenance Request'),
                        content: new Text(
                            'Has the maintenance request for room: ' +
                                requests.elementAt(index).roomCode +
                                ' been completed?'),
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
                              key: Key('CompleteRequest'),
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
                                  bool result = await employeeController
                                      .completeMaintenanceProgress(
                                          requests
                                              .elementAt(index)
                                              .maintenanceRequestId,
                                          false,
                                          UserData().loginEmployeeDTO.username);

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
                ));
          }
          // Else,
          else {
            return ListTile(
              key: Key('AssignedRequest' + index.toString()),
              title: Text('Room: ' + requests.elementAt(index).roomCode),
              subtitle: Text(requests.elementAt(index).description),
              trailing: Wrap(
                children: <Widget>[
                  IconButton(
                    key: Key('StartRequest' + index.toString()),
                    icon: Icon(Icons.play_arrow),
                    onPressed: () {
                      // Show new AlertDialog
                      showDialog(
                        context: context,
                        child: new AlertDialog(
                          title: new Text('Start Maintenance Request'),
                          content: new Text(
                              'Are you sure you want to start the maintenance request for room: ' +
                                  requests.elementAt(index).roomCode + '?'),
                          actions: <Widget>[
                            new FlatButton(
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
                                key: Key('StartRequest'),
                                child: new Text('OK',
                                    style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 18)),
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
                                    bool result = await employeeController
                                        .startMaintenanceProgress(
                                            requests
                                                .elementAt(index)
                                                .maintenanceRequestId,
                                            false,
                                            UserData()
                                                .loginEmployeeDTO
                                                .username);

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
                  IconButton(
                    key: Key('UnAssignRequest' + index.toString()),
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      // Show new AlertDialog
                      showDialog(
                        context: context,
                        child: new AlertDialog(
                          title: new Text('UnAssign Maintenance Request'),
                          content: new Text(
                              'Are you sure you want to be un-assigned from the maintenance request for room: ' +
                                  requests.elementAt(index).roomCode + '?'),
                          actions: <Widget>[
                            new FlatButton(
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
                                key: Key('UnAssignRequest'),
                                child: new Text('OK',
                                    style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 18)),
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
                                    bool result = await employeeController
                                        .assignUnassignEmployeeFromMaintenance(
                                            requests
                                                .elementAt(index)
                                                .maintenanceRequestId,
                                            false,
                                            UserData()
                                                .loginEmployeeDTO
                                                .username);

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
                  )
                ],
              ),
            );
          }
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      );
    }
  }
}
