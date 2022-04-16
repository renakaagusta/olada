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
import 'package:path/path.dart' as path;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:olada/constants/assets.dart';
import 'package:olada/constants/colors.dart';
import 'package:olada/constants/strings.dart';

class ProductMerchantScreen extends StatefulWidget {
  @override
  _ProductMerchantScreenState createState() => _ProductMerchantScreenState();
}

class _ProductMerchantScreenState extends State<ProductMerchantScreen> {
  var picker = ImagePicker();
  dynamic product;
  dynamic user;
  dynamic merchant;
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
  TextEditingController productTitleController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  String productCategory;
  String productType;
  List<dynamic> categories;
  List<File> images;
  Size size;

  Future<void> getData() async {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    prefs = await SharedPreferences.getInstance();
    setState(() {
      user = jsonDecode(prefs.getString("user"));
      firestore.collection('categories').get().then((snapshot) async {
        setState(() {
          categories = snapshot.docs;
        });
      });
      if (arguments == null) {
      } else {
        firestore
            .collection('products')
            .doc(arguments['productId'])
            .get()
            .then((document) {
          setState(() {
            product = document;
            productTitleController.text = product.data()['title'];
            productDescriptionController.text = product.data()['decription'];
            productPriceController.text = product.data()['price'];
            location = product.data()['location'];
          });
        });
      }
    });
  }

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

  Future<String> uploadImage(File image, String type, String id) async {
    firebase_storage.UploadTask task;

    task = firebase_storage.FirebaseStorage.instance
        .ref('images/$type/$id/${path.basename(image.path)}')
        .putFile(image);

    task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
      print('Task state: ${snapshot.state}');
      print(
          'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
    }, onError: (e) {
      print(task.snapshot);

      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    });

    try {
      var dowurl = await (await task).ref.getDownloadURL();
      return dowurl.toString();
    } on firebase_core.FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    }
  }

  Future<List<String>> uploadImages(
      List<File> images, String type, String id) async {
    var imageUrls = await Future.wait(
        images.map((image) async => await uploadImage(image, type, id)));
    return imageUrls;
  }

  Future getImagefromGallery() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);
    setState(() {
      if (pickedFile != null) {
        List<File> _images = images == null ? [] : images;
        _images.add(File(pickedFile.path));
        setState(() {
          images = _images;
        });
      } else {
        print('No image selected.');
      }
    });
  }

  void removeImage(int index) {
    List<File> _images = images;
    images.removeAt(index);
    setState(() {
      images = _images;
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
          title: Text('Produk',
              style: TextStyle(
                color: Colors.black,
              )),
          iconTheme: IconThemeData(color: Colors.black)),
      body: (user != null)
          ? Container(
              height: size.height,
              width: size.width,
              padding: EdgeInsets.only(top: 20),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.only(top: 10, left: 20.0, right: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Text('Nama produk',
                                    style: TextStyle(fontSize: 12)),
                              ),
                              TextFieldWidget(
                                hint: 'Nama produk',
                                icon: Icons.person,
                                textController: productTitleController,
                                inputAction: TextInputAction.next,
                                autoFocus: false,
                                errorText: "",
                              ),
                              SizedBox(height: 24.0),
                              Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Text('Deskripsi produk',
                                    style: TextStyle(fontSize: 12)),
                              ),
                              TextFieldWidget(
                                hint: 'Deskripsi produk',
                                icon: Icons.person,
                                textController: productDescriptionController,
                                inputAction: TextInputAction.next,
                                autoFocus: false,
                                errorText: "",
                                maxLines: 5,
                              ),
                              SizedBox(height: 24.0),
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Text('Foto produk',
                                    style: TextStyle(fontSize: 14)),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: size.width,
                                width: size.width,
                                margin: EdgeInsets.only(left: 10, right: 10),
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 20, bottom: 20),
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10)),
                                child: images == null
                                    ? Container(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(CupertinoIcons.camera,
                                                size: 80,
                                                color: Colors.grey[700]),
                                            SizedBox(height: 10),
                                            Text('Tambahkan foto produk'),
                                            SizedBox(height: 20),
                                            GestureDetector(
                                                onTap: () async {
                                                  getImagefromGallery();
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 10.0),
                                                  height: 45.0,
                                                  width: 100,
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
                                                    'Pilih foto',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.0),
                                                  ),
                                                )),
                                          ],
                                        ))
                                    : GridView.count(
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 15,
                                        mainAxisSpacing: 20,
                                        children: List.generate(
                                            images.length + 1, (index) {
                                          return index < images.length
                                              ? Container(
                                                  height: 140,
                                                  width: 140,
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Image.file(
                                                        images[index],
                                                        fit: BoxFit.cover,
                                                      )))
                                              : GestureDetector(
                                                  child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color:
                                                              Colors.grey[400]),
                                                      child: Icon(
                                                          CupertinoIcons.add)),
                                                  onTap: () =>
                                                      getImagefromGallery());
                                        }),
                                      ),
                              ),
                              SizedBox(height: 20.0),
                              Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Text('Harga produk',
                                    style: TextStyle(fontSize: 12)),
                              ),
                              TextFieldWidget(
                                hint: 'Harga',
                                icon: Icons.person,
                                textController: productPriceController,
                                inputAction: TextInputAction.next,
                                autoFocus: false,
                                errorText: "",
                                maxLines: 5,
                                inputType: TextInputType.number,
                              ),
                              SizedBox(height: 20.0),
                              Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Text('Kategori produk',
                                    style: TextStyle(fontSize: 12)),
                              ),
                              SizedBox(height: 10.0),
                              Container(
                                width: 300.0,
                                child: DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton(
                                        value: productCategory,
                                        items: <String>[
                                          'Jajan kering',
                                          'Aneka Makanan',
                                          'Makanan berat',
                                          'Roti rotian',
                                          'Lainnya'
                                        ].map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (choosedCategory) {
                                          setState(() {
                                            productCategory = choosedCategory;
                                          });
                                        },
                                      )),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Text('Jenis produk',
                                    style: TextStyle(fontSize: 12)),
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Radio(
                                    value: 'Tradisional',
                                    groupValue: productType,
                                    activeColor: AppColors.SecondaryColor,
                                    onChanged: (value) {
                                      setState(() {
                                        productType = value;
                                      });
                                    },
                                  ),
                                  Text(
                                    'Tradisional',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  Radio(
                                    value: 'Modern',
                                    groupValue: productType,
                                    activeColor: AppColors.SecondaryColor,
                                    onChanged: (value) {
                                      setState(() {
                                        productType = value;
                                      });
                                    },
                                  ),
                                  new Text(
                                    'Modern',
                                    style: new TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                              if (productType == 'Tradisional')
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 24.0),
                                    Container(
                                      margin: EdgeInsets.only(left: 15),
                                      child: Text('Asal daerah',
                                          style: TextStyle(fontSize: 14)),
                                    ),
                                    Container(
                                      height: size.width,
                                      width: size.width,
                                      padding: EdgeInsets.only(
                                          top: 15, left: 15, right: 15),
                                      child: GoogleMap(
                                        myLocationButtonEnabled: true,
                                        zoomControlsEnabled: true,
                                        initialCameraPosition:
                                            initialCameraPosition,
                                        gestureRecognizers: Set()
                                          ..add(Factory<PanGestureRecognizer>(
                                              () => PanGestureRecognizer()))
                                          ..add(
                                            Factory<VerticalDragGestureRecognizer>(
                                                () =>
                                                    VerticalDragGestureRecognizer()),
                                          )
                                          ..add(
                                            Factory<HorizontalDragGestureRecognizer>(
                                                () =>
                                                    HorizontalDragGestureRecognizer()),
                                          )
                                          ..add(
                                            Factory<ScaleGestureRecognizer>(
                                                () => ScaleGestureRecognizer()),
                                          ),
                                        onMapCreated: (controller) => {
                                          googleMapController = controller,
                                          getCurrentLocation()
                                        },
                                        markers: {
                                          if (origin != null) origin,
                                        },
                                        onLongPress: addMarker,
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: address != null
                                          ? Text(location['subAdminArea'] +
                                              ", " +
                                              location['adminArea'])
                                          : Text(''),
                                    ),
                                  ],
                                ),
                              SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      child: Container(
                        height: 80,
                        width: size.width,
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 10, left: 20, right: 20),
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                              color: Color(0xffdddddd).withOpacity(0.5),
                              spreadRadius: 3,
                              offset: Offset(1, 2),
                              blurRadius: 0.5)
                        ]),
                        child: GestureDetector(
                            onTap: () async {
                              EasyLoading.show();

                              if (productTitleController.text.isEmpty) {
                                EasyLoading.dismiss();
                                SweetAlert.show(context,
                                    subtitle: "Nama produk tidak valid",
                                    style: SweetAlertStyle.confirm);
                                return;
                              }

                              if (productTitleController.text.length < 8) {
                                EasyLoading.dismiss();
                                SweetAlert.show(context,
                                    subtitle: "Nama produk tidak valid",
                                    style: SweetAlertStyle.confirm);
                                return;
                              }

                              if (productDescriptionController
                                      .text.isNotEmpty &&
                                  productDescriptionController.text.length <
                                      8) {
                                EasyLoading.dismiss();
                                SweetAlert.show(context,
                                    subtitle: "Deskripsi produk tidak valid",
                                    style: SweetAlertStyle.confirm);
                                return;
                              }

                              if (productPriceController.text.isEmpty) {
                                EasyLoading.dismiss();
                                SweetAlert.show(context,
                                    subtitle: "Harga produk tidak valid",
                                    style: SweetAlertStyle.confirm);
                                return;
                              }

                              if (productCategory == null) {
                                EasyLoading.dismiss();
                                SweetAlert.show(context,
                                    subtitle: "Kategori tidak valid",
                                    style: SweetAlertStyle.confirm);
                                return;
                              }

                              if (productType == null) {
                                EasyLoading.dismiss();
                                SweetAlert.show(context,
                                    subtitle: "Jenis produk tidak valid",
                                    style: SweetAlertStyle.confirm);
                                return;
                              }

                              if (productType == 'Tradisional' &&
                                  location == null) {
                                EasyLoading.dismiss();
                                SweetAlert.show(context,
                                    subtitle: "Lokasi tidak valid",
                                    style: SweetAlertStyle.confirm);
                                return;
                              }

                              if (product == null) {
                                firestore.collection('products').add({
                                  'title': productTitleController.text,
                                  'description':
                                      productDescriptionController.text,
                                  'price': productPriceController.text,
                                  'type': productType,
                                  'category': productCategory,
                                  'location':
                                      location != null ? location : null,
                                  'merchant': user['merchant']['id'],
                                  'likes': 0,
                                  'review': 0,
                                  'rating': 0,
                                  'comments': 0,
                                  'orders': 0,
                                  'view': 0,
                                  'created': FieldValue.serverTimestamp()
                                }).then((result) async {
                                  List<String> imageUrls = await uploadImages(
                                      images, 'products', result.id);

                                  firestore
                                      .collection('products')
                                      .doc(result.id)
                                      .update({'images': imageUrls}).then(
                                          (result) {
                                    EasyLoading.dismiss();
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            '/profile/merchant',
                                            (Route<dynamic> route) => false);
                                  });
                                });
                              } else {
                                await firestore
                                    .collection('merchants')
                                    .doc(user['merchant']['id'])
                                    .update({
                                  'name': productTitleController.text,
                                  'description':
                                      productDescriptionController.text,
                                  'location': location,
                                  'updated': FieldValue.serverTimestamp()
                                });
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/profile/merchant',
                                    (Route<dynamic> route) => false);
                              }

                              getData();
                              EasyLoading.showSuccess('Produk disimpan',
                                  duration: Duration(seconds: 1));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              height: 45.0,
                              width: 100,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    AppColors.PrimaryColor,
                                    AppColors.SecondaryColor
                                  ]),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Text(
                                'Simpan',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            )),
                      ))
                ],
              ))
          : Container(),
    );
  }
}
