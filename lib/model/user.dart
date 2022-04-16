import 'dart:convert';

class UserOlada {
  String id;
  String username;
  String firstname;
  String lastname;
  String image;
  String email;
  String phoneNumber;
  int verification;
  String token;
  UserOlada(
      {this.id,
      this.username,
      this.firstname,
      this.lastname,
      this.image,
      this.email,
      this.phoneNumber,
      this.verification,
      this.token});
  factory UserOlada.fromJson(Map<String, dynamic> map) {
    return UserOlada(
        id: map["id"],
        username: map["username"],
        firstname: map["firstname"],
        lastname: map["lastname"],
        image: map["image"],
        email: map["email"],
        phoneNumber: map["phoneNumber"],
        verification: map["verification"],
        token: map["accessToken"]);
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "firstname": username,
      "lastname": username,
      "image": image,
      "email": email,
      "phoneNumber": phoneNumber,
      "verification": verification,
      "token": token
    };
  }

  @override
  String toString() {
    return 'UserOlada{id: $id, username: $username,firstname: $firstname,lastname: $lastname,image: $image, email: $email,phoneNumber: $phoneNumber, verification: $verification, token: $token}';
  }
}

UserOlada userFromJson(String jsonData) {
  return UserOlada();
}

String userToJson(UserOlada data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
