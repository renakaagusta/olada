import 'package:flutter/cupertino.dart';
import 'package:olada/widgets/app_icon_widget.dart';
import 'package:olada/widgets/empty_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:olada/constants/assets.dart';
import 'package:olada/constants/colors.dart';
import 'package:olada/constants/strings.dart';
import 'package:olada/widgets/rounded_button_widget.dart';

class OTPSuccessScreen extends StatefulWidget {
  @override
  _OTPSuccessScreenState createState() => _OTPSuccessScreenState();
}

class _OTPSuccessScreenState extends State<OTPSuccessScreen> {
  String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
      color: Colors.white,
      border: Border(bottom: BorderSide(color: Colors.grey, width: 1.0)));
      
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
            SizedBox(height: 80),
            Image.asset('assets/images/signup-success.png', height: 200.0, width: 200.0, fit:BoxFit.contain),
            SizedBox(height: 24.0),
            
            Text(
              'You have successfully created a new account',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10.0),
            GestureDetector(
              onTap: () async {
                Navigator.of(context).pushNamedAndRemoveUntil('/signin', (route) => false);
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
          ],
        ),
      ),
    );
  }
}
