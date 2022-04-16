import 'dart:convert';
import 'package:olada/model/user.dart';
import 'package:olada/model/customlocation.dart';

class Partner {
  String id;
  UserOlada user;
  String service;
  List<String> subservice;
  CustomLocation location;
  PartnerRating rating;
  String role;
  Partner(
      {this.id = "",
      this.user,
      this.service,
      this.subservice,
      this.location,
      this.rating,
      this.role});
  factory Partner.fromJson(Map<String, dynamic> map) {
    return Partner(
      id: map["_id"],
      service: map["service"],
      role: map["role"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user": user,
      "service": user,
      "subservice": user,
      "location": location,
      "rating": rating,
      "role": role,
    };
  }

  @override
  String toString() {
    return 'Partner{id: $id, user: $user,service: $service,subservice: $subservice,location: $location,rating: $rating,role: $role}';
  }
}

Partner partnerFromJson(String jsonData) {
  return Partner.fromJson(json.decode(jsonData));
}

String partnerToJson(Partner data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

class PartnerRating {
  int average;
  PartnerRating({this.average});
  factory PartnerRating.fromJson(Map<String, dynamic> map) {
    return PartnerRating(average: map["average"]);
  }
}
