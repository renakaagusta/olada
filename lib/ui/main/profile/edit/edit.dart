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
import 'package:olada/constants/assets.dart';
import 'package:olada/constants/colors.dart';
import 'package:olada/constants/strings.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var picker = ImagePicker();
  dynamic user;
  SharedPreferences prefs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController usernameController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  File image;
  Size size;

  Future<void> getData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      user = jsonDecode(prefs.getString("user"));
      usernameController.text = user['username'];
      displayNameController.text = user['name'];
      bioController.text = user['bio'].toString().replaceAll("\\n", "\n");
      emailController.text = user['email'];
      phoneNumberController.text = user['phone'];
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
          title: Text('Edit profile',
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
                                      imageUrl: user['picture'],
                                      imageBuilder: (context, imageProvider) =>
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
                            children: [
                              TextFieldWidget(
                                hint: 'Username',
                                icon: Icons.person,
                                textController: usernameController,
                                inputAction: TextInputAction.next,
                                autoFocus: false,
                                errorText: "",
                              ),
                              SizedBox(height: 24.0),
                              TextFieldWidget(
                                hint: 'Display name',
                                icon: Icons.person,
                                textController: displayNameController,
                                inputAction: TextInputAction.next,
                                autoFocus: false,
                                errorText: "",
                              ),
                              SizedBox(height: 24.0),
                              TextFieldWidget(
                                hint: 'Bio',
                                inputType: TextInputType.emailAddress,
                                icon: Icons.person,
                                textController: bioController,
                                inputAction: TextInputAction.next,
                                autoFocus: false,
                                errorText: "",
                                maxLines: 5,
                              ),
                              SizedBox(height: 20.0),
                              TextFieldWidget(
                                hint: 'Email',
                                inputType: TextInputType.emailAddress,
                                icon: Icons.email,
                                textController: emailController,
                                inputAction: TextInputAction.next,
                                autoFocus: false,
                                errorText: "",
                                enabled: user['authentication'] != 'google' &&
                                    user['authentication'] != 'email',
                              ),
                              SizedBox(height: 20.0),
                              TextFieldWidget(
                                hint: 'Phone Number',
                                inputType: TextInputType.number,
                                icon: Icons.phone,
                                textController: phoneNumberController,
                                inputAction: TextInputAction.next,
                                autoFocus: false,
                                errorText: "",
                              ),
                              SizedBox(height: 100.0),
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

                              if (usernameController.text.isEmpty) {
                                SweetAlert.show(context,
                                    subtitle: "Username isn't valid",
                                    style: SweetAlertStyle.confirm);
                                return;
                              }
                              if (usernameController.text.length < 8) {
                                SweetAlert.show(context,
                                    subtitle: "Username isn't valid",
                                    style: SweetAlertStyle.confirm);
                                return;
                              }

                              if (displayNameController.text.isEmpty) {
                                SweetAlert.show(context,
                                    subtitle: "Display name isn't valid",
                                    style: SweetAlertStyle.confirm);
                                return;
                              }

                              if (displayNameController.text.length < 8) {
                                SweetAlert.show(context,
                                    subtitle: "Display name isn't valid",
                                    style: SweetAlertStyle.confirm);
                                return;
                              }

                              if (phoneNumberController.text.isNotEmpty &&
                                  phoneNumberController.text.length < 8) {
                                SweetAlert.show(context,
                                    subtitle: "Phone number isn't valid",
                                    style: SweetAlertStyle.confirm);
                                return;
                              }

                              dynamic userQueryByUsername = await firestore
                                  .collection('users')
                                  .where('username',
                                      isEqualTo: usernameController.text)
                                  .get();

                              if (userQueryByUsername.docs.isNotEmpty) {
                                if (userQueryByUsername.docs.id != user['id']) {
                                  SweetAlert.show(context,
                                      subtitle: "Username isn't available",
                                      style: SweetAlertStyle.confirm);
                                  return;
                                }
                              }

                              userQueryByUsername = await firestore
                                  .collection('users')
                                  .where('phoneNumber',
                                      isEqualTo: phoneNumberController.text)
                                  .get();

                              if (userQueryByUsername.docs.isNotEmpty) {
                                if (userQueryByUsername.docs.id != user['id']) {
                                  SweetAlert.show(context,
                                      subtitle: "Phone number isn't available",
                                      style: SweetAlertStyle.confirm);
                                  return;
                                }
                              }
                              
                              await firestore
                                  .collection('users')
                                  .doc(user['id'])
                                  .update({
                                    'username': usernameController.text,
                                    'name': displayNameController.text,
                                    'email': emailController.text,
                                    'phoneNumber': phoneNumberController.text,
                                  });

                              dynamic newUser = user;
                              newUser['username'] = usernameController.text;
                              newUser['displayName'] = displayNameController.text;
                              newUser['email'] = emailController.text;
                              newUser['phoneNumber'] = phoneNumberController.text;

                              prefs.setString('user', jsonEncode(newUser));
                              getData();EasyLoading.showSuccess(
                                  'Disimpan',
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
                                'Save',
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
