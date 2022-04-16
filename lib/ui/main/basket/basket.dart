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
import 'package:olada/utils/timeago/timeago.dart';
import 'package:olada/constants/colors.dart';

class BasketScreen extends StatefulWidget {
  @override
  _BasketScreenState createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen>
    with SingleTickerProviderStateMixin {
  var picker = ImagePicker();
  dynamic user;
  List<dynamic> baskets;
  List<dynamic> merchants;
  List<dynamic> products;
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

    user = jsonDecode(prefs.getString("user"));

    firestore
        .collection('baskets')
        .where('user', isEqualTo: user['id'])
        .get()
        .then((snapshot) async {
      List<dynamic> productQuery = await Future.wait(snapshot.docs
          .map((doc) async => await getProductData(doc.data()['product'])));

      List<dynamic> merchantQuery = await Future.wait(snapshot.docs
          .map((doc) async => await getMerchantData(doc.data()['merchant'])));

      setState(() {
        products = productQuery;
        merchants = merchantQuery;
        baskets = snapshot.docs;
      });
    });
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
          title: Text('Keranjang',
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
                      (baskets != null)
                          ? Container(
                              height: size.height - 140,
                              child: baskets.length > 0
                                  ? Expanded(
                                      child: StaggeredGridView.countBuilder(
                                        crossAxisCount: 4,
                                        itemCount: baskets.length,
                                        padding: EdgeInsets.zero,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) =>
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
                                                          children: [
                                                            Container(
                                                                height: 30,
                                                                width: 30,
                                                                child:
                                                                    ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                15),
                                                                        child:
                                                                            CachedNetworkImage(
                                                                          imageUrl:
                                                                              merchants[index].data()['picture'],
                                                                          imageBuilder: (context, imageProvider) =>
                                                                              Container(
                                                                            decoration: BoxDecoration(
                                                                                image: DecorationImage(
                                                                              image: imageProvider,
                                                                              fit: BoxFit.cover,
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
                                                                    merchants[
                                                                                index]
                                                                            .data()[
                                                                        'name'],
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                SizedBox(
                                                                    width: 10),
                                                                Column(
                                                                  children: [
                                                                    SizedBox(
                                                                        height:
                                                                            5),
                                                                    Text(
                                                                        merchants[index].data()['location']['subAdminArea'] +
                                                                            ', ' +
                                                                            merchants[index].data()['location'][
                                                                                'adminArea'],
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12))
                                                                  ],
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(height: 10),
                                                        Row(children: [
                                                          Container(
                                                              height: 60,
                                                              width: 60,
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: products[
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
                                                                  products[
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
                                                                    products[
                                                                            index]
                                                                        [
                                                                        'description'],
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12)),
                                                              ),
                                                              SizedBox(
                                                                  height: 5),
                                                              Container(
                                                                width:
                                                                    size.width -
                                                                        120,
                                                                child: Text(
                                                                    'Rp ' +
                                                                        products[index]
                                                                            [
                                                                            'price'],
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                              )
                                                            ],
                                                          ),
                                                        ]),
                                                        SizedBox(height: 15),
                                                        Row(
                                                          children: [
                                                            GestureDetector(
                                                                onTap: () {
                                                                  EasyLoading
                                                                      .show();
                                                                  firestore
                                                                      .collection(
                                                                          'baskets')
                                                                      .doc(baskets[
                                                                              index]
                                                                          .id)
                                                                      .delete()
                                                                      .then(
                                                                          (result) {
                                                                    EasyLoading.showSuccess(
                                                                        'Item dihapus',
                                                                        duration:
                                                                            Duration(seconds: 1));
                                                                    getData();
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          20.0,
                                                                      vertical:
                                                                          10.0),
                                                                  height: 45.0,
                                                                  width:
                                                                      size.width *
                                                                          0.15,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      border: Border.all(
                                                                          width:
                                                                              1,
                                                                          color: AppColors
                                                                              .PrimaryColor),
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(10))),
                                                                  child: Icon(
                                                                      CupertinoIcons
                                                                          .trash,
                                                                      color: AppColors
                                                                          .PrimaryColor),
                                                                )),
                                                            SizedBox(width: 10),
                                                            GestureDetector(
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pushNamed(
                                                                          '/checkout',
                                                                          arguments: {
                                                                        'productId':
                                                                            baskets[index].data()['product'],
                                                                        'basketId':
                                                                            baskets[index].id,
                                                                        'role':
                                                                            'user'
                                                                      });
                                                                },
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          20.0,
                                                                      vertical:
                                                                          10.0),
                                                                  height: 45.0,
                                                                  width:
                                                                      size.width *
                                                                          0.7,
                                                                  decoration: BoxDecoration(
                                                                      gradient:
                                                                          LinearGradient(
                                                                              colors: [
                                                                            AppColors.PrimaryColor,
                                                                            AppColors.SecondaryColor
                                                                          ]),
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(10))),
                                                                  child: Text(
                                                                    'Beli',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            16.0),
                                                                  ),
                                                                ))
                                                          ],
                                                        )
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
                                          Text('Item tidak ditemukan',
                                              style: TextStyle(fontSize: 16))
                                        ],
                                      ),
                                    ))
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
