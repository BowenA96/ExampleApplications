// Class for login employee object
class LoginEmployeeDTO {
  // Employee username
  final String username;

  // Employee password
  final String password;

  // Employee type
  final String employeeType;

  // If it is a one time password
  final bool oneTimePassword;

  // Name of the hotel employee assigned to
  final String hotelName;

  // Constructor
  LoginEmployeeDTO(
      {this.username,
      this.password,
      this.employeeType,
      this.oneTimePassword,
      this.hotelName});

  // Create new login employee object from json
  factory LoginEmployeeDTO.fromJson(dynamic json) {
    return new LoginEmployeeDTO(
        username: json['username'].toString(),
        password: json['password'].toString(),
        employeeType: json['employeeType'].toString(),
        oneTimePassword: json['oneTimePassword'],
        hotelName: json['hotelName']);
  }
}
