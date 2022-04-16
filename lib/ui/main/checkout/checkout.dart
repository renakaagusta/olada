import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:olada/api/api_service.dart';
import 'package:olada/widgets/textfield_widget.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:olada/utils/timeago/timeago.dart';
import 'package:olada/constants/assets.dart';
import 'package:olada/constants/colors.dart';
import 'package:olada/constants/strings.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  var picker = ImagePicker();
  dynamic user;
  SharedPreferences prefs;
  ApiService apiService = ApiService();
  File image;
  Size size;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  dynamic merchant;
  dynamic product;
  int quantity = 1;
  int total;
  CarouselController carouselController = new CarouselController();
  List<Widget> productImages = [];
  List<dynamic> productReviews;
  List<dynamic> productLikes = [];
  List<dynamic> usersReview;
  List<dynamic> merchantFollowers;
  String basket;
  int currentPosition = 0;

  Marker origin, destination;
  Position position = Position(latitude: -7.2941646, longitude: 112.7986343);
  String address;
  static const initialCameraPosition = CameraPosition(
    target: LatLng(-7.2941646, 112.7986343),
    zoom: 11.5,
  );
  dynamic location;
  GoogleMapController googleMapController;
  TextEditingController commentController = TextEditingController();
  FocusNode commentFocusNode = FocusNode();

  void addMarker(LatLng pos) async {
    setState(() {
      Position position =
          Position(latitude: pos.latitude, longitude: pos.longitude);
      position = position;
      origin = Marker(
        markerId: const MarkerId('origin'),
        infoWindow: const InfoWindow(title: 'Origin'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: pos,
      );
    });
    List<geocoding.Placemark> placemarks =
        await geocoding.placemarkFromCoordinates(pos.latitude, pos.longitude);
    getAddress(origin.position.latitude, origin.position.longitude);
  }

  getCurrentLocation() async {
    Location location = Location();
    LocationData locationData;
    locationData = await location.getLocation();
    position = Position(
        latitude: locationData.latitude, longitude: locationData.longitude);
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 15.0)));
  }

  Future<void> getAddress(double lat, double long) async {
    final coordinates = new Coordinates(lat, long);
    List<Address> addressFromGeocoder =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      address = addressFromGeocoder.first.addressLine;

      location = {
        'latitude': lat,
        'longitude': long,
        'adminArea': addressFromGeocoder.first.adminArea,
        'subLocality': addressFromGeocoder.first.subLocality,
        'locality': addressFromGeocoder.first.locality,
        'subAdminArea': addressFromGeocoder.first.subAdminArea,
        'address': address
      };
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
  }

  Future<dynamic> getUserData(String id) async {
    return firestore.collection('users').doc(id).get();
  }

  Future<void> getData() async {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    prefs = await SharedPreferences.getInstance();
    setState(() {
      user = jsonDecode(prefs.getString('user'));

      if(arguments['basketId']!=null) {
        basket = arguments['basketId'];
      }

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
            .collection('review')
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
      appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
          centerTitle: true,
          title: Text('Beli Langsung',
              style: TextStyle(
                color: Colors.black,
              )),
          iconTheme: IconThemeData(color: Colors.black)),
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
                                            SizedBox(height: 15),
                                            Text("Produk yang dibeli",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(height: 15),
                                            Row(
                                              children: [
                                                Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: CachedNetworkImage(
                                                      imageUrl: product
                                                          .data()['images'][0],
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                image:
                                                                    DecorationImage(
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
                                                    Text(
                                                        product.data()['title'],
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors
                                                                .grey[800])),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                        'Rp ' +
                                                            product.data()[
                                                                'price'],
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  top: 10,
                                                  bottom: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text("Jumlah",
                                                      style: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 14)),
                                                  SizedBox(width: 20),
                                                  Container(
                                                    height: 40,
                                                    width: 100,
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1,
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        GestureDetector(
                                                            onTap: () {
                                                              if (quantity !=
                                                                  0) {
                                                                setState(() {
                                                                  quantity =
                                                                      quantity -
                                                                          1;
                                                                });
                                                              }
                                                            },
                                                            child: Icon(
                                                                CupertinoIcons
                                                                    .minus,
                                                                size: 15)),
                                                        Text(
                                                            quantity.toString(),
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .PrimaryColor)),
                                                        GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                quantity =
                                                                    quantity +
                                                                        1;
                                                              });
                                                            },
                                                            child: Icon(
                                                                CupertinoIcons
                                                                    .add,
                                                                size: 15))
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                    SizedBox(height: 20),
                                    Container(
                                        height: 5,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200])),
                                    Container(
                                        padding: EdgeInsets.only(
                                            left: 100, right: 20),
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200])),
                                    SizedBox(height: 20),
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
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
                                            top: 10,
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
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(merchant.data()['name'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(height: 10),
                                                Text(merchant.data()['location']
                                                    ['subAdminArea']),
                                              ],
                                            )
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
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 10),
                                              Text(
                                                "Lokasi dan Pengiriman",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Container(
                                                height: size.width,
                                                width: size.width,
                                                padding: EdgeInsets.only(
                                                  top: 15,
                                                ),
                                                child: GoogleMap(
                                                  myLocationButtonEnabled: true,
                                                  zoomControlsEnabled: true,
                                                  initialCameraPosition:
                                                      initialCameraPosition,
                                                  onMapCreated: (controller) =>
                                                      {
                                                    googleMapController =
                                                        controller,
                                                    getCurrentLocation()
                                                  },
                                                  markers: {
                                                    if (origin != null) origin,
                                                  },
                                                  onLongPress: addMarker,
                                                ),
                                              ),
                                              SizedBox(height: 10.0),
                                              address != null
                                                  ? Text(address)
                                                  : Text(''),
                                            ])),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                        height: 5,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200])),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 10),
                                              Text(
                                                "Total biaya",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                  'Rp ' +
                                                      (int.parse(product.data()[
                                                                  'price']) *
                                                              quantity)
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: AppColors
                                                          .PrimaryColor,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ]))
                                  ]))
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
                          SizedBox(height: 50.0),
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
                    child: GestureDetector(
                        onTap: () async {
                          EasyLoading.show();

                          if (location == null) {
                            EasyLoading.dismiss();
                            SweetAlert.show(context,
                                subtitle: "Lokasi tidak valid",
                                style: SweetAlertStyle.confirm);
                            return;
                          }

                          if(basket!=null) {
                            await firestore
                              .collection('baskets')
                              .doc(basket)
                              .delete();
                          }

                          await firestore
                            .collection('merchants')
                            .doc(merchant.id)
                            .update({
                              'transaction': {
                                'request': merchant.data()['transaction']['request']+1,
                                'deliver': merchant.data()['transaction']['deliver'],
                                'pay': merchant.data()['transaction']['pay'],
                                'success': merchant.data()['transaction']['success'],
                                'failed': merchant.data()['transaction']['failed'],
                              }
                            });

                          await firestore.collection('orders').add({
                            'user': user['id'],
                            'merchant': merchant.id,
                            'items': [
                              {
                                'product': product.id,
                                'quantity': quantity,
                                'price': int.parse(product.data()['price']) *
                                    quantity
                              }
                            ],
                            'totalPrice':
                                int.parse(product.data()['price']) * quantity,
                            'location': location,
                            'accepted': '',
                            'pay': '',
                            'delivered': '',
                            'finished': '',
                            'rating': 0,
                            'read': null,
                            'updatedBy': user['id'],
                            'updated': FieldValue.serverTimestamp(),
                            'created': FieldValue.serverTimestamp()
                          }).then((result) async {
                            await firestore.collection('notifications').add({
                              'from': user['id'],
                              'to': merchant.id,
                              'title':
                                  "Pesanan baru " + product.data()['title'],
                              'description': quantity.toString() +
                                  ' ' +
                                  product.data()['title'] +
                                  ' telah dipesan oleh ' +
                                  user['name'],
                              'type': 'order',
                              'data': result.id,
                              'thumbnail': product.data()['images'][0],
                              'read': null,
                              'created': FieldValue.serverTimestamp()
                            }).then((result) {});
                            await firestore
                                .collection('users')
                                .doc(merchant.data()['user'])
                                .get()
                                .then((document) async {
                              http.Response response = await http.post(
                                Uri.parse(
                                    'https://fcm.googleapis.com/fcm/send'),
                                headers: <String, String>{
                                  'Content-Type': 'application/json',
                                  'Authorization':
                                      'key=AAAAIm6AsJQ:APA91bGT81ymffaQJDAyZrOugf57o3DJTsLmjonfmX393M8Oaeb8Yj773T0I4VJugTBAEMq9ukFgez05titoCbNw4KQIFGuhS4DxQiuIRklAKYRZ_IIqOquhlMne-WxyKEtxNwRnBOPE',
                                },
                                body: jsonEncode(
                                  <String, dynamic>{
                                    'notification': <String, dynamic>{
                                      'title': 'Pesanan baru',
                                      'body': 'Ada pesanan ' +
                                          product.data()['title'] +
                                          ' baru',
                                    },
                                    'priority': 'high',
                                    'data': <String, dynamic>{
                                      'click_action':
                                          'FLUTTER_NOTIFICATION_CLICK',
                                      'id': '1',
                                      'status': 'done'
                                    },
                                    'to': document.data()['fcmToken'],
                                  },
                                ),
                              );
                              EasyLoading.showSuccess('Produk dibeli',
                                  duration: Duration(seconds: 1));

                              Future.delayed(const Duration(milliseconds: 1000),
                                  () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/dashboard',
                                    (Route<dynamic> route) => false);
                              });
                            });
                          });
                        },
                        child: Container(
                          width: size.width * 0.85,
                          height: 70,
                          decoration:
                              BoxDecoration(color: AppColors.PrimaryColor),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.shopping_cart,
                                  color: Colors.white),
                              SizedBox(width: 20),
                              Text('Beli',
                                  style: TextStyle(color: Colors.white))
                            ],
                          ),
                        )),
                  ))
            ],
          )),
    );
  }
}
