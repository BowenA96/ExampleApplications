import 'dart:io';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

// Find function for looking to see if a widget is currently present
Future<bool> lookup(String key, FlutterDriver flutterDriver,
    {Duration duration = const Duration(seconds: 10)}) async {
  try {
    // Try to find the widget by the key
    await flutterDriver.waitFor(find.byValueKey(key), timeout: duration);

    // If found, return true
    return true;
  } catch (exception) {
    // Return false if exception caught
    return false;
  }
}

// Main function for running the tests
void main() {
  group('Sprint 1 Tests', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) driver.close();
    });

    // Testing view hotels acceptance criteria
    test('View hotels', () async {
      // Initialize success bool value
      bool success = false;

      // Click the go to employee login button
      await driver.tap(find.byValueKey('GoToEmployeeLogin'));

      // Click the go to administrator login button
      await driver.tap(find.byValueKey('GoToAdministratorLogin'));

      // Get username textfield and set text
      await driver.tap(find.byValueKey('AdministratorUsername'));
      await driver.enterText('admin1');

      // Get password textfield and set text
      await driver.tap(find.byValueKey('AdministratorPassword'));
      await driver.enterText('test1');

      // If the go to admin screen button is null,
      if (await lookup('AdministratorLogin', driver)) {
        // Click the go to admin screen button
        await driver.tap(find.byValueKey('AdministratorLogin'));

        // If the hotels list can be found, set success to true
        if (await lookup('HotelsList', driver)) success = true;
      }

      expect(success, true);
    });

    // Testing view employees acceptance criteria
    test('View employees for hotel', () async {
      // Initialize success bool value
      bool success = false;

      if (await lookup('hotel1', driver)) {
        // Click the first hotel list item
        await driver.tap(find.byValueKey('hotel1'));

        // If the employees list can be found, set success to true
        if (await lookup('EmployeesList', driver)) success = true;
      }

      expect(success, true);
    });

    // Testing create employee acceptance criteria
    test('Create employee with valid details', () async {
      // Initialize success bool value
      bool success = false;

      // If the create employee button can be found,
      if (await lookup('CreateEmployee', driver)) {
        // Click the create employee button
        await driver.tap(find.byValueKey('CreateEmployee'));

        // Get username textfield and set text
        await driver.tap(find.byValueKey('EmployeeUsername'));
        await driver.enterText('IntegrationTest');

        // Get first name textfield and set text
        await driver.tap(find.byValueKey('EmployeeFirstName'));
        await driver.enterText('Test');

        // Get last name textfield and set text
        await driver.tap(find.byValueKey('EmployeeLastName'));
        await driver.enterText('Guy');

        // Get password textfield and set text
        await driver.tap(find.byValueKey('EmployeePassword'));
        await driver.enterText('Password');

        // If the confirm button can be found,
        if (await lookup('CreateEmployeeConfirm', driver)) {
          // Click the confirm button
          await driver.tap(find.byValueKey('CreateEmployeeConfirm'));

          // If the created employee list item can be found, set success to true
          if (await lookup('Employee-IntegrationTest', driver)) success = true;
        }

        expect(success, true);
      }
    });

    // Testing create employee acceptance criteria
    test('Create employee with invalid details', () async {
      // Initialize success bool value
      bool success = false;

      // If the create employee button can be found,
      if (await lookup('CreateEmployee', driver)) {
        // Click the create employee button
        await driver.tap(find.byValueKey('CreateEmployee'));

        // Get username textfield and set text
        await driver.tap(find.byValueKey('EmployeeUsername'));
        await driver.enterText('?IntegrationTest?');

        // Get first name textfield and set text
        await driver.tap(find.byValueKey('EmployeeFirstName'));
        await driver.enterText('?Test?');

        // Get last name textfield and set text
        await driver.tap(find.byValueKey('EmployeeLastName'));
        await driver.enterText('?Guy?');

        // Get password textfield and set text
        await driver.tap(find.byValueKey('EmployeePassword'));
        await driver.enterText('?Password?');

        // If the confirm button can be found,
        if (await lookup('CreateEmployeeConfirm', driver)) {
          // Click the confirm button
          await driver.tap(find.byValueKey('CreateEmployeeConfirm'));

          // If the created dialog is still showing, set success to true
          if (await lookup('CreateEmployeeConfirm', driver)) success = true;
        }

        expect(success, true);
      }
    });

    // Testing create employee acceptance criteria
    test('Create employee with existing employee username', () async {
      // Initialize success bool value
      bool success = false;

      // Get username textfield and set text
      await driver.tap(find.byValueKey('EmployeeUsername'));
      await driver.enterText('IntegrationTest');

      // Get first name textfield and set text
      await driver.tap(find.byValueKey('EmployeeFirstName'));
      await driver.enterText('Test');

      // Get last name textfield and set text
      await driver.tap(find.byValueKey('EmployeeLastName'));
      await driver.enterText('Guy');

      // Get password textfield and set text
      await driver.tap(find.byValueKey('EmployeePassword'));
      await driver.enterText('Password');

      // If the confirm button can be found,
      if (await lookup('CreateEmployeeConfirm', driver)) {
        // Click the confirm button
        await driver.tap(find.byValueKey('CreateEmployeeConfirm'));

        // If the created dialog is still showing, set success to true
        if (await lookup('CreateEmployeeConfirm', driver)) {
          await driver.tap(find.byValueKey('CreateEmployeeCancel'));
          success = true;
        }
      }

      expect(success, true);
    });

    // Testing delete employee acceptance criteria
    test('Delete employee', () async {
      // Initialize success bool value
      bool success = false;

      // If the employee can be found,
      if (await lookup('Employee-IntegrationTest', driver)) {
        // Click the delete button for the employee
        await driver.tap(find.byValueKey('DeleteEmployee-IntegrationTest'));

        // If the confirm delete employee can be found, press the button
        if (await lookup('DeleteEmployee', driver)) {
          await driver.tap(find.byValueKey('DeleteEmployee'));

          if (await lookup('Employee-IntegrationTest', driver)) success = true;
        }
      }

      expect(success, false);
    });
  });

  group('Sprint 2 Tests', () {
    FlutterDriver driver;

    setUpAll(() async {
      final String adbPath =
          'C:/Users/bowen/AppData/Local/Android/Sdk/platform-tools/adb.exe';
      await Process.run(adbPath, [
        'shell',
        'pm',
        'grant',
        'alexbowen.dev.hotel_room_booking_app',
        'android.permission.ACCESS_COARSE_LOCATION'
      ]);
      await Process.run(adbPath, [
        'shell',
        'pm',
        'grant',
        'alexbowen.dev.hotel_room_booking_app',
        'android.permission.ACCESS_FINE_LOCATION'
      ]);
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) driver.close();
    });

    // Testing logging in and out acceptance criteria
    test('Username login and logout', () async {
      // Initialize success bool value
      bool success = false;

      // Navigate back to the admin main page
      await driver.tap(find.pageBack());

      // Logout the administrator
      await driver.tap(find.pageBack());

      // Navigate back to the employee login screen
      await driver.tap(find.pageBack());

      // Get password textfield and set text
      await driver.tap(find.byValueKey('EmployeeUsername'));
      await driver.enterText('employee1');

      // Get password textfield and set text
      await driver.tap(find.byValueKey('EmployeePassword'));
      await driver.enterText('test1');

      // If the confirm button can be found,
      if (await lookup('EmployeeLogin', driver)) {
        // Click the confirm button
        await driver.tap(find.byValueKey('EmployeeLogin'));

        // If the update password button can be found,
        if (await lookup('UpdatePasswordConfirm', driver)) {
          // Get password textfield and set text
          await driver.tap(find.byValueKey('UpdateEmployeePassword'));
          await driver.enterText('test1');

          // If the confirm button can be found,
          if (await lookup('UpdatePasswordConfirm', driver)) {
            // Click the confirm button
            await driver.tap(find.byValueKey('UpdatePasswordConfirm'));
          }
        }

        // If the created employee page can be found,
        if (await lookup('CleaningEmployeePage', driver)) {
          // Navigate back to the employee login screen
          await driver.tap(find.pageBack());

          // If the created employee login page can be found, set success to true
          if (await lookup('EmployeeLoginPage', driver)) {
            // Navigate back to the landing page
            await driver.tap(find.pageBack());

            // Navigate to the customer login page
            await driver.tap(find.byValueKey('GoToCustomerLogin'));

            // Get password textfield and set text
            await driver.tap(find.byValueKey('CustomerUsername'));
            await driver.enterText('IntegrationTest');

            // Get password textfield and set text
            await driver.tap(find.byValueKey('CustomerPassword'));
            await driver.enterText('test1');

            // If the confirm button can be found,
            if (await lookup('CustomerLogin', driver)) {
              // Click the confirm button
              await driver.tap(find.byValueKey('CustomerLogin'));

              success = true;
            }
          }
        }
      }

      // Open the navigation menu
      await driver.tap(find.byTooltip("Open navigation menu"));

      // Logout the customer
      await driver.tap(find.byValueKey('Logout'));

      expect(success, true);
    });

    // Testing guest login and viewing hotels as customer
    test('Continue as guest and view hotels', () async {
      // Initialize success bool value
      bool success = false;

      // If the confirm button can be found,
      if (await lookup('GuestLogin', driver)) {
        // Click the confirm button
        await driver.tap(find.byValueKey('GuestLogin'));

        // If the hotel list can be found, set success to true
        if (await lookup('HotelsListAlpha', driver)) success = true;
      }

      expect(success, true);
    });

    // Testing viewing hotels by distance
    test('View hotels by distance', () async {
      // Initialize success bool value
      bool success = false;

      // If the sort location button can be found,
      if (await lookup('SortLocation', driver)) {
        // Click the sort location button
        await driver.tap(find.byValueKey('SortLocation'));

        // If the hotel list sorted by location can be found, set success to true
        if (await lookup('HotelsListLocation', driver)) success = true;
      }

      expect(success, true);
    });

    // Testing viewing hotel details
    test('View hotel details', () async {
      // Initialize success bool value
      bool success = false;

      // If the sort location button can be found,
      if (await lookup('hotel1', driver)) {
        // Click one of the hotels
        await driver.tap(find.byValueKey('hotel1'));

        // If the hotel details can be found, set success to true
        if (await lookup('HotelDetails', driver)) success = true;
      }

      expect(success, true);
    });

    // Testing viewing hotel details
    test('View list of rooms', () async {
      // Initialize success bool value
      bool success = false;

      // If the start date button can be found,
      if (await lookup('StartDate', driver)) {
        // Click one of the hotels
        await driver.tap(find.byValueKey('StartDate'));

        // Click the day of the month
        await driver.tap(find.text('27'));

        // Click the confirm button
        await driver.tap(find.text('OK'));

        // Click one of the hotels
        await driver.tap(find.byValueKey('EndDate'));

        // Click the day of the month
        await driver.tap(find.text('28'));

        // Click the confirm button
        await driver.tap(find.text('OK'));

        // Click the check rooms button
        await driver.tap(find.byValueKey('CheckRooms'));

        // Set success to true
        success = true;
      }

      expect(success, true);
    });
  });

  group('Sprint 3 Tests', () {
    FlutterDriver driver;

    setUpAll(() async {
      final String adbPath =
          'C:/Users/bowen/AppData/Local/Android/Sdk/platform-tools/adb.exe';
      await Process.run(adbPath, [
        'shell',
        'pm',
        'grant',
        'alexbowen.dev.hotel_room_booking_app',
        'android.permission.ACCESS_COARSE_LOCATION'
      ]);
      await Process.run(adbPath, [
        'shell',
        'pm',
        'grant',
        'alexbowen.dev.hotel_room_booking_app',
        'android.permission.ACCESS_FINE_LOCATION'
      ]);
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) driver.close();
    });

    // Testing adding room to basket
    test('Add room to basket as guest user', () async {
      // Initialize success bool value
      bool success = false;

      // Click one of the hotels
      await driver.tap(find.byValueKey('AddRoom1'));

      // If the register button can be found,
      if (await lookup('CustomerRegistration', driver)) {
        // Get username textfield and set text
        await driver.tap(find.byValueKey('CustomerUsername'));
        await driver.enterText('IntegrationTest123');

        // Get password textfield and set text
        await driver.tap(find.byValueKey('CustomerPassword'));
        await driver.enterText('test1');

        // Click the confirm button
        await driver.tap(find.byValueKey('CustomerRegistration'));

        // If the no button can be found,
        if (await lookup('NoButton', driver)) {
          // Click the no button
          await driver.tap(find.byValueKey('NoButton'));

          // Update success to true
          success = true;
        }
      }

      expect(success, true);
    });

    // Testing adding room to basket
    test('Add room to basket', () async {
      // Initialize success bool value
      bool success = false;

      // Click one of the hotels
      await driver.tap(find.byValueKey('AddRoom1'));

      // If the no button can be found,
      if (await lookup('YesButton', driver)) {
        // Click the no button
        await driver.tap(find.byValueKey('YesButton'));

        // Update success to true
        success = true;
      }

      expect(success, true);
    });

    // Testing adding room to basket
    test('View bookings in basket', () async {
      // Initialize success bool value
      bool success = false;

      // If the bookings list can be found,
      if (await lookup('BookingsList', driver)) {
        // Update success to true
        success = true;
      }

      expect(success, true);
    });

    // Testing adding room to basket
    test('Remove booking from basket', () async {
      // Initialize success bool value
      bool success = false;

      // If the remove booking icon can be found,
      if (await lookup('removebooking1', driver)) {
        // Click the no button
        await driver.tap(find.byValueKey('removebooking1'));

        // Click the no button
        await driver.tap(find.byValueKey('RemoveBooking'));

        // Update success to true
        success = true;
      }

      expect(success, true);
    });

    // Testing adding room to basket
    test('Checkout basket', () async {
      // Initialize success bool value
      bool success = false;

      // If the checkout basket icon can be found,
      if (await lookup('CheckoutBasket', driver)) {
        // Click the no button
        await driver.tap(find.byValueKey('CheckoutBasket'));

        // Update success to true
        success = true;
      }

      expect(success, true);
    });

    // Testing adding room to basket
    test('View list of bookings made by the customer', () async {
      // Initialize success bool value
      bool success = false;

      // If the future bookings list can be found,
      if (await lookup('FutureBookingsList', driver)) {
        // Update success to true
        success = true;
      }

      expect(success, true);
    });
  });

  group('Sprint 4 Tests', () {
    FlutterDriver driver;

    setUpAll(() async {
      final String adbPath =
          'C:/Users/bowen/AppData/Local/Android/Sdk/platform-tools/adb.exe';
      await Process.run(adbPath, [
        'shell',
        'pm',
        'grant',
        'alexbowen.dev.hotel_room_booking_app',
        'android.permission.ACCESS_COARSE_LOCATION'
      ]);
      await Process.run(adbPath, [
        'shell',
        'pm',
        'grant',
        'alexbowen.dev.hotel_room_booking_app',
        'android.permission.ACCESS_FINE_LOCATION'
      ]);
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) driver.close();
    });

    // Testing adding room to basket
    test('Cancel upcoming booking', () async {
      // Initialize success bool value
      bool success = false;

      // If the cancel booking icon can be found,
      if (await lookup('CancelBooking0', driver)) {
        // Click the cancel button
        await driver.tap(find.byValueKey('CancelBooking0'));

        // If the checkout basket icon can be found,
        if (await lookup('CancelBooking', driver)) {
          // Click the cancel button
          await driver.tap(find.byValueKey('CancelBooking'));

          // Update success to true
          success = true;
        }
      }

      expect(success, true);
    });

    // Testing adding room to basket
    test('Create maintenance request without description', () async {
      // Initialize success bool value
      bool success = false;

      // Open the navigation menu
      await driver.tap(find.byTooltip("Open navigation menu"));

      // Logout the customer
      await driver.tap(find.byValueKey('Logout'));

      // Navigate to the customer login page
      await driver.tap(find.byValueKey('GoToCustomerLogin'));

      // Get password textfield and set text
      await driver.tap(find.byValueKey('CustomerUsername'));
      await driver.enterText('IntegrationTest');

      // Get password textfield and set text
      await driver.tap(find.byValueKey('CustomerPassword'));
      await driver.enterText('test1');

      // Attempt customer registration
      await driver.tap(find.byValueKey('CustomerLogin'));

      // Open the navigation menu
      await driver.tap(find.byTooltip("Open navigation menu"));

      // Logout the customer
      await driver.tap(find.byValueKey('Bookings'));

      // If the cancel booking icon can be found,
      if (await lookup('CreateMaintenanceRequest0', driver)) {
        // Click the create button
        await driver.tap(find.byValueKey('CreateMaintenanceRequest0'));

        // If the create maintenance request can be found,
        if (await lookup('CreateMaintenanceRequest', driver)) {
          // Click the cancel button
          await driver.tap(find.byValueKey('CreateMaintenanceRequestConfirm'));

          // If the create maintenance request can be found,
          if (await lookup('CreateMaintenanceRequest', driver)) {
            // Update success to true
            success = true;
          }
        }
      }

      expect(success, true);
    });

    // Testing adding room to basket
    test('Create maintenance request with description', () async {
      // Initialize success bool value
      bool success = false;

      // If the create maintenance request can be found,
      if (await lookup('CreateMaintenanceRequest', driver)) {
        // Get password textfield and set text
        await driver.tap(find.byValueKey('MaintenanceRequestDescription'));
        await driver.enterText('testdescription');

        // Click the cancel button
        await driver.tap(find.byValueKey('CreateMaintenanceRequestConfirm'));

        // If the create maintenance request can be found,
        if (await lookup('ConfirmButton', driver)) {
          // Click the cancel button
          await driver.tap(find.byValueKey('ConfirmButton'));

          // Update success to true
          success = true;
        }
      }

      expect(success, true);
    });

    // Testing adding room to basket
    test('Create maintenance request with already active maintenance request',
        () async {
      // Initialize success bool value
      bool success = false;

      // If the cancel booking icon can be found,
      if (await lookup('CreateMaintenanceRequest0', driver)) {
        // Click the create button
        await driver.tap(find.byValueKey('CreateMaintenanceRequest0'));

        // If the create maintenance request can be found,
        if (await lookup('MaintenanceRequestActive', driver)) {
          // Click the cancel button
          await driver.tap(find.byValueKey('ConfirmButton'));

          // Update success to true
          success = true;
        }
      }

      expect(success, true);
    });

    // Testing adding invalid review
    test('Create invalid hotel review', () async {
      // Initialize success bool value
      bool success = false;

      // If the create review icon can be found,
      if (await lookup('CreateReview0', driver)) {
        // Click the create button
        await driver.tap(find.byValueKey('CreateReview0'));

        // If the create review dialog can be found,
        if (await lookup('CreateReview', driver)) {
          // Click the create button
          await driver.tap(find.byValueKey('CreateReviewConfirm'));

          // If the create review dialog can still be found,
          if (await lookup('CreateReview', driver)) {
            // Update success to true
            success = true;
          }
        }
      }

      expect(success, true);
    });

    // Testing adding valid review
    test('Create valid hotel review', () async {
      // Initialize success bool value
      bool success = false;

      // If the create review dialog can be found,
      if (await lookup('CreateReview', driver)) {
        // Get username textfield and set text
        await driver.tap(find.byValueKey('ReviewRating'));
        await driver.enterText('9');

        // Get password textfield and set text
        await driver.tap(find.byValueKey('ReviewDescription'));
        await driver.enterText('test');

        // Click the create button
        await driver.tap(find.byValueKey('CreateReviewConfirm'));

        // Click the cancel button
        await driver.tap(find.byValueKey('ConfirmButton'));

        // Set success to true
        success = true;
      }

      expect(success, true);
    });

    // Testing invalid update hotel review
    test('Update hotel review invalid details', () async {
      // Initialize success bool value
      bool success = false;

      // If the create review icon can be found,
      if (await lookup('CreateReview0', driver)) {
        // Click the create button
        await driver.tap(find.byValueKey('CreateReview0'));

        // If the update review dialog can be found,
        if (await lookup('UpdateReview', driver)) {
          // Click the update button
          await driver.tap(find.byValueKey('UpdateReviewConfirm'));

          // If the update review dialog can still be found,
          if (await lookup('UpdateReview', driver)) {
            // Update success to true
            success = true;
          }
        }
      }

      expect(success, true);
    });

    // Testing update hotel review
    test('Update hotel review valid details', () async {
      // Initialize success bool value
      bool success = false;

      // Get username textfield and set text
      await driver.tap(find.byValueKey('ReviewRating'));
      await driver.enterText('9');

      // Get password textfield and set text
      await driver.tap(find.byValueKey('ReviewDescription'));
      await driver.enterText('testtesttesttest');

      // Click the create button
      await driver.tap(find.byValueKey('UpdateReviewConfirm'));

      // Click the cancel button
      await driver.tap(find.byValueKey('ConfirmButton'));

      // Update success to true
      success = true;

      expect(success, true);
    });

    // Testing adding room to basket
    test('Delete hotel review', () async {
      // Initialize success bool value
      bool success = false;

      // If the create review icon can be found,
      if (await lookup('CreateReview0', driver)) {
        // Click the create button
        await driver.tap(find.byValueKey('CreateReview0'));

        // If the update review dialog can be found,
        if (await lookup('DeleteReviewConfirm', driver)) {
          // Click the update button
          await driver.tap(find.byValueKey('DeleteReviewConfirm'));

          // Click the cancel button
          await driver.tap(find.byValueKey('ConfirmButton'));

          // Update success to true
          success = true;
        }
      }

      expect(success, true);
    });

    // Testing adding room to basket
    test('Register customer invalid details', () async {
      // Initialize success bool value
      bool success = false;

      // Open the navigation menu
      await driver.tap(find.byTooltip("Open navigation menu"));

      // Logout the customer
      await driver.tap(find.byValueKey('Logout'));

      // Attempt customer registration
      await driver.tap(find.byValueKey('CustomerRegistration'));

      if (await lookup("CustomerLoginPage", driver)) {
        // Update success to true
        success = true;
      }

      expect(success, true);
    });

    // Testing registering customer
    test('Register customer valid details', () async {
      // Initialize success bool value
      bool success = false;

      // Get password textfield and set text
      await driver.tap(find.byValueKey('CustomerUsername'));
      await driver.enterText('testtesttest');

      // Get password textfield and set text
      await driver.tap(find.byValueKey('CustomerPassword'));
      await driver.enterText('test1');

      // Attempt customer registration
      await driver.tap(find.byValueKey('CustomerRegistration'));

      // Open the navigation menu
      await driver.tap(find.byTooltip("Open navigation menu"));

      // Logout the customer
      await driver.tap(find.byValueKey('Logout'));

      if (await lookup("CustomerLoginPage", driver)) {
        // Update success to true
        success = true;
      }

      expect(success, true);
    });
  });

  group('Sprint 5 Tests', () {
    FlutterDriver driver;

    setUpAll(() async {
      final String adbPath =
          'C:/Users/bowen/AppData/Local/Android/Sdk/platform-tools/adb.exe';
      await Process.run(adbPath, [
        'shell',
        'pm',
        'grant',
        'alexbowen.dev.hotel_room_booking_app',
        'android.permission.ACCESS_COARSE_LOCATION'
      ]);
      await Process.run(adbPath, [
        'shell',
        'pm',
        'grant',
        'alexbowen.dev.hotel_room_booking_app',
        'android.permission.ACCESS_FINE_LOCATION'
      ]);
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) driver.close();
    });

    // Testing first time login
    test('First time login invalid password', () async {
      // Initialize success bool value
      bool success = false;

      // Navigate back to the welcome screen
      await driver.tap(find.pageBack());

      // Click the go to employee login button
      await driver.tap(find.byValueKey('GoToEmployeeLogin'));

      // Get username textfield and set text
      await driver.tap(find.byValueKey('EmployeeUsername'));
      await driver.enterText('employee2');

      // Get password textfield and set text
      await driver.tap(find.byValueKey('EmployeePassword'));
      await driver.enterText('test2');

      // If the confirm button can be found,
      if (await lookup('EmployeeLogin', driver)) {
        // Click the confirm button
        await driver.tap(find.byValueKey('EmployeeLogin'));

        // If the confirm button can be found,
        if (await lookup('UpdatePasswordConfirm', driver)) {
          // Click the confirm button
          await driver.tap(find.byValueKey('UpdatePasswordConfirm'));

          // If the update password button can be found,
          if (await lookup('UpdatePasswordConfirm', driver)) {
            // Update success
            success = true;
          }
        }
      }

      expect(success, true);
    });

    // Testing first time login
    test('First time login valid password', () async {
      // Initialize success bool value
      bool success = false;

      // If the confirm button can be found,
      if (await lookup('UpdatePasswordConfirm', driver)) {
        // Get password textfield and set text
        await driver.tap(find.byValueKey('UpdateEmployeePassword'));
        await driver.enterText('test2');

        // Click the confirm button
        await driver.tap(find.byValueKey('UpdatePasswordConfirm'));

        // Update success
        success = true;
      }

      expect(success, true);
    });

    // Testing viewing list of checkups and requests
    test('View list of maintenance checkups and requests', () async {
      // Initialize success bool value
      bool success = false;

      // If the confirm button can be found,
      if (await lookup('UnAssignedRequestsList', driver)) {
        // Update success
        success = true;
      }

      expect(success, true);
    });

    // Testing updating list of checkups and requests
    test('Assign to checkup/request', () async {
      // Initialize success bool value
      bool success = false;

      // If the confirm button can be found,
      if (await lookup('AssignCheckup0', driver)) {
        // Click the confirm button
        await driver.tap(find.byValueKey('AssignCheckup0'));

        // If the confirm button can be found,
        if (await lookup('AssignCheckup', driver)) {
          // Click the confirm button
          await driver.tap(find.byValueKey('AssignCheckup'));

          // Update success
          success = true;
        }
      }

      expect(success, true);
    });

    // Testing updating list of checkups and requests
    test('UnAssign from checkup/request', () async {
      // Initialize success bool value
      bool success = false;

      // If the confirm button can be found,
      if (await lookup('UnAssignCheckup0', driver)) {
        // Click the confirm button
        await driver.tap(find.byValueKey('UnAssignCheckup0'));

        // If the confirm button can be found,
        if (await lookup('UnAssignCheckup', driver)) {
          // Click the confirm button
          await driver.tap(find.byValueKey('UnAssignCheckup'));

          // Update success
          success = true;
        }
      }

      expect(success, true);
    });

    // Testing updating list of checkups and requests
    test('Begin checkup/request', () async {
      // Initialize success bool value
      bool success = false;

      // If the confirm button can be found,
      if (await lookup('AssignCheckup0', driver)) {
        // Click the confirm button
        await driver.tap(find.byValueKey('AssignCheckup0'));

        // If the confirm button can be found,
        if (await lookup('AssignCheckup', driver)) {
          // Click the confirm button
          await driver.tap(find.byValueKey('AssignCheckup'));

          // If the confirm button can be found,
          if (await lookup('StartCheckup0', driver)) {
            // Click the confirm button
            await driver.tap(find.byValueKey('StartCheckup0'));

            // If the confirm button can be found,
            if (await lookup('StartCheckup', driver)) {
              // Click the confirm button
              await driver.tap(find.byValueKey('StartCheckup'));

              // update success bool value
              success = true;
            }
          }
        }
      }

      expect(success, true);
    });

    // Testing updating list of checkups and requests
    test('Complete checkup/request', () async {
      // Initialize success bool value
      bool success = false;

      // If the confirm button can be found,
      if (await lookup('CompleteCheckup0', driver)) {
        // Click the confirm button
        await driver.tap(find.byValueKey('CompleteCheckup0'));

        // If the confirm button can be found,
        if (await lookup('CompleteCheckup', driver)) {
          // Click the confirm button
          await driver.tap(find.byValueKey('CompleteCheckup'));

          // update success bool value
          success = true;
        }
      }

      expect(success, true);
    });
  });

  group('Sprint 6 Tests', () {
    FlutterDriver driver;

    setUpAll(() async {
      final String adbPath =
          'C:/Users/bowen/AppData/Local/Android/Sdk/platform-tools/adb.exe';
      await Process.run(adbPath, [
        'shell',
        'pm',
        'grant',
        'alexbowen.dev.hotel_room_booking_app',
        'android.permission.ACCESS_COARSE_LOCATION'
      ]);
      await Process.run(adbPath, [
        'shell',
        'pm',
        'grant',
        'alexbowen.dev.hotel_room_booking_app',
        'android.permission.ACCESS_FINE_LOCATION'
      ]);
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) driver.close();
    });

    // View list of cleaning checkups
    test('View cleaning checkups', () async {
      // Initialize success bool value
      bool success = false;

      // Navigate back to the welcome screen
      await driver.tap(find.pageBack());

      // Get username textfield and set text
      await driver.tap(find.byValueKey('EmployeeUsername'));
      await driver.enterText('employee1');

      // Get password textfield and set text
      await driver.tap(find.byValueKey('EmployeePassword'));
      await driver.enterText('test1');

      // Click the confirm button
      await driver.tap(find.byValueKey('EmployeeLogin'));

      // If the confirm button can be found,
      if (await lookup('UnAssignedCheckupsList', driver)) {
        // Update success
        success = true;
      }

      expect(success, true);
    });

    // Update cleaning checkup
    test('Assign to cleaning checkup', () async {
      // Initialize success bool value
      bool success = false;

      // If the confirm button can be found,
      if (await lookup('AssignCheckup0', driver)) {
        // Click the confirm button
        await driver.tap(find.byValueKey('AssignCheckup0'));

        // If the confirm button can be found,
        if (await lookup('AssignCheckup', driver)) {
          // Click the confirm button
          await driver.tap(find.byValueKey('AssignCheckup'));

          // Update success
          success = true;
        }
      }

      expect(success, true);
    });

    // Update cleaning checkup
    test('UnAssign from cleaning checkup', () async {
      // Initialize success bool value
      bool success = false;

      // If the confirm button can be found,
      if (await lookup('UnAssignCheckup0', driver)) {
        // Click the confirm button
        await driver.tap(find.byValueKey('UnAssignCheckup0'));

        // If the confirm button can be found,
        if (await lookup('UnAssignCheckup', driver)) {
          // Click the confirm button
          await driver.tap(find.byValueKey('UnAssignCheckup'));

          // Update success
          success = true;
        }
      }

      expect(success, true);
    });

    // Update cleaning checkup
    test('Begin cleaning checkup', () async {
      // Initialize success bool value
      bool success = false;

      // If the confirm button can be found,
      if (await lookup('AssignCheckup0', driver)) {
        // Click the confirm button
        await driver.tap(find.byValueKey('AssignCheckup0'));

        // If the confirm button can be found,
        if (await lookup('AssignCheckup', driver)) {
          // Click the confirm button
          await driver.tap(find.byValueKey('AssignCheckup'));

          // If the confirm button can be found,
          if (await lookup('StartCheckup0', driver)) {
            // Click the confirm button
            await driver.tap(find.byValueKey('StartCheckup0'));

            // If the confirm button can be found,
            if (await lookup('StartCheckup', driver)) {
              // Click the confirm button
              await driver.tap(find.byValueKey('StartCheckup'));

              // update success bool value
              success = true;
            }
          }
        }
      }

      expect(success, true);
    });

    // Update cleaning checkup
    test('Complete cleaning checkup', () async {
      // Initialize success bool value
      bool success = false;

      // If the confirm button can be found,
      if (await lookup('CompleteCheckup0', driver)) {
        // Click the confirm button
        await driver.tap(find.byValueKey('CompleteCheckup0'));

        // If the confirm button can be found,
        if (await lookup('CompleteCheckup', driver)) {
          // Click the confirm button
          await driver.tap(find.byValueKey('CompleteCheckup'));

          // update success bool value
          success = true;
        }
      }

      expect(success, true);
    });

    // View list of customer bookings
    test('View list of customer bookings', () async {
      // Initialize success bool value
      bool success = false;

      // Navigate back to the welcome screen
      await driver.tap(find.pageBack());

      // Get username textfield and set text
      await driver.tap(find.byValueKey('EmployeeUsername'));
      await driver.enterText('employee4');

      // Get password textfield and set text
      await driver.tap(find.byValueKey('EmployeePassword'));
      await driver.enterText('test4');

      // Click the confirm button
      await driver.tap(find.byValueKey('EmployeeLogin'));

      // If the confirm button can be found,
      if (await lookup('InActiveBookingsList', driver)) {
        // Update success
        success = true;
      }

      expect(success, true);
    });

    // Update customer booking
    test('Set customer booking to active', () async {
      // Initialize success bool value
      bool success = false;

      // If the confirm button can be found,
      if (await lookup('ActivateBooking0', driver)) {
        // Click the confirm button
        await driver.tap(find.byValueKey('ActivateBooking0'));

        // If the confirm button can be found,
        if (await lookup('ActivateBooking', driver)) {
          // Click the confirm button
          await driver.tap(find.byValueKey('ActivateBooking'));

          // Update success
          success = true;
        }
      }

      expect(success, true);
    });

    // Update customer booking
    test('Extend customer booking', () async {
      // Initialize success bool value
      bool success = false;

      // If the confirm button can be found,
      if (await lookup('ExtendBooking0', driver)) {
        // Click the confirm button
        await driver.tap(find.byValueKey('ExtendBooking0'));

        // If the confirm button can be found,
        if (await lookup('ExtendBooking', driver)) {
          await driver.tap(find.byValueKey('DateTimeField'));
          await driver.tap(find.text('28'));
          await driver.tap(find.text('OK'));

          // Click the confirm button
          await driver.tap(find.byValueKey('ExtendBooking'));

          // Update success
          success = true;
        }
      }

      expect(success, true);
    });

    // Update customer booking
    test('Set customer booking to completed', () async {
      // Initialize success bool value
      bool success = false;

      // If the confirm button can be found,
      if (await lookup('CompleteBooking0', driver)) {
        // Click the confirm button
        await driver.tap(find.byValueKey('CompleteBooking0'));

        // If the confirm button can be found,
        if (await lookup('CompleteBooking', driver)) {
          // Click the confirm button
          await driver.tap(find.byValueKey('CompleteBooking'));

          // Update success
          success = true;
        }
      }

      expect(success, true);
    });
  });
}
