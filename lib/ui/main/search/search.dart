import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:olada/constants/assets.dart';
import 'package:olada/constants/colors.dart';
import 'package:olada/constants/strings.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  List<dynamic> products;
  List<dynamic> merchants;
  dynamic user;
  TabController tabController;
  int tabIndex = 0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Size size;
  bool loading = true;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  Future<dynamic> getUserData(String id) async {
    return firestore.collection('merchants').doc(id).get();
  }

  Future<dynamic> getLikesData(String id) async {
    return firestore.collection('products').doc(id).collection('likes').get();
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user = jsonDecode(prefs.getString('user'));
    });
  }

  Future<void> search() async {
    firestore
        .collection('products')
        .where('title',
            isGreaterThanOrEqualTo:
                searchController.text.isNotEmpty ? searchController.text : "")
        .where('title',
            isLessThan: searchController.text.isNotEmpty
                ? searchController.text + '\uF7FF'
                : '\uF7FF')
        .limit(20)
        .get()
        .then((snapshotOfProduct) {
      firestore
          .collection('merchants')
          .where('name',
              isGreaterThanOrEqualTo:
                  searchController.text.isNotEmpty ? searchController.text : "")
          .where('name',
              isLessThan: searchController.text.isNotEmpty
                  ? searchController.text + '\uF7FF'
                  : '\uF7FF')
          .limit(20)
          .get()
          .then((snapshotOfUser) {
        setState(() {
          products = snapshotOfProduct.docs;
          merchants = snapshotOfUser.docs;
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
    tabController = new TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {
        tabIndex = tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    searchFocusNode.requestFocus();

    searchController.addListener(() {
      search();
    });

    if (user == null) getData();
    return Scaffold(
      primary: true,
      backgroundColor: Colors.white,
      body:  AnnotatedRegion<SystemUiOverlayStyle>(
         value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemStatusBarContrastEnforced: true,
        ),
        child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(top: 10),
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: size.width,
                      padding: EdgeInsets.only(
                          left: 20, top: 20, bottom: 10, right: 10),
                      decoration: BoxDecoration(color: Colors.white),
                      child: Column(children: [
                        Row(children: [
                          GestureDetector(
                            onTap: () async {
                              Navigator.pop(context);
                            },
                            child: Icon(CupertinoIcons.arrow_left,
                                color: Colors.black, size: 25),
                          ),
                          SizedBox(width: 20),
                          Container(
                            width: size.width * 0.78,
                            child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: searchController,
                              focusNode: searchFocusNode,
                              style: TextStyle(fontSize: 15),
                              decoration: InputDecoration.collapsed(
                                hintText: "Cari produk/toko",
                              ),
                            ),
                          ),
                        ]),
                      ])),
                  Container(
                    height: 60,
                    decoration: BoxDecoration(color: Colors.white),
                    child: TabBar(
                      tabs: [
                        Container(
                          width: 60,
                          child: Text(
                            'Produk',
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
                  (products != null)
                      ? Container(
                          height: size.height - 80,
                          child: tabIndex == 0
                              ? products.length > 0
                                  ? ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: products.length,
                                      itemBuilder: (context, index) {
                                        return new GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pushNamed(
                                                  '/product',
                                                  arguments: {
                                                    'productId':
                                                        products[index].id
                                                  });
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: (){
                                                Navigator.of(context).pushNamed(
                                                    '/product',
                                                    arguments: {
                                                      'productId':
                                                          products[index].id,
                                                    });
                                                  },
                                                  child: Container(
                                                    width: size.width,
                                                    padding: EdgeInsets.only(
                                                        top: 20,
                                                        left: 20,
                                                        right: 20),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                            height: 40,
                                                            width: 40,
                                                            child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
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
                                                                          .fill,
                                                                    )),
                                                                  ),
                                                                ))),
                                                        SizedBox(width: 15),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(products[index]
                                                                    .data()[
                                                                'title']),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                                'Rp ' +
                                                                    products[index]
                                                                            .data()[
                                                                        'price'],
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .PrimaryColor))
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                Container(
                                                    height: 1,
                                                    width: size.width,
                                                    color: Colors.grey[300]),
                                              ],
                                            ));
                                      })
                                  : Container(
                                      padding: EdgeInsets.only(top: 100),
                                      child: Column(
                                        children: [
                                          Icon(
                                              CupertinoIcons
                                                  .exclamationmark_circle,
                                              size: 40),
                                          SizedBox(height: 30),
                                          Text('Produk tidak ditemukan',
                                              style: TextStyle(fontSize: 18))
                                        ],
                                      ),
                                    )
                              : merchants.length > 0
                                  ? ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: merchants.length,
                                      itemBuilder: (context, index) {
                                        return new GestureDetector(
                                            onTap: () {
                                                Navigator.of(context).pushNamed(
                                                    '/merchant',
                                                    arguments: {
                                                      'merchantId':
                                                          merchants[index].id,
                                                    });
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: size.width,
                                                  padding: EdgeInsets.only(
                                                      top: 20,
                                                      left: 20,
                                                      right: 20),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                          height: 40,
                                                          width: 40,
                                                          child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
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
                                                                        .fill,
                                                                  )),
                                                                ),
                                                              ))),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
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
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      16)),
                                                          SizedBox(height: 10),
                                                          Text(merchants[index]
                                                                      .data()[
                                                                  'location']
                                                              ['subAdminArea'])
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                Container(
                                                    height: 1,
                                                    width: size.width,
                                                    color: Colors.grey[300]),
                                              ],
                                            ));
                                      })
                                  : Container(
                                      padding: EdgeInsets.only(top: 100),
                                      child: Column(
                                        children: [
                                          Icon(
                                              CupertinoIcons
                                                  .exclamationmark_circle,
                                              size: 40),
                                          SizedBox(height: 30),
                                          Text('Toko tidak ditemukan',
                                              style: TextStyle(fontSize: 18))
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
                          ))
                ],
              )),
        ),
      )),
    );
  }
}
