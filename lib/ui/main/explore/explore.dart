import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:olada/api/api_service.dart';
import 'package:olada/model/order.dart';
import 'package:olada/utils/timeago/timeago.dart';
import 'package:olada/constants/assets.dart';
import 'package:olada/constants/colors.dart';
import 'package:olada/constants/strings.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with TickerProviderStateMixin {
  ApiService apiService = ApiService();

  List<dynamic> _posts = [];
  List<dynamic> posts = [];
  List<dynamic> filteredPosts = [];
  List<dynamic> users = [];
  List<dynamic> likes = [];
  int status = 0;
  dynamic user;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Size size;
  bool loading = true;

  void search(String value) {
    List<Order> result = [];
    for (int i = 0; i < _posts.length; i++) {
      print(_posts.toString());
      if (_posts[i].subservice.toLowerCase().contains(value.toLowerCase())) {
        result.add(_posts[i]);
      }
    }
    setState(() {
      posts = result;
    });
  }

  Future<dynamic> getUserData(String id) async {
    return firestore.collection('users').doc(id).get();
  }

  Future<dynamic> getLikesData(String id) async {
    return firestore.collection('posts').doc(id).collection('likes').get();
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user = jsonDecode(prefs.getString('user'));
      firestore
          .collection('posts')
          .orderBy('created', descending: true)
          .get()
          .then((snapshot) async {
        users = await Future.wait(snapshot.docs
            .map((doc) async => await getUserData(doc.data()['user'])));
        likes = await Future.wait(
            snapshot.docs.map((doc) async => await getLikesData(doc.id)));
        setState(() {
          loading = false;
          posts = snapshot.docs;
        });
      });
    });
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
    getData();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(children: [
          Positioned(
            left: 0,
            right: 0,
            child: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.only(top: 40.0, left: 40, right: 40),
                    width: size.width,
                    child: Column(
                      children: [
                        
                        (!loading)
                            ? (posts.length > 0)
                                ? Container(
                                    constraints: BoxConstraints(
                                        minHeight: 100, maxHeight: 500),
                                    child: RefreshIndicator(
                                        color: AppColors.PrimaryColor,
                                        onRefresh: getData,
                                        child: GridView.count(
                                            shrinkWrap: true,
                                            physics: BouncingScrollPhysics(),
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 15,
                                            mainAxisSpacing: 20,
                                            children: List.generate(
                                                posts.length + 1, (index) {
                                              return index < posts.length
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pushNamed('/post',
                                                                arguments: {
                                                              'postId':
                                                                  posts[index]
                                                                      .id
                                                            });
                                                      },
                                                      child: Container(
                                                          height:
                                                              size.width - 80,
                                                          width:
                                                              size.width - 140,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 20),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Stack(
                                                            children: [
                                                              CachedNetworkImage(
                                                                imageUrl: posts[
                                                                            index]
                                                                        .data()[
                                                                    'images'][0],
                                                                imageBuilder:
                                                                    (context,
                                                                            imageProvider) =>
                                                                        Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          image:
                                                                              DecorationImage(
                                                                    image:
                                                                        imageProvider,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )),
                                                                ),
                                                              ),
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets.only(
                                                                        top: 20,
                                                                        right:
                                                                            20),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Icon(
                                                                            CupertinoIcons
                                                                                .heart,
                                                                            color:
                                                                                Colors.white),
                                                                        SizedBox(
                                                                            height:
                                                                                5),
                                                                        Text(
                                                                            posts[index].data()['likes'].toString(),
                                                                            style: TextStyle(color: Colors.white))
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets.only(
                                                                        top: 20,
                                                                        right:
                                                                            20),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Icon(
                                                                            CupertinoIcons
                                                                                .chat_bubble,
                                                                            color:
                                                                                Colors.white),
                                                                        SizedBox(
                                                                            height:
                                                                                5),
                                                                        Text(
                                                                            posts[index].data()['comments'].toString(),
                                                                            style: TextStyle(color: Colors.white))
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Color(
                                                                            0x77000000),
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                      ),
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              20),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                              height: 50,
                                                                              width: 50,
                                                                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(55)),
                                                                              child: ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(50),
                                                                                  child: CachedNetworkImage(
                                                                                    imageUrl: users[index].data()['picture'],
                                                                                    imageBuilder: (context, imageProvider) => Container(
                                                                                      decoration: BoxDecoration(
                                                                                          image: DecorationImage(
                                                                                        image: imageProvider,
                                                                                        fit: BoxFit.cover,
                                                                                      )),
                                                                                    ),
                                                                                  ))),
                                                                          Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(posts[index]['text'], style: TextStyle(color: Colors.white, fontSize: 12)),
                                                                              Text(users[index].data()['name'], style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                                                            ],
                                                                          ),
                                                                          Container(
                                                                            alignment:
                                                                                Alignment.bottomCenter,
                                                                            child:
                                                                                Text(TimeAgo.timeAgoSinceDate(posts[index]['created'].toDate().toString()), style: TextStyle(color: Colors.white, fontSize: 12)),
                                                                          )
                                                                        ],
                                                                      )),
                                                                ],
                                                              )
                                                            ],
                                                          )))
                                                  : Container();
                                            }))),
                                  )
                                : Container(
                                    padding: EdgeInsets.only(top: 100),
                                    child: Column(
                                      children: [
                                        Icon(CupertinoIcons.info_circle,
                                            size: 40),
                                        SizedBox(height: 30),
                                        Text('Post not found',
                                            style: TextStyle(fontSize: 18))
                                      ],
                                    ),
                                  )
                            : Container(
                                height: size.height - 200,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.PrimaryColor,
                                  ),
                                ))
                      ],
                    ))),
          ),
        ]));
  }
}
