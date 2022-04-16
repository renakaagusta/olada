import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:olada/utils/timeago/timeago.dart';
import 'package:olada/constants/colors.dart';
import 'package:olada/constants/strings.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  var picker = ImagePicker();
  dynamic user;
  List<dynamic> notificationsUser;
  List<dynamic> notificationsMerchant;
  dynamic users;
  dynamic data;
  dynamic merchants;
  List<dynamic> products;
  SharedPreferences prefs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int tabIndex = 0;
  TabController tabController;
  File image;
  Size size;

  Future<dynamic> getUserData(String id) async {
    return firestore.collection('users').doc(id).get();
  }

  Future<dynamic> getOrderData(String id) async {
    return firestore.collection('orders').doc(id).get();
  }

  Future<dynamic> getChatData(String id) async {
    return firestore.collection('chats').doc(id).get();
  }

  Future<void> getData() async {
    prefs = await SharedPreferences.getInstance();

    user = jsonDecode(prefs.getString("user"));
    users = {'user': [], 'merchant': []};
    data = {'user': [], 'merchant': []};
    
    firestore
        .collection('notifications')
        .where('to', isEqualTo: user['id'])
        .get()
        .then((snapshot) async {
      List<dynamic> notificationUserQuery = snapshot.docs;
      dynamic usersQuery = {'user': [], 'notification': []};
      dynamic dataQuery = {'user': [], 'notification': []};
      
      usersQuery['user'] = await Future.wait(snapshot.docs
          .map((doc) async => await getUserData(doc.data()['user'])));

      dataQuery['user'] = await Future.wait(snapshot.docs.map((doc) async =>
          doc.data()['type'] == 'order'
              ? await getOrderData(doc.data()['data'])
              : await getChatData(doc.data()['data'])));
              
      firestore
          .collection('notifications')
          .where('to',
              isEqualTo: user['merchant'] != null ? user['merchant']['id'] : '')
          .get()
          .then((snapshot) async {
        List<dynamic> notificationMerchantQuery = snapshot.docs;
        
        usersQuery['merchant'] = await Future.wait(snapshot.docs
            .map((doc) async => await getUserData(doc.data()['user'])));

        dataQuery['merchant'] = await Future.wait(snapshot.docs.map(
            (doc) async => doc.data()['type'] == 'order'
                ? await getOrderData(doc.data()['data'])
                : await getChatData(doc.data()['data'])));

        notificationUserQuery.sort((a,b)=>b.data()['created'].compareTo(a.data()['created']));
        notificationMerchantQuery.sort((a,b)=>b.data()['created'].compareTo(a.data()['created']));

        setState(() {
          notificationsUser = notificationUserQuery;
          notificationsMerchant = notificationMerchantQuery;
          users = usersQuery;
          data = dataQuery;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {
        tabIndex = tabController.index;
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
          title: Text('Notifikasi',
              style: TextStyle(
                color: Colors.black,
              )),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black)),
      body: (user != null)
          ? Container(
              height: size.height,
              width: size.width,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 60,
                        decoration: BoxDecoration(color: Colors.white),
                        child: TabBar(
                          tabs: [
                            Container(
                              width: 60,
                              child: Text(
                                'Pengguna',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            Container(
                              width: 60,
                              child: Text(
                                'Toko',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                          unselectedLabelColor: const Color(0xffacb3bf),
                          indicatorColor: AppColors.SecondaryColor,
                          labelColor: Colors.black,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorWeight: 3.0,
                          indicatorPadding: EdgeInsets.all(0),
                          isScrollable: false,
                          controller: tabController,
                        ),
                      ),
                      (notificationsUser != null &&
                              notificationsMerchant != null)
                          ? Container(
                              height: size.height - 140,
                              child: tabIndex == 0
                                  ? notificationsUser.length > 0
                                      ? Expanded(
                                          child: StaggeredGridView.countBuilder(
                                            crossAxisCount: 4,
                                            itemCount: notificationsUser.length,
                                            padding: EdgeInsets.zero,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (BuildContext context,
                                                    int index) =>
                                                new Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          width: 1,
                                                          color:
                                                              Colors.grey[300],
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    padding: EdgeInsets.only(
                                                        top: 20,
                                                        bottom: 20,
                                                        left: 20,
                                                        right: 20),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(notificationsUser[
                                                                        index]
                                                                    .data()[
                                                                'type']),
                                                            Text(
                                                                TimeAgo.timeAgoSinceDate(notificationsUser[
                                                                            index]
                                                                        [
                                                                        'created']
                                                                    .toDate()
                                                                    .toString()),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        12)),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10),
                                                        Row(children: [
                                                          Container(
                                                              height: 60,
                                                              width: 60,
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: notificationsUser[
                                                                            index]
                                                                        .data()[
                                                                    'thumbnail'],
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
                                                              )),
                                                          SizedBox(width: 15),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                  height: 5),
                                                              Text(
                                                                  notificationsUser[
                                                                          index]
                                                                      ['title'],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              SizedBox(
                                                                  height: 5),
                                                              Container(
                                                                width:
                                                                    size.width -
                                                                        120,
                                                                child: Text(
                                                                    notificationsUser[
                                                                            index]
                                                                        [
                                                                        'description'],
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12)),
                                                              )
                                                            ],
                                                          )
                                                        ])
                                                      ],
                                                    )),
                                            staggeredTileBuilder: (int index) =>
                                                new StaggeredTile.fit(4),
                                            mainAxisSpacing: 8.0,
                                            crossAxisSpacing: 8.0,
                                          ),
                                        )
                                      : Container(
                                          padding: EdgeInsets.only(top: 100),
                                          child: Column(
                                            children: [
                                              Icon(
                                                  CupertinoIcons
                                                      .exclamationmark_circle,
                                                  size: 80),
                                              SizedBox(height: 30),
                                              Text('Notifikasi tidak ditemukan',
                                                  style:
                                                      TextStyle(fontSize: 16))
                                            ],
                                          ),
                                        )
                                  : notificationsMerchant.length > 0
                                      ? Expanded(
                                          child: StaggeredGridView.countBuilder(
                                            crossAxisCount: 4,
                                            itemCount:
                                                notificationsMerchant.length,
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (BuildContext context,
                                                    int index) =>
                                                new Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          width: 1,
                                                          color:
                                                              Colors.grey[300],
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    padding: EdgeInsets.only(
                                                        top: 20,
                                                        bottom: 20,
                                                        left: 20,
                                                        right: 20),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(notificationsMerchant[
                                                                        index]
                                                                    .data()[
                                                                'type']),
                                                            Text(
                                                                TimeAgo.timeAgoSinceDate(notificationsMerchant[
                                                                            index]
                                                                        [
                                                                        'created']
                                                                    .toDate()
                                                                    .toString()),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        12)),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10),
                                                        Row(children: [
                                                          Container(
                                                              height: 60,
                                                              width: 60,
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: notificationsMerchant[
                                                                            index]
                                                                        .data()[
                                                                    'thumbnail'],
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
                                                              )),
                                                          SizedBox(width: 15),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                  height: 5),
                                                              Text(
                                                                  notificationsMerchant[
                                                                          index]
                                                                      ['title'],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              SizedBox(
                                                                  height: 5),
                                                              Container(
                                                                width:
                                                                    size.width -
                                                                        120,
                                                                child: Text(
                                                                    notificationsMerchant[
                                                                            index]
                                                                        [
                                                                        'description'],
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12)),
                                                              )
                                                            ],
                                                          )
                                                        ])
                                                      ],
                                                    )),
                                            staggeredTileBuilder: (int index) =>
                                                new StaggeredTile.fit(4),
                                            mainAxisSpacing: 8.0,
                                            crossAxisSpacing: 8.0,
                                          ),
                                        )
                                      : Container(
                                          padding: EdgeInsets.only(top: 100),
                                          child: Column(
                                            children: [
                                              Icon(
                                                  CupertinoIcons
                                                      .exclamationmark_circle,
                                                  size: 80),
                                              SizedBox(height: 30),
                                              Text('Notifikasi tidak ditemukan',
                                                  style:
                                                      TextStyle(fontSize: 16))
                                            ],
                                          ),
                                        ),
                            )
                          : Container(
                              height: size.height - 200,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.PrimaryColor,
                                ),
                              )),
                    ],
                  )
                ],
              ),
            )
          : Container(
              height: size.height - 200,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.PrimaryColor,
                ),
              )),
    );
  }
}
