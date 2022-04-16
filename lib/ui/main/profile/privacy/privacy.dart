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
import 'package:olada/constants/assets.dart';
import 'package:olada/constants/colors.dart';
import 'package:olada/constants/strings.dart';

class PrivacyScreen extends StatefulWidget {
  @override
  _PrivacyScreenState createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  @override
  void initState() {
    super.initState();
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
                  Image.asset(
                        Assets.appLogo,
                        height: 200,
                        width: 200,
                        fit: BoxFit.fill,
                      ),
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 30.0, right: 30.0),
                    child: Column(
                      children: [
                        Text(
                          'Kebijakan Privasi',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                            "Kebijakan Privasi berikut ini menjelaskan bagaimana kami, Olada mengumpulkan, menyimpan, menggunakan, mengolah, menguasai, mentransfer, mengungkapkan dan melindungi Informasi Pribadi Anda. Kebijakan Privasi ini berlaku bagi seluruh pengguna aplikasi-aplikasi, situs web (www.mandor-tukang.com), layanan, atau produk (“Aplikasi”) kami, kecuali diatur pada kebijakan privasi yang terpisah. Mohon baca Kebijakan Privasi ini dengan saksama untuk memastikan bahwa Anda memahami bagaimana proses pengolahan data kami. Kecuali didefinisikan lain, semua istilah dengan huruf kapital yang digunakan dalam Kebijakan Privasi ini memiliki arti yang sama dengan yang tercantum dalam Ketentuan Penggunaan.",
                            textAlign: TextAlign.justify,
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16)),
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                            onTap: () {},
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              width: size.width - 70,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    AppColors.PrimaryColor,
                                    AppColors.SecondaryColor
                                  ]),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Text(
                                'Baca',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            )),
                        SizedBox(
                          height: 30,
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
