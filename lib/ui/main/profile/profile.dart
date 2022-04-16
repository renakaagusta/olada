import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:olada/model/user.dart';
import 'package:olada/constants/assets.dart';
import 'package:olada/constants/colors.dart';
import 'package:olada/constants/strings.dart';
import 'package:olada/constants/data.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var picker = ImagePicker();
  List<File> images = [];
  TextEditingController captionController = TextEditingController();
  dynamic location;
  dynamic user;
  List<dynamic> posts;
  Position position = Position(latitude: -7.2941646, longitude: 112.7986343);
  String address;
  List<String> hobbies = [];
  static const initialCameraPosition = CameraPosition(
    target: LatLng(-7.2941646, 112.7986343),
    zoom: 11.5,
  );
  GoogleMapController googleMapController;
  Marker origin, destination;
  bool mapsDialog = false, hobbiesDialog = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  SharedPreferences prefs;
  Size size;

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
      };
    });
  }

  Future getImagefromGallery(String type) async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);
    setState(() {
      if (pickedFile != null) {
        if (type == 'post') {
          List<File> _images = images;
          _images.add(File(pickedFile.path));
          setState(() {
            images = _images;
          });
        } else if (type == 'profile') {
          changeImageProfile(File(pickedFile.path));
        }
      } else {
        print('No image selected.');
      }
    });
  }

  void changeImageProfile(File file) async {
    EasyLoading.show();
    String imageUrl = await uploadImage(file, 'profile', user['id']);
    firestore
        .collection('users')
        .doc(user['id'])
        .update({'picture': imageUrl}).then((result) {
      dynamic newUser = user;
      newUser['picture'] = imageUrl;
      prefs.setString('user', jsonEncode(newUser));
      EasyLoading.dismiss();
      setState(() {
        user = newUser;
      });
    });
  }

  void removeImage(int index) {
    List<File> _images = images;
    images.removeAt(index);
    setState(() {
      images = _images;
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

  Future<List<String>> uploadImages(
      List<File> images, String type, String id) async {
    var imageUrls = await Future.wait(
        images.map((image) async => await uploadImage(image, type, id)));
    return imageUrls;
  }

  Future<void> getData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      user = jsonDecode(
          prefs.getString("user") != null ? prefs.getString("user") : '{}');

      firestore
          .collection('posts')
          .where('user', isEqualTo: user['id'])
          .get()
          .then((snapshots) {
        setState(() {
          posts = snapshots.docs;
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
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    getData();
    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            child: Column(children: [
              if (user != null)
                Container(
                  padding:
                      EdgeInsets.only(top: 60, bottom: 40, left: 20, right: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      AppColors.PrimaryColor,
                      AppColors.SecondaryColor
                    ]),
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
                              child: user['picture'] != null
                                  ? CachedNetworkImage(
                                      imageUrl: user['picture'],
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        )),
                                      ),
                                    )
                                  : Container(),
                            ),
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user['name'] != null ? user['name'] : '',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(height: 10),
                              Text('088806875205',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white)),
                              SizedBox(height: 10),
                              Text(user['email'] != null ? user['email'] : '',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white)),
                            ],
                          ),
                        ],
                      ),
                      Icon(CupertinoIcons.pencil, color: Colors.white, size: 30)
                    ],
                  ),
                ),
              Container(
                  decoration: BoxDecoration(color: Colors.white),
                  padding: EdgeInsets.only(
                      left: 25, right: 25, top: 10.0, bottom: 20),
                  child: user != null
                      ? user['name'] != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(top: 20.0),
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Pesanan',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 20.0),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                '/profile/setting/edit');
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pushNamed('/order',
                                                          arguments: {
                                                        'role': 'user',
                                                        'status': 'unpaid'
                                                      });
                                                },
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      child: Icon(
                                                          CupertinoIcons
                                                              .money_dollar_circle,
                                                          size: 30),
                                                    ),
                                                    SizedBox(
                                                      height: 15.0,
                                                    ),
                                                    Text('Belum bayar',
                                                        style: TextStyle(
                                                            fontSize: 14.0))
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pushNamed('/order',
                                                          arguments: {
                                                        'role': 'user',
                                                        'status': 'packaged'
                                                      });
                                                },
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      child: Icon(
                                                          CupertinoIcons
                                                              .cube_box,
                                                          size: 30),
                                                    ),
                                                    SizedBox(
                                                      height: 15.0,
                                                    ),
                                                    Text('Dikemas',
                                                        style: TextStyle(
                                                            fontSize: 14.0))
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pushNamed('/order',
                                                          arguments: {
                                                        'role': 'user',
                                                        'status': 'delivered'
                                                      });
                                                },
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      child: Icon(
                                                          CupertinoIcons.share,
                                                          size: 30),
                                                    ),
                                                    SizedBox(
                                                      height: 15.0,
                                                    ),
                                                    Text('Dikirim',
                                                        style: TextStyle(
                                                            fontSize: 14.0))
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            '/order',
                                                            arguments: {
                                                          'role': 'user',
                                                          'status': 'finished'
                                                        });
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        child: Icon(
                                                            CupertinoIcons.star,
                                                            size: 30),
                                                      ),
                                                      SizedBox(
                                                        height: 15.0,
                                                      ),
                                                      Text('Penilaian',
                                                          style: TextStyle(
                                                              fontSize: 14.0))
                                                    ],
                                                  ))
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 30.0),
                                        Text(
                                          'Akun',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 20.0),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                '/profile/setting/edit');
                                          },
                                          child: Row(
                                            children: [
                                              Container(
                                                child: Icon(
                                                    CupertinoIcons
                                                        .profile_circled,
                                                    size: 30),
                                              ),
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              Text('Edit profil',
                                                  style:
                                                      TextStyle(fontSize: 18.0))
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 20.0),
                                        GestureDetector(
                                          onTap: () {
                                            if (user['merchant'] == null) {
                                              Navigator.of(context).pushNamed(
                                                  '/profile/merchant/register');
                                            } else {
                                              Navigator.of(context).pushNamed(
                                                  '/profile/merchant');
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              Container(
                                                child: Icon(
                                                    CupertinoIcons
                                                        .shopping_cart,
                                                    size: 30),
                                              ),
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              Text('Toko',
                                                  style:
                                                      TextStyle(fontSize: 18.0))
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 30.0),
                                        Text(
                                          'Aplikasi',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 20.0),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .pushNamed('/profile/privacy');
                                          },
                                          child: Row(
                                            children: [
                                              Container(
                                                child: Icon(
                                                    CupertinoIcons.shield,
                                                    size: 30),
                                              ),
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              Text('Kebijakan dan Privasi',
                                                  style:
                                                      TextStyle(fontSize: 18.0))
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 20.0),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .pushNamed('/profile/version');
                                          },
                                          child: Row(
                                            children: [
                                              Container(
                                                child: Icon(
                                                    CupertinoIcons.info_circle,
                                                    size: 30),
                                              ),
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              Text('Versi',
                                                  style:
                                                      TextStyle(fontSize: 18.0))
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 30.0),
                                        Text(
                                          'Navigasi',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 20.0),
                                        GestureDetector(
                                          onTap: () async {
                                            Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                                    '/signin',
                                                    (Route<dynamic> route) =>
                                                        false);
                                            await GoogleSignIn().signOut();
                                            prefs.clear();
                                          },
                                          child: Row(
                                            children: [
                                              Container(
                                                child: Icon(
                                                    CupertinoIcons.arrow_left),
                                              ),
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              Text('Sign out',
                                                  style:
                                                      TextStyle(fontSize: 18.0))
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            )
                          : Container()
                      : Center(
                          child: CircularProgressIndicator(
                            color: AppColors.PrimaryColor,
                          ),
                        )),
            ]),
          ),
        ),
      ],
    );
  }
}
