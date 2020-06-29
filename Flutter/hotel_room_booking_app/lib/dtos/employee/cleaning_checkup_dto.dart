// Class for cleaning checkup object
class CleaningCheckupDTO {
  // Room cleaning request Id
  final int roomCleaningId;

  // Date of the checkup
  final DateTime dateTime;

  // The room code
  final String roomCode;

  // The username
  final String username;

  // If the checkup is in progress
  final bool inProgress;

  // Constructor
  CleaningCheckupDTO(
      {this.roomCleaningId,
      this.dateTime,
      this.roomCode,
      this.username,
      this.inProgress});

  // Create new cleaning checkup object from json
  factory CleaningCheckupDTO.fromJson(dynamic json) {
    return new CleaningCheckupDTO(
        roomCleaningId: json['roomCleaningId'],
        dateTime: DateTime.parse(json['dateTime']),
        roomCode: json['roomCode'],
        username: json['username'],
        inProgress: json['inProgress']);
  }
}
