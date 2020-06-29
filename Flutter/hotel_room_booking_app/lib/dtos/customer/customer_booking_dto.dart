// Class for customer booking object
import 'package:hotel_room_booking_app/dtos/hotel/hotel_review_dto.dart';

class CustomerBookingDTO {
  // Booking Id
  final int bookingId;

  // Employees username
  final String username;

  // Start date for the booking
  final DateTime startDateTime;

  // Start date for the booking
  final DateTime endDateTime;

  // The hotel booking is made for
  final String hotelName;

  // The maximum booking length for the hotel
  final int maximumBookingLength;

  // The room which is booked
  final String roomCode;

  // The id of the room booked
  final int roomId;

  // The total cost of the booking
  final double totalCost;

  // If the booking is active
  final bool active;

  // If the booking has been completed
  final bool complete;

  // The review of the hotel
  final HotelReviewDTO review;

  // If the booking has a maintenance request active
  final bool hasMaintenanceRequest;

  // Constructor
  CustomerBookingDTO(
      {this.bookingId,
      this.username,
      this.startDateTime,
      this.endDateTime,
      this.hotelName,
      this.maximumBookingLength,
      this.roomCode,
      this.roomId,
      this.totalCost,
      this.active,
      this.complete,
      this.review,
      this.hasMaintenanceRequest});

  // Create new customer booking object from json
  factory CustomerBookingDTO.fromJson(dynamic json) {
    return new CustomerBookingDTO(
        bookingId: json['bookingId'],
        username: json['username'].toString(),
        startDateTime: DateTime.parse(json['startDateTime']),
        endDateTime: DateTime.parse(json['endDateTime']),
        hotelName: json['hotelName'].toString(),
        maximumBookingLength: json['maximumBookingLength'],
        roomCode: json['roomCode'].toString(),
        roomId: json['roomId'],
        totalCost: json['totalCost'],
        active: json['active'],
        complete: json['complete'],
        review: HotelReviewDTO.fromJson(json),
        hasMaintenanceRequest: json['hasMaintenanceRequest']);
  }
}
