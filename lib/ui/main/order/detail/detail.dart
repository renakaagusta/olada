import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olada/utils/timeago/timeago.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:olada/utils/date/date.dart';
import 'package:olada/constants/colors.dart';

class OrderDetailScreen extends StatefulWidget {
  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen>
    with SingleTickerProviderStateMixin {
  var picker = ImagePicker();
  TextEditingController reviewController = TextEditingController();
  dynamic user;
  dynamic order;
  dynamic customer;
  dynamic merchant;
  dynamic product;
  String role;
  String status;
  SharedPreferences prefs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  File image;
  Size size;

  dynamic ratingController;
  double rating;

  int ratingBarMode = 1;
  double initialRating = 2.0;
  bool isRTLMode = false;
  bool isVertical = false;

  Future<dynamic> getProductData(String id) async {
    return firestore.collection('products').doc(id).get();
  }

  Future<dynamic> getMerchantData(String id) async {
    return firestore.collection('merchants').doc(id).get();
  }

  Future<void> getData() async {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    prefs = await SharedPreferences.getInstance();
    dynamic orderQuery =
        await firestore.collection('orders').doc(arguments['orderId']).get();
    dynamic productQuery = await firestore
        .collection('products')
        .doc(arguments['productId'])
        .get();
    dynamic customerQuery =
        await firestore.collection('users').doc(arguments['customerId']).get();
    dynamic merchantQuery = await firestore
        .collection('merchants')
        .doc(arguments['merchantId'])
        .get();

    setState(() {
      user = jsonDecode(prefs.getString('user'));
      role = arguments['role'];
      order = orderQuery;
      product = productQuery;
      customer = customerQuery;
      merchant = merchantQuery;
    });
  }

  @override
  void initState() {
    super.initState();

    ratingController = TextEditingController(text: '3.0');
    rating = 0;
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
          title: Text('Detail Pesanan',
              style: TextStyle(
                color: Colors.black,
              )),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black)),
      body: (user != null)
          ? Container(
              height: size.height,
              width: size.width,
              child: (order != null &&
                      product != null &&
                      merchant != null &&
                      customer != null)
                  ? SingleChildScrollView(
                      child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Container(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 15),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Status",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                          if (order.data()['pay'] == '')
                                            Container(
                                                height: 40,
                                                padding: EdgeInsets.only(
                                                    top: 10,
                                                    bottom: 10,
                                                    left: 10,
                                                    right: 10),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Text(
                                                    'Menunggu pembayaran',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .PrimaryColor,
                                                        fontSize: 14))),
                                          if (order.data()['pay'] != '' &&
                                              order.data()['delivered'] == '')
                                            Container(
                                                height: 40,
                                                padding: EdgeInsets.only(
                                                    top: 10,
                                                    bottom: 10,
                                                    left: 10,
                                                    right: 10),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Text('Dikemas',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .PrimaryColor,
                                                        fontSize: 14))),
                                          if (order.data()['pay'] != '' &&
                                              order.data()['delivered'] != '' &&
                                              order.data()['finished'] == '')
                                            Container(
                                                height: 40,
                                                padding: EdgeInsets.only(
                                                    top: 10,
                                                    bottom: 10,
                                                    left: 10,
                                                    right: 10),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Text('Dikirim',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .PrimaryColor,
                                                        fontSize: 14))),
                                          if (order.data()['finished'] != '')
                                            Container(
                                                height: 40,
                                                padding: EdgeInsets.only(
                                                    top: 10,
                                                    bottom: 10,
                                                    left: 10,
                                                    right: 10),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Text('Selesai',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .PrimaryColor,
                                                        fontSize: 14))),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      Container(
                                          height: 0.5,
                                          width: size.width,
                                          color: Colors.grey[300]),
                                      SizedBox(height: 15),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(CupertinoIcons.calendar,
                                                  color: Colors.grey, size: 20),
                                              SizedBox(width: 10),
                                              Text('Tanggal pemesanan',
                                                  style: TextStyle(
                                                      color: Colors.grey[700],
                                                      fontSize: 14))
                                            ],
                                          ),
                                          Text(new DateUtil().getFormattedDate(
                                              DateTime.parse(order
                                                  .data()['created']
                                                  .toDate()
                                                  .toString())))
                                        ],
                                      ),
                                    ],
                                  )),
                              SizedBox(height: 20),
                              Container(
                                  height: 5,
                                  decoration:
                                      BoxDecoration(color: Colors.grey[200])),
                              Container(
                                  padding:
                                      EdgeInsets.only(left: 100, right: 20),
                                  decoration:
                                      BoxDecoration(color: Colors.grey[200])),
                              SizedBox(height: 20),
                              Container(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Text(
                                  "Pembeli",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                  height: 80,
                                  padding: EdgeInsets.only(
                                      top: 10, left: 20, right: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                          height: 50,
                                          width: 50,
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                customer.data()['picture'],
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
                                      SizedBox(width: 25),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(customer.data()['name'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(height: 10),
                                        ],
                                      )
                                    ],
                                  )),
                              SizedBox(height: 20),
                              Container(
                                  height: 5,
                                  decoration:
                                      BoxDecoration(color: Colors.grey[200])),
                              Container(
                                  padding:
                                      EdgeInsets.only(left: 100, right: 20),
                                  decoration:
                                      BoxDecoration(color: Colors.grey[200])),
                              SizedBox(height: 20),
                              Container(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Text(
                                  "Toko",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                  height: 100,
                                  padding: EdgeInsets.only(
                                      top: 10, bottom: 20, left: 20, right: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                          height: 50,
                                          width: 50,
                                          child: CachedNetworkImage(
                                            imageUrl: merchant['picture'],
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
                                      SizedBox(width: 25),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(merchant.data()['name'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(height: 10),
                                          Text(merchant.data()['location']
                                              ['subAdminArea']),
                                        ],
                                      )
                                    ],
                                  )),
                              Container(
                                  height: 5,
                                  decoration:
                                      BoxDecoration(color: Colors.grey[200])),
                              SizedBox(height: 20),
                              Container(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 15),
                                      Text("Produk yang dibeli",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Container(
                                              height: 50,
                                              width: 50,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    product.data()['images'][0],
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
                                              Text(product.data()['title'],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.grey[800])),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  'Rp ' +
                                                      product.data()['price'] +
                                                      ' x ' +
                                                      order
                                                          .data()['items'][0]
                                                              ['quantity']
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      Container(
                                          height: 0.5,
                                          width: size.width,
                                          color: Colors.grey[300]),
                                      SizedBox(height: 15),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(CupertinoIcons.money_dollar,
                                                  color: Colors.grey, size: 20),
                                              SizedBox(width: 10),
                                              Text('Total harga',
                                                  style: TextStyle(
                                                      color: Colors.grey[700],
                                                      fontSize: 14))
                                            ],
                                          ),
                                          Text(
                                              "Rp " +
                                                  order
                                                      .data()['totalPrice']
                                                      .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                    ],
                                  )),
                              SizedBox(height: 20),
                              Container(
                                  height: 5,
                                  decoration:
                                      BoxDecoration(color: Colors.grey[200])),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10),
                                        Text(
                                          "Pembayaran",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 15.0),
                                        Row(
                                          children: [
                                            Icon(CupertinoIcons.calendar,
                                                color: Colors.grey, size: 20),
                                            SizedBox(width: 10),
                                            Text('Pembayaran dikonfirmasi'),
                                          ],
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(order.data()['pay'] != ''
                                            ? DateUtil().getFormattedDate(
                                                DateTime.parse(order
                                                    .data()['pay']
                                                    .toDate()
                                                    .toString()))
                                            : '-'),
                                      ])),
                              SizedBox(height: 20),
                              Container(
                                  height: 5,
                                  decoration:
                                      BoxDecoration(color: Colors.grey[200])),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10),
                                        Text(
                                          "Pengiriman",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 15.0),
                                        Row(
                                          children: [
                                            Icon(CupertinoIcons.location,
                                                color: Colors.grey, size: 20),
                                            SizedBox(width: 10),
                                            Text('Alamat'),
                                          ],
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(order.data()['location']
                                            ['address']),
                                        SizedBox(height: 10.0),
                                        Row(
                                          children: [
                                            Icon(CupertinoIcons.calendar,
                                                color: Colors.grey, size: 20),
                                            SizedBox(width: 10),
                                            Text('Tanggal pengiriman'),
                                          ],
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(order.data()['delivered'] != ''
                                            ? DateUtil().getFormattedDate(
                                                DateTime.parse(order
                                                    .data()['delivered']
                                                    .toDate()
                                                    .toString()))
                                            : '-'),
                                        SizedBox(height: 10.0),
                                        Row(
                                          children: [
                                            Icon(CupertinoIcons.calendar,
                                                color: Colors.grey, size: 20),
                                            SizedBox(width: 10),
                                            Text('Tanggal sampai'),
                                          ],
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(order.data()['finished'] != ''
                                            ? DateUtil().getFormattedDate(
                                                DateTime.parse(order
                                                    .data()['finished']
                                                    .toDate()
                                                    .toString()))
                                            : '-'),
                                      ])),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                  height: 5,
                                  decoration:
                                      BoxDecoration(color: Colors.grey[200])),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10),
                                        Text(
                                          "Review",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 15.0),
                                        if (order.data()['review'] != null)
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              RatingBarIndicator(
                                                rating: double.parse(order
                                                    .data()['rating']
                                                    .toString()),
                                                itemBuilder: (context, index) =>
                                                    Icon(
                                                  CupertinoIcons.star_fill ??
                                                      CupertinoIcons.star,
                                                  color: Colors.amber,
                                                ),
                                                itemCount: 5,
                                                itemSize: 18.0,
                                                unratedColor:
                                                    Colors.amber.withAlpha(50),
                                                direction: isVertical
                                                    ? Axis.vertical
                                                    : Axis.horizontal,
                                              ),
                                              SizedBox(height: 10),
                                              Text(order.data()['review'], style: TextStyle(fontSize: 16)),
                                              SizedBox(height: 10),
                                              Text(TimeAgo.timeAgoSinceDate(order.data()['reviewed'].toDate().toString()), style: TextStyle(fontSize: 12, color: Colors.grey)),
                                              SizedBox(height: 20)
                                            ],
                                          ),
                                        if (order.data()['review'] == null)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Rating'),
                                              SizedBox(height: 10),
                                              RatingBar.builder(
                                                initialRating: 3,
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                onRatingUpdate: (newRating) {
                                                  setState(() {
                                                    rating = newRating;
                                                  });
                                                },
                                              ),
                                              SizedBox(height: 10),
                                              Text('Review'),
                                              SizedBox(height: 10),
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.grey)),
                                                child: TextField(
                                                  controller: reviewController,
                                                  textCapitalization:
                                                      TextCapitalization
                                                          .sentences,
                                                  maxLines: 5,
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                    hintText:
                                                        "Tell your review here",
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  EasyLoading.show();
                                                  await firestore
                                                      .collection('orders')
                                                      .doc(order.id)
                                                      .update({
                                                    'rating': rating,
                                                    'review':
                                                        reviewController.text,
                                                        'reviewed': FieldValue.serverTimestamp()
                                                  });
                                                  await firestore
                                                      .collection('products')
                                                      .doc(product.id)
                                                      .collection('reviews')
                                                      .add({
                                                    'user': customer.id,
                                                    'order': order.id,
                                                    'rating': rating,
                                                    'text':
                                                        reviewController.text,
                                                    'created': FieldValue
                                                        .serverTimestamp()
                                                  });
                                                  await firestore
                                                      .collection('products')
                                                      .doc(product.id)
                                                      .update({
                                                    'orders': product
                                                            .data()['orders'] +
                                                        1,
                                                    'rating': (product.data()[
                                                                    'orders'] *
                                                                product.data()[
                                                                    'rating'] +
                                                            rating) /
                                                        (product.data()[
                                                                'orders'] +
                                                            1)
                                                  });
                                                  await firestore
                                                      .collection('merchants')
                                                      .doc(merchant.id)
                                                      .update({
                                                    'transaction': {
                                                      'deliver':
                                                          merchant.data()[
                                                                  'transaction']
                                                              ['deliver'],
                                                      'failed': merchant.data()[
                                                              'transaction']
                                                          ['failed'],
                                                      'pay': merchant.data()[
                                                          'transaction']['pay'],
                                                      'request':
                                                          merchant.data()[
                                                                  'transaction']
                                                              ['request'],
                                                      'success':
                                                          merchant.data()[
                                                                  'transaction']
                                                              ['success'],
                                                    },
                                                    'orders': merchant
                                                            .data()['orders'] != null ? merchant
                                                            .data()['orders'] +
                                                        1 : 1,
                                                    'rating': merchant
                                                            .data()['orders'] != null ? (merchant.data()[
                                                                    'orders'] *
                                                                merchant.data()[
                                                                    'rating'] +
                                                            rating) /
                                                        (merchant.data()[
                                                                'orders'] +
                                                            1): rating
                                                  });
                                                  await firestore
                                                                .collection(
                                                                    'notifications')
                                                                .add({
                                                              'from': customer.id,
                                                              'to': merchant.id,
                                                              'title': "Pesanan " +
                                                                  product 
                                                                          .data()[
                                                                      'title'] +
                                                                  " telah direview",
                                                              'description': 'Pesanan ' +
                                                                  product 
                                                                          .data()[
                                                                      'title'] +
                                                                  ' telah direview', 
                                                              'type': 'order',
                                                              'data':
                                                                  order 
                                                                      .id,
                                                              'thumbnail': product 
                                                                      .data()[
                                                                  'images'][0],
                                                              'read': null,
                                                              'created': FieldValue
                                                                  .serverTimestamp()
                                                            }).then((result) {});
                                                            await firestore
                                                                .collection(
                                                                    'users')
                                                                .doc(merchant.data()['user'])
                                                                .get()
                                                                .then(
                                                                    (document) async {
                                                              http.Response
                                                                  response =
                                                                  await http
                                                                      .post(
                                                                Uri.parse(
                                                                    'https://fcm.googleapis.com/fcm/send'),
                                                                headers: <
                                                                    String,
                                                                    String>{
                                                                  'Content-Type':
                                                                      'application/json',
                                                                  'Authorization':
                                                                      'key=AAAAIm6AsJQ:APA91bGT81ymffaQJDAyZrOugf57o3DJTsLmjonfmX393M8Oaeb8Yj773T0I4VJugTBAEMq9ukFgez05titoCbNw4KQIFGuhS4DxQiuIRklAKYRZ_IIqOquhlMne-WxyKEtxNwRnBOPE',
                                                                },
                                                                body:
                                                                    jsonEncode(
                                                                  <String,
                                                                      dynamic>{
                                                                    'notification': <
                                                                        String,
                                                                        dynamic>{
                                                                      'title':
                                                                          'Pesanan direview',
                                                                      'body': 'Pesanan ' +
                                                                          product
                                                                              .data()['title'] +
                                                                          ' direview',
                                                                    },
                                                                    'priority':
                                                                        'high',
                                                                    'data': <
                                                                        String,
                                                                        dynamic>{
                                                                      'click_action':
                                                                          'FLUTTER_NOTIFICATION_CLICK',
                                                                      'id': '1',
                                                                      'status':
                                                                          'done'
                                                                    },
                                                                    'to': document.data()['fcmToken'],
                                                                  },
                                                                ),
                                                              );
                                                            });
                                                  EasyLoading.showSuccess(
                                                      'Review berhasil dikirim');
                                                  getData();
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 12.0),
                                                  width: 180,
                                                  margin:
                                                      EdgeInsets.only(top: 20),
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            AppColors
                                                                .PrimaryColor,
                                                            AppColors
                                                                .SecondaryColor
                                                          ]),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  child: Text(
                                                    'Submit',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16.0),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                            ],
                                          )
                                      ])),
                            ])),
                      ],
                    ))
                  : Container(
                      height: size.height - 200,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.PrimaryColor,
                        ),
                      )))
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
