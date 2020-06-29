import 'dart:convert';
import 'package:hotel_room_booking_app/dtos/employee/employee_dto.dart';
import 'package:hotel_room_booking_app/dtos/hotel/hotel_dto.dart';
import 'package:hotel_room_booking_app/dtos/login/login_dto.dart';
import 'package:hotel_room_booking_app/web_service_request.dart';
import 'package:http/http.dart';

// Class for performing administrator functionality
class AdministratorController {
  // Create instance of the web service request class
  WebServiceRequest webServiceRequest = new WebServiceRequest();

  // Function for logging in as administrator
  Future<LoginDTO> loginAdministrator(String username, String password) async {
    // Retrieve response from get web service request
    Response response = await webServiceRequest
        .getRequest("administrator/login/$username/$password");

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

  // Function for creating a list of hotels
  Future<List<HotelDTO>> createListOfHotels(
      String username, String password) async {
    // Initialize list of hotel objects
    List<HotelDTO> hotels = new List<HotelDTO>();

    // Retrieve response from get web service request
    Response response = await webServiceRequest
        .getRequest('administrator/hotel/$username/$password');

    // If the response is null, return null
    if (response.body == null || response.body == "null") return null;

    // Perform first decode of the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to create map object
    Map<String, dynamic> secondDecode = jsonDecode(firstDecode);

    // Create data list from map
    List<dynamic> data = secondDecode["hotels"];

    // Update list of hotels with hotel objects created from Json
    hotels = (data).map((i) => HotelDTO.fromJson(i)).toList();

    // Return the list of hotels
    return hotels;
  }

  // Function for creating a list of employees for the specified hotel
  Future<List<EmployeeDTO>> createListOfEmployees(
      String username, String password, String hotelName) async {
    // Initialize list of employee objects
    List<EmployeeDTO> employees = new List<EmployeeDTO>();

    // Create url for the get web service request
    String url = "administrator/employee/$username/$password/" + hotelName;

    // Retrieve response from the get request
    Response response = await webServiceRequest.getRequest(url);

    // If the response is null, return null
    if (response.body == null || response.body == "null") return null;

    // Perform first decode of the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to create map object
    Map<String, dynamic> secondDecode = jsonDecode(firstDecode);

    // Create data list from map
    List<dynamic> data = secondDecode["employees"];

    // Update list of employees with employee objects created from Json
    employees = (data.map((i) => EmployeeDTO.fromJson(i)).toList());

    // Return the list of employees
    return employees;
  }

  // Function for deleting a specified employee
  Future<bool> deleteEmployee(
      String username, String password, String employeeUsername) async {
    // Create map for the headers to be sent for request
    Map<String, String> content = new Map<String, String>();

    // Add username header to the map
    content['username'] = username;

    // Add password header to the map
    content['password'] = password;

    // Add employeeUsername header to the map
    content['employeeUsername'] = employeeUsername;

    // Retrieve the response from the web service
    Response response = await webServiceRequest.deleteRequest(
        "administrator/delete/employee", content);

    // If the response is null, return false
    if (response.body == null || response.body == "null") return false;

    // Perform first decode of the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to retrieve bool value
    bool secondDecode = jsonDecode(firstDecode);

    // Return the bool value
    return secondDecode;
  }

  // Function for creating a new employee
  Future<bool> createEmployee(
      String username,
      String password,
      String employeeUsername,
      String firstName,
      String lastName,
      String employeePassword,
      String employeeType,
      String hotelName) async {
    // Create map for web request headers
    Map<String, String> content = new Map<String, String>();

    // Add username header
    content['username'] = username;

    // Add password header
    content['password'] = password;

    // Add employeeUsername header
    content['employeeUsername'] = employeeUsername;

    // Add employeePassword header
    content['employeePassword'] = employeePassword;

    // Add firstName header
    content['firstName'] = firstName;

    // Add lastName header
    content['lastName'] = lastName;

    // Add employeeType header
    content['employeeType'] = employeeType;

    // Add hotelName header
    content['hotelName'] = hotelName;

    // Retrieve response from the post web service request
    Response response = await webServiceRequest.postRequest(
        "administrator/create/employee", content);

    // If the response was null, return false
    if (response.body == null || response.body == "null") return false;

    // Perform first decode on the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to retrieve bool value
    bool secondDecode = jsonDecode(firstDecode);

    // Return bool value
    return secondDecode;
  }
}
