class UserModel {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;

  UserModel({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });


  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      email: json['email'],
      password: json['password'],
      confirmPassword: json['confirmPassword'],
    );
  }

  // Method to convert SignUpModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}
