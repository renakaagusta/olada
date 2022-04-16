import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:olada/constants/assets.dart';
import 'package:olada/widgets/empty_app_bar_widget.dart';
import 'package:olada/widgets/progress_indicator_widget.dart';
import 'package:olada/widgets/rounded_button_widget.dart';
import 'package:olada/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:olada/api/api_service.dart';
import 'package:olada/model/response.dart';
import 'package:olada/utils/loader/loader.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  ApiService apiService = ApiService();
  TextEditingController usernameController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
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
        padding: const EdgeInsets.only(
          top: 40,
        ),
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
            SizedBox(height: 30),
            Container(
                padding: EdgeInsets.only(
                    top: 25.0, left: 20.0, right: 20.0, bottom: 25.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )),
                child: Column(children: [
                  SizedBox(height: 24.0),
                  _buildUserIdField(),
                  SizedBox(height: 24.0),
                  _buildFirstnameField(),
                  SizedBox(height: 24.0),
                  _buildLastnameField(),
                  SizedBox(height: 20.0),
                  _buildEmail(),
                  SizedBox(height: 20.0),
                  _buildPhoneNumber(),
                  SizedBox(height: 20.0),
                  _buildPasswordField(),
                  SizedBox(height: 20.0),
                  _buildConfirmPasswordField(),
                  SizedBox(height: 20.0),
                  _buildSignUpButton(),
                ]))
          ],
        ),
      ),
    );
  }

  Widget _buildUserIdField() {
    return TextFieldWidget(
      hint: 'Username',
      inputType: TextInputType.emailAddress,
      icon: Icons.person,
      textController: usernameController,
      inputAction: TextInputAction.next,
      autoFocus: false,
      errorText: "",
    );
  }

  Widget _buildFirstnameField() {
    return TextFieldWidget(
      hint: 'Firstname',
      inputType: TextInputType.emailAddress,
      icon: Icons.person,
      textController: firstnameController,
      inputAction: TextInputAction.next,
      autoFocus: false,
      errorText: "",
    );
  }

  Widget _buildLastnameField() {
    return TextFieldWidget(
      hint: 'Lastname',
      inputType: TextInputType.emailAddress,
      icon: Icons.person,
      textController: lastnameController,
      inputAction: TextInputAction.next,
      autoFocus: false,
      errorText: "",
    );
  }

  Widget _buildEmail() {
    return TextFieldWidget(
      hint: 'Email',
      inputType: TextInputType.emailAddress,
      icon: Icons.email,
      textController: emailController,
      inputAction: TextInputAction.next,
      autoFocus: false,
      errorText: "",
    );
  }

  Widget _buildPhoneNumber() {
    return TextFieldWidget(
      hint: 'Nomor Ponsel',
      inputType: TextInputType.emailAddress,
      icon: Icons.phone,
      textController: phoneNumberController,
      inputAction: TextInputAction.next,
      autoFocus: false,
      errorText: "",
    );
  }

  Widget _buildPasswordField() {
    return TextFieldWidget(
      hint: 'Password',
      isObscure: true,
      icon: Icons.lock,
      textController: passwordController,
      errorText: "",
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFieldWidget(
      hint: 'Konfirmasi Password',
      isObscure: true,
      icon: Icons.lock,
      textController: confirmPasswordController,
      errorText: "",
    );
  }

  Widget _buildSignUpButton() {
    return GestureDetector(
        onTap: () async {
          if (usernameController.text.isEmpty ||
              emailController.text.isEmpty ||
              phoneNumberController.text.isEmpty ||
              passwordController.text.isEmpty ||
              confirmPasswordController.text.isEmpty) {
            SweetAlert.show(context,
                subtitle: "Harap isi seluruh form",
                style: SweetAlertStyle.confirm);
          } else {
            if (passwordController.text != confirmPasswordController.text) {
              SweetAlert.show(context,
                  subtitle: "Konfirmasi password tidak sama",
                  style: SweetAlertStyle.confirm);
            } else {
              if (!emailController.text.contains('@')) {
                SweetAlert.show(context,
                    subtitle: "Format email salah",
                    style: SweetAlertStyle.confirm);
              } else {
                CustomResponse response = await apiService.checkExistUser(
                    "-",
                    usernameController.text,
                    emailController.text,
                    phoneNumberController.text);

                if (response.status == 200) {
                  if (response.data == null) {
                    var phoneNumber = phoneNumberController.text;
                    if (phoneNumber[0] == '0') {
                      phoneNumber = "+62";
                      for (int i = 1;
                          i < phoneNumberController.text.length;
                          i++) {
                        phoneNumber += phoneNumberController.text[i];
                      }
                    }
                    CustomResponse response = await apiService.signUp(
                        usernameController.text,
                        firstnameController.text,
                        lastnameController.text,
                        passwordController.text,
                        emailController.text,
                        phoneNumber);
                    print(response.data);
                    if (response.status == 200) {
                      Alert(
                          context: context,
                          title: '',
                          closeIcon: null,
                          content: Column(
                            children: <Widget>[
                              Icon(CupertinoIcons.check_mark_circled,
                                  color: Colors.green, size: 100.0),
                              SizedBox(height: 20.0),
                              Text('Registrasi akun anda berhasil',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0))
                            ],
                          ),
                          buttons: [
                            DialogButton(
                              color: Color(0xffFF5400),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();

                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/signin',
                                  (Route<dynamic> route) => false,
                                );
                              },
                              child: Text(
                                "OK",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            )
                          ]).show();
                    }
                  }

                  /*Navigator.of(context).pushNamed('/otp', arguments: {
                    'username': usernameController.text,
                    'firstname': firstnameController.text,
                    'lastname': lastnameController.text,
                    'email': emailController.text,
                    'phoneNumber': phoneNumber,
                    'password': passwordController.text,
                    'passwordConfirm': confirmPasswordController.text,
                  });*/
                } else {
                  if (response.message.contains('username')) {
                    SweetAlert.show(context,
                        subtitle: 'Username telah digunakan',
                        style: SweetAlertStyle.confirm);
                  } else if (response.message.contains('email')) {
                    SweetAlert.show(context,
                        subtitle: 'Email telah digunakan',
                        style: SweetAlertStyle.confirm);
                  } else if (response.message.contains('phone')) {
                    SweetAlert.show(context,
                        subtitle: 'Nomor HP telah digunakan',
                        style: SweetAlertStyle.confirm);
                  }
                }
              }
            }
          }
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          width: MediaQuery.of(context).size.width - 40,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xffFF5400), Color(0xffF99746)]),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Text(
            'Register',
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
        ));
  }
}
