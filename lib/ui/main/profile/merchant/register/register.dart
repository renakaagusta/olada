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

class RegisterMerchantScreen extends StatefulWidget {
  @override
  _RegisterMerchantScreenState createState() => _RegisterMerchantScreenState();
}

class _RegisterMerchantScreenState extends State<RegisterMerchantScreen> {
  var picker = ImagePicker();
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
        .ref('images/$type/$id/${basename(image.path)}')
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

  void changeImageProfile(File file) async {
    EasyLoading.show();
    String imageUrl =
        await uploadImage(file, 'merchant', user['id']['merchant']);

    firestore
        .collection('merchants')
        .doc(user['merchant']['id'])
        .update({'picture': imageUrl}).then((result) {
      dynamic newUser = user;
      newUser['merchant']['picture'] = imageUrl;
      prefs.setString('user', jsonEncode(newUser));
      EasyLoading.dismiss();
      setState(() {
        user = newUser;
      });
    });
  }

  Future getImagefromGallery(String type) async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);
    setState(() {
      if (pickedFile != null) {
        changeImageProfile(File(pickedFile.path));
      } else {
        print('No image selected.');
      }
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
          title: Text('Buka Toko',
              style: TextStyle(
                color: Colors.black,
              )),
          iconTheme: IconThemeData(color: Colors.black)),
      body: (user != null)
          ? Container(
              height: size.height,
              width: size.width,
              padding: EdgeInsets.only(top: 40),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (user['merchant'] != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 4,
                                          color: AppColors.PrimaryColor),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(75)),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(75),
                                      child: CachedNetworkImage(
                                        imageUrl: user['merchant']['picture'],
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          )),
                                        ),
                                      ))),
                              Container(
                                height: 35,
                                width: 35,
                                padding: EdgeInsets.all(5),
                                transform:
                                    Matrix4.translationValues(0.0, -40.0, 0.0),
                                decoration: BoxDecoration(
                                    color: AppColors.PrimaryColor,
                                    borderRadius: BorderRadius.circular(40)),
                                child: GestureDetector(
                                    child: Icon(CupertinoIcons.camera,
                                        color: Colors.white, size: 20),
                                    onTap: () {
                                      getImagefromGallery('profile');
                                    }),
                              ),
                            ],
                          ),
                        Container(
                            child: (user['name'] != null)
                                ? Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(70.0)),
                                        child: CachedNetworkImage(
                                          imageUrl: user['picture'],
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
                                      Positioned(
                                          bottom: 5,
                                          right: 5,
                                          child: GestureDetector(
                                            onTap: () =>
                                                getImagefromGallery('profile'),
                                            child: Container(
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                    gradient:
                                                        LinearGradient(colors: [
                                                      AppColors.PrimaryColor,
                                                      AppColors.SecondaryColor
                                                    ]),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                child: Icon(
                                                  CupertinoIcons.camera,
                                                  color: Colors.white,
                                                  size: 20,
                                                )),
                                          ))
                                    ],
                                  )
                                : Container(height: size.height * 0.3)),
                        Container(
                          padding:
                              EdgeInsets.only(top: 10, left: 20.0, right: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Text('Nama toko',
                                    style: TextStyle(fontSize: 12)),
                              ),
                              TextFieldWidget(
                                hint: 'Nama toko',
                                icon: Icons.person,
                                textController: displayNameController,
                                inputAction: TextInputAction.next,
                                autoFocus: false,
                                errorText: "",
                              ),
                              SizedBox(height: 24.0),
                              Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Text('Deskripsi',
                                    style: TextStyle(fontSize: 12)),
                              ),
                              TextFieldWidget(
                                hint: 'Deskripsi',
                                icon: Icons.person,
                                textController: descriptionController,
                                inputAction: TextInputAction.next,
                                autoFocus: false,
                                errorText: "",
                                maxLines: 5,
                              ),
                              SizedBox(height: 20.0),
                              Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Text('Lokasi',
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
                                  initialCameraPosition: initialCameraPosition,
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
                              address != null ? Text(address) : Text(''),
                              SizedBox(height: 80),
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

                              if (displayNameController.text.isEmpty) {
                                EasyLoading.dismiss();
                                SweetAlert.show(context,
                                    subtitle: "Nama toko tidak valid",
                                    style: SweetAlertStyle.confirm);
                                return;
                              }

                              if (displayNameController.text.length < 8) {
                                EasyLoading.dismiss();
                                SweetAlert.show(context,
                                    subtitle: "Nama toko tidak valid",
                                    style: SweetAlertStyle.confirm);
                                return;
                              }

                              if (descriptionController.text.isNotEmpty &&
                                  descriptionController.text.length < 8) {
                                EasyLoading.dismiss();
                                SweetAlert.show(context,
                                    subtitle: "Deskripsi tidak valid",
                                    style: SweetAlertStyle.confirm);
                                return;
                              }

                              if (location == null) {
                                EasyLoading.dismiss();
                                SweetAlert.show(context,
                                    subtitle: "Lokasi tidak valid",
                                    style: SweetAlertStyle.confirm);
                                return;
                              }

                              if (user['merchant'] == null) {
                                await firestore.collection('merchants').add({
                                  'name': displayNameController.text,
                                  'picture': Strings.defaultMerchantPictureUrl,
                                  'description': descriptionController.text,
                                  'location': location,
                                  'followers': 0,
                                  'rating': 0,
                                  'transaction': {
                                    'success': 0,
                                    'failed': 0,
                                    'request': 0,
                                    'pay': 0,
                                    'packaged': 0,
                                    'deliver': 0,
                                  },
                                  'balance': 0,
                                  'type': 'Regular',
                                  'status': 'active',
                                  'user': user['id'],
                                }).then((result) {
                                  firestore
                                      .collection('merchants')
                                      .doc(result.id)
                                      .get()
                                      .then((document) async {
                                    firestore
                                        .collection('users')
                                        .doc(user['id'])
                                        .update({'merchant': result.id});
                                    dynamic newUser = user;
                                    newUser['merchant'] = document.data();
                                    newUser['merchant']['id'] = result.id;
                                    await prefs.setString(
                                        'user', jsonEncode(newUser));

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
                                  'name': displayNameController.text,
                                  'description': descriptionController.text,
                                  'location': location
                                });

                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/profile/merchant',
                                    (Route<dynamic> route) => false);
                              }

                              dynamic newUser = user;
                              newUser['displayName'] =
                                  displayNameController.text;
                              newUser['email'] = emailController.text;
                              newUser['phoneNumber'] =
                                  phoneNumberController.text;

                              prefs.setString('user', jsonEncode(newUser));
                              getData();
                              EasyLoading.showSuccess(
                                  'Toko berhasil dibuka',
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
