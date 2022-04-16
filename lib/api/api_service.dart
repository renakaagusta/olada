import 'package:olada/model/response.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';

class ApiService {
  final String baseUrl = "http://213.190.4.239:3000/api/v1";
  final String baseUrlMidtrans = "http://213.190.4.239:3000";
  Client client = Client();
  Future<CustomResponse> signIn(
      String username, String password, String token) async {
    final response = await client.post(Uri.parse("$baseUrl/auth/signin"),
        headers: {"content-type": "application/json"},
        body: jsonEncode({
          'username': username,
          'password': password,
          'fcmToken': token,
        }));
    if (response.statusCode == 200) {
      return customResponseFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<CustomResponse> signUp(
      String username,
      String firstname,
      String lastname,
      String password,
      String email,
      String phoneNumber) async {
    final response = await client.post(Uri.parse("$baseUrl/auth/signup"),
        headers: {"content-type": "application/json"},
        body: jsonEncode({
          'username': username,
          'firstname': firstname,
          'lastname': lastname,
          'password': password,
          'email': email,
          'phoneNumber': phoneNumber,
          'role': 'customer'
        }));
    if (response.statusCode == 200) {
      return customResponseFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<CustomResponse> sendOTP(String code, String phoneNumber) async {
    final response = await client.post(Uri.parse("$baseUrl/auth/send-otp"),
        headers: {"content-type": "application/json"},
        body: jsonEncode({'code': code, 'phoneNumber': phoneNumber}));
    if (response.statusCode == 200) {
      return customResponseFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<CustomResponse> getUserById(String userId) async {
    final response = await client.get(Uri.parse("$baseUrl/auth/$userId"),
        headers: {"content-type": "application/json"});
    print(response);
    if (response.statusCode == 200) {
      return customResponseFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<CustomResponse> changeProfile(var _arguments) async {
    Map arguments = {
      'username': _arguments['username'],
      'firstname': _arguments['firstname'],
      'lastname': _arguments['lastname'],
      'email': _arguments['email'],
      'phoneNumber': _arguments['phoneNumber'],
    };
    String id = _arguments['id'];
    final response = await client.post(Uri.parse("$baseUrl/auth/$id"),
        headers: {"content-type": "application/json"},
        body: json.encode(arguments));

    if (response.statusCode == 200) {
      return customResponseFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<Response> changeImageProfile(String id, FormData data) async {
    String url = "$baseUrl/auth/$id/change-image-profile";
    Dio dio = new Dio();
    return await dio.post(url,
        data: data, options: Options(contentType: 'multipart/form-data'));
  }

  Future<CustomResponse> checkExistUser(
      String id, String username, String email, String phoneNumber) async {
    final response = await client.get(
        Uri.parse(
            "$baseUrl/auth/$id/username/$username/phone-number/$phoneNumber/email/$email"),
        headers: {"content-type": "application/json"});
    print(username);
    if (response.statusCode == 200) {
      return customResponseFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<Response> sendForm(FormData data) async {
    String url = "$baseUrl/order";
    Dio dio = new Dio();
    return await dio.post(url,
        data: data, options: Options(contentType: 'multipart/form-data'));
  }

  Future<CustomResponse> getPartnerByCityAndService(
      String city, String service, String subservices) async {
    final response = await client.get(
        Uri.parse(
            "$baseUrl/partner/service/$service/subservice/$subservices/city/$city"),
        headers: {"content-type": "application/json"});
    print(response);
    if (response.statusCode == 200) {
      return customResponseFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<CustomResponse> getOrderByCustomerAndStatus(
      String customerID, int status) async {
    final response = await client.get(
        Uri.parse("$baseUrl/order/customer/$customerID/status/$status"),
        headers: {"content-type": "application/json"});

    if (response.statusCode == 200) {
      return customResponseFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<CustomResponse> getOrderByPartnerAndStatus(
      String customerID, int status) async {
    final response = await client.get(
        Uri.parse("$baseUrl/order/partner/$customerID/status/$status"),
        headers: {"content-type": "application/json"});
    print(response);
    if (response.statusCode == 200) {
      return customResponseFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<CustomResponse> getOrderById(String orderID) async {
    final response = await client.get(Uri.parse("$baseUrl/order/$orderID"),
        headers: {"content-type": "application/json"});

    if (response.statusCode == 200) {
      return customResponseFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<CustomResponse> acceptOrder(String orderId, String customerId) async {
    final response =
        await client.post(Uri.parse("$baseUrl/order/$orderId/accept"),
            headers: {"content-type": "application/json"},
            body: json.encode({
              'customerId': customerId,
            }));
    if (response.statusCode == 200) {
      return customResponseFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<CustomResponse> createChat(String orderId, String userId,
      String partnerId, String content, int type, String createdAt) async {
    print(jsonEncode({
      'userId': userId,
      'partnerId': partnerId,
      'content': content,
      'type': type,
      'createdAt': createdAt
    }));
    print(orderId + "//////");
    final response =
        await client.post(Uri.parse("$baseUrl/order/$orderId/chat"),
            headers: {"content-type": "application/json"},
            body: jsonEncode({
              'userId': userId,
              'partnerId': userId,
              'content': content,
              'type': type,
              'createdAt': createdAt
            }));
    if (response.statusCode == 200) {
      return customResponseFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<CustomResponse> getNotificationById(String userID) async {
    final response = await client.get(
        Uri.parse("$baseUrl/notification/user/$userID"),
        headers: {"content-type": "application/json"});
    print(response);
    if (response.statusCode == 200) {
      return customResponseFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<CustomResponse> getPaymentStatus(String paymentID) async {
    final response = await client.get(
        Uri.parse("$baseUrlMidtrans/status/$paymentID"),
        headers: {"content-type": "application/json"});

    if (response.statusCode == 200) {
      return customResponseFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<CustomResponse> chargePayment(var payment) async {
    final _body = jsonEncode(payment);

    final response = await client.post(Uri.parse("$baseUrlMidtrans/charge"),
        headers: {"content-type": "application/json"}, body: _body);

    if (response.statusCode == 200) {
      return customResponseFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<CustomResponse> getPartnerById(String partnerID) async {
    final response = await client.get(Uri.parse("$baseUrl/partner/$partnerID"),
        headers: {"content-type": "application/json"});
    print(response);
    if (response.statusCode == 200) {
      return customResponseFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<Response> sendFile(String url, File file) async {
    Dio dio = new Dio();
    var len = await file.length();
    var response = await dio.post(url,
        data: file.openRead(),
        options: Options(headers: {
          Headers.contentLengthHeader: len,
        }));
    return response;
  }
}
