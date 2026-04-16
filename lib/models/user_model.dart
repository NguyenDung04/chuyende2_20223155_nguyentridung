class UserModel {
  final String fullName;
  final String email;
  final String password;

  UserModel({
    required this.fullName,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }
}