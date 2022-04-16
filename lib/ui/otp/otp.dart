import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:olada/widgets/app_icon_widget.dart';
import 'package:olada/widgets/empty_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:olada/constants/assets.dart';
import 'package:olada/constants/colors.dart';
import 'package:olada/constants/strings.dart';
import 'package:olada/widgets/rounded_button_widget.dart';

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
      color: Colors.white,
      border: Border(bottom: BorderSide(color: Colors.grey, width: 1.0)));
  String name;
  String email;
  String phoneNumber;
  String password;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> getData() async {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      setState(() {
        name = arguments['name'];
        email = arguments['email'];
        phoneNumber = arguments['phoneNumber'];
        password = arguments['password'];
        verifyPhone(arguments);
      });
    }
  }

  verifyPhone(dynamic arguments) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: arguments['phoneNumber'],
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {});
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, int resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffFFFFFF),
      statusBarIconBrightness: Brightness.dark,
    ));
    Future.delayed(Duration(seconds: 1), () {
      getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: EmptyAppBar(),
      body: _buildRightSide(),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildRightSide() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 50.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                  child: Icon(CupertinoIcons.back),
                  onTap: () {
                    Navigator.of(context).pop();
                  }),
            ),
            SizedBox(height: 50.0),
            Image.asset('assets/images/otp.png', height: 100.0, width: 100.0),
            SizedBox(height: 24.0),
            Text(
              'OTP Verification',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 10.0),
            phoneNumber != null
                ? Text(
                    'Enter the OTP sent to ' + phoneNumber,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0, color: Colors.grey),
                  )
                : Text(''),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: PinPut(
                fieldsCount: 6,
                textStyle: const TextStyle(fontSize: 20.0, color: Colors.black),
                eachFieldWidth: 30.0,
                eachFieldHeight: 55.0,
                focusNode: _pinPutFocusNode,
                controller: _pinPutController,
                submittedFieldDecoration: pinPutDecoration,
                selectedFieldDecoration: pinPutDecoration,
                followingFieldDecoration: pinPutDecoration,
                eachFieldPadding: EdgeInsets.all(10.0),
                pinAnimationType: PinAnimationType.fade,
                onSubmit: (pin) async {
                  EasyLoading.show();
                  try {
                    await FirebaseAuth.instance
                        .signInWithCredential(PhoneAuthProvider.credential(
                            verificationId: _verificationCode, smsCode: pin))
                        .then((value) async {
                      await firestore.collection('users').add({
                        'name': name,
                        'email': email,
                        'phoneNumber': phoneNumber,
                        'password': password,
                        'picture':
                            'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png',
                        'bio': '',
                        'followers': 0,
                        'following': 0,
                        'posts': 0,
                        'authentication': 'olada',
                        'created': FieldValue.serverTimestamp(),
                      }).then((result) {EasyLoading.showSuccess(
                                  'OTP berhasil',
                                  duration: Duration(seconds: 1));
                                  
                                  Future.delayed(const Duration(milliseconds: 1000),
                                  () {
                        Navigator.of(context).pushNamed('/otp-success');});
                      });
                    });
                  } catch (e) {
                    EasyLoading.dismiss();
                    print(e);
                    FocusScope.of(context).unfocus();
                    SweetAlert.show(context,
                        subtitle: "OTP code isn't valid",
                        style: SweetAlertStyle.confirm);
                  }
                },
              ),
            ),
            GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  height: 50,
                  width: 100,
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        AppColors.PrimaryColor,
                        AppColors.SecondaryColor
                      ]),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text(
                    'Confirm',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
                onTap: () async {
                  EasyLoading.show();
                  String pin = _pinPutController.text;
                  try {
                    await FirebaseAuth.instance
                        .signInWithCredential(PhoneAuthProvider.credential(
                            verificationId: _verificationCode, smsCode: pin))
                        .then((value) async {
                      await firestore.collection('users').add({
                        'name': name,
                        'email': email,
                        'phoneNumber': phoneNumber,
                        'password': password,
                        'picture':
                            'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png',
                        'bio': '',
                        'followers': 0,
                        'following': 0,
                        'posts': 0,
                        'authentication': 'olada',
                        'created': FieldValue.serverTimestamp(),
                      }).then((result) {
                        EasyLoading.showSuccess(
                                  'OTP berhasil',
                                  duration: Duration(seconds: 1));
                                  Future.delayed(const Duration(milliseconds: 1000),
                                  () {
                        Navigator.of(context).pushNamed('/otp-success');});
                      });
                    });
                  } catch (e) {
                    EasyLoading.dismiss();
                    print(e);
                    FocusScope.of(context).unfocus();
                    SweetAlert.show(context,
                        subtitle: "OTP code isn't valid",
                        style: SweetAlertStyle.confirm);
                  }
                }),
          ],
        ),
      ),
    );
  }
}
