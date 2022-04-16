import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:olada/api/api_service.dart';
import 'package:olada/utils/timeago/timeago.dart';
import 'package:olada/constants/assets.dart';
import 'package:olada/constants/colors.dart';
import 'package:olada/constants/strings.dart';

class ChatListScreen extends StatefulWidget {
  final String username;

  const ChatListScreen({
    Key key,
    this.username,
  }) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController chatController = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  var childList = <Widget>[];
  ApiService apiService = ApiService();
  dynamic user;
  dynamic userOther;
  dynamic chatroomList;
  List<dynamic> users = [];
  List<dynamic> merchants = [];
  int tabIndex = 0;
  TabController tabController;
  Size size;
  SharedPreferences prefs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool updated = false;

  Future<dynamic> getUserData(String id) async {
    return firestore.collection('users').doc(id).get();
  }

  Future<dynamic> getMerchantData(String id) async {
    return firestore.collection('merchants').doc(id).get();
  }

  Future<dynamic> getUserListData(List<dynamic> chatroomList) async {
    List<dynamic> userListQuery = await Future.wait(chatroomList.map(
        (chatroom) async => await getUserData(chatroom['members']
            .where((member) => member != user['id'])
            .toList()[0])));
    setState(() {
      users = userListQuery;
    });
  }

  Future<dynamic> getMerchantListData(List<dynamic> chatroomList) async {
    List<dynamic> merchantListQuery;
    if(user['merchant']!=null) {
      merchantListQuery = await Future.wait(chatroomList.map(
        (chatroom) async => await getMerchantData(chatroom['members']
            .where((member) => member != user['id'] || member!=user['merchant']['id'])
            .toList()[0])));
    } else {
      merchantListQuery = await Future.wait(chatroomList.map(
        (chatroom) async => await getMerchantData(chatroom['members']
            .where((member) => member != user['id'])
            .toList()[0])));
    }
    setState(() {
      merchants = merchantListQuery;
    });
  }

  Future<void> getData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      user = jsonDecode(
          prefs.getString("user") != null ? prefs.getString("user") : '{}');
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
    final scrollController = ScrollController();
    size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.white,
            centerTitle: true,
            title: Text('Obrolan',
                style: TextStyle(
                  color: Colors.black,
                )),
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black)),
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: Stack(
              fit: StackFit.loose,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Flexible(
                        fit: FlexFit.tight,
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 60,
                                    decoration:
                                        BoxDecoration(color: Colors.white),
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
                                      unselectedLabelColor:
                                          const Color(0xffacb3bf),
                                      indicatorColor: AppColors.SecondaryColor,
                                      labelColor: Colors.black,
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      indicatorWeight: 3.0,
                                      indicatorPadding: EdgeInsets.all(0),
                                      isScrollable: false,
                                      controller: tabController,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Expanded(
                                      child: (user != null)
                                          ? (tabIndex == 0)
                                              ? StreamBuilder<QuerySnapshot>(
                                                  stream: firestore
                                                      .collection('chats')
                                                      .where('members',
                                                          arrayContains:
                                                              user['id'])
                                                      .snapshots(),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                        color: AppColors
                                                            .PrimaryColor,
                                                      ));
                                                    }

                                                    List<Map<String, dynamic>>
                                                        docs = [];

                                                    for (int i = 0;
                                                        i <
                                                            snapshot.data.docs
                                                                .length;
                                                        i++) {
                                                      docs.add(snapshot
                                                          .data.docs[i]
                                                          .data());
                                                      docs[i]['id'] = snapshot
                                                          .data.docs[i].id;
                                                      Map<String, dynamic>
                                                          _doc = snapshot
                                                              .data.docs[i]
                                                              .data();
                                                      if (_doc['created'] !=
                                                          null) {
                                                        docs[i]['_created'] =
                                                            DateTime.parse(_doc[
                                                                        'created']
                                                                    .toDate()
                                                                    .toString())
                                                                .toLocal();
                                                      } else {
                                                        docs[i]['_created'] =
                                                            DateTime.now()
                                                                .toLocal();
                                                      }
                                                    }

                                                    docs.sort((a, b) =>
                                                        (a['_created'])
                                                            .compareTo(
                                                                b['_created']));

                                                    getUserListData(docs);
                                                    getMerchantListData(docs);

                                                    return snapshot.data.docs
                                                            .isNotEmpty
                                                        ? ListView.builder(
                                                            controller:
                                                                scrollController,
                                                                
                                                            itemCount:
                                                                docs.length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              return GestureDetector(
                                                                  child: merchants
                                                                          .isNotEmpty 
                                                                      ? merchants[index] !=
                                                                              null
                                                                          ? Column(children: [Container(
                                                                              padding: EdgeInsets.only(left:10, right: 10, top:5, bottom: 5),
                                                                              decoration: BoxDecoration(color: Colors.white),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      Container(
                                                                                          height: 50,
                                                                                          width: 50,
                                                                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(55)),
                                                                                          child: ClipRRect(
                                                                                              borderRadius: BorderRadius.circular(50),
                                                                                              child: CachedNetworkImage(
                                                                                                imageUrl: merchants[index].data() != null ? merchants[index].data()['picture'] : users[index].data()['picture'],
                                                                                                imageBuilder: (context, imageProvider) => Container(
                                                                                                  decoration: BoxDecoration(
                                                                                                      image: DecorationImage(
                                                                                                    image: imageProvider,
                                                                                                    fit: BoxFit.cover,
                                                                                                  )),
                                                                                                ),
                                                                                              ))),
                                                                                      SizedBox(width: 15),
                                                                                      Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text(merchants[index].data() != null ? merchants[index].data()['name'] : users[index].data()['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                                                                          SizedBox(height: 5),
                                                                                          Row(
                                                                                            children: [
                                                                                              if (docs[index]['updatedBy'] == user['id']) docs[index]['messageUnread'] != 0 ? Container(margin: EdgeInsets.only(right: 5), child: Icon(CupertinoIcons.check_mark, color: Colors.grey[400], size: 18)) : Container(margin: EdgeInsets.only(right: 5), child: Icon(CupertinoIcons.check_mark, color: Colors.blue, size: 18)),
                                                                                              docs[index]['image'] != null
                                                                                                  ? Row(
                                                                                                      children: [
                                                                                                        Icon(CupertinoIcons.photo_fill, size: 18, color: Colors.grey),
                                                                                                        SizedBox(width: 10),
                                                                                                        Text('Image')
                                                                                                      ],
                                                                                                    )
                                                                                                  : Text(docs[index]['text'].length > 30 ? docs[index]['text'].toString().substring(0, 26)+"...": docs[index]['text'])
                                                                                            ],
                                                                                          )
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                                    children: [
                                                                                      (docs[index]['messageUnread'] > 0 && docs[index]['updatedBy'] != user['id']) ? Container(height: 25, width: 25, padding: EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.PrimaryColor, borderRadius: BorderRadius.circular(40)), child: Text(docs[index]['messageUnread'].toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white))) : Text(''),
                                                                                      SizedBox(height: 10),
                                                                                      Text(TimeAgo.timeAgoSinceDate(docs[index]['created'].toDate().toString()), style: TextStyle(color: Colors.grey))
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              )), SizedBox(height: 10),Container(height: 1, width: size.width, color: Colors.grey)],)
                                                                          : Container()
                                                                      : Container(),
                                                                  onTap: () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pushNamed(
                                                                            '/chat',
                                                                            arguments: {
                                                                              'role': 'user',
                                                                          'chatroomId':
                                                                              docs[index]['id'],
                                                                        });
                                                                  });
                                                            })
                                                        : Container(
                                                            width:
                                                                size.width,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                    CupertinoIcons
                                                                        .exclamationmark_circle,
                                                                    size: 80),
                                                                SizedBox(
                                                                    height: 30),
                                                                Text(
                                                                    'Tidak ada obrolan')
                                                              ],
                                                            ),
                                                          );
                                                  })
                                              : user['merchant'] != null ? StreamBuilder<QuerySnapshot>(
                                                  stream: firestore
                                                      .collection('chats')
                                                      .where('members',
                                                          arrayContains:
                                                              user['merchant']['id'])
                                                      .snapshots(),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                        color: AppColors
                                                            .PrimaryColor,
                                                      ));
                                                    }

                                                    List<Map<String, dynamic>>
                                                        docs = [];

                                                    for (int i = 0;
                                                        i <
                                                            snapshot.data.docs
                                                                .length;
                                                        i++) {
                                                      docs.add(snapshot
                                                          .data.docs[i]
                                                          .data());
                                                      docs[i]['id'] = snapshot
                                                          .data.docs[i].id;
                                                      Map<String, dynamic>
                                                          _doc = snapshot
                                                              .data.docs[i]
                                                              .data();
                                                      if (_doc['created'] !=
                                                          null) {
                                                        docs[i]['_created'] =
                                                            DateTime.parse(_doc[
                                                                        'created']
                                                                    .toDate()
                                                                    .toString())
                                                                .toLocal();
                                                      } else {
                                                        docs[i]['_created'] =
                                                            DateTime.now()
                                                                .toLocal();
                                                      }
                                                    }

                                                    docs.sort((a, b) =>
                                                        (a['_created'])
                                                            .compareTo(
                                                                b['_created']));
                                                                
                                                    getUserListData(docs);
                                                    getMerchantListData(docs);

                                                    return snapshot.data.docs
                                                            .isNotEmpty
                                                        ? ListView.builder(
                                                            controller:
                                                                scrollController,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            itemCount:
                                                                docs.length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              return GestureDetector(
                                                                  child: users
                                                                          .isNotEmpty
                                                                      ? users[index] !=
                                                                              null
                                                                          ? Column(children: [Container(                                                                              padding: EdgeInsets.only(left:10, right: 10, top:5, bottom: 5),

                                                                              decoration: BoxDecoration(color: Colors.white),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      Container(
                                                                                          height: 50,
                                                                                          width: 50,
                                                                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(55)),
                                                                                          child: ClipRRect(
                                                                                              borderRadius: BorderRadius.circular(50),
                                                                                              child: CachedNetworkImage(
                                                                                                imageUrl: merchants[index].data() != null ? merchants[index].data()['picture'] : users[index].data()['picture'],
                                                                                                imageBuilder: (context, imageProvider) => Container(
                                                                                                  decoration: BoxDecoration(
                                                                                                      image: DecorationImage(
                                                                                                    image: imageProvider,
                                                                                                    fit: BoxFit.cover,
                                                                                                  )),
                                                                                                ),
                                                                                              ))),
                                                                                      SizedBox(width: 15),
                                                                                      Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text(merchants[index].data() != null ? merchants[index].data()['name'] : users[index].data()['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                                                                          SizedBox(height: 5),
                                                                                          Row(
                                                                                          children: [
                                                                                              if (docs[index]['updatedBy'] == user['merchant']['id']) docs[index]['messageUnread'] != 0 ? Container(margin: EdgeInsets.only(right: 5), child: Icon(CupertinoIcons.check_mark, color: Colors.grey[400], size: 18)) : Container(margin: EdgeInsets.only(right: 5), child: Icon(CupertinoIcons.check_mark, color: Colors.blue, size: 18)),
                                                                                              docs[index]['image'] != null
                                                                                                  ? Row(
                                                                                                      children: [
                                                                                                        Icon(CupertinoIcons.photo_fill, size: 18, color: Colors.grey),
                                                                                                        SizedBox(width: 10),
                                                                                                        Text('Image')
                                                                                                      ],
                                                                                                    )
                                                                                                  : Text(docs[index]['text'].length > 30 ? docs[index]['text'].toString().substring(0, 26)+"...": docs[index]['text'])
                                                                                            ],
                                                                                          )
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                                    children: [
                                                                                      (docs[index]['messageUnread'] > 0 && docs[index]['updatedBy'] != user['merchant']['id']) ? Container(height: 25, width: 25, padding: EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.PrimaryColor, borderRadius: BorderRadius.circular(40)), child: Text(docs[index]['messageUnread'].toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white))) : Text(''),
                                                                                      SizedBox(height: 10),
                                                                                      Text(TimeAgo.timeAgoSinceDate(docs[index]['created'].toDate().toString()), style: TextStyle(color: Colors.grey))
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              )), SizedBox(height: 10),Container(height: 1, width: size.width, color: Colors.grey)])
                                                                          : Container()
                                                                      : Container(),
                                                                  onTap: () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pushNamed(
                                                                            '/chat',
                                                                            arguments: {
                                                                              'role': 'merchant',
                                                                          'chatroomId':
                                                                              docs[index]['id'],
                                                                        });
                                                                  });
                                                            })
                                                        : Container(
                                                            width:
                                                                size.width,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                    CupertinoIcons
                                                                        .exclamationmark_circle,
                                                                    size: 80),
                                                                SizedBox(
                                                                    height: 30),
                                                                Text(
                                                                    'Tidak ada obrolan')
                                                              ],
                                                            ),
                                                          );
                                                  }): Container(
                                                            width:
                                                                size.width,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                    CupertinoIcons
                                                                        .exclamationmark_circle,
                                                                    size: 80),
                                                                SizedBox(
                                                                    height: 30),
                                                                Text(
                                                                    'Tidak ada obrolan')
                                                              ],
                                                            ),
                                                          )
                                          : Center(
                                              child: CircularProgressIndicator(
                                              color: AppColors.PrimaryColor,
                                            )))
                                ]))),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
