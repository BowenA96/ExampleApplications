import 'package:flutter/material.dart';
import 'package:hotel_room_booking_app/controllers/employee_controller.dart';
import 'package:hotel_room_booking_app/controllers/general_controller.dart';
import 'package:hotel_room_booking_app/dtos/employee/cleaning_checkup_dto.dart';
import 'package:hotel_room_booking_app/user_data.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// Class for the cleaning employee screen
class CleaningEmployeeScreen extends StatefulWidget {
  CleaningEmployeeScreen({Key key}) : super(key: key);

  @override
  State createState() => new CleaningEmployeeScreenState();
}

// Class for the cleaning employee screen state
class CleaningEmployeeScreenState extends State<CleaningEmployeeScreen> {
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

    // Create the list of cleaning details then,
    createCleaningListView(context).then((result) {
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
          key: Key('CleaningEmployeePage'),
          title: Text('Cleaning Employee Page'),
          backgroundColor: Colors.deepPurple,
        ),
        // Display the listView
        body: Center(child: listView),
      ),
    );
  }

  // Function for creating list view
  Future<ListView> createCleaningListView(BuildContext context) async {
    // Retrieve the maintenance checkups
    List<CleaningCheckupDTO> checkups =
        await employeeController.getCleaningCheckups(
            UserData().loginEmployeeDTO.username,
            UserData().loginEmployeeDTO.hotelName);

    // Create list of checkups which are assigned to the employee
    List<CleaningCheckupDTO> assignedCheckups = new List<CleaningCheckupDTO>();

    // Create list of checkups which are unassigned to the employee
    List<CleaningCheckupDTO> unAssignedCheckups = new List<CleaningCheckupDTO>();

    // For each of the checkups,
    for (CleaningCheckupDTO cleaningCheckupDTO in checkups) {
      // If the username is for the employee, add it to the assigned list
      if (cleaningCheckupDTO.username == UserData().loginEmployeeDTO.username)
        assignedCheckups.add(cleaningCheckupDTO);
      // Else, add it to the unassigned list
      else
        unAssignedCheckups.add(cleaningCheckupDTO);
    }

    return ListView.separated(
      scrollDirection: Axis.vertical,
      key: Key('HotelDetails'),
      itemCount: 4,
      itemBuilder: (context, index) {
        if (index == 0) {
          return ListTile(
            title: Text('Assigned Cleaning Checkups:',
                style: TextStyle(fontWeight: FontWeight.bold)),
          );
        } else if (index == 1) {
          return createAssignedCheckupsList(assignedCheckups);
        } else if (index == 2) {
          return ListTile(
            title: Text('Un-Assigned Cleaning Checkups:',
                style: TextStyle(fontWeight: FontWeight.bold)),
          );
        } else {
          return createUnAssignedCheckupsList(unAssignedCheckups);
        }
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  // Function for creating the listview for the unassigned checkups
  ListView createUnAssignedCheckupsList(List<CleaningCheckupDTO> checkups) {
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
              title: Text("No cleaning checkups un-assigned for today found..."),
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
                      title: new Text('Assign To Cleaning Checkup'),
                      content: new Text(
                          'Are you sure you want to be assigned to the cleaning checkup for room: ' +
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
                                    .assignUnassignEmployeeFromCleaning(
                                        checkups
                                            .elementAt(index)
                                            .roomCleaningId,
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
  ListView createAssignedCheckupsList(List<CleaningCheckupDTO> checkups) {
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
              title: Text("No cleaning checkups assigned..."),
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
                        title: new Text('Complete Cleaning Checkup'),
                        content: new Text(
                            'Has the cleaning checkup for room: ' +
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
                                      .completeCleaningProgress(
                                          checkups
                                              .elementAt(index)
                                              .roomCleaningId,
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
                          title: new Text('Start Cleaning Checkup'),
                          content: new Text(
                              'Are you sure you want to start the cleaning checkup for room: ' +
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
                                        .startCleaningProgress(
                                            checkups
                                                .elementAt(index)
                                                .roomCleaningId,
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
                          title: new Text('UnAssign Cleaning Checkup'),
                          content: new Text(
                              'Are you sure you want to be un-assigned from the cleaning checkup for room: ' +
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
                                        .assignUnassignEmployeeFromCleaning(
                                            checkups
                                                .elementAt(index)
                                                .roomCleaningId,
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
