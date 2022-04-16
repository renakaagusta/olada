import 'package:flutter/cupertino.dart';
import 'package:olada/widgets/textfield_second_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:olada/constants/assets.dart';
import 'package:olada/constants/colors.dart';
import 'package:olada/constants/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  bool hidePassword = true;
  bool hidePasswordConfirm = true;
  Size size;

  @override
  void initState() {
    FirebaseAuth auth = FirebaseAuth.instance;
    super.initState();
  }

  Future getLocalData() async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    getLocalData();
    size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Color(0x00000000),
            statusBarIconBrightness: Brightness.dark,
          ),
          child: Container(
              padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
              height: size.height,
              width: size.width,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                          child: Icon(CupertinoIcons.back),
                          onTap: () {
                            Navigator.of(context).pop();
                          }),
                    ),
                    SizedBox(height: 10.0),
                    Text('Lets Get Started',
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10.0),
                    Text('Create new account', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 20.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 2,
                            offset: Offset(1, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: TextFieldWidget(
                        hint: 'Name',
                        icon: Icons.person,
                        textController: nameController,
                        inputAction: TextInputAction.next,
                        autoFocus: false,
                        errorText: "",
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 2,
                            offset: Offset(1, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: TextFieldWidget(
                        hint: 'Email',
                        icon: Icons.person,
                        textController: emailController,
                        inputAction: TextInputAction.next,
                        autoFocus: false,
                        errorText: "",
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 2,
                            offset: Offset(1, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: TextFieldWidget(
                        hint: 'Phone Number',
                        icon: Icons.person,
                        textController: phoneNumberController,
                        inputType: TextInputType.number,
                        autoFocus: false,
                        errorText: "",
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 2,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      child: TextFieldWidget(
                        hint: 'Password',
                        icon: Icons.person,
                        textController: passwordController,
                        inputAction: TextInputAction.next,
                        isObscure: hidePassword,
                        autoFocus: false,
                        errorText: "",
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 2,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      child: TextFieldWidget(
                        hint: 'Confirm password',
                        icon: Icons.person,
                        textController: passwordConfirmController,
                        inputAction: TextInputAction.next,
                        isObscure: hidePassword,
                        autoFocus: false,
                        errorText: "",
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                        onTap: () async {
                          if (nameController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          passwordController.text.isEmpty ||
                          passwordConfirmController.text.isEmpty) {
                        Alert(
                            context: context,
                            title: '',
                            closeIcon: null,
                            content: Column(
                              children: <Widget>[
                                Icon(CupertinoIcons.exclamationmark_triangle,
                                    color: AppColors.PrimaryColor, size: 100.0),
                                SizedBox(height: 20.0),
                                Text("Fill all the field",
                                    style: TextStyle(
                                        fontSize: 20.0))
                              ],
                            ),
                            buttons: [
                              DialogButton(
                                color: AppColors.PrimaryColor,
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                                child: Text(
                                  "OK",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              )
                            ]).show();
                        return;
                      }

                      if (passwordController.text !=
                          passwordConfirmController.text) {
                        Alert(
                            context: context,
                            title: '',
                            closeIcon: null,
                            content: Column(
                              children: <Widget>[
                                Icon(CupertinoIcons.exclamationmark_triangle,
                                    color: AppColors.PrimaryColor, size: 100.0),
                                SizedBox(height: 20.0),
                                Text("Password doesn't match",
                                    style: TextStyle(
                                        fontSize: 20.0))
                              ],
                            ),
                            buttons: [
                              DialogButton(
                                color: AppColors.PrimaryColor,
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                                child: Text(
                                  "OK",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              )
                            ]).show();
                        return;
                      }

                      if (passwordController.text !=
                          passwordConfirmController.text) {
                        Alert(
                            context: context,
                            title: '',
                            closeIcon: null,
                            content: Column(
                              children: <Widget>[
                                Icon(CupertinoIcons.exclamationmark_triangle,
                                    color: AppColors.PrimaryColor, size: 100.0),
                                SizedBox(height: 20.0),
                                Text("Email format isn't correct",
                                    style: TextStyle(
                                        fontSize: 20.0))
                              ],
                            ),
                            buttons: [
                              DialogButton(
                                color: AppColors.PrimaryColor,
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                                child: Text(
                                  "OK",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              )
                            ]).show();
                        return;
                      }

                      if (passwordController.text != passwordConfirmController.text) {
                        Alert(
                            context: context,
                            title: '',
                            closeIcon: null,
                            content: Column(
                              children: <Widget>[
                                Icon(CupertinoIcons.exclamationmark_triangle,
                                    color: AppColors.PrimaryColor, size: 100.0),
                                SizedBox(height: 20.0),
                                Text("Password confirmation isn't correct",
                                    style: TextStyle(
                                        fontSize: 20.0))
                              ],
                            ),
                            buttons: [
                              DialogButton(
                                color: AppColors.PrimaryColor,
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                                child: Text(
                                  "OK",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              )
                            ]).show();
                        return;
                      }

                      Navigator.of(context).pushNamed('/otp', arguments: {
                        'name': nameController.text,
                        'email': emailController.text,
                        'phoneNumber': '+62'+phoneNumberController.text,
                        'password': passwordController.text,
                      });
                         },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 12.0),
                          width: 180,
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                AppColors.PrimaryColor,
                                AppColors.SecondaryColor
                              ]),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Text(
                            'Sign up',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        )),
                    SizedBox(height: 20),
                    Text('Or register with'),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () async {},
                            child: Image.asset(Assets.google,
                                height: 30, width: 30)),
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                            child: Image.asset(Assets.facebook,
                                height: 30, width: 30)),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account'),
                        GestureDetector(
                            child: Text('Login here',
                                style:
                                    TextStyle(color: AppColors.PrimaryColor)),
                            onTap: () {
                              Navigator.of(context).pushNamed('/signin');
                            })
                      ],
                    )
                  ],
                ),
              ))),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
