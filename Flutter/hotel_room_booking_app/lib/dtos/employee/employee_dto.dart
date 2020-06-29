// Class for employee object
class EmployeeDTO {
  // Employees username
  final String username;

  // Employees first name
  final String firstName;

  // Employees last name
  final String lastName;

  // Employees type/role e.g. Maintenance
  final String employeeType;

  // Name of the hotel employee assigned to
  final String hotelName;

  // Constructor
  EmployeeDTO(
      {this.username,
      this.firstName,
      this.lastName,
      this.employeeType,
      this.hotelName});

  // Create new employee object from json
  factory EmployeeDTO.fromJson(dynamic json) {
    return new EmployeeDTO(
        username: json['username'].toString(),
        firstName: json['firstName'].toString(),
        lastName: json['lastName'].toString(),
        employeeType: json['employeeType'].toString(),
        hotelName: json['hotelName'].toString());
  }
}
