import 'dart:convert';

class Chat {
  String from;
  int type;
  String content;
  DateTime createdAt;
  DateTime readAt;
  Chat({this.from, this.type, this.content, this.createdAt, this.readAt});
  factory Chat.fromJson(Map<String, dynamic> map) {
    return Chat(
      from: map["from"],
      type: map["type"],
      content: map["content"],
      createdAt: map["createdAt"],
      readAt: map["readAt"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "from": from,
      "type": type,
      "content": content,
      "createdAt": createdAt,
      "readAt": readAt,
    };
  }

  @override
  String toString() {
    return 'Chat{from: $from, type: $type, content: $content, createdAt: $createdAt, readAt: $readAt}';
  }
}

Chat chatFromJson(String jsonData) {
  return Chat.fromJson(json.decode(jsonData));
}

String chatToJson(Chat data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
