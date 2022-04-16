import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:olada/api/api_service.dart';
import 'package:olada/widgets/textfield_widget.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:path/path.dart' as path;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:olada/utils/timeago/timeago.dart';
import 'package:olada/constants/assets.dart';
import 'package:olada/constants/colors.dart';
import 'package:olada/constants/strings.dart';

class PromoScreen extends StatefulWidget {
  @override
  _PromoScreenState createState() => _PromoScreenState();
}

class _PromoScreenState extends State<PromoScreen> {
  var picker = ImagePicker();
  dynamic user;
  SharedPreferences prefs;
  ApiService apiService = ApiService();
  File image;
  Size size;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  dynamic userOther;
  dynamic post;
  CarouselController carouselController = new CarouselController();
  List<Widget> postImages = [];
  List<dynamic> postComments;
  List<dynamic> postLikes = [];
  List<dynamic> usersComment;
  List<dynamic> userOtherFollowers;
  int currentPosition = 0;
  TextEditingController commentController = TextEditingController();
  FocusNode commentFocusNode = FocusNode();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> getUserData(String id) async {
    return firestore.collection('users').doc(id).get();
  }

  Future<void> getData() async {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    prefs = await SharedPreferences.getInstance();
    setState(() {
      user = jsonDecode(prefs.getString('user'));

      firestore
          .collection('posts')
          .doc(arguments['postId'])
          .get()
          .then((document) {
        List<Widget> postImagesLocal = [];
        document.data()['images'].forEach((imageUrl) {
          postImagesLocal.add(Container(
              height: size.width,
              width: size.width,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fill,
                  )),
                ),
              )));
        });
        firestore
            .collection('posts')
            .doc(document.id)
            .collection('comments')
            .get()
            .then((snapshot) async {
          usersComment = await Future.wait(snapshot.docs
              .map((doc) async => await getUserData(doc.data()['user'])));
          setState(() {
            postComments = snapshot.docs;
          });
        });
        firestore
            .collection('posts')
            .doc(document.id)
            .collection('likes')
            .get()
            .then((snapshots) {
          setState(() {
            postLikes = snapshots.docs;
          });
        });

        setState(() {
          post = document;
          postImages = postImagesLocal;

          firestore
              .collection('users')
              .doc(post.data()['user'])
              .get()
              .then((document) {
            setState(() {
              userOther = document;
              firestore
                  .collection('users')
                  .doc(post.data()['user'])
                  .collection('followers')
                  .get()
                  .then((snapshot) {
                setState(() {
                  userOtherFollowers = snapshot.docs;
                });
              });
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) getData();
    size = MediaQuery.of(context).size;
    return Scaffold(
      primary: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
          centerTitle: true,
          title: Text('Post',
              style: TextStyle(
                color: Colors.black,
              )),
          iconTheme: IconThemeData(color: Colors.black)),
      body: Container(
          height: size.height,
          width: size.width,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    (post != null && userOther != null && user != null)
                        ? Container(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Column(
                              children: [
                                Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Row(
                                      children: [
                                        Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                            ),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      userOther['picture'],
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    )),
                                                  ),
                                                ))),
                                        SizedBox(width: 15),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .pushNamed('/user', arguments: {
                                              'userId': userOther.id
                                            });
                                          },
                                          child: Text(userOther.data()['name'],
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        SizedBox(width: 15),
                                        if (userOtherFollowers != null)
                                          (userOtherFollowers
                                                      .where((follower) =>
                                                          follower
                                                              .data()['user'] ==
                                                          user['id'])
                                                      .toList()
                                                      .length >
                                                  0)
                                              ? Container()
                                              : GestureDetector(
                                                  onTap: () async {
                                                    await firestore
                                                        .collection('users')
                                                        .doc(userOther.id)
                                                        .collection('followers')
                                                        .add({
                                                      'user': user['id'],
                                                      'created': FieldValue
                                                          .serverTimestamp()
                                                    });
                                                    await firestore
                                                        .collection('users')
                                                        .doc(userOther.id)
                                                        .update({
                                                      'followers':
                                                          userOther.data()[
                                                                  'followers'] +
                                                              1
                                                    });
                                                    await firestore
                                                        .collection('users')
                                                        .doc(user['id'])
                                                        .collection('following')
                                                        .add({
                                                      'user': userOther.id,
                                                      'created': FieldValue
                                                          .serverTimestamp()
                                                    });
                                                    await firestore
                                                        .collection('users')
                                                        .doc(user['id'])
                                                        .update({
                                                      'following':
                                                          user['following'] + 1
                                                    });
                                                    getData();
                                                  },
                                                  child: Text('Follow',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.blue,
                                                          fontWeight: FontWeight
                                                              .bold))),
                                      ],
                                    )),
                                SizedBox(height: 15),
                                CarouselSlider(
                                  items: postImages,
                                  options: CarouselOptions(
                                      autoPlay: postImages.length > 1,
                                      autoPlayInterval:
                                          Duration(milliseconds: 3000),
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          currentPosition = index;
                                        });
                                      }),
                                  carouselController: carouselController,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (postImages.length > 1)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: postImages.map((url) {
                                                int index =
                                                    postImages.indexOf(url);
                                                return Container(
                                                  width: 8.0,
                                                  height: 8.0,
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 2.0),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color:
                                                        currentPosition == index
                                                            ? Color.fromRGBO(
                                                                0, 0, 0, 0.9)
                                                            : Color.fromRGBO(
                                                                0, 0, 0, 0.4),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              (postLikes
                                                          .map((like) =>
                                                              (like.data()[
                                                                      'user'] ==
                                                                  user['id']))
                                                          .length >
                                                      0)
                                                  ? GestureDetector(
                                                      onTap: () async {
                                                        await firestore
                                                            .collection('posts')
                                                            .doc(post.id)
                                                            .collection('likes')
                                                            .doc(postLikes
                                                                .firstWhere((like) =>
                                                                    like.data()[
                                                                        'user'] ==
                                                                    user['id'])
                                                                .id
                                                                .toString())
                                                            .delete();
                                                        await firestore
                                                            .collection('posts')
                                                            .doc(post.id)
                                                            .update({
                                                          'likes': post.data()[
                                                                  'likes'] -
                                                              1
                                                        });
                                                        getData();
                                                      },
                                                      child: Icon(
                                                          CupertinoIcons
                                                              .heart_fill,
                                                          color: Colors.red),
                                                    )
                                                  : GestureDetector(
                                                      onTap: () async {
                                                        await firestore
                                                            .collection('posts')
                                                            .doc(post.id)
                                                            .collection('likes')
                                                            .add({
                                                          'user': user['id'],
                                                          'created': FieldValue
                                                              .serverTimestamp()
                                                        });
                                                        await firestore
                                                            .collection('posts')
                                                            .doc(post.id)
                                                            .update({
                                                          'likes': post.data()[
                                                                  'likes'] +
                                                              1
                                                        });
                                                        getData();
                                                      },
                                                      child: Icon(
                                                          CupertinoIcons.heart,
                                                          color: Colors.black),
                                                    ),
                                              SizedBox(width: 10),
                                              GestureDetector(
                                                onTap: () {
                                                  commentFocusNode
                                                      .requestFocus();
                                                },
                                                child: Icon(
                                                    CupertinoIcons.chat_bubble,
                                                    color: Colors.black),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pushNamed(
                                                  '/list',
                                                  arguments: {
                                                    'type': 'likes',
                                                    'postId': post.id
                                                  });
                                            },
                                            child: Text(
                                                post
                                                        .data()['likes']
                                                        .toString() +
                                                    ' poeple likes',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            post.data()['text'],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              TimeAgo.timeAgoSinceDate(post
                                                  .data()['created']
                                                  .toDate()
                                                  .toString()),
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                          SizedBox(
                                            height: 15,
                                          ),
                                        ])),
                                (postComments != null && usersComment != null)
                                    ? Container(
                                        constraints: BoxConstraints(
                                            minHeight: 200, maxHeight: 300),
                                        child: ListView.builder(
                                            itemCount: postComments.length,
                                            itemBuilder: (context, index) {
                                              return new Column(
                                                children: [
                                                  Container(
                                                      height: 1,
                                                      width: size.width,
                                                      color: Colors.grey[300]),
                                                  Container(
                                                      padding: EdgeInsets.only(
                                                          left: 20, right: 20),
                                                      margin: EdgeInsets.only(
                                                          top: 20, bottom: 20),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            height: 40,
                                                            width: 40,
                                                            child: GestureDetector(
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pushNamed(
                                                                          '/user',
                                                                          arguments: {
                                                                        'userId':
                                                                            postComments[index].data()['user']
                                                                      });
                                                                },
                                                                child: ClipRRect(
                                                                    borderRadius: BorderRadius.circular(20),
                                                                    child: CachedNetworkImage(
                                                                      imageUrl:
                                                                          usersComment[index]
                                                                              [
                                                                              'picture'],
                                                                      imageBuilder:
                                                                          (context, imageProvider) =>
                                                                              Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                                image: DecorationImage(
                                                                          image:
                                                                              imageProvider,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        )),
                                                                      ),
                                                                    ))),
                                                          ),
                                                          SizedBox(width: 15),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.of(context).pushNamed(
                                                                          '/user',
                                                                          arguments: {
                                                                            'userId':
                                                                                postComments[index].data()['user']
                                                                          });
                                                                    },
                                                                    child: Text(
                                                                      usersComment[
                                                                              index]
                                                                          [
                                                                          'name'],
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                      ' ' +
                                                                          TimeAgo.timeAgoSinceDate(usersComment[index]['created']
                                                                              .toDate()
                                                                              .toString()),
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.grey))
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 5),
                                                              Text(
                                                                  postComments[
                                                                              index]
                                                                          .data()[
                                                                      'text'],
                                                                  style:
                                                                      TextStyle())
                                                            ],
                                                          )
                                                        ],
                                                      ))
                                                ],
                                              );
                                            }))
                                    : Container(
                                        width: size.width - 40,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(CupertinoIcons.info_circle,
                                                size: 40),
                                            SizedBox(height: 30),
                                            Text('Comment not found')
                                          ],
                                        ),
                                      )
                              ],
                            ))
                        : Container(
                            height: size.height - 200,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.PrimaryColor,
                              ),
                            )),
                    Container(
                      padding:
                          EdgeInsets.only(top: 30, left: 20.0, right: 20.0),
                      child: Column(
                        children: [
                          SizedBox(height: 100.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  bottom: 0,
                  child: Container(
                    height: 70,
                    width: size.width,
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 10, left: 20, right: 5),
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: Color(0xffdddddd).withOpacity(0.5),
                          spreadRadius: 3,
                          offset: Offset(1, 2),
                          blurRadius: 0.5)
                    ]),
                    child: Row(children: [
                      Container(
                        width: size.width * 0.78,
                        child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: commentController,
                          focusNode: commentFocusNode,
                          style: TextStyle(fontSize: 14),
                          decoration: InputDecoration.collapsed(
                            hintText: "Leave your comment here",
                          ),
                        ),
                      ),
                      GestureDetector(
                          onTap: () async {
                            if (commentController.text.isNotEmpty) {
                              await firestore
                                  .collection('posts')
                                  .doc(post.id)
                                  .collection('comments')
                                  .add({
                                'user': user['id'],
                                'text': commentController.text,
                                'created': FieldValue.serverTimestamp()
                              });
                              await firestore
                                  .collection('posts')
                                  .doc(post.id)
                                  .update({
                                'comments': post.data()['comments'] + 1
                              });
                              await firestore
                                  .collection('posts')
                                  .doc(post.id)
                                  .collection('comments')
                                  .get()
                                  .then((snapshots) {
                                setState(() {
                                  postComments = snapshots.docs;
                                });
                              });

                              commentController.clear();
                              FocusScope.of(context).unfocus();

                              getData();
                            }
                          },
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
                                    Radius.circular(size.width * 0.1 / 2))),
                            child: Icon(CupertinoIcons.paperplane_fill,
                                color: Colors.white, size: 20),
                          ))
                    ]),
                  ))
            ],
          )),
    );
  }
}
