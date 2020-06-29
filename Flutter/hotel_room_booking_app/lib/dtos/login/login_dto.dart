// Class for login object
class LoginDTO {
  // User username
  final String username;

  // User password
  final String password;

  // Constructor
  LoginDTO(
      {this.username,
        this.password});

  // Create new login object from json
  factory LoginDTO.fromJson(dynamic json) {
    return new LoginDTO(
        username: json['username'].toString(),
        password: json['password'].toString());
  }
}
