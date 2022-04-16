import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:path/path.dart' as path;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/scheduler.dart';
import 'package:olada/utils/timeago/timeago.dart';
import 'package:olada/constants/assets.dart';
import 'package:olada/constants/colors.dart';
import 'package:olada/constants/strings.dart';

class ChatScreen extends StatefulWidget {
  final String username;

  const ChatScreen({
    Key key,
    this.username,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var picker = ImagePicker();
  File image;
  TextEditingController chatController = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  var childList = <Widget>[];
  dynamic user;
  dynamic userOther;
  dynamic merchantOther;
  dynamic chatroom;
  dynamic products;
  dynamic product;
  Size size;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool updated = false;
  String role;

  Future getImagefromGallery() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);
    setState(() {
      if (pickedFile != null) {
        setState(() {
          image = File(pickedFile.path);
        });
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> uploadImage(File image, String type, String id) async {
    firebase_storage.UploadTask task;

    task = firebase_storage.FirebaseStorage.instance
        .ref('images/$type/$id/${path.basename(image.path)}')
        .putFile(image);

    task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
      print('Task state: ${snapshot.state}');
      print(
          'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
    }, onError: (e) {
      print(task.snapshot);

      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    });

    try {
      var dowurl = await (await task).ref.getDownloadURL();
      return dowurl.toString();
    } on firebase_core.FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    }
  }

  Future<List<String>> uploadImages(
      List<File> images, String type, String id) async {
    var imageUrls = await Future.wait(
        images.map((image) async => await uploadImage(image, type, id)));
    return imageUrls;
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      if (arguments['productId'] != null) {
        firestore
            .collection('products')
            .doc(arguments['productId'])
            .get()
            .then((document) {
          setState(() {
            product = document;
          });
        });
        chatController.text = "Halo, Apakah produk ini masih tersedia?";
      }
      if (arguments['chatroomId'] != null) {
        firestore
            .collection('chats')
            .doc(arguments['chatroomId'])
            .get()
            .then((document) {
          setState(() {
            role = arguments['role'];
            user = jsonDecode(prefs.getString('user'));
            chatroom = document;

            if (user['merchant'] == null) {
              if (chatroom['updatedBy'] != user['id']) {
                firestore.collection('chats').doc(chatroom.id).update({
                  'messageUnread': 0,
                });
              }
              print("..param");
              print(document
                  .data()['members']
                  .where((member) => member != user['id'])
                  .toList()[0]);
              firestore
                  .collection('users')
                  .doc(document
                      .data()['members']
                      .where((member) => member != user['id'])
                      .toList()[0])
                  .get()
                  .then((documentUser) {
                if (documentUser.exists) {
                  setState(() {
                    user = jsonDecode(prefs.getString('user'));
                    userOther = documentUser;
                  });
                } else {
                  firestore
                      .collection('merchants')
                      .doc(document
                          .data()['members']
                          .where((member) => member != user['id'])
                          .toList()[0])
                      .get()
                      .then((document) {
                    print("..document");
                    print(document.data());
                    print("..merchant");
                    print(document.data());
                    setState(() {
                      user = jsonDecode(prefs.getString('user'));
                      merchantOther = document;
                    });

                    firestore
                        .collection('users')
                        .doc(document.data()['user'])
                        .get()
                        .then((document) {
                      setState(() {
                        userOther = document;
                      });
                    });
                  });
                }
              });
            } else {
              if (chatroom['updatedBy'] != user['id'] ||
                  chatroom['updatedBy'] != user['merchant']) {
                firestore.collection('chats').doc(chatroom.id).update({
                  'messageUnread': 0,
                });
              }
              firestore
                  .collection('users')
                  .doc(document
                      .data()['members']
                      .where((member) =>
                          member != user['id'] &&
                          member != user['merchant']['id'])
                      .toList()[0])
                  .get()
                  .then((documentUser) {
                if (documentUser.exists) {
                  setState(() {
                    user = jsonDecode(prefs.getString('user'));
                    userOther = documentUser;
                  });
                } else {
                  firestore
                      .collection('merchants')
                      .doc(document
                          .data()['members']
                          .where((member) =>
                              member != user['id'] &&
                              member != user['merchant']['id'])
                          .toList()[0])
                      .get()
                      .then((document) {
                    setState(() {
                      role = arguments['role'];
                      user = jsonDecode(prefs.getString('user'));
                      merchantOther = document;
                    });

                    firestore
                        .collection('users')
                        .doc(document.data()['user'])
                        .get()
                        .then((document) {
                      setState(() {
                        userOther = document;
                      });
                    });
                  });
                }
              });
            }
          });
        });
      } else {
        firestore
            .collection(arguments['merchantId'] != null ? 'merchants' : 'users')
            .doc(arguments['merchantId'] != null
                ? arguments['merchantId']
                : arguments['userId'])
            .get()
            .then((document) {
          setState(() {
            user = jsonDecode(prefs.getString('user'));
            userOther = document;

            firestore
                .collection('chats')
                .where('members', arrayContainsAny: [user['id'], document.id])
                .where('type', isEqualTo: 'personal')
                .get()
                .then((snapshot) {
                  if (snapshot.docs.isEmpty) {
                    firestore.collection('chats').add({
                      'members': [user['id'], userOther.id],
                      'type': 'personal',
                      'messageUnread': 0,
                      'created': FieldValue.serverTimestamp(),
                      'updated': FieldValue.serverTimestamp()
                    }).then((result) {
                      getData();

                      setState(() {
                        product = null;
                      });
                    });
                  } else {
                    setState(() {
                      chatroom = snapshot.docs[0];
                    });
                  }
                });
          });
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) getData();
    final scrollController = ScrollController();
    size = MediaQuery.of(context).size;
    Future.delayed(const Duration(milliseconds: 1000), () {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients)
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        centerTitle: true,
        title: userOther != null || merchantOther != null
            ? Text(
                merchantOther != null
                    ? merchantOther.data()['name']
                    : userOther.data()['name'],
                style: TextStyle(
                  color: Colors.black,
                ))
            : Text(''),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Container(
          child: Stack(
            fit: StackFit.loose,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Divider(
                    height: 0,
                    color: Colors.black54,
                  ),
                  Flexible(
                      fit: FlexFit.tight,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(),
                          child: Column(children: [
                            Expanded(
                                child: (chatroom != null)
                                    ? StreamBuilder<QuerySnapshot>(
                                        stream: firestore
                                            .collection('chats')
                                            .doc(chatroom.id)
                                            .collection('chats')
                                            .where('created',
                                                isNotEqualTo: null)
                                            .orderBy('created')
                                            .snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshot) {
                                          if (!snapshot.hasData) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator(
                                              color: AppColors.PrimaryColor,
                                            ));
                                          }

                                          List<Map<String, dynamic>> docs = [];

                                          for (int i = 0;
                                              i < snapshot.data.docs.length;
                                              i++) {
                                            docs.add(
                                                snapshot.data.docs[i].data());

                                            Map<String, dynamic> _doc =
                                                snapshot.data.docs[i].data();
                                            if (_doc['created'] != null) {
                                              docs[i]['_created'] =
                                                  DateTime.parse(_doc['created']
                                                          .toDate()
                                                          .toString())
                                                      .toLocal();
                                            } else {
                                              docs[i]['_created'] =
                                                  DateTime.now().toLocal();
                                            }
                                          }

                                          docs.sort((a, b) => (a['_created'])
                                              .compareTo(b['_created']));

                                          var lastDate;
                                          var changeDate;
                                          return snapshot.data.docs.isNotEmpty
                                              ? ListView.builder(
                                                  controller: scrollController,
                                                  padding: EdgeInsets.all(8.0),
                                                  itemCount: docs.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    changeDate = 0;
                                                    var _doc = docs[index];
                                                    var dateTime;
                                                    if (_doc['created'] ==
                                                        null) {
                                                      _doc['created'] =
                                                          DateTime.now()
                                                              .toLocal();
                                                      dateTime = DateTime.parse(
                                                              _doc['created']
                                                                  .toString())
                                                          .toLocal();
                                                    } else {
                                                      dateTime = DateTime.parse(
                                                              _doc['created']
                                                                  .toDate()
                                                                  .toString())
                                                          .toLocal();
                                                    }

                                                    var time = dateTime.hour
                                                            .toString() +
                                                        ":" +
                                                        dateTime.minute
                                                            .toString();

                                                    if (lastDate !=
                                                        _doc['_created']
                                                            .toString()
                                                            .substring(0, 9)) {
                                                      print('.....');
                                                      print(lastDate);
                                                      print(_doc['_created']);
                                                      print('-----');
                                                      lastDate =
                                                          _doc['_created']
                                                              .toString()
                                                              .substring(0, 9);
                                                      changeDate = 1;
                                                    }
                                                    var chat;

                                                    bool myMessage = true;

                                                    if (user['merchant'] !=
                                                        null) {
                                                      myMessage = _doc[
                                                                  'user'] !=
                                                              user['id'] &&
                                                          _doc['user'] !=
                                                              user['merchant']
                                                                  ['id'];
                                                    } else {
                                                      myMessage =
                                                          _doc['user'] !=
                                                              user['id'];
                                                    }

                                                    if (myMessage) {
                                                      if (changeDate == 1) {
                                                        chat = Column(
                                                          children: [
                                                            Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10.0),
                                                                decoration: BoxDecoration(
                                                                    color: Color(
                                                                        0xffeeeeee),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0)),
                                                                child: Text(dateTime
                                                                        .day
                                                                        .toString() +
                                                                    "/" +
                                                                    dateTime
                                                                        .month
                                                                        .toString() +
                                                                    "/" +
                                                                    dateTime
                                                                        .year
                                                                        .toString())),
                                                            ReceivedMessageWidget(
                                                              text:
                                                                  _doc['text'],
                                                              time: time,
                                                              image:
                                                                  _doc['image'],
                                                              product: _doc[
                                                                  'product'],
                                                            )
                                                          ],
                                                        );
                                                      } else {
                                                        chat =
                                                            ReceivedMessageWidget(
                                                          text: _doc['text'],
                                                          time: time,
                                                          image: _doc['image'],
                                                          product:
                                                              _doc['product'],
                                                        );
                                                      }
                                                    } else {
                                                      if (changeDate == 1) {
                                                        chat = Column(
                                                          children: [
                                                            Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10.0),
                                                                decoration: BoxDecoration(
                                                                    color: Color(
                                                                        0xffeeeeee),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0)),
                                                                child: Text(dateTime
                                                                        .day
                                                                        .toString() +
                                                                    "/" +
                                                                    dateTime
                                                                        .month
                                                                        .toString() +
                                                                    "/" +
                                                                    dateTime
                                                                        .year
                                                                        .toString())),
                                                            SendedMessageWidget(
                                                              text:
                                                                  _doc['text'],
                                                              image:
                                                                  _doc['image'],
                                                              product: _doc[
                                                                  'product'],
                                                              time: time,
                                                              isImage: _doc[
                                                                      'type'] ==
                                                                  1,
                                                            )
                                                          ],
                                                        );
                                                      } else {
                                                        chat =
                                                            SendedMessageWidget(
                                                          text: _doc['text'],
                                                          image: _doc['image'],
                                                          product:
                                                              _doc['product'],
                                                          time: time,
                                                          isImage:
                                                              _doc['type'] == 1,
                                                        );
                                                      }
                                                    }

                                                    return chat;
                                                  })
                                              : Container(
                                                  width: size.width - 40,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                          CupertinoIcons
                                                              .exclamationmark_circle,
                                                          size: 40),
                                                      SizedBox(height: 30),
                                                      Text('Chat not found')
                                                    ],
                                                  ),
                                                );
                                        })
                                    : Center(
                                        child: CircularProgressIndicator(
                                        color: AppColors.PrimaryColor,
                                      )))
                          ]))),
                  Positioned(
                      child: Column(children: [
                    Divider(height: 0, color: Colors.black26),
                    if (image != null)
                      GestureDetector(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                                child: Icon(CupertinoIcons.xmark,
                                    size: 22, color: Colors.grey)),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            image = null;
                          });
                        },
                      ),
                    if (product != null)
                      Container(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 10),
                        height: 70,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: 50,
                                width: 50,
                                child: CachedNetworkImage(
                                  imageUrl: product.data()['images'][0],
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fill,
                                    )),
                                  ),
                                )),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product.data()['title'],
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey[800])),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('Rp ' + product.data()['price'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ],
                            )
                          ],
                        ),
                      ),
                    if (image != null)
                      Container(
                          height: 200,
                          child: Image.file(
                            image,
                            fit: BoxFit.contain,
                          )),
                    Container(
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, bottom: 10, top: 10),
                        child: TextField(
                          maxLines: 20,
                          controller: chatController,
                          textCapitalization: TextCapitalization.sentences,
                          cursorColor: AppColors.PrimaryColor,
                          decoration: InputDecoration(
                            focusColor: AppColors.PrimaryColor,
                            prefixIcon: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Icon(CupertinoIcons.photo,
                                          color: AppColors.PrimaryColor,
                                          size: 20),
                                    ),
                                    onTap: () async {
                                      getImagefromGallery();
                                    }),
                              ],
                            ),
                            suffixIcon: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 10.0),
                                    height: size.width * 0.1,
                                    width: size.width * 0.1,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          AppColors.PrimaryColor,
                                          AppColors.SecondaryColor
                                        ]),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                size.width * 0.1 / 2))),
                                    child: Icon(CupertinoIcons.paperplane_fill,
                                        color: Colors.white, size: 20),
                                  ),
                                  onTap: () async {
                                    String imageUrl, fileUrl, reply;
                                    if (image != null) {
                                      imageUrl = await uploadImage(
                                          image, 'chat', chatroom.id);
                                      setState(() {
                                        image = null;
                                      });
                                    }
                                    await firestore
                                        .collection('chats')
                                        .doc(chatroom.id)
                                        .collection('chats')
                                        .add({
                                      'text': chatController.text != null
                                          ? chatController.text
                                          : null,
                                      'image':
                                          imageUrl != null ? imageUrl : null,
                                      'product':
                                          product != null ? product.id : null,
                                      'file': fileUrl != null ? fileUrl : null,
                                      'reply': reply != null ? reply : null,
                                      'user': role == 'merchant'
                                          ? user['merchant']['id']
                                          : user['id'],
                                      'created': FieldValue.serverTimestamp(),
                                    }).then((result) {
                                      setState(() {
                                        product = null;
                                      });
                                    });

                                    await firestore
                                        .collection('notifications')
                                        .add({
                                      'from': user['id'],
                                      'to': merchantOther != null
                                          ? merchantOther.id
                                          : userOther.id,
                                      'title': role == 'merchant'
                                          ? user['merchant']['name']
                                          : user['name'],
                                      'description': chatController.text,
                                      'type': 'chat',
                                      'data': chatroom.id,
                                      'thumbnail': merchantOther != null
                                          ? merchantOther.data()['picture']
                                          : userOther.data()['picture'],
                                      'read': null,
                                      'created': FieldValue.serverTimestamp()
                                    }).then((result) {});

                                    http.Response response = await http.post(
                                      Uri.parse(
                                          'https://fcm.googleapis.com/fcm/send'),
                                      headers: <String, String>{
                                        'Content-Type': 'application/json',
                                        'Authorization':
                                            'key=AAAAIm6AsJQ:APA91bGT81ymffaQJDAyZrOugf57o3DJTsLmjonfmX393M8Oaeb8Yj773T0I4VJugTBAEMq9ukFgez05titoCbNw4KQIFGuhS4DxQiuIRklAKYRZ_IIqOquhlMne-WxyKEtxNwRnBOPE',
                                      },
                                      body: jsonEncode(
                                        <String, dynamic>{
                                          'notification': <String, dynamic>{
                                            'title': role == 'merchant'
                                                ? user['merchant']['name']
                                                : user['name'],
                                            'body': chatController.text,
                                          },
                                          'priority': 'high',
                                          'data': <String, dynamic>{
                                            'click_action':
                                                'FLUTTER_NOTIFICATION_CLICK',
                                            'id': '1',
                                            'status': 'done'
                                          },
                                          'to': userOther.data()['fcmToken'],
                                        },
                                      ),
                                    );

                                    await firestore
                                        .collection('chats')
                                        .doc(chatroom.id)
                                        .update({
                                      'text': chatController.text,
                                      'image': imageUrl,
                                      'messageUnread': chatroom.data() != null
                                          ? chatroom.data()['messageUnread'] + 1
                                          : 1,
                                      'updatedBy': role == 'merchant'
                                          ? user['merchant']['id']
                                          : user['id'],
                                      'updated': FieldValue.serverTimestamp(),
                                    });

                                    chatController.clear();

                                    Future.delayed(
                                        const Duration(milliseconds: 1000), () {
                                      SchedulerBinding.instance
                                          .addPostFrameCallback((_) {
                                        if (scrollController.hasClients)
                                          scrollController.animateTo(
                                            scrollController
                                                .position.maxScrollExtent,
                                            duration: Duration(seconds: 1),
                                            curve: Curves.fastOutSlowIn,
                                          );
                                      });
                                    });
                                  },
                                ),
                              ],
                            ),
                            border: InputBorder.none,
                            hintText: "Write your message here",
                          ),
                        ),
                      ),
                    ),
                  ]))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SendedMessageWidget extends StatefulWidget {
  final String text;
  final String image;
  final String product;
  final String time;
  final bool isImage;
  const SendedMessageWidget({
    Key key,
    this.text,
    this.time,
    this.image,
    this.product,
    this.isImage,
  }) : super(key: key);

  @override
  State<SendedMessageWidget> createState() => _SendedMessageWidgetState();
}

class _SendedMessageWidgetState extends State<SendedMessageWidget> {
  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(
              right: 8.0, left: 50.0, top: 4.0, bottom: 4.0),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(0),
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15)),
            child: Container(
              padding: EdgeInsets.all(5.0),
              color: AppColors.PrimaryColor,
              child: Stack(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      right: 12.0, left: 23.0, top: 8.0, bottom: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.product != null)
                        StreamBuilder(
                            stream: firestore
                                .collection('products')
                                .doc(widget.product)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Container(
                                    child: Text("----"));
                              }

                              return GestureDetector(
                                onTap: (){
                                  Navigator.of(context).pushNamed('/product', arguments: {
                                    'productId': widget.product
                                  });
                                },
                                  child: Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              height: 50,
                                              width: 50,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    snapshot.data['images'][0],
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.fill,
                                                  )),
                                                ),
                                              )),
                                          SizedBox(width: 20),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(snapshot.data['title'],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.grey[800])),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  'Rp ' +
                                                      snapshot.data['price'],
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          )
                                        ],
                                      )));
                            }),
                      if (widget.image != null)
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          child: Image.network(
                            widget.image,
                            width: 130,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),
                      if (widget.text != null)
                        Text(widget.text, style: TextStyle(color: Colors.white))
                    ],
                  ),
                ),
                Positioned(
                  bottom: 1,
                  left: 10,
                  child: Text(
                    widget.time,
                    style: TextStyle(
                        fontSize: 10, color: Colors.white.withOpacity(0.6)),
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class ReceivedMessageWidget extends StatefulWidget {
  final String text;
  final String image;
  final String product;
  final String time;
  const ReceivedMessageWidget({
    Key key,
    this.text,
    this.time,
    this.image,
    this.product,
  }) : super(key: key);

  @override
  State<ReceivedMessageWidget> createState() => _ReceivedMessageWidgetState();
}

class _ReceivedMessageWidgetState extends State<ReceivedMessageWidget> {
  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
            child: Padding(
          padding: const EdgeInsets.only(
              right: 75.0, left: 8.0, top: 8.0, bottom: 8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(15),
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15)),
            child: Container(
              padding: EdgeInsets.all(5),
              color: Color(0xffbbbbbb),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 8.0, left: 8.0, top: 8.0, bottom: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.product != null)
                          StreamBuilder(
                              stream: firestore
                                  .collection('products')
                                  .doc(widget.product)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Container(
                                    child: Text("----"));
                              }

                              return GestureDetector(
                                onTap: (){
                                  Navigator.of(context).pushNamed('/product', arguments: {
                                    'productId': widget.product
                                  });
                                },
                                  child: Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              height: 50,
                                              width: 50,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    snapshot.data['images'][0],
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.fill,
                                                  )),
                                                ),
                                              )),
                                          SizedBox(width: 20),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(snapshot.data['title'],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.grey[800])),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  'Rp ' +
                                                      snapshot.data['price'],
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          )
                                        ],
                                      )));
                              }),
                        if (widget.image != null)
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            child: Image.network(
                              widget.image,
                              height: 130,
                              width: 130,
                              fit: BoxFit.cover,
                            ),
                          ),
                        SizedBox(
                          height: 5,
                        ),
                        if (widget.text != null)
                          Text(
                            widget.text,
                          )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 1,
                    right: 10,
                    child: Text(
                      widget.time,
                      style: TextStyle(
                          fontSize: 10, color: Colors.black.withOpacity(0.6)),
                    ),
                  )
                ],
              ),
            ),
          ),
        )));
  }
}

const MaterialColor blue = const MaterialColor(0xFF54C5E6, const <int, Color>{
  10: const Color(0x0D54C5E6),
  50: const Color(0x2654C5E6),
  100: const Color(0x4054C5E6),
  200: const Color(0x5954C5E6),
  300: const Color(0x7354C5E6),
  400: const Color(0x8C54C5E6),
  500: const Color(0xA654C5E6),
  600: const Color(0xBF54C5E6),
  700: const Color(0xD954C5E6),
  800: const Color(0xF254C5E6),
  900: const Color(0xFF54C5E6),
});

const MaterialColor orange = const MaterialColor(0xFFFF8C00, const <int, Color>{
  10: const Color(0x0DFF8C00),
  50: const Color(0x26FF8C00),
  100: const Color(0x40FF8C00),
  200: const Color(0x59FF8C00),
  300: const Color(0x73FF8C00),
  400: const Color(0x8CFF8C00),
  500: const Color(0xA6FF8C00),
  600: const Color(0xBFFF8C00),
  700: const Color(0xD9FF8C00),
  800: const Color(0xF2FF8C00),
  900: const Color(0xFFFF8C00),
});

Color backGround = const Color(0xFFFbFbFb);
Color darkBackGround = Colors.grey[850];

bool isDarkMode = false;
Function changeTheme;
