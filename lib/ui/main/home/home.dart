import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:olada/api/api_service.dart';
import 'package:olada/model/order.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:olada/utils/timeago/timeago.dart';
import 'package:olada/constants/assets.dart';
import 'package:olada/constants/colors.dart';
import 'package:olada/constants/strings.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  ApiService apiService = ApiService();

  List<dynamic> merchants = [];
  List<dynamic> _products = [];
  List<dynamic> products = [];
  List<dynamic> filteredProducts = [];
  List<dynamic> users = [];
  List<dynamic> likes = [];
  List<dynamic> categories;
  CarouselController carouselController = new CarouselController();
  List<Widget> promoList;
  int currentPosition = 0;

  List<dynamic> notifications = [];
  List<dynamic> chats = [];

  int status = 0;
  dynamic user;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Size size;
  bool loading = true;

  void search(String value) {
    List<Order> result = [];
    for (int i = 0; i < _products.length; i++) {
      print(_products.toString());
      if (_products[i].subservice.toLowerCase().contains(value.toLowerCase())) {
        result.add(_products[i]);
      }
    }
    setState(() {
      products = result;
    });
  }

  Future<dynamic> getMerchantData(String id) async {
    return firestore.collection('merchants').doc(id).get();
  }

  Future<dynamic> getUserData(String id) async {
    return firestore.collection('users').doc(id).get();
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user = jsonDecode(prefs.getString('user'));
      promoList = [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/search');
          },
          child: Container(
              padding: EdgeInsets.zero,
              child: Image.asset('assets/images/banner.png'),
              margin: EdgeInsets.only(right: 20)),
        ),
        GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/search');
            },
            child: Container(
                padding: EdgeInsets.zero,
                child: Image.asset('assets/images/banner.png'),
                margin: EdgeInsets.only(right: 20))),
        GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/search');
            },
            child: Container(
                padding: EdgeInsets.zero,
                child: Image.asset('assets/images/banner.png'),
                margin: EdgeInsets.only(right: 20))),
      ];
      firestore.collection('categories').get().then((snapshot) async {
        setState(() {
          loading = false;
          categories = snapshot.docs;
        });
      });
      firestore.collection('products').get().then((snapshot) async {
        
        merchants = await Future.wait(
            snapshot.docs.map((doc) async => await getMerchantData(doc.data()['merchant'])));
        setState(() {
          loading = false;
          products = snapshot.docs;
        });
      });
      firestore
          .collection('notifications')
          .where('to', isEqualTo: user['id'])
          .where('read', isNull: true)
          .get()
          .then((snapshot) async {
        setState(() {
          notifications = notifications + snapshot.docs;
        });
      });
      firestore
          .collection('notifications')
          .where('to',
              isEqualTo: user['merchant'] != null ? user['merchant']['id'] : '')
          .where('read', isNull: true)
          .get()
          .then((snapshot) async {
        setState(() {
          notifications = notifications + snapshot.docs;
        });
      });
      firestore
          .collection('chats')
          .where('members', arrayContains: user['id'])
          .where('updatedBy', isNotEqualTo: user['id'])
          .where('type', isEqualTo: 'personal')
          .where('read', isNull: true)
          .get()
          .then((snapshot) {
        setState(() {
          chats = chats + snapshot.docs;
        });
      });
      firestore
          .collection('chats')
          .where('members',
              arrayContains:
                  user['merchant'] != null ? user['merchant']['id'] : '')
          .where('updatedBy',
              isNotEqualTo:
                  user['merchant'] != null ? user['merchant']['id'] : '')
          .where('type', isEqualTo: 'personal')
          .where('read', isNull: true)
          .get()
          .then((snapshot) {
        setState(() {
          chats = chats + snapshot.docs;
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
    return SingleChildScrollView(
        child: Container(
            height: size.height + 300,
            width: size.width,
            child: Stack(
              children: [
                Positioned(
                  top: -size.height * 1.2,
                  left: -size.width * 0.225,
                  child: Container(
                    height: size.height * 1.6,
                    width: size.width * 1.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        AppColors.PrimaryColor,
                        AppColors.SecondaryColor
                      ]),
                      borderRadius: BorderRadius.circular(size.width * 0.5),
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(top: 40, bottom: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              user != null
                                  ? GestureDetector(
                                      child: Container(
                                        width: size.width * 0.6,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: TextField(
                                          enabled: false,
                                          style: TextStyle(fontSize: 13),
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                                CupertinoIcons.search,
                                                size: 18),
                                            hintText: "Hi, " + user['name'],
                                            contentPadding: EdgeInsets.only(
                                                top: 0,
                                                bottom: 0,
                                                left: 10,
                                                right: 10),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed('/search');
                                      })
                                  : Container(),
                              GestureDetector(
                                  child: Container(
                                      child: Stack(
                                    children: [
                                      Icon(CupertinoIcons.bell,
                                          color: Colors.white),
                                      if (notifications.length > 0)
                                        Positioned(
                                            right: 0,
                                            child: Icon(
                                                CupertinoIcons.circle_fill,
                                                color: Colors.red,
                                                size: 14))
                                    ],
                                  )),
                                  onTap: () { 
                                    notifications.forEach((notification) {

                                      firestore
                                          .collection('notifications')
                                          .doc(notification.id)
                                          .update({
                                        'read': FieldValue.serverTimestamp()
                                      });
                                    });
                                    
                                    setState(() {
                                        notifications = [];
                                      });
                                    Navigator.of(context)
                                        .pushNamed('/notifications');
                                  }),
                              GestureDetector(
                                  child: Container(
                                      child: Stack(
                                    children: [
                                      Icon(CupertinoIcons.envelope,
                                          color: Colors.white),
                                      if (chats.length > 0)
                                        Positioned(
                                            right: 0,
                                            child: Icon(
                                                CupertinoIcons.circle_fill,
                                                color: Colors.red,
                                                size: 14)),
                                    ],
                                  )),
                                  onTap: () {
                                    Navigator.of(context).pushNamed('/chats');
                                  }),
                              GestureDetector(
                                  child: Container(
                                      child: Stack(
                                    children: [
                                      Icon(CupertinoIcons.heart,
                                          color: Colors.white)
                                    ],
                                  )),
                                  onTap: () {
                                    Navigator.of(context).pushNamed('/likes');
                                  })
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                Icon(CupertinoIcons.location,
                                    color: Colors.white, size: 14),
                                SizedBox(width: 10),
                                Text.rich(
                                    TextSpan(
                                        text: 'Dikirim ke ',
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: 'Surabaya',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                    style: TextStyle(color: Colors.white)),
                                SizedBox(width: 10),
                                Icon(CupertinoIcons.chevron_down,
                                    color: Colors.white, size: 14),
                              ],
                            )),
                        promoList != null
                            ? Container(
                                transform:
                                    Matrix4.translationValues(0.0, -10.0, 0.0),
                                child: CarouselSlider(
                                  items: promoList,
                                  options: CarouselOptions(
                                      autoPlay: promoList.length > 1,
                                      autoPlayInterval:
                                          Duration(milliseconds: 3000),
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          currentPosition = index;
                                        });
                                      }),
                                  carouselController: carouselController,
                                ),
                              )
                            : Container(),
                        promoList != null
                            ? Container(
                                transform:
                                    Matrix4.translationValues(0.0, -20.0, 0.0),
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: promoList.map((url) {
                                    int index = promoList.indexOf(url);
                                    return Container(
                                      width: 8.0,
                                      height: 8.0,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 2.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: currentPosition == index
                                            ? AppColors.PrimaryColor
                                            : Color.fromRGBO(0, 0, 0, 0.4),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )
                            : Container(),
                        RefreshIndicator(
                          color: AppColors.PrimaryColor,
                          onRefresh: getData,
                          child: Column(
                            children: [],
                          ),
                        ),
                        Container(
                          width: size.width,
                          padding: EdgeInsets.only(left: 20, right: 10),
                          child:
                              Text('Kategori', style: TextStyle(fontSize: 20)),
                        ),
                        SizedBox(height: 20),
                        categories != null
                            ? Container(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    for (int i = 0; i < categories.length; i++)
                                      GestureDetector(
                                          child: Container(
                                              child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                Container(
                                                  height: 48,
                                                  width: 48,
                                                  alignment:
                                                      Alignment.topCenter,
                                                  padding: EdgeInsets.only(
                                                      top: 10,
                                                      bottom: 10,
                                                      left: 10,
                                                      right: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: Color(0x66E7D66F)),
                                                  child: CachedNetworkImage(
                                                    imageUrl: categories[i]
                                                        .data()['image'],
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      decoration: BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.fitHeight,
                                                      )),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                    categories[i]
                                                        .data()['title']
                                                        .toString()
                                                        .replaceAll(' ', '\n'),
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center)
                                              ])),
                                          onTap: () {
                                            Navigator.of(context)
                                                .pushNamed('/list', arguments: {
                                              'category':
                                                  categories[i].data()['title']
                                            });
                                          })
                                  ],
                                ))
                            : Container(),
                        Container(
                          width: size.width,
                          padding:
                              EdgeInsets.only(left: 20, top: 20, right: 10),
                          child: Text('Produk terbaru',
                              style: TextStyle(fontSize: 20)),
                        ),
                        SizedBox(height: 10),
                        (!loading)
                            ? (products.length > 0)
                                ? Expanded(
                                    child: StaggeredGridView.countBuilder(
                                      crossAxisCount: 4,
                                      itemCount: products.length,
                                      padding: EdgeInsets.zero,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (BuildContext context,
                                              int index) =>
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                    '/product',
                                                    arguments: {
                                                      'productId':
                                                          products[index].id,
                                                    });
                                              },
                                              child: new Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        width: 1,
                                                        color: Colors.grey[300],
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  padding: EdgeInsets.only(
                                                      top: 10,
                                                      bottom: 10,
                                                      left: 10,
                                                      right: 10),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: 100,
                                                        width: 100,
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              products[index]
                                                                      .data()[
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
                                                        ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(height: 5),
                                                          Text(
                                                              products[index]['title'].substring(
                                                                  0,
                                                                  products[index]['title']
                                                                              .length >=
                                                                          30
                                                                      ? products[index]
                                                                              [
                                                                              'title']
                                                                          .substring(
                                                                              0,
                                                                              30)
                                                                      : products[index]
                                                                              [
                                                                              'title']
                                                                          .length),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12)),
                                                          SizedBox(height: 5),
                                                          Text(
                                                              'Rp ' +
                                                                  products[
                                                                          index]
                                                                      ['price'],
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          SizedBox(height: 5),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                height: 20,
                                                                width: 20,
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl:
                                                                        merchants[index].data()['picture'],
                                                                    imageBuilder:
                                                                        (context,
                                                                                imageProvider) =>
                                                                            Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                              image: DecorationImage(
                                                                        image:
                                                                            imageProvider,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      )),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                  products[index]
                                                                          [
                                                                          'location']
                                                                      [
                                                                      'subAdminArea'],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12)),
                                                            ],
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ))),
                                      staggeredTileBuilder: (int index) =>
                                          new StaggeredTile.fit(2),
                                      mainAxisSpacing: 8.0,
                                      crossAxisSpacing: 8.0,
                                    ),
                                  )
                                : Container(
                                    width: size.width,
                                    padding: EdgeInsets.only(top: 100),
                                    child: Column(
                                      children: [
                                        Icon(CupertinoIcons.info_circle,
                                            size: 40),
                                        SizedBox(height: 30),
                                        Text('Product not found',
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
                    ))
              ],
            )));
  }
}
