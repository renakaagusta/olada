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
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:olada/utils/timeago/timeago.dart';
import 'package:olada/constants/assets.dart';
import 'package:olada/constants/colors.dart';
import 'package:olada/constants/strings.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  var picker = ImagePicker();
  dynamic user;
  SharedPreferences prefs;
  ApiService apiService = ApiService();
  File image;
  Size size;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  dynamic merchant;
  dynamic product;
  CarouselController carouselController = new CarouselController();
  List<Widget> productImages = [];
  List<dynamic> productReviews;
  List<dynamic> productLikes = [];
  List<dynamic> usersReview;
  List<dynamic> merchantFollowers;
  int currentPosition = 0;
  TextEditingController commentController = TextEditingController();
  FocusNode commentFocusNode = FocusNode();

  bool _isVertical = false;

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
          .collection('products')
          .doc(arguments['productId'])
          .get()
          .then((document) {
        List<Widget> productImagesLocal = [];
        document.data()['images'].forEach((imageUrl) {
          productImagesLocal.add(CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.fill,
          ));
        });
        firestore
            .collection('products')
            .doc(document.id)
            .update({'view': document.data()['view'] + 1});
        firestore
            .collection('products')
            .doc(document.id)
            .collection('reviews')
            .get()
            .then((snapshot) async {
          usersReview = await Future.wait(snapshot.docs
              .map((doc) async => await getUserData(doc.data()['user'])));
          setState(() {
            productReviews = snapshot.docs;
          });
        });
        firestore
            .collection('products')
            .doc(document.id)
            .collection('likes')
            .get()
            .then((snapshots) {
          setState(() {
            productLikes = snapshots.docs;
          });
        });

        setState(() {
          product = document;
          productImages = productImagesLocal;

          firestore
              .collection('merchants')
              .doc(product.data()['merchant'])
              .get()
              .then((document) {
            setState(() {
              merchant = document;
              firestore
                  .collection('users')
                  .doc(product.data()['user'])
                  .collection('followers')
                  .get()
                  .then((snapshot) {
                setState(() {
                  merchantFollowers = snapshot.docs;
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
      body: Container(
          height: size.height,
          width: size.width,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    (product != null && merchant != null && user != null)
                        ? Container(
                            child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: size.width,
                                    child: CarouselSlider(
                                      items: productImages,
                                      options: CarouselOptions(
                                          height: size.width,
                                          autoPlayInterval:
                                              Duration(milliseconds: 3000),
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              currentPosition = index;
                                            });
                                          }),
                                      carouselController: carouselController,
                                    ),
                                  ),
                                  Positioned(
                                      top: 30,
                                      left: 15,
                                      child: GestureDetector(
                                          child: Icon(
                                              CupertinoIcons.chevron_left,
                                              color: Colors.white),
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          }))
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Container(
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (productImages.length > 1)
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children:
                                                    productImages.map((url) {
                                                  int index = productImages
                                                      .indexOf(url);
                                                  return Container(
                                                    width: 8.0,
                                                    height: 8.0,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10.0,
                                                            horizontal: 2.0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: currentPosition ==
                                                              index
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
                                            Text(product.data()['title'],
                                                style: TextStyle(fontSize: 20)),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                                'Rp ' + product.data()['price'],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: AppColors
                                                        .SecondaryColor)),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                RatingBarIndicator(
                                                  rating: double.parse(product
                                                      .data()['rating']
                                                      .toString()),
                                                  itemBuilder:
                                                      (context, index) => Icon(
                                                    CupertinoIcons.star_fill ??
                                                        CupertinoIcons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  itemCount: 5,
                                                  itemSize: 18.0,
                                                  unratedColor: Colors.amber
                                                      .withAlpha(50),
                                                  direction: _isVertical
                                                      ? Axis.vertical
                                                      : Axis.horizontal,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    double.parse(product
                                                            .data()['rating']
                                                            .toString())
                                                        .toStringAsFixed(2),
                                                    style: TextStyle(
                                                        color: Colors.amber)),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Icon(CupertinoIcons.eye,
                                                    size: 15,
                                                    color: Colors.black87),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  product
                                                      .data()['view']
                                                      .toString(),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Text(
                                                  product
                                                          .data()['orders']
                                                          .toString() +
                                                      ' terjual',
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                (productLikes
                                                            .map((like) => (like
                                                                        .data()[
                                                                    'user'] ==
                                                                user['id']))
                                                            .length >
                                                        0)
                                                    ? GestureDetector(
                                                        onTap: () async {
                                                          await firestore
                                                              .collection(
                                                                  'products')
                                                              .doc(product.id)
                                                              .collection(
                                                                  'likes')
                                                              .doc(productLikes
                                                                  .firstWhere((like) =>
                                                                      like.data()[
                                                                          'user'] ==
                                                                      user[
                                                                          'id'])
                                                                  .id
                                                                  .toString())
                                                              .delete();
                                                          await firestore
                                                              .collection(
                                                                  'products')
                                                              .doc(product.id)
                                                              .update({
                                                            'likes': product
                                                                        .data()[
                                                                    'likes'] -
                                                                1
                                                          });
                                                          await firestore
                                                              .collection(
                                                                  'likes')
                                                              .where('user',
                                                                  isEqualTo:
                                                                      user[
                                                                          'id'])
                                                              .where('product',
                                                                  isEqualTo:
                                                                      product
                                                                          .id)
                                                              .get()
                                                              .then((snapshot) {
                                                            firestore
                                                                .collection(
                                                                    'likes')
                                                                .doc(snapshot
                                                                    .docs[0].id)
                                                                .delete();
                                                          });
                                                          await firestore
                                                              .collection(
                                                                  'likes')
                                                              .add({
                                                            'user': user['id'],
                                                            'product':
                                                                product.id,
                                                            'type': 'product',
                                                            'created': FieldValue
                                                                .serverTimestamp()
                                                          });
                                                          getData();
                                                        },
                                                        child: Icon(
                                                            CupertinoIcons
                                                                .heart_fill,
                                                            size: 20,
                                                            color: Colors.red),
                                                      )
                                                    : GestureDetector(
                                                        onTap: () async {
                                                          await firestore
                                                              .collection(
                                                                  'products')
                                                              .doc(product.id)
                                                              .collection(
                                                                  'likes')
                                                              .add({
                                                            'user': user['id'],
                                                            'created': FieldValue
                                                                .serverTimestamp()
                                                          });
                                                          await firestore
                                                              .collection(
                                                                  'products')
                                                              .doc(product.id)
                                                              .update({
                                                            'likes': product
                                                                        .data()[
                                                                    'likes'] +
                                                                1
                                                          });
                                                          await firestore
                                                              .collection(
                                                                  'likes')
                                                              .add({
                                                            'user': user['id'],
                                                            'product':
                                                                product.id,
                                                            'created': FieldValue
                                                                .serverTimestamp()
                                                          });
                                                          getData();
                                                        },
                                                        child: Icon(
                                                            CupertinoIcons
                                                                .heart,
                                                            size: 20,
                                                            color:
                                                                Colors.black),
                                                      ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        )),
                                    Container(
                                        height: 5,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200])),
                                    Container(
                                        height: 100,
                                        padding: EdgeInsets.only(
                                            top: 20,
                                            bottom: 20,
                                            left: 20,
                                            right: 20),
                                        child: Row(
                                          children: [
                                            Container(
                                                height: 50,
                                                width: 50,
                                                child: CachedNetworkImage(
                                                  imageUrl: merchant['picture'],
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.fill,
                                                    )),
                                                  ),
                                                )),
                                            SizedBox(width: 25),
                                            GestureDetector(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        merchant.data()['name'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(height: 10),
                                                    Text(merchant
                                                            .data()['location']
                                                        ['subAdminArea']),
                                                  ],
                                                ),
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pushNamed('/merchant',
                                                          arguments: {
                                                        'merchantId': product
                                                            .data()['merchant']
                                                      });
                                                })
                                          ],
                                        )),
                                    Container(
                                        height: 5,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200])),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.data()['description'],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              TimeAgo.timeAgoSinceDate(product
                                                  .data()['created']
                                                  .toDate()
                                                  .toString()),
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                        height: 5,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200])),
                                    Container(
                                        padding: EdgeInsets.only(
                                          
                                            bottom: 20,
                                            left: 20,
                                            right: 20),
                                        child: Column(
                                          children: [
                                            (productReviews != null &&
                                                    usersReview != null)
                                                ? (productReviews.length > 0)
                                                    ? Container(
                                                        height: 150,
                                                        child: ListView.builder(
                                                            itemCount:
                                                                productReviews
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return new Column(
                                                                children: [
                                                                  Container(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              20,
                                                                          right:
                                                                              20),
                                                                      margin: EdgeInsets.only(
                                                                        
                                                                          bottom:
                                                                              20),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Container(
                                                                            height:
                                                                                30,
                                                                            width:
                                                                                40,
                                                                            child: GestureDetector(
                                                                                onTap: () {
                                                                                  Navigator.of(context).pushNamed('/user', arguments: {
                                                                                    'userId': productReviews[index].data()['user']
                                                                                  });
                                                                                },
                                                                                child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(20),
                                                                                    child: CachedNetworkImage(
                                                                                      imageUrl: usersReview[index]['picture'],
                                                                                      imageBuilder: (context, imageProvider) => Container(
                                                                                        decoration: BoxDecoration(
                                                                                            image: DecorationImage(
                                                                                          image: imageProvider,
                                                                                          fit: BoxFit.fill,
                                                                                        )),
                                                                                      ),
                                                                                    ))),
                                                                          ),
                                                                          SizedBox(
                                                                              width: 15),
                                                                          Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  GestureDetector(
                                                                                    onTap: () {
                                                                                      
                                                                                      
                                                                                    },
                                                                                    child: Text(
                                                                                      usersReview[index]['name'] + ' ',
                                                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                  ),       
                                                                                ],
                                                                              ),
                                                                              SizedBox(height: 5),
                                                                              RatingBarIndicator(
                                                                                rating: double.parse(productReviews[index].data()['rating'].toString()),
                                                                                itemBuilder: (context, index) => Icon(
                                                                                  CupertinoIcons.star_fill ?? CupertinoIcons.star,
                                                                                  color: Colors.amber,
                                                                                ),
                                                                                itemCount: 5,
                                                                                itemSize: 12.0,
                                                                                unratedColor: Colors.amber.withAlpha(50),
                                                                                direction: _isVertical ? Axis.vertical : Axis.horizontal,
                                                                              ),
                                                                              SizedBox(height: 5),
                                                                              Text(productReviews[index].data()['text'], style: TextStyle()),
                                                                              SizedBox(height: 5),Text(TimeAgo.timeAgoSinceDate(usersReview[index]['created'].toDate().toString()), style: TextStyle(color: Colors.grey, fontSize: 12))
                                                                           
                                                                            ],
                                                                          )
                                                                        ],
                                                                      )),
                                                                  Container(
                                                                      height: 1,
                                                                      width: size
                                                                          .width,
                                                                      color: Colors
                                                                              .grey[
                                                                          300]),
                                                                ],
                                                              );
                                                            }))
                                                    : Container(
                                                        width: size.width - 40,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                                height: 40),
                                                            Icon(
                                                                CupertinoIcons
                                                                    .exclamationmark_circle,
                                                                size: 40),
                                                            SizedBox(
                                                                height: 30),
                                                            Text(
                                                                'Belum ada review untuk produk ini')
                                                          ],
                                                        ),
                                                      )
                                                : Container(
                                                    height: size.height - 200,
                                                    child: Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: AppColors
                                                            .PrimaryColor,
                                                      ),
                                                    )),
                                          ],
                                        ))
                                  ])),
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
                    height: 60,
                    width: size.width,
                    padding: EdgeInsets.only(),
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: Color(0xffdddddd).withOpacity(0.5),
                          spreadRadius: 3,
                          offset: Offset(1, 2),
                          blurRadius: 0.5)
                    ]),
                    child: Row(children: [
                      GestureDetector(
                          child: Container(
                            width: size.width * 0.15,
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Icon(CupertinoIcons.chat_bubble_text,
                                color: AppColors.PrimaryColor),
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed('/chat',
                                arguments: {
                                  'merchantId': merchant.id,
                                  'productId': product.id,
                                  'role': 'user'
                                });
                          }),
                      Container(height: 50, width: 1, color: Colors.grey),
                      GestureDetector(
                          child: Container(
                            width: size.width * 0.15,
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Icon(CupertinoIcons.shopping_cart,
                                color: AppColors.PrimaryColor),
                          ),
                          onTap: () async {
                            EasyLoading.show();
                            await firestore.collection('baskets').add({
                              'user': user['id'],
                              'merchant': merchant.id,
                              'product': product.id,
                              'created': FieldValue.serverTimestamp()
                            }).then((result) async {
                              EasyLoading.showSuccess(
                                  'Item ditambahkan ke keranjang',
                                  duration: Duration(seconds: 1));
                            });
                          }),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/checkout',
                              arguments: {'productId': product.id});
                        },
                        child: Container(
                          width: size.width * 0.7 - 1,
                          height: 70,
                          decoration:
                              BoxDecoration(color: AppColors.PrimaryColor),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Beli sekarang',
                                  style: TextStyle(color: Colors.white))
                            ],
                          ),
                        ),
                      )
                    ]),
                  ))
            ],
          )),
    );
  }
}
