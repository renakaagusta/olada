import 'dart:convert';

class CustomResponse {
  var status;
  String message;
  var data;
  String error;
  CustomResponse({this.status = 200, this.message, this.data, this.error});
  factory CustomResponse.fromJson(Map<String, dynamic> map) {
    return CustomResponse(
        status: map["status"],
        message: map["message"],
        data: map["data"],
        error: map["error"]);
  }
  Map<String, dynamic> toJson() {
    return {"status": status, "message": message, "data": data, "error": error};
  }

  @override
  String toString() {
    return 'CustomResponse{status: $status, message: $message, data: $data, error: $error}';
  }
}

CustomResponse customResponseFromJson(String jsonData) {
  return CustomResponse.fromJson(json.decode(jsonData));
}

String customResponseToJson(CustomResponse data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
