import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:hotel_room_booking_app/dtos/customer/customer_booking_dto.dart';
import 'package:hotel_room_booking_app/dtos/customer/maintenance_request_dto.dart';
import 'package:hotel_room_booking_app/dtos/employee/cleaning_checkup_dto.dart';
import 'package:hotel_room_booking_app/dtos/employee/maintenance_checkup_dto.dart';
import 'package:hotel_room_booking_app/dtos/login/login_employee_dto.dart';
import 'package:hotel_room_booking_app/web_service_request.dart';
import 'package:http/http.dart';

// Class for performing employee functionality
class EmployeeController {
  // Create instance of the web service request class
  WebServiceRequest webServiceRequest = new WebServiceRequest();

  // Function for logging in as employee
  Future<LoginEmployeeDTO> loginEmployee(
      String username, String password) async {
    // Retrieve response from get web service request
    Response response = await webServiceRequest
        .getRequest("employee/login/$username/$password");

    // If the response is null, return null
    if (response.body == null || response.body == "null") return null;

    // Perform first decode of the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to create map object
    Map<String, dynamic> secondDecode = jsonDecode(firstDecode);

    // Get login details from Json
    LoginEmployeeDTO login = LoginEmployeeDTO.fromJson(secondDecode);

    // Return the login details
    return login;
  }

  // Function for updating the password as employee
  Future<LoginEmployeeDTO> updatePassword(
      String username, String password) async {
    // Retrieve response from get web service request
    Response response = await webServiceRequest
        .getRequest("employee/first/login/$username/$password");

    // If the response is null, return null
    if (response.body == null || response.body == "null") return null;

    // Perform first decode of the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to create map object
    Map<String, dynamic> secondDecode = jsonDecode(firstDecode);

    // Get login details from Json
    LoginEmployeeDTO login = LoginEmployeeDTO.fromJson(secondDecode);

    // Return the login details
    return login;
  }

  // Function for retrieving all the maintenance checkups
  Future<List<MaintenanceCheckupDTO>> getMaintenanceCheckups(
      String username, String hotelName) async {
    // Retrieve response from get web service request
    Response response = await webServiceRequest
        .getRequest("employee/maintenance/checkups/$username/$hotelName");

    // If the response is null, return null
    if (response.body == null || response.body == "null") return null;

    // Perform first decode of the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to create map object
    Map<String, dynamic> secondDecode = jsonDecode(firstDecode);

    // Create data list from map
    List<dynamic> data = secondDecode["checkups"];

    // Initialize list of checkups objects
    List<MaintenanceCheckupDTO> checkups = new List<MaintenanceCheckupDTO>();

    // Update list of checkups with checkups objects created from Json
    checkups = (data).map((i) => MaintenanceCheckupDTO.fromJson(i)).toList();

    // Return the list of checkups
    return checkups;
  }

  // Function for retrieving all the maintenance requests
  Future<List<MaintenanceRequestDTO>> getMaintenanceRequests(
      String username, String hotelName) async {
    // Retrieve response from get web service request
    Response response = await webServiceRequest
        .getRequest("employee/maintenance/requests/$username/$hotelName");

    // If the response is null, return null
    if (response.body == null || response.body == "null") return null;

    // Perform first decode of the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to create map object
    Map<String, dynamic> secondDecode = jsonDecode(firstDecode);

    // Create data list from map
    List<dynamic> data = secondDecode["requests"];

    // Initialize list of requests objects
    List<MaintenanceRequestDTO> requests = new List<MaintenanceRequestDTO>();

    // Update list of requests with request objects created from Json
    requests = (data).map((i) => MaintenanceRequestDTO.fromJson(i)).toList();

    // Return the list of requests
    return requests;
  }

  // Function for assigning or unassigning an employee from maintenance
  Future<bool> assignUnassignEmployeeFromMaintenance(
      int maintenanceId, bool isCheckup, String username) async {
    // Create map for web request headers
    Map<String, String> content = new Map<String, String>();

    // Add maintenanceId header to the map
    content['maintenanceId'] = maintenanceId.toString();

    // Add isCheckup header to the map
    content['isCheckup'] = isCheckup.toString();

    // Add username header to the map
    content['username'] = username;

    // Retrieve response from the post web service request
    Response response = await webServiceRequest.putRequest(
        "employee/maintenance/assign", content);

    // If the response was null, return false
    if (response.body == null || response.body == "null") return null;

    // Perform first decode on the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to retrieve bool value
    bool secondDecode = jsonDecode(firstDecode);

    // Return bool value
    return secondDecode;
  }

  // Function for starting maintenance progress
  Future<bool> startMaintenanceProgress(
      int maintenanceId, bool isCheckup, String username) async {
    // Create map for web request headers
    Map<String, String> content = new Map<String, String>();

    // Add maintenanceId header to the map
    content['maintenanceId'] = maintenanceId.toString();

    // Add isCheckup header to the map
    content['isCheckup'] = isCheckup.toString();

    // Add username header to the map
    content['username'] = username;

    // Retrieve response from the post web service request
    Response response = await webServiceRequest.putRequest(
        "employee/maintenance/started", content);

    // If the response was null, return false
    if (response.body == null || response.body == "null") return null;

    // Perform first decode on the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to retrieve bool value
    bool secondDecode = jsonDecode(firstDecode);

    // Return bool value
    return secondDecode;
  }

  // Function for completing maintenance progress
  Future<bool> completeMaintenanceProgress(
      int maintenanceId, bool isCheckup, String username) async {
    // Create map for web request headers
    Map<String, String> content = new Map<String, String>();

    // Add maintenanceId header to the map
    content['maintenanceId'] = maintenanceId.toString();

    // Add isCheckup header to the map
    content['isCheckup'] = isCheckup.toString();

    // Add username header to the map
    content['username'] = username;

    // Retrieve response from the delete web service request
    Response response = await webServiceRequest.deleteRequest(
        "employee/maintenance/completed", content);

    // If the response was null, return false
    if (response.body == null || response.body == "null") return null;

    // Perform first decode on the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to retrieve bool value
    bool secondDecode = jsonDecode(firstDecode);

    // Return bool value
    return secondDecode;
  }

  // Function for retrieving all the cleaning checkups
  Future<List<CleaningCheckupDTO>> getCleaningCheckups(
      String username, String hotelName) async {
    // Retrieve response from get web service request
    Response response = await webServiceRequest
        .getRequest("employee/cleaning/checkups/$username/$hotelName");

    // If the response is null, return null
    if (response.body == null || response.body == "null") return null;

    // Perform first decode of the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to create map object
    Map<String, dynamic> secondDecode = jsonDecode(firstDecode);

    // Create data list from map
    List<dynamic> data = secondDecode["checkups"];

    // Initialize list of checkup objects
    List<CleaningCheckupDTO> checkups = new List<CleaningCheckupDTO>();

    // Update list of checkups with checkups objects created from Json
    checkups = (data).map((i) => CleaningCheckupDTO.fromJson(i)).toList();

    // Return the list of checkups
    return checkups;
  }

  // Function for assigning or unassigning an employee from cleaning
  Future<bool> assignUnassignEmployeeFromCleaning(
      int cleaningId, String username) async {
    // Create map for web request headers
    Map<String, String> content = new Map<String, String>();

    // Add cleaningId header to the map
    content['cleaningId'] = cleaningId.toString();

    // Add username header to the map
    content['username'] = username;

    // Retrieve response from the post web service request
    Response response =
        await webServiceRequest.putRequest("employee/cleaning/assign", content);

    // If the response was null, return false
    if (response.body == null || response.body == "null") return null;

    // Perform first decode on the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to retrieve bool value
    bool secondDecode = jsonDecode(firstDecode);

    // Return bool value
    return secondDecode;
  }

  // Function for starting cleaning progress
  Future<bool> startCleaningProgress(int cleaningId, String username) async {
    // Create map for web request headers
    Map<String, String> content = new Map<String, String>();

    // Add cleaningId header to the map
    content['cleaningId'] = cleaningId.toString();

    // Add username header to the map
    content['username'] = username;

    // Retrieve response from the post web service request
    Response response = await webServiceRequest.putRequest(
        "employee/cleaning/started", content);

    // If the response was null, return false
    if (response.body == null || response.body == "null") return null;

    // Perform first decode on the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to retrieve bool value
    bool secondDecode = jsonDecode(firstDecode);

    // Return bool value
    return secondDecode;
  }

  // Function for completing cleaning progress
  Future<bool> completeCleaningProgress(int cleaningId, String username) async {
    // Create map for web request headers
    Map<String, String> content = new Map<String, String>();

    // Add cleaningId header to the map
    content['cleaningId'] = cleaningId.toString();

    // Add username header to the map
    content['username'] = username;

    // Retrieve response from the delete web service request
    Response response = await webServiceRequest.deleteRequest(
        "employee/cleaning/completed", content);

    // If the response was null, return false
    if (response.body == null || response.body == "null") return null;

    // Perform first decode on the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to retrieve bool value
    bool secondDecode = jsonDecode(firstDecode);

    // Return bool value
    return secondDecode;
  }

  // Function for retrieving all the bookings for the receptionist
  Future<List<CustomerBookingDTO>> getBookings(
      String username, String hotelName) async {
    // Retrieve response from get web service request
    Response response = await webServiceRequest
        .getRequest("employee/reception/bookings/$username/$hotelName");

    // If the response is null, return null
    if (response.body == null || response.body == "null") return null;

    // Perform first decode of the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to create map object
    Map<String, dynamic> secondDecode = jsonDecode(firstDecode);

    // Create data list from map
    List<dynamic> data = secondDecode["customerBookings"];

    // Initialize list of booking objects
    List<CustomerBookingDTO> bookings = new List<CustomerBookingDTO>();

    // Update list of bookings with booking objects created from Json
    bookings = (data).map((i) => CustomerBookingDTO.fromJson(i)).toList();

    // Return the list of bookings
    return bookings;
  }

  // Function for starting customers booking
  Future<bool> bookingStarted(int bookingId, String username) async {
    // Create map for web request headers
    Map<String, String> content = new Map<String, String>();

    // Add bookingId header to the map
    content['bookingId'] = bookingId.toString();

    // Add username header to the map
    content['username'] = username;

    // Retrieve response from the put web service request
    Response response = await webServiceRequest.putRequest(
        "employee/reception/started", content);

    // If the response was null, return false
    if (response.body == null || response.body == "null") return null;

    // Perform first decode on the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to retrieve bool value
    bool secondDecode = jsonDecode(firstDecode);

    // Return bool value
    return secondDecode;
  }

  // Function for completing customers booking
  Future<bool> bookingCompleted(int bookingId, String username) async {
    // Create map for web request headers
    Map<String, String> content = new Map<String, String>();

    // Add bookingId header to the map
    content['bookingId'] = bookingId.toString();

    // Add username header to the map
    content['username'] = username;

    // Retrieve response from the put web service request
    Response response = await webServiceRequest.putRequest(
        "employee/reception/completed", content);

    // If the response was null, return false
    if (response.body == null || response.body == "null") return null;

    // Perform first decode on the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to retrieve bool value
    bool secondDecode = jsonDecode(firstDecode);

    // Return bool value
    return secondDecode;
  }

  // Function for completing customers booking
  Future<bool> checkBookingCanBeExtended(int bookingId, String username, DateTime dateTime) async {
    // Create map for web request headers
    Map<String, String> content = new Map<String, String>();

    // Add bookingId header to the map
    content['bookingId'] = bookingId.toString();

    // Add username header to the map
    content['username'] = username;

    // Add dateTime header to the map
    content['dateTime'] = dateTime.toString();

    // Retrieve response from the put web service request
    Response response = await webServiceRequest.putRequest(
        "employee/reception/extendable", content);

    // If the response was null, return false
    if (response.body == null || response.body == "null") return null;

    // Perform first decode on the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to retrieve bool value
    bool secondDecode = jsonDecode(firstDecode);

    // Return bool value
    return secondDecode;
  }

  // Function for extending customers booking
  Future<bool> extendBooking(int bookingId, String username, DateTime dateTime) async {
    // Create map for web request headers
    Map<String, String> content = new Map<String, String>();

    // Add bookingId header to the map
    content['bookingId'] = bookingId.toString();

    // Add username header to the map
    content['username'] = username;

    // Add dateTime header to the map
    content['dateTime'] = dateTime.toString();

    // Retrieve response from the put web service request
    Response response = await webServiceRequest.putRequest(
        "employee/reception/extend", content);

    // If the response was null, return false
    if (response.body == null || response.body == "null") return null;

    // Perform first decode on the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to retrieve bool value
    bool secondDecode = jsonDecode(firstDecode);

    // Return bool value
    return secondDecode;
  }
}
