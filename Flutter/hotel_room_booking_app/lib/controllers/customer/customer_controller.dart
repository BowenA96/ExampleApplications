import 'dart:convert';
import 'package:hotel_room_booking_app/controllers/general_controller.dart';
import 'package:hotel_room_booking_app/dtos/customer/customer_booking_dto.dart';
import 'package:hotel_room_booking_app/dtos/hotel/hotel_attraction_dto.dart';
import 'package:hotel_room_booking_app/dtos/hotel/hotel_dto.dart';
import 'package:hotel_room_booking_app/dtos/hotel/hotel_review_dto.dart';
import 'package:hotel_room_booking_app/dtos/hotel/hotel_room_dto.dart';
import 'package:hotel_room_booking_app/user_data.dart';
import 'package:hotel_room_booking_app/web_service_request.dart';
import 'package:http/http.dart';

// Class for performing customer functionality
class CustomerController {
  // Create instance of the web service request class
  WebServiceRequest webServiceRequest = new WebServiceRequest();

  // Create instance of the general controller
  GeneralController generalController = new GeneralController();

  // Function for retrieving a list of hotels
  Future<List<HotelDTO>> getHotelList() async {
    // Initialize list of hotel objects
    List<HotelDTO> hotels = new List<HotelDTO>();

    // Retrieve response from get web service request
    Response response = await webServiceRequest.getRequest('customer/hotels');

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

  // Function for retrieving a list of hotel reviews
  Future<List<HotelReviewDTO>> getHotelReviews(String hotelName) async {
    // Initialize list of hotel objects
    List<HotelReviewDTO> reviews = new List<HotelReviewDTO>();

    // Retrieve response from get web service request
    Response response = await webServiceRequest
        .getRequest('customer/hotel/reviews/' + hotelName);

    // If the response is null, return null
    if (response.body == null || response.body == "null") return null;

    // Perform first decode of the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to create map object
    Map<String, dynamic> secondDecode = jsonDecode(firstDecode);

    // Create data list from map
    List<dynamic> data = secondDecode["reviews"];

    // Update list of hotels with hotel review objects created from Json
    reviews = (data).map((i) => HotelReviewDTO.fromJson(i)).toList();

    // Return the list of reviews
    return reviews;
  }

  // Function for retrieving a list of hotel attractions
  Future<List<HotelAttractionDTO>> getHotelAttractions(String hotelName) async {
    // Initialize list of hotel attraction objects
    List<HotelAttractionDTO> attractions = new List<HotelAttractionDTO>();

    // Retrieve response from get web service request
    Response response = await webServiceRequest
        .getRequest('customer/hotel/attractions/' + hotelName);

    // If the response is null, return null
    if (response.body == null || response.body == "null") return null;

    // Perform first decode of the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to create map object
    Map<String, dynamic> secondDecode = jsonDecode(firstDecode);

    // Create data list from map
    List<dynamic> data = secondDecode["attractions"];

    // Update list of hotels with hotel attraction objects created from Json
    attractions = (data).map((i) => HotelAttractionDTO.fromJson(i)).toList();

    // Return the list of hotels
    return attractions;
  }

  // Function for retrieving a list of hotel rooms
  Future<List<HotelRoomDTO>> getHotelRooms(
      String hotelName, DateTime startDateTime, DateTime endDateTime) async {
    // Initialize list of hotel room objects
    List<HotelRoomDTO> rooms = new List<HotelRoomDTO>();

    // Retrieve response from get web service request
    Response response = await webServiceRequest.getRequest(
        'customer/hotel/rooms?hotelName=' +
            hotelName +
            '&start=' +
            startDateTime.toString() +
            '&end=' +
            endDateTime.toString());

    // If the response is null, return null
    if (response.body == null || response.body == "null") return null;

    // Perform first decode of the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to create map object
    Map<String, dynamic> secondDecode = jsonDecode(firstDecode);

    // Create data list from map
    List<dynamic> data = secondDecode["rooms"];

    // Update list of hotels with hotel room objects created from Json
    rooms = (data).map((i) => HotelRoomDTO.fromJson(i)).toList();

    // Sort list of rooms
    rooms.sort((a, b) => a.roomCode.compareTo(a.roomCode));

    // Return the list of hotels
    return rooms;
  }

  // Function for checking a room booking
  Future<bool> checkRoomBooking(String username, String password, int roomId,
      DateTime startDateTime, DateTime endDateTime) async {
    // Create map for the headers to be sent for request
    Map<String, String> content = new Map<String, String>();

    // Add username header to the map
    content['username'] = username;

    // Add password header to the map
    content['password'] = password;

    // Add roomId header to the map
    content['roomId'] = roomId.toString();

    // Add startDateTime header to the map
    content['startDateTime'] = startDateTime.toString();

    // Add endDateTime header to the map
    content['endDateTime'] = endDateTime.toString();

    // Retrieve the response from the web service
    Response response = await webServiceRequest.postRequest(
        "customer/booking/check/complete", content);

    // If the response is null, return false
    if (response.body == null || response.body == "null") return null;

    // Perform first decode of the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to retrieve bool value
    bool secondDecode = jsonDecode(firstDecode);

    // Return the bool value
    return secondDecode;
  }

  // Function for completing room booking
  Future<bool> completeRoomBooking(String username, String password, int roomId,
      DateTime startDateTime, DateTime endDateTime, double totalCost) async {
    // Create map for web request headers
    Map<String, String> content = new Map<String, String>();

    // Add username header to the map
    content['username'] = username;

    // Add password header to the map
    content['password'] = password;

    // Add roomId header to the map
    content['roomId'] = roomId.toString();

    // Add startDateTime header to the map
    content['startDateTime'] = startDateTime.toString();

    // Add endDateTime header to the map
    content['endDateTime'] = endDateTime.toString();

    // Add totalCost header to the map
    content['totalCost'] = totalCost.toString();

    // Retrieve response from the post web service request
    Response response = await webServiceRequest.postRequest(
        "customer/booking/complete", content);

    // If the response was null, return false
    if (response.body == null || response.body == "null") return null;

    // Perform first decode on the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to retrieve bool value
    bool secondDecode = jsonDecode(firstDecode);

    // Return bool value
    return secondDecode;
  }

  // Function for retrieving a list of hotel rooms
  Future<List<CustomerBookingDTO>> getCustomerBookings() async {
    // Initialize list of hotel room objects
    List<CustomerBookingDTO> bookings = new List<CustomerBookingDTO>();

    // Retrieve response from get web service request
    Response response = await webServiceRequest.getRequest(
        'customer/bookings/' +
            UserData().loginDTO.username +
            '/' +
            UserData().loginDTO.password);

    // If the response is null, return null
    if (response.body == null || response.body == "null") return null;

    // Perform first decode of the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to create map object
    Map<String, dynamic> secondDecode = jsonDecode(firstDecode);

    // Create data list from map
    List<dynamic> data = secondDecode["customerBookings"];

    // Update list of hotels with customer booking objects created from Json
    bookings = (data).map((i) => CustomerBookingDTO.fromJson(i)).toList();

    // Return the list of bookings
    return bookings;
  }

  // Function for cancelling room booking
  Future<bool> cancelBooking(
      String username, String password, int bookingId) async {
    // Create map for web request headers
    Map<String, String> content = new Map<String, String>();

    // Add username header to the map
    content['username'] = username;

    // Add password header to the map
    content['password'] = password;

    // Add bookingId header to the map
    content['bookingId'] = bookingId.toString();

    // Retrieve response from the post web service request
    Response response = await webServiceRequest.deleteRequest(
        "customer/booking/cancel", content);

    // If the response was null, return false
    if (response.body == null || response.body == "null") return null;

    // Perform first decode on the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to retrieve bool value
    bool secondDecode = jsonDecode(firstDecode);

    // Return bool value
    return secondDecode;
  }

  // Function for creating review
  Future<bool> createReview(String username, String password, int bookingId,
      int rating, String description) async {
    // Create map for web request headers
    Map<String, String> content = new Map<String, String>();

    // Add username header to the map
    content['username'] = username;

    // Add password header to the map
    content['password'] = password;

    // Add bookingId header to the map
    content['bookingId'] = bookingId.toString();

    // Add rating header to the map
    content['rating'] = rating.toString();

    // Add description header to the map
    content['description'] = description;

    // Retrieve response from the post web service request
    Response response = await webServiceRequest.postRequest(
        "customer/hotel/review/create", content);

    // If the response was null, return false
    if (response.body == null || response.body == "null") return null;

    // Perform first decode on the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to retrieve bool value
    bool secondDecode = jsonDecode(firstDecode);

    // Return bool value
    return secondDecode;
  }

  // Function for editing review
  Future<bool> editReview(String username, String password, int bookingId,
      int rating, String description) async {
    // Create map for web request headers
    Map<String, String> content = new Map<String, String>();

    // Add username header to the map
    content['username'] = username;

    // Add password header to the map
    content['password'] = password;

    // Add bookingId header to the map
    content['bookingId'] = bookingId.toString();

    // Add rating header to the map
    content['rating'] = rating.toString();

    // Add description header to the map
    content['description'] = description;

    // Retrieve response from the post web service request
    Response response = await webServiceRequest.putRequest(
        "customer/hotel/review/edit", content);

    // If the response was null, return false
    if (response.body == null || response.body == "null") return null;

    // Perform first decode on the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to retrieve bool value
    bool secondDecode = jsonDecode(firstDecode);

    // Return bool value
    return secondDecode;
  }

  // Function for deleting review
  Future<bool> deleteReview(
      String username, String password, int bookingId) async {
    // Create map for web request headers
    Map<String, String> content = new Map<String, String>();

    // Add username header to the map
    content['username'] = username;

    // Add password header to the map
    content['password'] = password;

    // Add bookingId header to the map
    content['bookingId'] = bookingId.toString();

    // Retrieve response from the post web service request
    Response response = await webServiceRequest.deleteRequest(
        "customer/hotel/review/delete", content);

    // If the response was null, return false
    if (response.body == null || response.body == "null") return null;

    // Perform first decode on the response body
    String firstDecode = jsonDecode(response.body);

    // Perform second decode to retrieve bool value
    bool secondDecode = jsonDecode(firstDecode);

    // Return bool value
    return secondDecode;
  }

  // Function for creating maintenance request
  Future<bool> createMaintenanceRequest(String username, String password,
      int bookingId, String description) async {
    // Create map for web request headers
    Map<String, String> content = new Map<String, String>();

    // Add username header to the map
    content['username'] = username;

    // Add password header to the map
    content['password'] = password;

    // Add bookingId header to the map
    content['bookingId'] = bookingId.toString();

    // Add description header to the map
    content['description'] = description;

    // Retrieve response from the post web service request
    Response response = await webServiceRequest.postRequest(
        "customer/maintenance/request", content);

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
