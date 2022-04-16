import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:olada/model/user.dart';
import 'package:olada/model/response.dart';
import 'package:olada/api/api_service.dart';
import 'package:olada/widgets/textfield_widget.dart';
import 'package:sweetalert/sweetalert.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  var picker = ImagePicker();
  UserOlada user;
  SharedPreferences prefs;
  ApiService apiService = ApiService();
  TextEditingController usernameController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  File image;

  @override
  void initState() {
    super.initState();
    if (mounted) _getArguments();
  }

  Future<void> _getArguments() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      user = userFromJson(prefs.getString("user"));
      usernameController.text = user.username;
      firstnameController.text = user.firstname;
      lastnameController.text = user.lastname;
      emailController.text = user.email;
      phoneNumberController.text = user.phoneNumber;
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
        body:  _buildRightSide(),
         );
  }

  Widget _buildRightSide() {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.only(top: 50),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  if (user != null)
                    Container(
                        padding: EdgeInsets.only(top: 30.0),
                        child: (user.username != null)
                            ? Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                        'assets/icons/logo-app.png',
                                        height: 100),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                        margin: EdgeInsets.only(top: 130),
                                        child: Text(
                                          "Olada",
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  )
                                ],
                              )
                            : Container(height: size.height * 0.3)),
                  Container(
                    padding: EdgeInsets.only(top: 40, left: 30.0, right: 30.0),
                    child: Column(
                      children: [
                        Text(
                          'Versi Aplikasi',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          '1.00',
                          style: TextStyle(fontSize: 20, color: Colors.black45),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Change log',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          '-',
                          style: TextStyle(fontSize: 20, color: Colors.black45),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
