import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:olada/api/api_service.dart';
import 'package:olada/widgets/textfield_widget.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path/path.dart' as path;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:olada/constants/assets.dart';
import 'package:olada/constants/colors.dart';
import 'package:olada/constants/strings.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var picker = ImagePicker();
  dynamic user;
  SharedPreferences prefs;
  ApiService apiService = ApiService();

  File image;
  Size size;

  @override
  void initState() {
    super.initState();
    if (mounted) _getArguments();
  }

  Future<void> _getArguments() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      user = jsonDecode(prefs.getString("user"));
    });
  }

  Future getImagefromcamera() async {
    final _picker = ImagePicker();
    PickedFile pickedImage = await _picker.getImage(source: ImageSource.camera);
    setState(() {
      image = File(pickedImage.path);
    });
  }

  Future getImagefromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      var images = [];
      images.add(image);
      final formData = FormData.fromMap({
        'id': user.id,
        'images': user.image,
      });
      formData.files.addAll([
        for (var file in images)
          ...{
            MapEntry(
                "images",
                await MultipartFile.fromFile(file.path,
                    filename: path.basename(file.path)))
          }.toList()
      ]);

      var response = await apiService.changeImageProfile(user.id, formData);

      print(response.data['data']);
      setState(() {
        user.image = response.data['data']['image'];
      });
      prefs.setString('user', jsonEncode(user));
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        primary: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.white,
            centerTitle: true,
            title: Text('Setting',
                style: TextStyle(
                  color: Colors.black,
                )),
            iconTheme: IconThemeData(color: Colors.black)),
        body: _buildRightSide(),
         );
  }

  Widget _buildRightSide() {
    size = MediaQuery.of(context).size;
    return Container(
        height: size.height,
        width: size.width,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            SingleChildScrollView(
              child: Column(children: [
                Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('/profile/setting/edit');
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 60.0,
                                width: 60.0,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Color(0xffeeeeee),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Icon(CupertinoIcons.profile_circled,
                                    size: 30),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text('Edit profile',
                                  style: TextStyle(fontSize: 18.0))
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('/profile/setting/hobby');
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 60.0,
                                width: 60.0,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Color(0xffeeeeee),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Icon(CupertinoIcons.play, size: 30),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text('Hobbies', style: TextStyle(fontSize: 18.0))
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          'Application',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('/profile/privacy');
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 60.0,
                                width: 60.0,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Color(0xffeeeeee),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Icon(CupertinoIcons.shield, size: 30),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text('Privacy and Policy',
                                  style: TextStyle(fontSize: 18.0))
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('/profile/version');
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 60.0,
                                width: 60.0,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Color(0xffeeeeee),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child:
                                    Icon(CupertinoIcons.info_circle, size: 30),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text('Version', style: TextStyle(fontSize: 18.0))
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          'Navigation',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await GoogleSignIn().signOut();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/signin', (Route<dynamic> route) => false);
                                prefs.clear();
                              },
                              child: Container(
                                height: 60.0,
                                width: 60.0,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Color(0xffeeeeee),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Icon(CupertinoIcons.arrow_left),
                              ),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Text('Sign out', style: TextStyle(fontSize: 18.0))
                          ],
                        ),
                      ],
                    )),
              ]),
            ),
          ],
        ));
  }
}
