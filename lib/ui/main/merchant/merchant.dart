import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:olada/widgets/textfield_widget.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:olada/constants/colors.dart';

class MerchantScreen extends StatefulWidget {
  @override
  _MerchantScreenState createState() => _MerchantScreenState();
}

class _MerchantScreenState extends State<MerchantScreen> {
  var picker = ImagePicker();
  dynamic user;
  dynamic merchant;
  List<dynamic> merchantFollowers;
  String merchantId;
  List<dynamic> products;
  SharedPreferences prefs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Marker origin, destination;
  Position position = Position(latitude: -7.2941646, longitude: 112.7986343);
  String address;
  static const initialCameraPosition = CameraPosition(
    target: LatLng(-7.2941646, 112.7986343),
    zoom: 11.5,
  );
  dynamic location;
  GoogleMapController googleMapController;

  File image;
  Size size;

  Future<void> getData() async {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    prefs = await SharedPreferences.getInstance();
    setState(() {
      user = jsonDecode(prefs.getString("user"));
      merchantId = arguments['merchantId'];
      firestore
          .collection('merchants')
          .doc(arguments['merchantId'])
          .get()
          .then((document) {
        merchant = document;

        location = document.data()['location'];
        address = document.data()['location']['address'];

        firestore
            .collection('products')
            .where('merchant', isEqualTo: arguments['merchantId'])
            .get()
            .then((snapshot) {
          setState(() {
            products = snapshot.docs;
          });
        });

        firestore
            .collection('merchants')
            .doc(arguments['merchantId'])
            .collection('followers')
            .get()
            .then((snapshot) {
          setState(() {
            merchantFollowers = snapshot.docs;
          });
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
    if (merchant == null) getData();
    size = MediaQuery.of(context).size;

    return Scaffold(
        primary: true,
        backgroundColor: Colors.white,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Color(0x00000000),
            statusBarIconBrightness: Brightness.light,
          ),
          child: (merchant != null)
              ? Container(
                  height: size.height,
                  width: size.width,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      if (merchant != null)
                        SingleChildScrollView(
                            child: Container(
                          height: size.height + 500,
                          width: size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  padding: EdgeInsets.only(
                                      top: 20, bottom: 10, left: 20, right: 20),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      AppColors.PrimaryColor,
                                      AppColors.SecondaryColor
                                    ]),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 20),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                                child: Icon(CupertinoIcons.back,
                                                    color: Colors.white),
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                }),
                                            Text('Toko',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Container()
                                          ]),
                                      SizedBox(height: 20),
                                      Container(
                                        width: size.width,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height: 80,
                                                  width: 80,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          merchant.data()['picture'],
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover,
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      user != null
                                                          ? merchant.data()['name']
                                                          : '',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      merchant.data()['location']
                                                          ['subAdminArea'],
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            if (merchantId != user['merchant'])
                                              Column(
                                                children: [
                                                  if (merchantFollowers != null)
                                                    if (merchantFollowers
                                                            .length >
                                                        0)
                                                      if (merchantFollowers
                                                          .firstWhere(
                                                              (merchant) =>
                                                                  merchant.data()[
                                                                      'user'] ==
                                                                  user['id'])!=null)
                                                        GestureDetector(
                                                          onTap: () async {
                                                            EasyLoading.show();
                                                            await firestore
                                                                .collection(
                                                                    'merchants')
                                                                .doc(
                                                                    merchant.id)
                                                                .update({
                                                              'followers': merchant
                                                                          .data()[
                                                                      'followers'] -
                                                                  1
                                                            });
                                                            await firestore
                                                                .collection(
                                                                    'merchants')
                                                                .doc(
                                                                    merchant.id)
                                                                .collection(
                                                                    'followers')
                                                                .where('user',
                                                                    isEqualTo:
                                                                        user[
                                                                            'id'])
                                                                .get()
                                                                .then(
                                                                    (snapshot) {
                                                              firestore
                                                                  .collection(
                                                                      'merchants')
                                                                  .doc(merchant
                                                                      .id)
                                                                  .collection(
                                                                      'followers')
                                                                  .doc(snapshot
                                                                      .docs[0]
                                                                      .id)
                                                                  .delete();
                                                            });

                                                            EasyLoading
                                                                .dismiss();
                                                            EasyLoading.showSuccess(
                                                                'Diikuti',
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            1));
                                                            getData();
                                                          },
                                                          child: Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      right: 10,
                                                                      top: 5,
                                                                      bottom:
                                                                          5),
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .white,
                                                                      width:
                                                                          1)),
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                      CupertinoIcons.minus,
                                                                      color: AppColors.PrimaryColor,
                                                                      size: 18),
                                                                  SizedBox(
                                                                      width:
                                                                          10),
                                                                  Text(
                                                                      'Batal ikuti',
                                                                      style: TextStyle(
                                                                      color: AppColors.PrimaryColor,
                                                                          fontSize:
                                                                              13))
                                                                ],
                                                              )),
                                                        )
                                                      else
                                                        GestureDetector(
                                                          onTap: () async {
                                                            EasyLoading.show();
                                                            await firestore
                                                                .collection(
                                                                    'merchants')
                                                                .doc(
                                                                    merchant.id)
                                                                .update({
                                                              'followers': merchant
                                                                          .data()[
                                                                      'followers'] +
                                                                  1
                                                            });
                                                            await firestore
                                                                .collection(
                                                                    'merchants')
                                                                .doc(
                                                                    merchant.id)
                                                                .collection(
                                                                    'followers')
                                                                .add({
                                                              'user':
                                                                  user['id'],
                                                              'created': FieldValue
                                                                  .serverTimestamp()
                                                            });
                                                            EasyLoading
                                                                .dismiss();
                                                            EasyLoading.showSuccess(
                                                                'Diikuti',
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            1));
                                                          },
                                                          child: Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      right: 10,
                                                                      top: 5,
                                                                      bottom:
                                                                          5),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .white,
                                                                      width:
                                                                          1)),
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                      CupertinoIcons
                                                                          .add,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 18),
                                                                  SizedBox(
                                                                      width:
                                                                          10),
                                                                  Text('ikuti',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              13))
                                                                ],
                                                              )),
                                                        )
                                                    else
                                                      GestureDetector(
                                                        onTap: () async {
                                                          EasyLoading.show();
                                                          await firestore
                                                              .collection(
                                                                  'merchants')
                                                              .doc(merchant.id)
                                                              .update({
                                                            'followers': merchant
                                                                        .data()[
                                                                    'followers'] +
                                                                1
                                                          });
                                                          await firestore
                                                              .collection(
                                                                  'merchants')
                                                              .doc(merchant.id)
                                                              .collection(
                                                                  'followers')
                                                              .add({
                                                            'user': user['id'],
                                                            'created': FieldValue
                                                                .serverTimestamp()
                                                          });
                                                          EasyLoading.dismiss();
                                                          EasyLoading.showSuccess(
                                                              'Diikuti',
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          1));
                                                          getData();
                                                        },
                                                        child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    right: 10,
                                                                    top: 5,
                                                                    bottom: 5),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 1)),
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                    CupertinoIcons
                                                                        .add,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 18),
                                                                SizedBox(
                                                                    width: 10),
                                                                Text('ikuti',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            13))
                                                              ],
                                                            )),
                                                      ),
                                                  SizedBox(height: 10),
                                                  Container(
                                                      padding: EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          top: 5,
                                                          bottom: 5),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 1)),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                              CupertinoIcons
                                                                  .chat_bubble,
                                                              color:
                                                                  Colors.white,
                                                              size: 18),
                                                          SizedBox(width: 10),
                                                          Text('Chat',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 13))
                                                        ],
                                                      ))
                                                ],
                                              )
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                    double.parse(
                                                            merchant.data()['rating']
                                                                .toString())
                                                        .toStringAsFixed(2),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 26)),
                                                SizedBox(height: 5),
                                                Text('Rating',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14))
                                              ],
                                            ),
                                            Container(
                                                height: 50,
                                                width: 0.5,
                                                color: Colors.white),
                                            Column(
                                              children: [
                                                Text(
                                                    merchant.data()['followers'] 
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 26)),
                                                SizedBox(height: 5),
                                                Text('Pengikut',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14))
                                              ],
                                            ),
                                            Container(
                                                height: 50,
                                                width: 0.5,
                                                color: Colors.white),
                                            Column(
                                              children: [
                                                Text(
                                                    merchant.data()['transaction']
                                                            ['request']
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 26)),
                                                SizedBox(height: 5),
                                                Text('Terjual',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14))
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                    ],
                                  )),
                              Container(height: 8, color: Colors.grey[100]),
                              if (products != null)
                                if (products.length > 0)
                                  Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text('Daftar produk',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            )),
                                      ),
                                      SizedBox(height: 15),
                                    ],
                                  ),
                              (products != null)
                                  ? (products.length > 0)
                                      ? Expanded(
                                          child: StaggeredGridView.countBuilder(
                                            crossAxisCount: 4,
                                            itemCount: products.length,
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
                                                            imageUrl: products[
                                                                        index]
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
                                                                fit: BoxFit
                                                                    .cover,
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
                                                                    products[index]['title'].length >=
                                                                            30
                                                                        ? products[index]['title'].substring(
                                                                            0,
                                                                            30)
                                                                        : products[index]['title']
                                                                            .length),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12)),
                                                            SizedBox(height: 5),
                                                            Text(
                                                                'Rp ' +
                                                                    products[
                                                                            index]
                                                                        [
                                                                        'price'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
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
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      imageUrl:
                                                                      merchant.data()['picture'],
                                                                      imageBuilder:
                                                                          (context, imageProvider) =>
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
                                                    )),
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
                                              Text('Belum ada produk',
                                                  style:
                                                      TextStyle(fontSize: 18))
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
                          ),
                        )),
                    ],
                  ))
              : Container(),
        ));
  }
}
