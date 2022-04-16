import 'package:olada/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:olada/api/api_service.dart';

class SelectRoleScreen extends StatefulWidget {
  @override
  _SelectRoleScreenState createState() => _SelectRoleScreenState();
}

class _SelectRoleScreenState extends State<SelectRoleScreen> {
  ApiService apiService = ApiService();

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffFFFFFF),
      statusBarIconBrightness: Brightness.dark,
    ));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Color(0x00000000),
        statusBarIconBrightness: Brightness.light,
      ),
      child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.fill)),
          child: _buildRightSide()),
    ));
  }

  Widget _buildRightSide() {
    return SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 10.0, right: 10.0, top: 40, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AppIconWidget(image: 'assets/images/register.png'),
            SizedBox(height: 20),
            Text(
              'Registrasi',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0, color: Colors.white),
            ),
            SizedBox(height: 20),
            Container(
                padding: EdgeInsets.only(
                    top: 25.0, left: 20.0, right: 20.0, bottom: 25.0),
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0)),
                child: Column(children: [
                  SizedBox(height: 24.0),
                  _buildSignUpButton(),
                ]))
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return GestureDetector(
        onTap: () async {},
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          width: MediaQuery.of(context).size.width - 40,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xffFF5400), Color(0xffF99746)]),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Text(
            'Pilih',
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
        ));
  }
}
