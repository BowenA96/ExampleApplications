// Class for maintenance request object
class MaintenanceRequestDTO {
  // Maintenance request Id
  final int maintenanceRequestId;

  // Request description
  final String description;

  // The room code
  final String roomCode;

  // The username
  final String username;

  // If the request is in progress
  final bool inProgress;

  // Constructor
  MaintenanceRequestDTO(
      {this.maintenanceRequestId,
      this.description,
      this.roomCode,
      this.username,
      this.inProgress});

  // Create new maintenance request object from json
  factory MaintenanceRequestDTO.fromJson(dynamic json) {
    return new MaintenanceRequestDTO(
        maintenanceRequestId: json['maintenanceRequestId'],
        description: json['description'],
        roomCode: json['roomCode'],
        username: json['username'],
        inProgress: json['inProgress']);
  }
}
