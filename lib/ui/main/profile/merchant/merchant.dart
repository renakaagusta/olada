import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:olada/widgets/textfield_widget.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path/path.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:olada/constants/assets.dart';
import 'package:olada/constants/colors.dart';
import 'package:olada/constants/strings.dart';

class MerchantProfileScreen extends StatefulWidget {
  @override
  _MerchantProfileScreenState createState() => _MerchantProfileScreenState();
}

class _MerchantProfileScreenState extends State<MerchantProfileScreen> {
  var picker = ImagePicker();
  dynamic user;
  dynamic merchant;
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
  TextEditingController displayNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  File image;
  Size size;

  Future<void> getData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      user = jsonDecode(prefs.getString("user"));
      if (user['merchant'] == null) {
      } else {
        merchant = user['merchant'];
        displayNameController.text = merchant['name'];
        descriptionController.text =
            merchant['description'].toString().replaceAll("\\n", "\n");
        location = merchant['location'];
        address = location['address'];

        firestore
            .collection('products')
            .where('merchant', isEqualTo: user['merchant']['id'])
            .get()
            .then((snapshot) {
          setState(() {
            products = snapshot.docs;
          });
        });
      }
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
      appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
          centerTitle: true,
          title: Text('Toko Saya',
              style: TextStyle(
                color: Colors.black,
              )),
          iconTheme: IconThemeData(color: Colors.black)),
      body: (merchant != null)
          ? Container(
              height: size.height,
              width: size.width,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  if (user['merchant'] != null)
                    SingleChildScrollView(
                        child: Container(
                      height: size.height + 500,
                      width: size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                top: 20, bottom: 10, left: 20, right: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 80,
                                      width: 80,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child: CachedNetworkImage(
                                          imageUrl: merchant['picture'],
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            )),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user != null ? merchant['name'] : '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        SizedBox(height: 10),
                                        Text('088806875205',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black)),
                                        SizedBox(height: 10),
                                        Text(user['email'],
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                              height: 50,
                              margin: EdgeInsets.only(
                                  top: 10, bottom: 10, left: 20, right: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 1, color: Colors.grey[300]),
                              ),
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(merchant['type'] + ' Merchant',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                          GestureDetector(
                                            onTap: (){
                                              EasyLoading.showInfo("Fitur upgrade belum tersedia");
                                            },
                                            child: 
                                  Text('Upgrade',
                                      style: TextStyle(
                                          color: AppColors.SecondaryColor)),)
                                ],
                              )),
                          SizedBox(height: 10),
                          Container(height: 1, color: Colors.grey[200]),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Saldo",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16)),
                                Text('Rp ' + merchant['balance'].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(height: 8, color: Colors.grey[100]),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Penjualan",
                                    style: TextStyle(
                                        color: Colors.black45, fontSize: 14)),
                                GestureDetector(onTap: (){
                                    Navigator.of(context).pushNamed('/order',
                                        arguments: {
                                          'role': 'merchant',
                                          'status': 'history'
                                        });},child:
                                Text('Riwayat',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.SecondaryColor)),),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed('/order',
                                        arguments: {
                                          'role': 'merchant',
                                          'status': 'unpaid'
                                        });
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.grey[300]),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(CupertinoIcons.cube_box,
                                            color: Colors.orange[600]),
                                      ),
                                      SizedBox(width: 15),
                                      Text('Pesanan baru',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[800]))
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed('/order',
                                        arguments: {
                                          'role': 'merchant',
                                          'status': 'paid'
                                        });
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.grey[300]),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(CupertinoIcons.share,
                                            color: Colors.orange[600]),
                                      ),
                                      SizedBox(width: 15),
                                      Text('Siap dikirim',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[800]))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(height: 8, color: Colors.grey[100]),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Produk",
                                    style: TextStyle(
                                        color: Colors.black45, fontSize: 14)),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed('/profile/merchant/product');
                                  },
                                  child: Text('Tambah',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors.SecondaryColor)),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          (products != null)
                              ? (products.length > 0)
                                  ? Expanded(
                                      child: StaggeredGridView.countBuilder(
                                        crossAxisCount: 4,
                                        itemCount: products.length,
                                        padding: EdgeInsets.zero,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (BuildContext context,
                                                int index) =>
                                            new Container(
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
                                                                fontSize: 12)),
                                                        SizedBox(height: 5),
                                                        Text(
                                                            'Rp ' +
                                                                products[index]
                                                                    ['price'],
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        SizedBox(height: 5),
                                                        Row(
                                                          children: [
                                                            
                                                            Text(
                                                                products[index][
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
                      ),
                    )),
                ],
              ))
          : Container(),
    );
  }
}
