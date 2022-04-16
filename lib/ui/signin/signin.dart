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

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Color(0x00000000),
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Container(
            height: double.infinity,
            width: double.infinity,
            child: _buildRightSide()),
      ),
    );
  }

  Widget _buildRightSide() {
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 30),
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(Assets.signIn, height: 200, width: 280, fit: BoxFit.fill),
          SizedBox(height: 10.0),
          Text('Welcome Back!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.0),
          Text('Log in to your existant account',
              style: TextStyle(fontSize: 16)),
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
                  offset: Offset(1, 1),
                ),
              ],
            ),
            child: TextFieldWidget(
              hint: 'Username',
              icon: Icons.person,
              textController: usernameController,
              inputAction: TextInputAction.next,
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
              autoFocus: false,
              errorText: "",
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
              onTap: () async {
                String fcmToken = await FirebaseMessaging.instance.getToken();
                SharedPreferences prefs = await SharedPreferences.getInstance();

                firestore
                    .collection("users")
                    .where("email", isEqualTo: usernameController.text)
                    .where("password", isEqualTo: passwordController.text)
                    .get()
                    .then((snapshot) {
                  if (snapshot.docs.isEmpty) {
                    Alert(
                        context: context,
                        title: '',
                        closeIcon: null,
                        content: Column(
                          children: <Widget>[
                            Icon(CupertinoIcons.exclamationmark_triangle,
                                color: AppColors.PrimaryColor, size: 100.0),
                            SizedBox(height: 20.0),
                            Text("Email or password isn't valid",
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                        buttons: [
                          DialogButton(
                            color: AppColors.PrimaryColor,
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Text(
                              "OK",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          )
                        ]).show();
                    return;
                  } else {
                    var currentUser = snapshot.docs[0];
                    firestore
                        .collection("users")
                        .doc(snapshot.docs[0].id)
                        .update({
                      'id': currentUser.id,
                      'fcmToken': fcmToken
                    }).then((result) async {
                      dynamic merchant;
                      if (currentUser.data()['merchant'] != null) {
                        await firestore
                            .collection('merchants')
                            .doc(currentUser.data()['merchant'])
                            .get()
                            .then((document) {
                          merchant = document.data();
                          merchant['id'] = document.id;
                        });
                      }

                      if (merchant != null) {
                        prefs.setString("merchant", jsonEncode(merchant));
                      }

                      prefs.setString(
                          "user",
                          jsonEncode({
                            'id': currentUser.id,
                            'name': currentUser.data()['name'],
                            'username': currentUser.data()['username'],
                            'bio': currentUser.data()['bio'],
                            'phone': currentUser.data()['phone'],
                            'email': currentUser.data()['email'],
                            'picture': currentUser.data()['picture'],
                            'followers': currentUser.data()['followers'],
                            'following': currentUser.data()['following'],
                            'posts': currentUser.data()['posts'],
                            'merchant': merchant != null ? merchant : null,
                            'fcmToken': fcmToken,
                            'authentication':
                                currentUser.data()['authentication'],
                          }));

                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/dashboard', (Route<dynamic> route) => false);
                    });
                  }
                });
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                width: 180,
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      AppColors.PrimaryColor,
                      AppColors.SecondaryColor
                    ]),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Text(
                  'Log In',
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              )),
          SizedBox(height: 20),
          Text('Or connect using'),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () async {
                    GoogleSignInAccount googleAccount =
                        await GoogleSignIn().signIn();
                    final GoogleSignInAuthentication googleAuth =
                        await googleAccount.authentication;
                    final credential = GoogleAuthProvider.credential(
                      accessToken: googleAuth.accessToken,
                      idToken: googleAuth.idToken,
                    );
                    var user = await FirebaseAuth.instance
                        .signInWithCredential(credential);
                    String fcmToken =
                        await FirebaseMessaging.instance.getToken();

                    if (user != null) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      firestore
                          .collection("users")
                          .where("email",
                              isEqualTo:
                                  user.additionalUserInfo.profile['email'])
                          .get()
                          .then((snapshot) {
                        if (snapshot.docs.isEmpty) {
                          firestore.collection("users").add({
                            'name': user.additionalUserInfo.profile['name'],
                            'username': user.additionalUserInfo.profile['email']
                                .substring(
                                    0,
                                    user.additionalUserInfo.profile['email']
                                        .indexOf('@')),
                            'bio':
                                'Hello i\'am ${user.additionalUserInfo.profile['email'].substring(0, user.additionalUserInfo.profile['email'].indexOf('@'))}\nWelcome to my profile',
                            'phone': '',
                            'email': user.additionalUserInfo.profile['email'],
                            'picture':
                                user.additionalUserInfo.profile['picture'],
                            'followers': 0,
                            'following': 0,
                            'posts': 0,
                            'created': FieldValue.serverTimestamp(),
                            'authentication': 'google'
                          }).then((result) async {
                            firestore
                                .collection("users")
                                .where("email",
                                    isEqualTo: user
                                        .additionalUserInfo.profile['email'])
                                .get()
                                .then((snapshot) {
                              firestore
                                  .collection("users")
                                  .doc(snapshot.docs[0].id)
                                  .update({'id': snapshot.docs[0].id}).then(
                                      (result) {
                                prefs.setString(
                                    "user",
                                    jsonEncode({
                                      'id': snapshot.docs[0].id,
                                      'name': user
                                          .additionalUserInfo.profile['name'],
                                      'username': user
                                          .additionalUserInfo.profile['email']
                                          .substring(
                                              0,
                                              user.additionalUserInfo
                                                  .profile['email']
                                                  .indexOf('@')),
                                      'bio': user
                                          .additionalUserInfo.profile['bio'],
                                      'phone': '',
                                      'email': user
                                          .additionalUserInfo.profile['email'],
                                      'picture': user.additionalUserInfo
                                          .profile['picture'],
                                      'followers': 0,
                                      'following': 0,
                                      'posts': 0,
                                      'fcmToken': fcmToken,
                                      'authentication': 'google'
                                    }));
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/dashboard',
                                    (Route<dynamic> route) => false);
                              });
                            });
                          });
                        } else {
                          var currentUser = snapshot.docs[0];
                          firestore
                              .collection("users")
                              .doc(snapshot.docs[0].id)
                              .update({
                            'id': currentUser.id,
                            'fcmToken': fcmToken
                          }).then((result) async {
                            dynamic merchant;
                            if (currentUser.data()['merchant'] != null) {
                              await firestore
                                  .collection('merchants')
                                  .doc(currentUser.data()['merchant'])
                                  .get()
                                  .then((document) {
                                merchant = document.data();
                                merchant['id'] = document.id;
                              });
                            }

                            if (merchant != null) {
                              prefs.setString("merchant", jsonEncode(merchant));
                            }

                            prefs.setString(
                                "user",
                                jsonEncode({
                                  'id': currentUser.id,
                                  'name': currentUser.data()['name'],
                                  'username': currentUser.data()['username'],
                                  'bio': currentUser.data()['bio'],
                                  'phone': currentUser.data()['phone'],
                                  'email': currentUser.data()['email'],
                                  'picture': currentUser.data()['picture'],
                                  'followers': currentUser.data()['followers'],
                                  'following': currentUser.data()['following'],
                                  'posts': currentUser.data()['posts'],
                                  'merchant':
                                      merchant != null ? merchant : null,
                                  'fcmToken': fcmToken,
                                  'authentication':
                                      currentUser.data()['authentication'],
                                }));
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/dashboard', (Route<dynamic> route) => false);
                          });
                        }
                      });
                    }
                    return await FirebaseAuth.instance
                        .signInWithCredential(credential);
                  },
                  child: Image.asset(Assets.google, height: 30, width: 30)),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                  child: Image.asset(Assets.facebook, height: 30, width: 30)),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Don\'t have an account? '),
              GestureDetector(
                  child: Text('Sign up',
                      style: TextStyle(color: AppColors.PrimaryColor)),
                  onTap: () {
                    Navigator.of(context).pushNamed('/signup');
                  })
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
