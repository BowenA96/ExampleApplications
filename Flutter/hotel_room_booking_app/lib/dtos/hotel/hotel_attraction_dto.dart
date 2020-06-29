// Class for hotel attraction object
class HotelAttractionDTO {
  // Name of the attraction
  final String attractionName;

  // Description of the attraction
  final String description;

  // Distance of the attraction from the hotel
  final int distance;

  // Constructor
  HotelAttractionDTO({this.attractionName, this.description, this.distance});

  // Create hotel attraction object from Json
  factory HotelAttractionDTO.fromJson(Map<String, dynamic> json) {
    return new HotelAttractionDTO(
        attractionName: json['attractionName'],
        description: json['description'],
        distance: json['distance']);
  }
}
