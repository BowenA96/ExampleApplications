// Class for hotel room object
class HotelRoomDTO {
  // Id for the hotel room
  final int roomId;

  // Code for the hotel room
  final String roomCode;

  // Price of the hotel room for one day
  final double price;

  // Number of beds in the room
  final int numberOfBeds;

  // If the hotel room has disability access
  final bool disabilityAccess;

  // Availability of the hotel room
  final bool available;

  // Constructor
  HotelRoomDTO(
      {this.roomId,
      this.roomCode,
      this.price,
      this.numberOfBeds,
      this.disabilityAccess,
      this.available});

  // Create hotel review object from Json
  factory HotelRoomDTO.fromJson(Map<String, dynamic> json) {
    return new HotelRoomDTO(
        roomId: json['roomId'],
        roomCode: json['roomCode'],
        price: json['price'],
        numberOfBeds: json['numberOfBeds'],
        disabilityAccess: json['disabilityAccess'],
        available: json['available']);
  }
}
