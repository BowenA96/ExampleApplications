// Class for hotel review object
class HotelReviewDTO {
  // Rating out of 10 for hotel
  final int rating;

  // Description for hotel review
  final String description;

  // Constructor
  HotelReviewDTO({this.rating, this.description});

  // Create hotel review object from Json
  factory HotelReviewDTO.fromJson(Map<String, dynamic> json) {
    return new HotelReviewDTO(
        rating: json['rating'], description: json['description']);
  }
}
