import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:olada/constants/assets.dart';
import 'package:olada/constants/colors.dart';
import 'package:olada/constants/strings.dart';
import 'package:olada/model/user.dart';
import 'package:olada/constants/assets.dart';
import 'package:olada/constants/colors.dart';
import 'package:olada/constants/strings.dart';
import 'package:olada/constants/data.dart';

class HobbyScreen extends StatefulWidget {
  @override
  _HobbyScreenState createState() => _HobbyScreenState();
}

class _HobbyScreenState extends State<HobbyScreen> {
  dynamic user;
  List<dynamic> hobbies = [];
  bool mapsDialog = false, hobbiesDialog = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  SharedPreferences prefs;
  Size size;

  Future<void> getData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      user = jsonDecode(
          prefs.getString("user") != null ? prefs.getString("user") : '{}');
      hobbies = user['hobbies'] != null ? user['hobbies'] : [];
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(user == null) getData();
    return Scaffold(
        primary: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.white,
            centerTitle: true,
            title: Text('Hobby',
                style: TextStyle(
                  color: Colors.black,
                )),
            iconTheme: IconThemeData(color: Colors.black)),
        body:  _buildRightSide(),
         );
  }

  Widget _buildRightSide() {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.only(top: 20),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      constraints: BoxConstraints(
                          minHeight: size.height, maxHeight: size.height),
                      child: ListView.builder(
                          itemCount: AppData.hobbyList.length,
                          itemBuilder: (context, index) {
                            return new GestureDetector(
                                child: Container(
                                    padding: EdgeInsets.only(
                                        top: 15,
                                        bottom: 15,
                                        left: 10,
                                        right: 10),
                                    margin: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: hobbies
                                                        .where((hobby) =>
                                                            hobby ==
                                                            AppData.hobbyList[
                                                                index])
                                                        .toList()
                                                        .length !=
                                                    0
                                                ? AppColors.PrimaryColor
                                                : Colors.grey[300]),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(AppData.hobbyList[index],
                                        textAlign: TextAlign.center)),
                                onTap: () {
                                  List<dynamic> newHobbyList = hobbies;
                                  if (hobbies
                                          .where((hobby) =>
                                              hobby == AppData.hobbyList[index])
                                          .toList()
                                          .length ==
                                      0) {
                                    newHobbyList.add(AppData.hobbyList[index]);
                                  } else {
                                    newHobbyList.remove(hobbies
                                        .indexOf(AppData.hobbyList[index]));
                                  }
                                  setState(() {
                                    hobbies = newHobbyList;
                                  });
                                });
                          })),
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
                        firestore
                            .collection('users')
                            .doc(user['id'])
                            .update({'hobbies': hobbies}).then((result) {
                          dynamic newUser = user;
                          newUser['hobbies'] = hobbies;
                          prefs.setString('user', jsonEncode(newUser));
                          
                          setState(() {
                            user = newUser;
                          });
                        });
                        EasyLoading.dismiss();
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
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      )),
                ))
          ],
        ));
  }
}
