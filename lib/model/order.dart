import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:olada/model/customlocation.dart';
import 'package:olada/model/chat.dart';

class Order {
  String id;
  String service;
  String subservice;
  String serviceDescription;
  List<File> images;
  String customerID;
  String partnerID;
  List<Chat> chats;
  DateTime date;
  TimeOfDay time;
  DateTime createdAt;
  int status;
  CustomLocation location;
  Order(
      {this.id,
      this.service,
      this.subservice,
      this.serviceDescription,
      this.customerID,
      this.partnerID,
      this.status});
  factory Order.fromJson(Map<String, dynamic> map) {
    return Order(
        id: map["_id"],
        service: map["service"],
        subservice: map["subservice"],
        serviceDescription: map["description"],
        customerID: map["customerId"],
        partnerID: map["partnerId"],
        status: int.parse(map["status"]));
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "service": service,
      "subservice": service,
      "serviceDescription": service,
      "images": images,
      "customerID": customerID,
      "partnerID": partnerID,
      "status": status,
      "location": location
    };
  }

  @override
  String toString() {
    return 'Order{id: $id, service: $service,subservice: $subservice,serviceDescription: $serviceDescription,images: $images, customerID: $customerID, partnerID: $partnerID, status: $status, location: $location}';
  }
}

Order orderFromJson(String jsonData) {
  return Order.fromJson(json.decode(jsonData));
}

String orderToJson(Order data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
