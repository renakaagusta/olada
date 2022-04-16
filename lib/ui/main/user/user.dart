import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:olada/model/user.dart';
import 'package:olada/constants/assets.dart';
import 'package:olada/constants/colors.dart';
import 'package:olada/constants/strings.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  var picker = ImagePicker();
  List<File> images = [];
  TextEditingController caption = TextEditingController();
  dynamic user;
  dynamic userOther;
  List<dynamic> posts;
  List<dynamic> userOtherFollowers;
  List<dynamic> userOtherFollowing;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  SharedPreferences prefs;
  Size size;

  Future<void> getData() async {
    if (context != null) {
      final Map arguments = ModalRoute.of(context).settings.arguments as Map;
      prefs = await SharedPreferences.getInstance();
      print("..aguments");
      print(arguments);
      setState(() {
        user = jsonDecode(
            prefs.getString("user") != null ? prefs.getString("user") : '{}');
        firestore
            .collection('users')
            .doc(arguments['userId'])
            .get()
            .then((document) {
          setState(() {
            userOther = document;
            firestore
                .collection('users')
                .doc(arguments['userId'])
                .collection('followers')
                .get()
                .then((snapshot) {
              setState(() {
                userOtherFollowers = snapshot.docs;
              });
            });
            firestore
                .collection('users')
                .doc(arguments['userId'])
                .collection('following')
                .get()
                .then((snapshot) {
              setState(() {
                userOtherFollowing = snapshot.docs;
              });
            });
            firestore
                .collection('posts')
                .where('user', isEqualTo: arguments['userId'])
                .get()
                .then((snapshots) {
              setState(() {
                posts = snapshots.docs;
              });
            });
          });
        });
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    if (user == null) getData();
    EasyLoading.instance
      ..userInteractions = false
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..dismissOnTap = false;
    return Scaffold(
        primary: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.white,
            centerTitle: true,
            title: Text('Profile',
                style: TextStyle(
                  color: Colors.black,
                )),
            iconTheme: IconThemeData(color: Colors.black)),
        body:  SingleChildScrollView(
                child: Container(
          padding: EdgeInsets.only(top: 30.0, bottom: 20),
          child: userOther != null
              ? userOther.data()!=null?userOther.data()['name'] != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(userOther.data()['name'],
                                            style: TextStyle(fontSize: 20)),
                                        Text('@' + userOther.data()['username'],
                                            style: TextStyle(fontSize: 16)),
                                        SizedBox(height: 30),
                                        Text(
                                            'Hello i\'am ' +
                                                userOther.data()['name'],
                                            style: TextStyle(fontSize: 14)),
                                        Text('Welcome to my profile',
                                            style: TextStyle(fontSize: 14)),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 4,
                                                    color:
                                                        AppColors.PrimaryColor),
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(55)),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: CachedNetworkImage(
                                                  imageUrl: userOther
                                                      .data()['picture'],
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
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: 40.0),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pushNamed('/list', arguments: {
                                            'type': 'following',
                                            'userId': userOther.id
                                          });
                                        },
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                  userOther
                                                      .data()['following']
                                                      .toString(),
                                                  style:
                                                      TextStyle(fontSize: 24)),
                                              SizedBox(height: 5),
                                              Text('Following',
                                                  style:
                                                      TextStyle(fontSize: 14)),
                                            ]),
                                      ),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                                userOther
                                                    .data()['posts']
                                                    .toString(),
                                                style: TextStyle(fontSize: 24)),
                                            SizedBox(height: 5),
                                            Text('Post',
                                                style: TextStyle(fontSize: 14)),
                                          ]),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pushNamed('/list', arguments: {
                                            'type': 'followers',
                                            'userId': userOther.id
                                          });
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                                userOther
                                                    .data()['followers']
                                                    .toString(),
                                                style: TextStyle(fontSize: 24)),
                                            SizedBox(height: 5),
                                            Text('Followers',
                                                style: TextStyle(fontSize: 14)),
                                          ]),)
                                    ],
                                  ),
                                ),
                                SizedBox(height: 30.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (userOtherFollowers != null)
                                      (userOtherFollowers.where((follower) => follower.data()['user'] == user['id']).toList().length >
                                              0)
                                          ? GestureDetector(
                                              onTap: () async {
                                                await firestore
                                                    .collection('users')
                                                    .doc(userOther.id)
                                                    .collection('followers')
                                                    .where('user',
                                                        isEqualTo: user['id'])
                                                    .get()
                                                    .then((snapshot) async {
                                                  await firestore
                                                      .collection('users')
                                                      .doc(userOther.id)
                                                      .collection('followers')
                                                      .doc(snapshot.docs[0].id)
                                                      .delete();
                                                });
                                                await firestore
                                                    .collection('users')
                                                    .doc(userOther.id)
                                                    .update({
                                                  'followers': userOther
                                                          .data()['followers'] -
                                                      1
                                                });
                                                await firestore
                                                    .collection('users')
                                                    .doc(user['id'])
                                                    .collection('following')
                                                    .where('user',
                                                        isEqualTo:
                                                            userOther['id'])
                                                    .get()
                                                    .then((snapshot) async {
                                                  await firestore
                                                      .collection('users')
                                                      .doc(user['id'])
                                                      .collection('following')
                                                      .doc(snapshot.docs[0].id)
                                                      .delete();
                                                });
                                                await firestore
                                                    .collection('users')
                                                    .doc(user['id'])
                                                    .update({
                                                  'following':
                                                      user['following'] - 1
                                                });
                                                getData();
                                              },
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 10.0),
                                                  height: 45.0,
                                                  width: size.width / 2 - 40,
                                                  decoration: BoxDecoration(
                                                      gradient:
                                                          LinearGradient(colors: [
                                                        AppColors.PrimaryColor,
                                                        AppColors.SecondaryColor
                                                      ]),
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(10))),
                                                  child: Text(
                                                    'Unfollow',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16.0),
                                                  )))
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
                                                  'followers': userOther
                                                          .data()['followers'] +
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
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 10.0),
                                                  height: 45.0,
                                                  width: size.width / 2 - 40,
                                                  decoration: BoxDecoration(
                                                      gradient:
                                                          LinearGradient(colors: [
                                                        AppColors.PrimaryColor,
                                                        AppColors.SecondaryColor
                                                      ]),
                                                      borderRadius:
                                                          BorderRadius.all(Radius.circular(10))),
                                                  child: Text(
                                                    'Follow',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16.0),
                                                  ))),
                                    userOtherFollowers != null
                                        ? GestureDetector(
                                            onTap: () async {
                                              Navigator.of(context).pushNamed(
                                                  '/chat',
                                                  arguments: {
                                                    'userId': userOther.id
                                                  });
                                            },
                                            child: Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.0,
                                                    vertical: 10.0),
                                                height: 45.0,
                                                width: size.width / 2 - 40,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: AppColors
                                                          .PrimaryColor,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: Text(
                                                  'Chat',
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .PrimaryColor,
                                                      fontSize: 16.0),
                                                )))
                                        : Container()
                                  ],
                                ),
                              ],
                            )),
                        SizedBox(height: 30.0),
                        Container(
                          height: size.width / 3,
                          constraints: BoxConstraints(
                              maxHeight: 600,
                              minHeight: 100.0,
                              minWidth: size.width),
                          child: posts != null
                              ? posts.length != 0
                                  ? GridView.count(
                                      physics: BouncingScrollPhysics(),
                                      crossAxisCount: 3,
                                      children:
                                          List.generate(posts.length, (index) {
                                        return GestureDetector(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: user != null
                                                ? posts[index]
                                                            .data()['images'] !=
                                                        null
                                                    ? CachedNetworkImage(
                                                        imageUrl:
                                                            posts[index].data()[
                                                                'images'][0],
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover,
                                                          )),
                                                        ),
                                                      )
                                                    : Container()
                                                : Container(),
                                          ),
                                          onTap: () {
                                            Navigator.of(context)
                                                .pushNamed('/post', arguments: {
                                              'postId': posts[index].id
                                            });
                                          },
                                        );
                                      }))
                                  : Container(
                                      child: Column(
                                        children: [
                                          Icon(CupertinoIcons.info_circle,
                                              size: 40),
                                          SizedBox(height: 30),
                                          Text('Post not found')
                                        ],
                                      ),
                                    )
                              : Container(),
                        )
                      ],
                    )
                  : Container():Container()
              : Container(
                  height: size.height - 200,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.PrimaryColor,
                    ),
                  )),
        )) );
  }
}
