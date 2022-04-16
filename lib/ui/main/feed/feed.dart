import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path/path.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:olada/api/api_service.dart';
import 'package:olada/model/order.dart';
import 'package:olada/utils/timeago/timeago.dart';
import 'package:olada/constants/assets.dart';
import 'package:olada/constants/colors.dart';
import 'package:olada/constants/strings.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with TickerProviderStateMixin {
  ApiService apiService = ApiService();

  var picker = ImagePicker();
  List<dynamic> postUserLikes = [];
  List<dynamic> posts = [];

  List<dynamic> notifications = [];
  List<dynamic> chats = [];
  List<dynamic> filteredPosts = [];
  Position position = Position(latitude: -7.2941646, longitude: 112.7986343);
  List<dynamic> users = [];
  List<dynamic> likes = [];
  List<File> images = [];
  TextEditingController captionController = TextEditingController();
  int status = 0;
  dynamic user;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Size size;
  bool loading = true;
  dynamic location;
  String address;
  static const initialCameraPosition = CameraPosition(
    target: LatLng(-7.2941646, 112.7986343),
    zoom: 11.5,
  );
  GoogleMapController googleMapController;
  Marker origin, destination;
  bool mapsDialog = false, hobbiesDialog = false;
  SharedPreferences prefs;

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

  Future<dynamic> getCreatorData(dynamic data) async {
    return data['merchant'] != null
        ? firestore.collection('merchants').doc(data.data()['merchant']).get()
        : firestore.collection('users').doc(data.data()['user']).get();
  }

  Future<dynamic> getLikesData(String id) async {
    return firestore.collection('posts').doc(id).collection('likes').get();
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user = jsonDecode(prefs.getString('user'));
      firestore
          .collection('posts')
          .orderBy('created', descending: true)
          .get()
          .then((snapshot) async {
        users = await Future.wait(
            snapshot.docs.map((doc) async => await getCreatorData(doc)));
        likes = await Future.wait(
            snapshot.docs.map((doc) async => await getLikesData(doc.id)));
        firestore
            .collection('notifications')
            .where('to', isEqualTo: user['id'])
            .where('read', isEqualTo: null)
            .get()
            .then((snapshot) async {
          setState(() {
            notifications = notifications + snapshot.docs;
          });
        });
        firestore
            .collection('notifications')
            .where('to',
                isEqualTo:
                    user['merchant'] != null ? user['merchant']['id'] : '')
            .where('read', isEqualTo: null)
            .get()
            .then((snapshot) async {
          setState(() {
            notifications = notifications + snapshot.docs;
          });
        });
        firestore
            .collection('chats')
            .where('members', arrayContains: user['id'])
            .where('updatedBy', isNotEqualTo: user['id'])
            .where('type', isEqualTo: 'personal')
            .where('read', isEqualTo: null)
            .get()
            .then((snapshot) {
          chats = chats + snapshot.docs;
        });
        firestore
            .collection('chats')
            .where('members',
                arrayContains:
                    user['merchant'] != null ? user['merchant']['id'] : '')
            .where('updatedBy',
                isNotEqualTo:
                    user['merchant'] != null ? user['merchant']['id'] : '')
            .where('type', isEqualTo: 'personal')
            .where('read', isEqualTo: null)
            .get()
            .then((snapshot) {
          chats = chats + snapshot.docs;
        });
        setState(() {
          loading = false;
          posts = snapshot.docs;
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
    getData();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    size = MediaQuery.of(context).size;
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemStatusBarContrastEnforced: true,
            ),
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    child: SingleChildScrollView(
                        child: Container(
                            padding: EdgeInsets.only(
                              top: 40.0,
                            ),
                            width: size.width,
                            child: Column(
                              children: [
                                (!loading)
                                    ? (posts.length > 0)
                                        ? Container(
                                            constraints: BoxConstraints(
                                                minHeight: 100,
                                                maxHeight: size.height),
                                            padding:
                                                EdgeInsets.only(bottom: 100),
                                            child: RefreshIndicator(
                                                color: AppColors.PrimaryColor,
                                                onRefresh: getData,
                                                child: ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    itemCount: posts.length + 1,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return index == 0
                                                          ? Container(
                                                              width: size.width,
                                                              padding:
                                                                  EdgeInsets.all(
                                                                      20),
                                                              margin:
                                                                  EdgeInsets.only(
                                                                      left: 20,
                                                                      right: 20,
                                                                      top: 20,
                                                                      bottom:
                                                                          20),
                                                              decoration: BoxDecoration(
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.2),
                                                                      spreadRadius:
                                                                          1,
                                                                      blurRadius:
                                                                          2,
                                                                      offset:
                                                                          Offset(
                                                                              1,
                                                                              2),
                                                                    ),
                                                                  ],
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              child: Column(
                                                                children: [
                                                                  if (address !=
                                                                      null)
                                                                    Container(
                                                                        child:
                                                                            Column(
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Icon(CupertinoIcons.location_solid),
                                                                                SizedBox(width: 10),
                                                                                Text('Location')
                                                                              ],
                                                                            ),
                                                                            GestureDetector(
                                                                                child: Icon(CupertinoIcons.xmark),
                                                                                onTap: () {
                                                                                  setState(() {
                                                                                    address = null;
                                                                                  });
                                                                                })
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                20),
                                                                        Text(
                                                                            address),
                                                                        SizedBox(
                                                                            height:
                                                                                20),
                                                                        Container(
                                                                            height:
                                                                                1,
                                                                            width:
                                                                                size.width,
                                                                            decoration: BoxDecoration(color: Colors.grey[350])),
                                                                        SizedBox(
                                                                            height:
                                                                                20),
                                                                      ],
                                                                    )),
                                                                  TextField(
                                                                    controller:
                                                                        captionController,
                                                                    textCapitalization:
                                                                        TextCapitalization
                                                                            .sentences,
                                                                    maxLines: 5,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14),
                                                                    decoration:
                                                                        InputDecoration
                                                                            .collapsed(
                                                                      hintText:
                                                                          "What do yo want to tell to everyone?",
                                                                    ),
                                                                  ),
                                                                  if (images
                                                                          .length >
                                                                      0)
                                                                    Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              10),
                                                                      decoration: BoxDecoration(
                                                                          color: Colors.grey[
                                                                              100],
                                                                          borderRadius:
                                                                              BorderRadius.circular(5)),
                                                                      child:
                                                                          ConstrainedBox(
                                                                        constraints: BoxConstraints(
                                                                            maxHeight:
                                                                                200,
                                                                            minHeight:
                                                                                100.0),
                                                                        child: GridView
                                                                            .count(
                                                                          shrinkWrap:
                                                                              true,
                                                                          physics:
                                                                              BouncingScrollPhysics(),
                                                                          crossAxisCount:
                                                                              2,
                                                                          crossAxisSpacing:
                                                                              15,
                                                                          mainAxisSpacing:
                                                                              20,
                                                                          children: List.generate(
                                                                              images.length + 1,
                                                                              (index) {
                                                                            return index < images.length
                                                                                ? GestureDetector(
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Container(
                                                                                            height: 90,
                                                                                            width: 90,
                                                                                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                                                                            child: Image.file(
                                                                                              images[index],
                                                                                              fit: BoxFit.cover,
                                                                                            )),
                                                                                        Container(
                                                                                          transform: Matrix4.translationValues(0.0, -60.0, 0.0),
                                                                                          child: Icon(
                                                                                            CupertinoIcons.minus_circle,
                                                                                            color: Colors.grey,
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    onTap: () {
                                                                                      removeImage(index);
                                                                                    })
                                                                                : GestureDetector(child: Container(decoration: BoxDecoration(color: Colors.grey[300]), child: Icon(CupertinoIcons.add)), onTap: () => getImagefromGallery('post'));
                                                                          }),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                getImagefromGallery('post');
                                                                              },
                                                                              child: Container(height: 35, width: 35, padding: EdgeInsets.all(5), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(40)), child: Icon(CupertinoIcons.camera_fill, color: AppColors.PrimaryColor, size: 20)),
                                                                            ),
                                                                            SizedBox(width: 10),
                                                                            GestureDetector(
                                                                              child: Container(height: 35, width: 35, padding: EdgeInsets.all(5), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(40)), child: Icon(CupertinoIcons.location_solid, color: AppColors.PrimaryColor, size: 20)),
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  mapsDialog = true;
                                                                                });
                                                                              },
                                                                            )
                                                                          ],
                                                                        ),
                                                                        GestureDetector(
                                                                            onTap:
                                                                                () async {
                                                                              if(user['merchant']==null) {
                                                                                EasyLoading.showInfo('Anda perlu membuka toko');
                                                                                return;
                                                                              }
                                                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                              if (captionController.text.isNotEmpty) {
                                                                                EasyLoading.show();
                                                                                if (images.length < 1) {
                                                                                  SweetAlert.show(context, subtitle: "No image chosen", style: SweetAlertStyle.confirm);
                                                                                  EasyLoading.dismiss();
                                                                                  return;
                                                                                }

                                                                                await firestore.collection('posts').add({
                                                                                  'merchant': user['merchant'],
                                                                                  'text': captionController.text,
                                                                                  'location': location,
                                                                                  'likes': 0,
                                                                                  'comments': 0,
                                                                                  'created': FieldValue.serverTimestamp()
                                                                                }).then((result) async {
                                                                                  List<String> imageUrls = await uploadImages(images, 'post', result.id);

                                                                                  firestore.collection('posts').doc(result.id).update({
                                                                                    'images': imageUrls
                                                                                  }).then((result) {
                                                                                    dynamic newUser = user;
                                                                                    newUser['posts'] += 1;
                                                                                    prefs.setString('user', jsonEncode(newUser));
                                                                                    firestore.collection('users').doc(user['id']).update({
                                                                                      'posts': user['posts']
                                                                                    }).then((result) {
                                                                                      EasyLoading.showSuccess('Postingan dipublikasikan', duration: Duration(seconds: 1));
                                                                                      setState(() {
                                                                                        captionController.clear();

                                                                                        address = null;
                                                                                        images = [];
                                                                                        user = newUser;
                                                                                      });
                                                                                    });
                                                                                  });
                                                                                });
                                                                              } else {}
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              alignment: Alignment.center,
                                                                              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                                                              width: 100,
                                                                              margin: EdgeInsets.only(top: 20),
                                                                              decoration: BoxDecoration(
                                                                                  gradient: LinearGradient(colors: [
                                                                                    AppColors.PrimaryColor,
                                                                                    AppColors.SecondaryColor
                                                                                  ]),
                                                                                  borderRadius: BorderRadius.all(Radius.circular(20))),
                                                                              child: Text(
                                                                                'Post',
                                                                                style: TextStyle(color: Colors.white, fontSize: 14.0),
                                                                              ),
                                                                            ))
                                                                      ])
                                                                ],
                                                              ))
                                                          : GestureDetector(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pushNamed(
                                                                        '/post',
                                                                        arguments: {
                                                                      'postId':
                                                                          posts[index - 1]
                                                                              .id
                                                                    });
                                                              },
                                                              child: Container(
                                                                  width: size
                                                                      .width,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                20,
                                                                            right:
                                                                                20),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                                height: 50,
                                                                                width: 50,
                                                                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(55)),
                                                                                child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(50),
                                                                                    child: CachedNetworkImage(
                                                                                      imageUrl: users[index - 1].data()['picture'],
                                                                                      imageBuilder: (context, imageProvider) => Container(
                                                                                        decoration: BoxDecoration(
                                                                                            image: DecorationImage(
                                                                                          image: imageProvider,
                                                                                          fit: BoxFit.cover,
                                                                                        )),
                                                                                      ),
                                                                                    ))),
                                                                            SizedBox(width: 10),
                                                                            Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(users[index - 1].data()['name'], style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                                                                                SizedBox(width: 10),
                                                                                if (posts[index - 1]['location'] != null)
                                                                                  Column(
                                                                                    children: [
                                                                                      SizedBox(height: 5),
                                                                                      Text(posts[index - 1].data()['location']['subAdminArea'] + ', ' + posts[index - 1].data()['location']['adminArea'])
                                                                                    ],
                                                                                  ),
                                                                                if (users[index - 1].data()['location'] != null && posts[index - 1]['location'] == null)
                                                                                  Column(
                                                                                    children: [
                                                                                      SizedBox(height: 5),
                                                                                      Text(users[index - 1].data()['location']['subAdminArea'] + ', ' + users[index - 1].data()['location']['adminArea'])
                                                                                    ],
                                                                                  )
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              15),
                                                                      Container(
                                                                        height:
                                                                            size.width,
                                                                        width: size
                                                                            .width,
                                                                        child:
                                                                            CachedNetworkImage(
                                                                          imageUrl:
                                                                              posts[index - 1].data()['images'][0],
                                                                          imageBuilder: (context, imageProvider) =>
                                                                              Container(
                                                                            decoration: BoxDecoration(
                                                                                image: DecorationImage(
                                                                              image: imageProvider,
                                                                              fit: BoxFit.cover,
                                                                            )),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              20),
                                                                      Container(
                                                                          padding: EdgeInsets.only(
                                                                              left:
                                                                                  20,
                                                                              right:
                                                                                  20),
                                                                          child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    (likes[index-1].docs .map((like) => (like.data()['user'] == user['id'])).length > 0)
                                                                                        ? GestureDetector(
                                                                                            onTap: () async {
                                                                                              await firestore.collection('posts').doc(posts[index - 1].id).collection('likes').doc(likes[index-1].docs.firstWhere((like) => like.data()['user'] == user['id']).id.toString()).delete();
                                                                                              await firestore.collection('posts').doc(posts[index - 1].id).update({
                                                                                                'likes': posts[index - 1].data()['likes'] - 1
                                                                                              });
                                                                                              getData();
                                                                                            },
                                                                                            child: Icon(CupertinoIcons.heart_fill, color: Colors.red),
                                                                                          )
                                                                                        : GestureDetector(
                                                                                            onTap: () async {
                                                                                              await firestore
                                                                                              .collection('posts')
                                                                                              .doc(posts[index - 1].id)
                                                                                              .collection('likes')
                                                                                              .add({
                                                                                                'user': user['id'],
                                                                                                'created':FieldValue.serverTimestamp()
                                                                                              });
                                                                                              await firestore.collection('posts').doc(posts[index - 1].id).update({
                                                                                                'likes': posts[index - 1].data()['likes'] + 1
                                                                                              });
                                                                                              getData();},
                                                                                            child: Icon(CupertinoIcons.heart, color: Colors.black),
                                                                                          ),
                                                                                    SizedBox(width: 10),
                                                                                    GestureDetector(
                                                                                      onTap: () {},
                                                                                      child: Icon(CupertinoIcons.chat_bubble, color: Colors.black),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    Navigator.of(context).pushNamed('/list', arguments: {
                                                                                      'type': 'likes',
                                                                                      'postId': posts[index - 1].id
                                                                                    });
                                                                                  },
                                                                                  child: Text(posts[index - 1].data()['likes'].toString() + ' orang menyukai', style: TextStyle(fontWeight: FontWeight.bold)),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                Text(
                                                                                  posts[index - 1].data()['text'],
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                Text(TimeAgo.timeAgoSinceDate(posts[index - 1].data()['created'].toDate().toString()), style: TextStyle(color: Colors.grey)),
                                                                                SizedBox(
                                                                                  height: 15,
                                                                                ),
                                                                              ])),
                                                                    ],
                                                                  )));
                                                    })),
                                          )
                                        : Container(
                                            child: Column(
                                              children: [
                                                Icon(CupertinoIcons.info_circle,
                                                    size: 40),
                                                SizedBox(height: 30),
                                                Text('Post not found',
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
                                        )),
                              ],
                            ))),
                  ),
                ]))));
  }
}
