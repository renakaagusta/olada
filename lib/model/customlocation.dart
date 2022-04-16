import 'dart:convert';

class CustomLocation {
  double latitude;
  double longitude;
  String province;
  String city;
  String address;
  String description;
  CustomLocation(
      {this.latitude,
      this.longitude,
      this.province,
      this.city,
      this.address,
      this.description});
  factory CustomLocation.fromJson(Map<String, dynamic> map) {
    return CustomLocation(
        latitude: map["latitude"],
        longitude: map["longitude"],
        province: map["province"],
        city: map["city"],
        address: map["address"],
        description: map["description"]);
  }
  Map<String, dynamic> toJson() {
    return {
      "latitude": latitude,
      "longitude": longitude,
      "description": description,
      "province": province,
      "city": city,
      "address": address,
    };
  }
}

CustomLocation locationFromJson(String jsonData) {
  return CustomLocation.fromJson(json.decode(jsonData));
}

String locationToJson(CustomLocation data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
