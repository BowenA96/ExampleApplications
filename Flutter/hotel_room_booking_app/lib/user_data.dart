// Class holding the local user data for the application
import 'package:hotel_room_booking_app/dtos/customer/customer_booking_dto.dart';
import 'package:hotel_room_booking_app/dtos/hotel/hotel_dto.dart';
import 'package:hotel_room_booking_app/dtos/login/login_dto.dart';
import 'package:hotel_room_booking_app/dtos/login/login_employee_dto.dart';

class UserData {
  // Instance of the application
  static UserData _instance = new UserData._internal();

  factory UserData() {
    return _instance;
  }

  // Users login info
  LoginDTO loginDTO;

  // Employeees login info
  LoginEmployeeDTO loginEmployeeDTO;

  // Name of the hotel
  String hotelName;

  // Hotel being used
  HotelDTO hotel;

  // Start date time for a booking
  DateTime startDateTime;

  // End date time for a booking
  DateTime endDateTime;

  // Room bookings in the basket
  List<CustomerBookingDTO> bookings;

  // Constructor
  UserData._internal() {
    loginDTO = new LoginDTO();
    loginEmployeeDTO = new LoginEmployeeDTO();
  }
}
