import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:olada/constants/colors.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  var picker = ImagePicker();
  dynamic user;
  List<dynamic> orders;
  List<dynamic> merchants;
  List<dynamic> products;
  String role;
  String status;
  SharedPreferences prefs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  File image;
  Size size;

  Future<dynamic> getProductData(String id) async {
    return firestore.collection('products').doc(id).get();
  }

  Future<dynamic> getMerchantData(String id) async {
    return firestore.collection('merchants').doc(id).get();
  }

  Future<void> getData() async {
    prefs = await SharedPreferences.getInstance();
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    setState(() {
      user = jsonDecode(prefs.getString("user"));
      role = arguments['role'];
      status = arguments['status'];
    });

    if (status == 'unpaid') {
      firestore
          .collection('orders')
          .where(role == 'merchant' ? 'merchant' : 'user',
              isEqualTo:
                  role == 'merchant' ? user['merchant']['id'] : user['id'])
          .where('pay', isEqualTo: '')
          .get()
          .then((snapshot) async {
        List<dynamic> productQuery = await Future.wait(snapshot.docs.map(
            (doc) async =>
                await getProductData(doc.data()['items'][0]['product'])));

        List<dynamic> merchantQuery = await Future.wait(snapshot.docs
            .map((doc) async => await getMerchantData(doc.data()['merchant'])));

        setState(() {
          products = productQuery;
          merchants = merchantQuery;
          orders = snapshot.docs;
        });
      });
    } else if (status == 'paid' || status == 'packaged') {
      firestore
          .collection('orders')
          .where(role == 'merchant' ? 'merchant' : 'user',
              isEqualTo:
                  role == 'merchant' ? user['merchant']['id'] : user['id'])
          .where('pay', isNotEqualTo: '')
          .where('delivered', isEqualTo: '')
          .get()
          .then((snapshot) async {
        snapshot.docs.removeWhere((doc) => doc.data()['delivered'] != '');
        List<dynamic> productQuery = await Future.wait(snapshot.docs.map(
            (doc) async =>
                await getProductData(doc.data()['items'][0]['product'])));

        List<dynamic> merchantQuery = await Future.wait(snapshot.docs
            .map((doc) async => await getMerchantData(doc.data()['merchant'])));

        setState(() {
          products = productQuery;
          merchants = merchantQuery;
          orders = snapshot.docs;
        });
      });
    } else if (status == 'delivered') {
      firestore
          .collection('orders')
          .where(role == 'merchant' ? 'merchant' : 'user',
              isEqualTo:
                  role == 'merchant' ? user['merchant']['id'] : user['id'])
          .where('delivered', isNotEqualTo: '')
          .where('finished', isEqualTo: '')
          .get()
          .then((snapshot) async {
        List<dynamic> productQuery = await Future.wait(snapshot.docs.map(
            (doc) async =>
                await getProductData(doc.data()['items'][0]['product'])));

        List<dynamic> merchantQuery = await Future.wait(snapshot.docs
            .map((doc) async => await getMerchantData(doc.data()['merchant'])));

        setState(() {
          products = productQuery;
          merchants = merchantQuery;
          orders = snapshot.docs;
        });
      });
    } else if (status == 'finished') {
      firestore
          .collection('orders')
          .where(role == 'merchant' ? 'merchant' : 'user',
              isEqualTo:
                  role == 'merchant' ? user['merchant']['id'] : user['id'])
          .where('finished', isNotEqualTo: '')
          .get()
          .then((snapshot) async {
        List<dynamic> productQuery = await Future.wait(snapshot.docs.map(
            (doc) async =>
                await getProductData(doc.data()['items'][0]['product'])));

        List<dynamic> merchantQuery = await Future.wait(snapshot.docs
            .map((doc) async => await getMerchantData(doc.data()['merchant'])));

        setState(() {
          products = productQuery;
          merchants = merchantQuery;
          orders = snapshot.docs;
        });
      });
    } else if (status == 'history') {
      firestore
          .collection('orders')
          .where(role == 'merchant' ? 'merchant' : 'user',
              isEqualTo:
                  role == 'merchant' ? user['merchant']['id'] : user['id'])
          .where('pay', isNotEqualTo: '')
          .get()
          .then((snapshot) async {
        snapshot.docs.removeWhere((doc) => doc.data()['delivered'] == '');

        List<dynamic> productQuery = await Future.wait(snapshot.docs.map(
            (doc) async =>
                await getProductData(doc.data()['items'][0]['product'])));

        List<dynamic> merchantQuery = await Future.wait(snapshot.docs
            .map((doc) async => await getMerchantData(doc.data()['merchant'])));

        setState(() {
          products = productQuery;
          merchants = merchantQuery;
          orders = snapshot.docs;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
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
          title: Text('Daftar Pesanan',
              style: TextStyle(
                color: Colors.black,
              )),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black)),
      body: (user != null)
          ? SingleChildScrollView(
              child: Container(
                  height: size.height,
                  width: size.width,
                  child: (orders != null)
                      ? orders.length > 0
                          ? Expanded(
                              child: StaggeredGridView.countBuilder(
                                crossAxisCount: 4,
                                itemCount: orders.length,
                                padding: EdgeInsets.zero,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context,
                                        int index) =>
                                    new GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              '/order/detail',
                                              arguments: {
                                                'orderId': orders[index].id,
                                                'customerId': orders[index]
                                                    .data()['user'],
                                                'merchantId': orders[index]
                                                    .data()['merchant'],
                                                'productId': orders[index]
                                                        .data()['items'][0]
                                                    ['product'],
                                                'role': role,
                                              });
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1,
                                                  color: Colors.grey[300],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
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
                                                    Row(
                                                      children: [
                                                        Container(
                                                            height: 30,
                                                            width: 30,
                                                            child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl: merchants[
                                                                              index]
                                                                          .data()[
                                                                      'picture'],
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
                                                                ))),
                                                        SizedBox(width: 10),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                merchants[index]
                                                                        .data()[
                                                                    'name'],
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            SizedBox(width: 10),
                                                            Column(
                                                              children: [
                                                                SizedBox(
                                                                    height: 5),
                                                                Text(
                                                                    merchants[index].data()['location']
                                                                            [
                                                                            'subAdminArea'] +
                                                                        ', ' +
                                                                        merchants[index].data()['location']
                                                                            [
                                                                            'adminArea'],
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12))
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    if (status == 'unpaid')
                                                      Container(
                                                          height: 40,
                                                          width: 100,
                                                          padding:
                                                              EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 10,
                                                          ),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .grey[100],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Text('Unpaid',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .PrimaryColor))),
                                                    if (status == 'delivered')
                                                      Container(
                                                          height: 40,
                                                          width: 100,
                                                          padding:
                                                              EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 10,
                                                          ),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .grey[100],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Text(
                                                              'Delivered',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .PrimaryColor))),
                                                    if (status == 'history' ||
                                                        status == 'finished')
                                                      if (orders[index].data()['finished'] ==
                                                          '')
                                                        Container(
                                                            height: 40,
                                                            width: 100,
                                                            padding:
                                                                EdgeInsets.only(
                                                              top: 10,
                                                              bottom: 10,
                                                            ),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .grey[100],
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        10)),
                                                            child: Text('Delivered',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .PrimaryColor)))
                                                      else
                                                        Container(
                                                            height: 40,
                                                            width: 100,
                                                            padding:
                                                                EdgeInsets.only(
                                                              top: 10,
                                                              bottom: 10,
                                                            ),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .grey[100],
                                                                borderRadius:
                                                                    BorderRadius.circular(10)),
                                                            child: Text('Finished', textAlign: TextAlign.center, style: TextStyle(color: AppColors.PrimaryColor)))
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Row(children: [
                                                  Container(
                                                      height: 60,
                                                      width: 60,
                                                      child: CachedNetworkImage(
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
                                                      )),
                                                  SizedBox(width: 15),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(height: 5),
                                                      Text(
                                                          products[index]
                                                              ['title'],
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      SizedBox(height: 5),
                                                      Container(
                                                        width: size.width - 120,
                                                        child: Text(
                                                            products[index]
                                                                ['description'],
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 12)),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(orders[index]
                                                              .data()['items']
                                                                  [0]
                                                                  ['quantity']
                                                              .toString() +
                                                          ' item')
                                                    ],
                                                  ),
                                                ]),
                                                SizedBox(height: 15),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text('Total belanja',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey[700],
                                                                fontSize: 12)),
                                                        SizedBox(height: 5),
                                                        Text(
                                                            'Rp ' +
                                                                (int.parse(products[index]
                                                                            [
                                                                            'price']) *
                                                                        orders[index].data()['items'][0]
                                                                            [
                                                                            'quantity'])
                                                                    .toString(),
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ],
                                                    ),
                                                    if (role == 'user' &&
                                                        status == 'delivered')
                                                      GestureDetector(
                                                          onTap: () async {
                                                            EasyLoading.show();
                                                            await firestore
                                                                .collection(
                                                                    'merchants')
                                                                .doc(merchants[
                                                                        index]
                                                                    .id)
                                                                .update({
                                                              'transaction': {
                                                                'request': merchants[index]
                                                                            .data()[
                                                                        'transaction']
                                                                    ['request'],
                                                                'deliver': merchants[index]
                                                                            .data()[
                                                                        'transaction']
                                                                    ['deliver'],
                                                                'pay': merchants[
                                                                            index]
                                                                        .data()[
                                                                    'transaction']['pay'],
                                                                'success': merchants[index]
                                                                            .data()['transaction']
                                                                        [
                                                                        'success'] +
                                                                    1,
                                                                'failed': merchants[
                                                                            index]
                                                                        .data()[
                                                                    'transaction']['failed'],
                                                              }
                                                            });
                                                            await firestore
                                                                .collection(
                                                                    'orders')
                                                                .doc(orders[
                                                                        index]
                                                                    .id)
                                                                .update({
                                                              'finished': FieldValue
                                                                  .serverTimestamp()
                                                            }).then((result) {
                                                              EasyLoading
                                                                  .showSuccess(
                                                                      'Pesanan telah sampai');

                                                              Navigator.of(
                                                                      context)
                                                                  .pushNamed(
                                                                      '/order/detail',
                                                                      arguments: {
                                                                    'orderId':
                                                                        orders[index]
                                                                            .id,
                                                                    'customerId':
                                                                        orders[index]
                                                                            .data()['user'],
                                                                    'merchantId':
                                                                        orders[index]
                                                                            .data()['merchant'],
                                                                    'productId':
                                                                        orders[index].data()['items'][0]
                                                                            [
                                                                            'product'],
                                                                    'role':
                                                                        role,
                                                                  });
                                                            });
                                                          },
                                                          child: Container(
                                                              height: 40,
                                                              width: 100,
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                top: 10,
                                                                bottom: 10,
                                                              ),
                                                              decoration: BoxDecoration(
                                                                  color: AppColors
                                                                      .PrimaryColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              child: Text(
                                                                  'Sampai',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white)))),
                                                    if (role == 'merchant' &&
                                                        status == 'unpaid')
                                                      GestureDetector(
                                                          onTap: () async {
                                                            EasyLoading.show();

                                                            await firestore
                                                                .collection(
                                                                    'merchants')
                                                                .doc(merchants[
                                                                        index]
                                                                    .id)
                                                                .update({
                                                              'transaction': {
                                                                'request': merchants[index]
                                                                            .data()[
                                                                        'transaction']
                                                                    ['request'],
                                                                'deliver': merchants[index]
                                                                            .data()[
                                                                        'transaction']
                                                                    ['deliver'],
                                                                'pay': merchants[index]
                                                                            .data()['transaction']
                                                                        [
                                                                        'pay'] +
                                                                    1,
                                                                'success': merchants[index]
                                                                            .data()[
                                                                        'transaction']
                                                                    ['success'],
                                                                'failed': merchants[
                                                                            index]
                                                                        .data()[
                                                                    'transaction']['failed'],
                                                              }
                                                            });
                                                            await firestore
                                                                .collection(
                                                                    'orders')
                                                                .doc(orders[
                                                                        index]
                                                                    .id)
                                                                .update({
                                                              'accepted': FieldValue
                                                                  .serverTimestamp(),
                                                              'pay': FieldValue
                                                                  .serverTimestamp()
                                                            }).then((result) {});

                                                            await firestore
                                                                .collection(
                                                                    'notifications')
                                                                .add({
                                                              'from': merchants[
                                                                      index]
                                                                  .id,
                                                              'to': user['id'],
                                                              'title': "Pembayaran pesanan " +
                                                                  products[index]
                                                                          .data()[
                                                                      'title'] +
                                                                  " telah dikonfirmasi",
                                                              'description': 'Pesanan ' +
                                                                  products[index]
                                                                          .data()[
                                                                      'title'] +
                                                                  ' telah dikonfirmasi',
                                                              'type': 'order',
                                                              'data':
                                                                  orders[index]
                                                                      .id,
                                                              'thumbnail': products[
                                                                          index]
                                                                      .data()[
                                                                  'images'][0],
                                                              'read': null,
                                                              'created': FieldValue
                                                                  .serverTimestamp()
                                                            }).then((result) {});
                                                            await firestore
                                                                .collection(
                                                                    'users')
                                                                .doc(user['id'])
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
                                                                          'Pesanan dikonfirmasi',
                                                                      'body': 'Pesanan ' +
                                                                          products[index]
                                                                              .data()['title'] +
                                                                          ' dikonfirmasi',
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
                                                                    'to': user[
                                                                        'fcmToken'],
                                                                  },
                                                                ),
                                                              );
                                                            });

                                                            EasyLoading.showSuccess(
                                                                'Pesanan dikonfirmasi');
                                                            getData();
                                                          },
                                                          child: Container(
                                                              height: 40,
                                                              width: 100,
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                top: 10,
                                                                bottom: 10,
                                                              ),
                                                              decoration: BoxDecoration(
                                                                  color: AppColors
                                                                      .PrimaryColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              child: Text(
                                                                  'Konfirmasi',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white)))),
                                                    if (role == 'merchant' &&
                                                        status == 'paid')
                                                      GestureDetector(
                                                          onTap: () async {
                                                            EasyLoading.show();
                                                            await firestore
                                                                .collection(
                                                                    'merchants')
                                                                .doc(merchants[
                                                                        index]
                                                                    .id)
                                                                .update({
                                                              'transaction': {
                                                                'request': merchants[index]
                                                                            .data()[
                                                                        'transaction']
                                                                    ['request'],
                                                                'deliver': merchants[index]
                                                                            .data()['transaction']
                                                                        [
                                                                        'deliver'] +
                                                                    1,
                                                                'pay': merchants[
                                                                            index]
                                                                        .data()[
                                                                    'transaction']['pay'],
                                                                'success': merchants[index]
                                                                            .data()[
                                                                        'transaction']
                                                                    ['success'],
                                                                'failed': merchants[
                                                                            index]
                                                                        .data()[
                                                                    'transaction']['failed'],
                                                              }
                                                            });
                                                            await firestore
                                                                .collection(
                                                                    'orders')
                                                                .doc(orders[
                                                                        index]
                                                                    .id)
                                                                .update({
                                                              'delivered':
                                                                  FieldValue
                                                                      .serverTimestamp()
                                                            }).then((result) {});
                                                            await firestore
                                                                .collection(
                                                                    'notifications')
                                                                .add({
                                                              'from': merchants[
                                                                      index]
                                                                  .id,
                                                              'to': user['id'],
                                                              'title': "Pesanan " +
                                                                  products[index]
                                                                          .data()[
                                                                      'title'] +
                                                                  " telah dikirim",
                                                              'description': 'Pesanan ' +
                                                                  products[index]
                                                                          .data()[
                                                                      'title'] +
                                                                  ' telah dikirim',
                                                              'type': 'order',
                                                              'data':
                                                                  orders[index]
                                                                      .id,
                                                              'thumbnail': products[
                                                                          index]
                                                                      .data()[
                                                                  'images'][0],
                                                              'read': null,
                                                              'created': FieldValue
                                                                  .serverTimestamp()
                                                            }).then((result) {});
                                                            await firestore
                                                                .collection(
                                                                    'users')
                                                                .doc(user['id'])
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
                                                                          'Pesanan dikirim',
                                                                      'body': 'Pesanan ' +
                                                                          products[index]
                                                                              .data()['title'] +
                                                                          ' dikirim',
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
                                                                    'to': user[
                                                                        'fcmToken'],
                                                                  },
                                                                ),
                                                              );
                                                            });

                                                            EasyLoading.showSuccess(
                                                                'Pesanan dikirim');
                                                            getData();
                                                          },
                                                          child: Container(
                                                              height: 40,
                                                              width: 100,
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                top: 10,
                                                                bottom: 10,
                                                              ),
                                                              decoration: BoxDecoration(
                                                                  color: AppColors
                                                                      .PrimaryColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              child: Text(
                                                                  'Kirim',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white)))),
                                                    if (role == 'merchant' &&
                                                        orders[index].data()[
                                                                'review'] !=
                                                            null)
                                                      RatingBarIndicator(
                                                        rating: double.parse(
                                                            orders[index]
                                                                .data()[
                                                                    'rating']
                                                                .toString()),
                                                        itemBuilder:
                                                            (context, index) =>
                                                                Icon(
                                                          CupertinoIcons
                                                                  .star_fill ??
                                                              CupertinoIcons
                                                                  .star,
                                                          color: Colors.amber,
                                                        ),
                                                        itemCount: 5,
                                                        itemSize: 18.0,
                                                        unratedColor: Colors
                                                            .amber
                                                            .withAlpha(50),
                                                        direction:
                                                            Axis.horizontal,
                                                      ),
                                                    if (role == 'user' &&
                                                        status == 'finished')
                                                      if (orders[index].data()[
                                                              'review'] !=
                                                          null)
                                                        RatingBarIndicator(
                                                          rating: double.parse(
                                                              orders[index]
                                                                  .data()[
                                                                      'rating']
                                                                  .toString()),
                                                          itemBuilder: (context,
                                                                  index) =>
                                                              Icon(
                                                            CupertinoIcons
                                                                    .star_fill ??
                                                                CupertinoIcons
                                                                    .star,
                                                            color: Colors.amber,
                                                          ),
                                                          itemCount: 5,
                                                          itemSize: 18.0,
                                                          unratedColor: Colors
                                                              .amber
                                                              .withAlpha(50),
                                                          direction:
                                                              Axis.horizontal,
                                                        )
                                                      else
                                                        GestureDetector(
                                                            onTap: () async {
                                                              Navigator.of(
                                                                      context)
                                                                  .pushNamed(
                                                                      '/order/detail',
                                                                      arguments: {
                                                                    'orderId':
                                                                        orders[index]
                                                                            .id,
                                                                    'customerId':
                                                                        orders[index]
                                                                            .data()['user'],
                                                                    'merchantId':
                                                                        orders[index]
                                                                            .data()['merchant'],
                                                                    'productId':
                                                                        orders[index].data()['items'][0]
                                                                            [
                                                                            'product'],
                                                                    'role':
                                                                        role,
                                                                  });
                                                            },
                                                            child: Container(
                                                                height: 40,
                                                                width: 100,
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  top: 10,
                                                                  bottom: 10,
                                                                ),
                                                                decoration: BoxDecoration(
                                                                    color: AppColors
                                                                        .PrimaryColor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child: Text(
                                                                    'Review',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white)))),
                                                  ],
                                                )
                                              ],
                                            ))),
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
                                  Icon(CupertinoIcons.exclamationmark_circle,
                                      size: 80),
                                  SizedBox(height: 30),
                                  Text('Item tidak ditemukan',
                                      style: TextStyle(fontSize: 16))
                                ],
                              ),
                            )
                      : Container(
                          child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.PrimaryColor,
                          ),
                        ))))
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
