// Class for hotel object
class HotelDTO {
  // Name of the hotel
  final String hotelName;

  // Latitude of the hotel
  final double latitude;

  // Longitude of the hotel
  final double longitude;

  // Maximum lead-up time of the hotel
  final int maximumLeadTime;

  // Maximum booking length of the hotel
  final int maximumBookingLength;

  // Distance from the selected hotel
  double distance;

  // Constructor
  HotelDTO(
      {this.hotelName,
      this.latitude,
      this.longitude,
      this.maximumLeadTime,
      this.distance,
      this.maximumBookingLength});

  // Create hotel object from Json
  factory HotelDTO.fromJson(Map<String, dynamic> json) {
    return new HotelDTO(
        hotelName: json['hotelName'].toString(),
        latitude: json['latitude'],
        longitude: json['longitude'],
        maximumLeadTime: json['maximumLeadTime'],
        maximumBookingLength: json['maximumBookingLength'],
        distance: 0);
  }
}
