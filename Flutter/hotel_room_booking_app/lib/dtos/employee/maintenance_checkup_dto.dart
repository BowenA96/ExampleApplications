// Class for maintenance request object
class MaintenanceCheckupDTO {
  // Maintenance request Id
  final int roomMaintenanceCheckupId;

  // Date of the checkup
  final DateTime dateTime;

  // The room code
  final String roomCode;

  // The username
  final String username;

  // If the checkup is in progress
  final bool inProgress;

  // Constructor
  MaintenanceCheckupDTO(
      {this.roomMaintenanceCheckupId,
      this.dateTime,
      this.roomCode,
      this.username,
      this.inProgress});

  // Create new maintenance checkup object from json
  factory MaintenanceCheckupDTO.fromJson(dynamic json) {
    return new MaintenanceCheckupDTO(
        roomMaintenanceCheckupId: json['roomMaintenanceCheckupId'],
        dateTime: DateTime.parse(json['dateTime']),
        roomCode: json['roomCode'],
        username: json['username'],
        inProgress: json['inProgress']);
  }
}
