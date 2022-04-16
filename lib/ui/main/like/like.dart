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

class LikeScreen extends StatefulWidget {
  @override
  _LikeScreenState createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen>
    with SingleTickerProviderStateMixin {
  var picker = ImagePicker();
  dynamic user;
  List<dynamic> likes;
  List<dynamic> products;
  List<dynamic> merchants;
  SharedPreferences prefs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  File image;
  Size size;

  Future<dynamic> getProductData(String id) async {
    return firestore.collection('products').doc(id).get();
  }

  Future<void> getData() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      user = json.decode(prefs.getString('user'));

      firestore
          .collection('likes')
          .where('user', isEqualTo: user['id'])
          .get()
          .then((snapshot) async {
        List<dynamic> productsQuery = await Future.wait(snapshot.docs
            .map((doc) async => await getProductData(doc.data()['product'])));

        List<dynamic> merchantsQuery = await Future.wait(productsQuery
            .map((doc) async => await getProductData(doc.data()['merchant'])));

        setState(() {
          likes = snapshot.docs;
          products = productsQuery;
          merchants = merchantsQuery;
        });
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
          title: Text('Disimpan',
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
                      (likes != null)
                          ? Container(
                              height: size.height - 140,
                              child: likes.length > 0
                                  ? Expanded(
                                      child: StaggeredGridView.countBuilder(
                                        crossAxisCount: 4,
                                        itemCount: likes.length,
                                        padding: EdgeInsets.zero,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (BuildContext context,
                                                int index) =>
                                            GestureDetector(
                                                child: new Container(
                                                    margin: EdgeInsets.only(),
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
                                                                          borderRadius: BorderRadius.circular(
                                                                              10),
                                                                          image:
                                                                              DecorationImage(
                                                                            image:
                                                                                imageProvider,
                                                                            fit:
                                                                                BoxFit.cover,
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
                                                          )
                                                        ])
                                                      ],
                                                    )),
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pushNamed('/product',
                                                          arguments: {
                                                        'productId':
                                                            products[index].id,
                                                      });
                                                }),
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
                                          Text('Produk tidak ditemukan',
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
