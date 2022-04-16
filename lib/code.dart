]FJfile:///C:/xampp/htdocs/pawonan/app/olada/lib/api/api_service.dart
import 'package:olada/model/response.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
class ApiService {
  final String baseUrl = "http://213.190.4.239:3000/api/v1";
  Client client = Client();
  Future<CustomResponse> signIn(
      String username, String password, String token) async {
    final response = await client.post(Uri.parse("$baseUrl/auth/signin"),
        headers: {"content-type": "application/json"},
        body: jsonEncode({
          'username': username,
          'password': password,
          'fcmToken': token,
        }));
    if (response.statusCode == 200) {
      return customResponseFromJson(response.body);
    } else {
      return null;
    }
  Future<CustomResponse> signUp(
      String username,
      String firstname,
      String lastname,
      String password,
      String email,
      String phoneNumber) async {
    final response = await client.post(Uri.parse("$baseUrl/auth/signup"),
        headers: {"content-type": "application/json"},
        body: jsonEncode({
          'username': username,
          'firstname': firstname,
          'lastname': lastname,
          'password': password,
          'email': email,
          'phoneNumber': phoneNumber,
          'role': 'customer'
        }));
    if (response.statusCode == 200) {
      return customResponseFromJson(response.body);
    } else {
      return null;
    }
  Future<CustomResponse> checkExistUser(
      String username, String email, String phoneNumber) async {
    final response = await client.get(
        Uri.parse(
            "$baseUrl/auth/username/$username/phone-number/$phoneNumber/email/$email"),
        headers: {"content-type": "application/json"});
    print(username);
    if (response.statusCode == 200) {
      return customResponseFromJson(response.body);
    } else {
      return null;
    }
  Future<Response> sendForm(FormData data) async {
    String url = "$baseUrl/order";
    Dio dio = new Dio();
    return await dio.post(url,
        data: data, options: Options(contentType: 'multipart/form-data'));
  Future<CustomResponse> getPartnerByCityAndService(
      String city, String service, String subservices) async {
    final response = await client.get(
        Uri.parse(
            "$baseUrl/partner/service/$service/subservice/$subservices/city/$city"),
        headers: {"content-type": "application/json"});
    print(response);
    if (response.statusCode == 200) {
      return customResponseFromJson(response.body);
    } else {
      return null;
    }
  Future<CustomResponse> getOrderByCustomerAndStatus(
      String customerID, int status) async {
    final response = await client.get(
        Uri.parse("$baseUrl/order/customer/$customerID/status/$status"),
        headers: {"content-type": "application/json"});
    print(response);
    if (response.statusCode == 200) {
      return customResponseFromJson(response.body);
    } else {
      return null;
    }
  Future<CustomResponse> getOrderById(String orderID) async {
    final response = await client.get(Uri.parse("$baseUrl/order/$orderID"),
        headers: {"content-type": "application/json"});
    print(response);
    if (response.statusCode == 200) {
      return customResponseFromJson(response.body);
    } else {
      return null;
    }
  Future<CustomResponse> getPartnerById(String partnerID) async {
    final response = await client.get(Uri.parse("$baseUrl/partner/$partnerID"),
        headers: {"content-type": "application/json"});
    print(response);
    if (response.statusCode == 200) {
      return customResponseFromJson(response.body);
    } else {
      return null;
    }
  Future<Response> sendFile(String url, File file) async {
    Dio dio = new Dio();
    var len = await file.length();
    var response = await dio.post(url,
        data: file.openRead(),
        options: Options(headers: {
          Headers.contentLengthHeader: len,
        }));
    return response;
!>J7
 "  
6-'I8
*package:olada/api/api_service.dart
Nfile:///C:/xampp/htdocs/pawonan/app/olada/lib/constants/app_theme.dart
import 'package:olada/constants/colors.dart';
import 'package:olada/constants/font_family.dart';
 * Creating custom color palettes is part of creating a custom app. The idea is to create
 * your class of custom colors, in this case `CompanyColors` and then create a `ThemeData`
 * object with those colors you just defined.
 * Resource:
 * A good resource would be this website: http://mcg.mbitson.com/
 * You simply need to put in the colour you wish to use, and it will generate all shades
 * for you. Your primary colour will be the `500` value.
 * Colour Creation:
 * In order to create the custom colours you need to create a `Map<int, Color>` object
 * which will have all the shade values. `const Color(0xFF...)` will be how you create
 * the colours. The six character hex code is what follows. If you wanted the colour
 * #114488 or #D39090 as primary colours in your theme, then you would have
 * `const Color(0x114488)` and `const Color(0xD39090)`, respectively.
 * Usage:
 * In order to use this newly created theme or even the colours in it, you would just
 * `import` this file in your project, anywhere you needed it.
 * `import 'path/to/theme.dart';`
import 'package:flutter/material.dart';
final ThemeData themeData = new ThemeData(
    fontFamily: FontFamily.productSans,
    brightness: Brightness.light,
    primarySwatch: MaterialColor(AppColors.orange[500].value, AppColors.orange),
    primaryColor: AppColors.orange[500],
    primaryColorBrightness: Brightness.light,
    accentColor: AppColors.orange[500],
    accentColorBrightness: Brightness.light);
final ThemeData themeDataDark = ThemeData(
  fontFamily: FontFamily.productSans,
  brightness: Brightness.dark,
  primaryColor: AppColors.orange[500],
  primaryColorBrightness: Brightness.dark,
  accentColor: AppColors.orange[500],
  accentColorBrightness: Brightness.dark,
XXVMG
,)#R*/)/
,' (,'+
.package:olada/constants/app_theme.dart
Kfile:///C:/xampp/htdocs/pawonan/app/olada/lib/constants/assets.dart
class Assets {
  Assets._();
  // splash screen assets
  static const String appLogo = "assets/icons/ic_appicon.png";
  // login screen assets
  static const String carBackground = "assets/images/img_login.jpg";
+package:olada/constants/assets.dart
Kfile:///C:/xampp/htdocs/pawonan/app/olada/lib/constants/colors.dart
3import 'package:flutter/material.dart';
class AppColors {
  AppColors._(); // this basically makes it so you can't instantiate this class
  static const Map<int, Color> orange = const <int, Color>{
    50: const Color(0xFFFCF2E7),
    100: const Color(0xFFF8DEC3),
    200: const Color(0xFFF3C89C),
    300: const Color(0xFFEEB274),
    400: const Color(0xFFEAA256),
    500: const Color(0xFFE69138),
    600: const Color(0xFFE38932),
    700: const Color(0xFFDF7E2B),
    800: const Color(0xFFDB7424),
    900: const Color(0xFFD56217)
  };
="########"
+package:olada/constants/colors.dart
WiPfile:///C:/xampp/htdocs/pawonan/app/olada/lib/constants/font_family.dart|class FontFamily {
  FontFamily._();
  static String productSans = "ProductSans";
  static String roboto = "Roboto";
0package:olada/constants/font_family.dart
Lfile:///C:/xampp/htdocs/pawonan/app/olada/lib/constants/strings.dartkclass Strings {
  Strings._();
  //General
  static const String appName = "Boilerplate Project";
,package:olada/constants/strings.dart
?file:///C:/xampp/htdocs/pawonan/app/olada/lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:olada/ui/my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print(message.data);
  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
        ),
      ));
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  runApp(MyApp());
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
class _MyAppState extends State<MyApp> {
  String token;
  List subscribed = [];
  List topics = [
    'Samsung',
    'Apple',
    'Huawei',
    'Nokia',
    'Sony',
    'HTC',
    'Lenovo'
  ];
  @override
  void initState() {
    super.initState();
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: android?.smallIcon,
              ),
            ));
      }
    });
    getToken();
    getTopics();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: App(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(0xffFF5400)),
    );
  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = token;
      prefs.setString("token", token);
    });
    print("firebase token: " + token);
  getTopics() async {
    setState(() {
      subscribed = subscribed;
    });
4>)P0>
H$-G 
O)/5-
(?"H
IB?D6/$! "4
package:olada/main.dart
Efile:///C:/xampp/htdocs/pawonan/app/olada/lib/model/chat.dart
import 'dart:convert';
class Chat {
  String from;
  int type;
  String content;
  DateTime createdAt;
  DateTime readAt;
  Chat({this.from, this.type, this.content, this.createdAt, this.readAt});
  factory Chat.fromJson(Map<String, dynamic> map) {
    return Chat(
      from: map["from"],
      type: map["type"],
      content: map["content"],
      createdAt: map["createdAt"],
      readAt: map["readAt"],
    );
  Map<String, dynamic> toJson() {
    return {
      "from": from,
      "type": type,
      "content": content,
      "createdAt": createdAt,
      "readAt": readAt,
    };
  @override
  String toString() {
    return 'Chat{from: $from, type: $type, content: $content, createdAt: $createdAt, readAt: $readAt}';
Chat chatFromJson(String jsonData) {
  return Chat.fromJson(json.decode(jsonData));
String chatToJson(Chat data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
%package:olada/model/chat.dart
Ofile:///C:/xampp/htdocs/pawonan/app/olada/lib/model/customlocation.dart
Vimport 'dart:convert';
class CustomLocation {
  double latitude;
  double longitude;
  String province;
  String city;
  String address;
  String description;
  CustomLocation(
      {this.latitude,
      this.longitude,
      this.province,
      this.city,
      this.address,
      this.description});
  factory CustomLocation.fromJson(Map<String, dynamic> map) {
    return CustomLocation(
        latitude: map["latitude"],
        longitude: map["longitude"],
        province: map["province"],
        city: map["city"],
        address: map["address"],
        description: map["description"]);
  Map<String, dynamic> toJson() {
    return {
      "latitude": latitude,
      "longitude": longitude,
      "description": description,
      "province": province,
      "city": city,
      "address": address,
    };
CustomLocation locationFromJson(String jsonData) {
  return CustomLocation.fromJson(json.decode(jsonData));
String locationToJson(CustomLocation data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
/package:olada/model/customlocation.dart
Ffile:///C:/xampp/htdocs/pawonan/app/olada/lib/model/order.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:olada/model/customlocation.dart';
import 'package:olada/model/chat.dart';
class Order {
  String id;
  String service;
  String subservice;
  String serviceDescription;
  List<File> images;
  String customerID;
  String partnerID;
  List<Chat> chats;
  DateTime date;
  TimeOfDay time;
  DateTime createdAt;
  int status;
  CustomLocation location;
  Order(
      {this.id,
      this.service,
      this.subservice,
      this.serviceDescription,
      this.customerID,
      this.partnerID,
      this.status});
  factory Order.fromJson(Map<String, dynamic> map) {
    return Order(
        id: map["_id"],
        service: map["service"],
        subservice: map["subservice"],
        serviceDescription: map["description"],
        customerID: map["customerId"],
        partnerID: map["partnerId"],
        status: int.parse(map["status"]));
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "service": service,
      "subservice": service,
      "serviceDescription": service,
      "images": images,
      "customerID": customerID,
      "partnerID": partnerID,
      "status": status,
      "location": location
    };
  @override
  String toString() {
    return 'Order{id: $id, service: $service,subservice: $subservice,serviceDescription: $serviceDescription,images: $images, customerID: $customerID, partnerID: $partnerID, status: $status, location: $location}';
Order orderFromJson(String jsonData) {
  return Order.fromJson(json.decode(jsonData));
String orderToJson(Order data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
!'0'%+
&package:olada/model/order.dart
Hfile:///C:/xampp/htdocs/pawonan/app/olada/lib/model/partner.dart
import 'dart:convert';
import 'package:olada/model/user.dart';
import 'package:olada/model/customlocation.dart';
class Partner {
  String id;
  UserOlada user;
  String service;
  List<String> subservice;
  CustomLocation location;
  PartnerRating rating;
  Partner(
      {this.id = "",
      this.user,
      this.service,
      this.subservice,
      this.location,
      this.rating});
  factory Partner.fromJson(Map<String, dynamic> map) {
    return Partner(
      id: map["_id"],
      service: map["service"],
    );
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user": user,
      "service": user,
      "subservice": user,
      "location": location,
      "rating": rating
    };
  @override
  String toString() {
    return 'Partner{id: $id, user: $user,service: $service,subservice: $subservice,location: $location,rating: $rating}';
Partner partnerFromJson(String jsonData) {
  return Partner.fromJson(json.decode(jsonData));
String partnerToJson(Partner data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
class PartnerRating {
  int average;
  PartnerRating({this.average});
  factory PartnerRating.fromJson(Map<String, dynamic> map) {
    return PartnerRating(average: map["average"]);
(package:olada/model/partner.dart
Ifile:///C:/xampp/htdocs/pawonan/app/olada/lib/model/response.dart
zimport 'dart:convert';
class CustomResponse {
  int status;
  String message;
  var data;
  String error;
  CustomResponse({this.status = 200, this.message, this.data, this.error});
  factory CustomResponse.fromJson(Map<String, dynamic> map) {
    return CustomResponse(
        status: map["status"],
        message: map["message"],
        data: map["data"],
        error: map["error"]);
  Map<String, dynamic> toJson() {
    return {"status": status, "message": message, "data": data, "error": error};
  @override
  String toString() {
    return 'CustomResponse{status: $status, message: $message, data: $data, error: $error}';
CustomResponse customResponseFromJson(String jsonData) {
  return CustomResponse.fromJson(json.decode(jsonData));
String customResponseToJson(CustomResponse data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
)package:olada/model/response.dart
Efile:///C:/xampp/htdocs/pawonan/app/olada/lib/model/user.dart
limport 'dart:convert';
class UserOlada {
  String id;
  String username;
  String firstname;
  String lastname;
  String image;
  String email;
  int verification;
  String token;
  UserOlada(
      {this.id,
      this.username,
      this.firstname,
      this.lastname,
      this.image,
      this.email,
      this.verification,
      this.token});
  factory UserOlada.fromJson(Map<String, dynamic> map) {
    return UserOlada(
        id: map["id"],
        username: map["username"],
        firstname: map["firstname"],
        lastname: map["lastname"],
        image: map["image"],
        email: map["email"],
        verification: map["verification"],
        token: map["accessToken"]);
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "firstname": username,
      "lastname": username,
      "image": image,
      "email": email,
      "verification": verification,
      "token": token
    };
  @override
  String toString() {
    return 'UserOlada{id: $id, username: $username,firstname: $firstname,lastname: $lastname,image: $image, email: $email, verification: $verification, token: $token}';
UserOlada userFromJson(String jsonData) {
  return UserOlada.fromJson(json.decode(jsonData));
String userToJson(UserOlada data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
%package:olada/model/user.dart
Ifile:///C:/xampp/htdocs/pawonan/app/olada/lib/ui/signin/signin.dart
import 'package:olada/constants/assets.dart';
import 'package:olada/widgets/empty_app_bar_widget.dart';
import 'package:olada/widgets/rounded_button_widget.dart';
import 'package:olada/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:olada/api/api_service.dart';
import 'package:olada/model/response.dart';
import 'package:olada/model/user.dart';
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ApiService apiService = ApiService();
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffFFFFFF),
      statusBarIconBrightness: Brightness.dark,
    ));
    FirebaseAuth auth = FirebaseAuth.instance;
    super.initState();
  Future getLocalData() async {
    await Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: EmptyAppBar(),
      body: _buildBody(),
    );
  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Material(
      color: Color(0xffffffff),
      child: Stack(
        children: <Widget>[
          MediaQuery.of(context).orientation == Orientation.landscape
              ? Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: _buildLeftSide(),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildRightSide(),
                    ),
                  ],
                )
              : Center(child: _buildRightSide()),
        ],
      ),
    );
  Widget _buildLeftSide() {
    return SizedBox.expand(
      child: Image.asset(
        Assets.carBackground,
        fit: BoxFit.cover,
      ),
    );
  Widget _buildRightSide() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/icons/logo-orange.png',
                height: 100.0, width: 100.0),
            Text(
              'Olada',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 24.0),
            _buildUserOladaIdField(),
            _buildPasswordField(),
            SizedBox(height: 25.0),
            _buildSignInButton(),
            _buildSignInBySocialMedia(),
            _buildForgotPasswordButton(),
          ],
        ),
      ),
    );
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUserOlada = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUserOlada.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  Widget _buildUserOladaIdField() {
    return TextFieldWidget(
      hint: 'Email',
      inputType: TextInputType.emailAddress,
      icon: Icons.person,
      textController: usernameController,
      inputAction: TextInputAction.next,
      autoFocus: false,
      onFieldSubmitted: (value) {},
      errorText: "",
    );
  Widget _buildPasswordField() {
    return TextFieldWidget(
      hint: 'Password',
      isObscure: true,
      padding: EdgeInsets.only(top: 16.0),
      icon: Icons.lock,
      textController: passwordController,
      errorText: "",
    );
  Widget _buildForgotPasswordButton() {
    return Column(
      children: [
        SizedBox(
          height: 30.0,
        ),
        Align(
          alignment: FractionalOffset.center,
          child: Center(
              child:
                  Text.rich(TextSpan(text: 'Tidak memiliki akun? ', children: [
            TextSpan(
              text: 'Daftar Sekarang',
              style: TextStyle(color: Color(0xffFF5400)),
              recognizer: new TapGestureRecognizer()
                ..onTap = () => Navigator.of(context).pushNamed('/register'),
            )
          ]))),
        )
      ],
    );
  Widget _buildSignInButton() {
    return RoundedButtonWidget(
      buttonText: 'Login',
      buttonColor: Color(0xffFF5400),
      textColor: Colors.white,
      onPressed: () async {
        String token = await FirebaseMessaging.instance.getToken();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          token = token;
          prefs.setString("token", token);
        });
        CustomResponse response = await apiService.signIn(
            usernameController.text, passwordController.text, token);
        if (response.status == 200) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          UserOlada user = UserOlada.fromJson(response.data);
          prefs.setString("user", jsonEncode(user));
          prefs.setString("token", user.token);
          Navigator.of(context).pushNamed('/dashboard');
        }
      },
    );
  Widget _buildSignInBySocialMedia() {
    return Center(
        child: Column(
      children: [
        SizedBox(
          height: 30.0,
        ),
        Text(
          "Atau masuk dengan sosial mediamu",
          style: TextStyle(color: Color(0xff1f1f1f)),
        ),
        SizedBox(
          height: 25.0,
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  var credential = signInWithGoogle();
                  var user = FirebaseAuth.instance.currentUser.email;
                },
                child: Image.asset('assets/icons/google-orange.png',
                    width: 35.0, height: 35.0),
              ),
              SizedBox(
                width: 15.0,
              ),
              Image.asset('assets/icons/facebook-orange.png',
                  width: 35.0, height: 35.0),
              SizedBox(
                width: 15.0,
              ),
              Image.asset('assets/icons/twitter-orange.png',
                  width: 35.0, height: 35.0)
            ])
      ],
    ));
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
7CD?)>))651
644>
@*1	0
%($%#*+
(;6O
<G'LA61
 #8G
)package:olada/ui/signin/signin.dart
ALfile:///C:/xampp/htdocs/pawonan/app/olada/lib/ui/main/home/home.dart
wimport 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:olada/model/user.dart';
import 'dart:convert';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
class _HomeScreenState extends State<HomeScreen> {
  SharedPreferences preferences;
  String user;
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffFF5400),
      statusBarIconBrightness: Brightness.light,
    ));
    super.initState();
    getLocalData();
  Future getLocalData() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      this.user = preferences.getString('user');
    });
  @override
  Widget build(BuildContext context) {
    print(user);
    return _buildRightSide();
  Widget _buildRightSide() {
    List promos = [Container(), Container(), Container()];
    return SingleChildScrollView(
        child: Column(
      children: [
        Container(
            padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
            decoration: BoxDecoration(color: Color(0xffFF5400)),
            height: 150.0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/icons/sun.png',
                            height: 32.0, width: 32.0),
                        SizedBox(
                          width: 20.0,
                        ),
                        Text('Selamat pagi',
                            style: TextStyle(
                                color: Color(0xffFFFFFF), fontSize: 20.0))
                      ],
                    ),
                    Image.asset('assets/icons/notification.png',
                        height: 32.0, width: 32.0)
                  ],
                )
              ],
            )),
        Container(
            transform: Matrix4.translationValues(0.0, -50.0, 0.0),
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
                decoration: BoxDecoration(
                    color: Color(0xffFFFFFF),
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      )
                    ]),
                padding: EdgeInsets.only(top: 25.0, left: 20.0, right: 20.0),
                height: 100.0,
                width: double.infinity,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Poin anda',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color(0xff777777), fontSize: 16.0)),
                        SizedBox(height: 10.0),
                        Text('163.000',
                            style: TextStyle(
                                color: Color(0xff000000),
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0))
                      ],
                    ),
                    Column(
                      children: [],
                    ),
                  ],
                ))),
        Container(
            transform: Matrix4.translationValues(0.0, -20.0, 0.0),
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          Navigator.of(context).pushNamed('/subservices',
                              arguments: {'service': 'Bangunan'});
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 60.0,
                            width: 60.0,
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                color: Color(0xffeeeeee),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Image.asset('assets/icons/building.png',
                                height: 25.0, width: 25.0),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text('Bangunan')
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          Navigator.of(context).pushNamed('/subservices',
                              arguments: {'service': 'Elektronik'});
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 60.0,
                            width: 60.0,
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                color: Color(0xffeeeeee),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Image.asset('assets/icons/electronics.png',
                                height: 25.0, width: 25.0),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text('Elektronik')
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          Navigator.of(context)
                              .pushNamed('/subservices', arguments: {
                            'service': 'Mekanik',
                          });
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 60.0,
                            width: 60.0,
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                color: Color(0xffeeeeee),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Image.asset('assets/icons/setting.png',
                                height: 25.0, width: 25.0),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text('Mekanik')
                        ],
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            Navigator.of(context)
                                .pushNamed('/subservice', arguments: {
                              'service': 'Air',
                            });
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 60.0,
                              width: 60.0,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: Color(0xffeeeeee),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Image.asset('assets/icons/water.png',
                                  height: 25.0, width: 25.0),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text('Air')
                          ],
                        ))
                  ],
                ),
                SizedBox(height: 20.0),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.of(context).pushNamed('/order/form',
                            arguments: {
                              'service': 'Bangunan',
                              'subService': 'Renovasi'
                            });
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 60.0,
                              width: 60.0,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: Color(0xffeeeeee),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Image.asset('assets/icons/furniture.png',
                                  height: 25.0, width: 25.0),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text('Furnitur')
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              height: 60.0,
                              width: 60.0,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: Color(0xffeeeeee),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Image.asset('assets/icons/homecare.png',
                                  height: 25.0, width: 25.0),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text('Home care')
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              Navigator.of(context)
                                  .pushNamed('/subservices', arguments: {
                                'service': 'Bangunan',
                              });
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 60.0,
                                width: 60.0,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Color(0xffeeeeee),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Image.asset('assets/icons/grass.png',
                                    height: 25.0, width: 25.0),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text('Pekarangan')
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              height: 60.0,
                              width: 60.0,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: Color(0xffeeeeee),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Image.asset('assets/icons/other.png',
                                  height: 25.0, width: 25.0),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text('Lainnya')
                          ],
                        ),
                      ],
                    )),
              ],
            )),
        Container(
          height: 4.0,
          width: double.infinity,
          transform: Matrix4.translationValues(0.0, 10.0, 0.0),
          decoration: BoxDecoration(color: Color(0xffeeeeee)),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Spesial untuk kamu',
                    style: TextStyle(fontSize: 18.0)),
              ),
              Container(
                  height: 120.0,
                  margin: EdgeInsets.only(top: 20.0),
                  child: ListView.builder(
                    itemCount: promos.length,
                    itemBuilder: (context, index) {
                      return new Container(
                        width: 300,
                        child: Stack(children: <Widget>[
                          Container(
                            height: 120.0,
                            width: 300.0,
                            margin: EdgeInsets.only(right: 30.0),
                            decoration: BoxDecoration(
                                color: Color(0xffcccccc),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        ]),
                      );
                    },
                    scrollDirection: Axis.horizontal,
                  ))
            ],
          ),
        )
      ],
    ));
(=(0
"<8"'
+.>!!=)'.
D"*7.L0(.:=1
%"&JC
%$%*);7:LL<
%"&JE
%$%*);7:LO<
%"&0F2
%$%*);7:LK<
%$(2G0 
'&',+=9<NK>
(! $G)57 
 I" &',+=9<NO>
 &',+=9<NN>
)&*4J7" 
)().-?;>PM@!(-!1
 &',+=9<NK>
!6+.4,$9%+*B7:.L
,package:olada/ui/main/home/home.dart
Gfile:///C:/xampp/htdocs/pawonan/app/olada/lib/ui/main/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:olada/ui/main/home/home.dart';
import 'package:olada/ui/main/order/order.dart';
import 'package:olada/ui/main/reward/reward.dart';
import 'package:olada/ui/main/profile/profile.dart';
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [];
  final List<Widget> pages = [
    HomeScreen(),
    OrderScreen(),
    RewardScreen(),
    ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffFF5400),
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
        floatingActionButton: new FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/subservices');
          },
          tooltip: 'Increment',
          backgroundColor: Color(0xffFF5400),
          child: new Icon(
            Icons.add,
            color: Colors.white,
          ),
          elevation: 0.0,
        ),
        bottomNavigationBar: BottomAppBar(
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentIndex = 0;
                        });
                      },
                      child: Container(
                          padding: EdgeInsets.only(top: 5.0),
                          height: 50.0,
                          child: Column(children: [
                            Icon(CupertinoIcons.home,
                                color: (_currentIndex == 0)
                                    ? Color(0xffFF5400)
                                    : Color(0xff000000)),
                            Text('Beranda',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: (_currentIndex == 0)
                                        ? Color(0xffFF5400)
                                        : Color(0xff000000)))
                          ])))),
              Expanded(
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentIndex = 1;
                        });
                      },
                      child: Container(
                          padding: EdgeInsets.only(top: 5.0),
                          height: 50.0,
                          child: Column(children: [
                            Icon(CupertinoIcons.list_bullet,
                                color: (_currentIndex == 1)
                                    ? Color(0xffFF5400)
                                    : Color(0xff000000)),
                            Text('Pesanan',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: (_currentIndex == 1)
                                        ? Color(0xffFF5400)
                                        : Color(0xff000000)))
                          ])))),
              Expanded(child: new Text('')),
              Expanded(
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentIndex = 2;
                        });
                      },
                      child: Container(
                          padding: EdgeInsets.only(top: 5.0),
                          height: 50.0,
                          child: Column(children: [
                            Icon(CupertinoIcons.gift,
                                color: (_currentIndex == 2)
                                    ? Color(0xffFF5400)
                                    : Color(0xff000000)),
                            Text('Hadiah',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: (_currentIndex == 2)
                                        ? Color(0xffFF5400)
                                        : Color(0xff000000)))
                          ])))),
              Expanded(
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentIndex = 3;
                        });
                      },
                      child: Container(
                          padding: EdgeInsets.only(top: 5.0),
                          height: 50.0,
                          child: Column(children: [
                            Icon(CupertinoIcons.profile_circled,
                                color: (_currentIndex == 3)
                                    ? Color(0xffFF5400)
                                    : Color(0xff000000)),
                            Text('Profil',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: (_currentIndex == 3)
                                        ? Color(0xffFF5400)
                                        : Color(0xff000000)))
                          ])))),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: SafeArea(
          child: SingleChildScrollView(
            child: pages[_currentIndex],
          ),
        ));
()(79;=
'?)1
*"&-
(>(46<8:,24@<>!
*"&-
(>(4=<8:,24@<>!-
*"&-
(>(46<8:+24@<>!
*"&-
(>(4A<8:+24@<>!
'package:olada/ui/main/main.dart
Zfile:///C:/xampp/htdocs/pawonan/app/olada/lib/ui/main/order/checkout/checkout.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math' as math;
import 'package:olada/api/api_service.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:olada/model/partner.dart';
import 'package:olada/model/user.dart';
import 'dart:math' as Math;
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:olada/utils/map/icon_map.dart';
class CheckoutOrderScreen extends StatefulWidget {
  @override
  _CheckoutOrderScreenState createState() => _CheckoutOrderScreenState();
class _CheckoutOrderScreenState extends State<CheckoutOrderScreen> {
  String serviceDescription;
  Position locationCoordinate;
  String locationDescription;
  List<File> images;
  DateTime date;
  TimeOfDay time;
  var paymentMethod;
  Position location = Position(latitude: -7.2941646, longitude: 112.7986343);
  static final LatLng _kMapCenter = LatLng(-7.2941646, 112.7986343);
  static final CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);
  String service = "";
  String subService = "";
  String address = "-";
  String city;
  Partner partner;
  GoogleMapController _googleMapController;
  Marker _origin;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController serviceDescriptionController = TextEditingController();
  TextEditingController locationDescriptionController = TextEditingController();
  Future<void> _getAddress(double lat, double lang) async {
    final coordinates = new Coordinates(lat, lang);
    List<Address> add =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      this.address = add.first.addressLine;
    });
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffFFFFFF),
      statusBarIconBrightness: Brightness.dark,
    ));
    super.initState();
  Future<void> _getArguments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      setState(() {
        this.service = arguments['service'];
        this.subService = arguments['subService'];
        this.city = arguments['city'];
        this.serviceDescription = arguments['service_description'];
        this.locationCoordinate = arguments['location_coordinate'];
        this.locationDescription = arguments['location_description'];
        this.images = arguments['images'];
        this.date = arguments['date'];
        this.time = arguments['time'];
        this.partner = arguments['partner'];
        _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(
                    locationCoordinate.latitude, locationCoordinate.longitude),
                zoom: 15.0)));
        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position:
              LatLng(locationCoordinate.latitude, locationCoordinate.longitude),
        );
        serviceDescriptionController.text = serviceDescription;
        locationDescriptionController.text = locationDescription;
        _getAddress(partner.location.latitude, partner.location.longitude);
      });
    }
  String _getDistance(double latitude, double longitude) {
    var distance = "";
    if (latitude != null) {
      var R = 6371;
      var dLat = deg2rad(locationCoordinate.latitude - latitude);
      var dLon = deg2rad(locationCoordinate.longitude - longitude);
      var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
          Math.cos(deg2rad(latitude)) *
              Math.cos(deg2rad(locationCoordinate.latitude)) *
              Math.sin(dLon / 2) *
              Math.sin(dLon / 2);
      var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
      var _distanceInKm = R * c;
      distance = _distanceInKm.toStringAsFixed(2) + " Km dari anda";
    }
    return distance;
  double deg2rad(deg) {
    return deg * (Math.pi / 180);
  @override
  Widget build(BuildContext context) {
    var apiService = new ApiService();
    return Stack(children: [
      Scaffold(
        primary: true,
        appBar: AppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.white,
            centerTitle: true,
            title: Text('Konfirmasi Pesanan',
                style: TextStyle(
                  color: Colors.black,
                )),
            iconTheme: IconThemeData(color: Colors.black)),
        body: _buildRightSide(),
      ),
      Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            child: Container(
              padding: EdgeInsets.all(15.0),
              height: 70.0,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                )
              ]),
              child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  elevation: 0.0,
                  minWidth: 50.0,
                  padding: EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                  height: 35,
                  color: Color(0xffFF5400),
                  child: new Text('Konfirmasi',
                      style:
                          new TextStyle(fontSize: 16.0, color: Colors.white)),
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    UserOlada user = userFromJson(prefs.getString("user"));
                    final formData = FormData.fromMap({
                      'customerId': user.id,
                      'partnerId': partner.id,
                      'service': service,
                      'subservice': subService,
                      'description': serviceDescription,
                      'latitude': locationCoordinate.latitude,
                      'longitude': locationCoordinate.longitude,
                      'locationDescription': locationDescription,
                      'date': date.toString(),
                      'time': time.toString()
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
                    print("service: " + service);
                    print("subservice: " + subService);
                    var res1 = await apiService.sendForm(formData);
                    Navigator.of(context).pushNamed('/dashboard');
                  }),
            ),
          ))
    ]);
  Widget _buildRightSide() {
    return SingleChildScrollView(
        child: Column(
      children: [
        Container(
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 60.0,
                          width: 60.0,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              color: Color(0xffeeeeee),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Image.asset(iconOfSubservices[subService],
                              height: 25.0, width: 25.0),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(service,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.grey)),
                        Text(subService,
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold))
                      ],
                    )
                  ],
                ),
              ],
            )),
        Container(
          height: 4.0,
          width: double.infinity,
          transform: Matrix4.translationValues(0.0, 10.0, 0.0),
          decoration: BoxDecoration(color: Color(0xffeeeeee)),
        ),
        Container(
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Lokasi dan Waktu Pengerjaan',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/order/form/maps');
                  },
                  child: Container(
                    height: 150.0,
                    child: GoogleMap(
                      onMapCreated: (controller) =>
                          {_googleMapController = controller, _getArguments()},
                      initialCameraPosition: _kInitialPosition,
                      markers: {
                        if (_origin != null) _origin,
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(address,
                    style: TextStyle(color: Colors.black, fontSize: 17.0)),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: locationDescriptionController,
                  decoration: new InputDecoration(
                      contentPadding:
                          EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: BorderSide(color: Color(0xffFF5400))),
                      hintText: 'Keterangan Alamat (ex: RT/RW, Blok)'),
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                      fontSize: 16.0,
                      height: 1,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w100),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: 190.0,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: GestureDetector(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.calendar,
                                color: Color(0xffFF5400)),
                            SizedBox(width: 8.0),
                            Text(new DateFormat.yMMMd().format(selectedDate))
                          ],
                        ))),
                    Container(
                        width: 120.0,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.clock,
                                  color: Color(0xffFF5400)),
                              SizedBox(width: 8.0),
                              Text(selectedTime.hour.toString() +
                                  ":" +
                                  selectedTime.minute.toString())
                            ],
                          ),
                        ))
                  ],
                )
              ],
            )),
        Container(
          height: 4.0,
          width: double.infinity,
          transform: Matrix4.translationValues(0.0, 10.0, 0.0),
          decoration: BoxDecoration(color: Color(0xffeeeeee)),
        ),
        (partner != null)
            ? Container(
                decoration: BoxDecoration(color: Colors.white),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tukang',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          width: MediaQuery.of(context).size.width - 40.0,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 200.0,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Image.network(
                                              'http://213.190.4.239/img/users/${partner.user.image}',
                                              height: 55.0,
                                              width: 55.0)
                                        ],
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              left: 15.0, top: 0.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  partner.user.firstname +
                                                      " " +
                                                      partner.user.lastname,
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(height: 5.0),
                                              Text(_getDistance(
                                                  partner.location.latitude,
                                                  partner.location.longitude)),
                                              SizedBox(height: 5.0),
                                              Row(children: [
                                                Icon(CupertinoIcons.star_fill,
                                                    color: Colors.yellow,
                                                    size: 18.0),
                                                SizedBox(width: 5.0),
                                                Text((partner.rating != null
                                                    ? partner.rating.average
                                                    : '-'))
                                              ])
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                              ]))
                    ]))
            : Text(''),
        Container(
          height: 4.0,
          width: double.infinity,
          transform: Matrix4.translationValues(0.0, 10.0, 0.0),
          decoration: BoxDecoration(color: Color(0xffeeeeee)),
        ),
        Container(
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Deskripsi pekerjaan',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: serviceDescriptionController,
                    decoration: new InputDecoration(
                        contentPadding:
                            EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Color(0xffFF5400))),
                        hintText: 'Deskripsi pekerjaan)'),
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                        fontSize: 16.0,
                        height: 1,
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w100),
                  )
                ])),
        Container(
          height: 4.0,
          width: double.infinity,
          transform: Matrix4.translationValues(0.0, 10.0, 0.0),
          decoration: BoxDecoration(color: Color(0xffeeeeee)),
        ),
        Container(
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Foto pekerjaan yang harus dilakukan',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                SizedBox(height: 20.0),
                Container(
                  height: 120.0,
                  child: (images != null)
                      ? ListView.builder(
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return new Container(
                              height: 120.0,
                              width: 120.0,
                              child: Stack(children: <Widget>[
                                GestureDetector(
                                    child: Container(
                                  height: 130.0,
                                  width: 120.0,
                                  margin: EdgeInsets.only(right: 20.0),
                                  decoration: BoxDecoration(
                                      color: Color(0xffffffff),
                                      border: Border.all(color: Colors.grey),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  alignment: Alignment.center,
                                  child: images[index] == null
                                      ? Icon(CupertinoIcons.add)
                                      : Image.file(images[index],
                                          height: 130.0, width: 120.0),
                                )),
                              ]),
                            );
                          },
                          scrollDirection: Axis.horizontal,
                        )
                      : Text(''),
                ),
                SizedBox(height: 10.0),
                Text('*Opsional, maksimal 4',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey))
              ],
            )),
        Container(
          height: 4.0,
          width: double.infinity,
          transform: Matrix4.translationValues(0.0, 10.0, 0.0),
          decoration: BoxDecoration(color: Color(0xffeeeeee)),
        ),
        Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Metode Pembayaran',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.all(15.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tunai', style: TextStyle(color: Colors.grey)),
                      Transform.rotate(
                          angle: 180 * math.pi / 180,
                          child: Icon(CupertinoIcons.triangle_fill,
                              size: 12.0, color: Color(0xff222222)))
                    ],
                  ),
                )
              ],
            )),
        SizedBox(
          height: 70.0,
        )
      ],
    ));
?-)=30
NE2L
*,PQ
-3'DDF+''-
BD8(?#">!
7#!(
%1M"",G
O(.?
8-/*09?AB/.
$(FG#
"#('958JL:
BD"&#P).N
$#&4P@!6
=3&O$/=HG=HMH4$&!04
&73BE
0(G&:;2N
&73BE
0&I(9=4B(B
@B %,M &
!AK&QL2+0.8BP0-49f<;+)1CE9@J84K<MDFBMEAMPE>OJAFMM<1/-'%#"
!>5(Q&1?JI?JO;6&(#26
!**4:2-,?1610H=@N4Q??ABH$"
1*-<>
G K(6DE
:package:olada/ui/main/order/checkout/checkout.dart
Vfile:///C:/xampp/htdocs/pawonan/app/olada/lib/ui/main/order/detail/detail.dart
PWimport 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:olada/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:olada/model/partner.dart';
import 'dart:io';
import 'dart:async';
import 'package:geocoder/geocoder.dart';
import 'dart:math' as Math;
import 'package:olada/api/api_service.dart';
import 'package:olada/model/response.dart';
import 'package:olada/model/order.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:olada/model/customlocation.dart';
import 'package:olada/utils/map/icon_map.dart';
class DetailOrderScreen extends StatefulWidget {
  @override
  _DetailOrderScreenState createState() => _DetailOrderScreenState();
class _DetailOrderScreenState extends State<DetailOrderScreen> {
  String serviceDescription;
  Position locationCoordinate;
  String locationDescription;
  List<String> images;
  String date;
  String time;
  var paymentMethod;
  Position location = Position(latitude: -7.2941646, longitude: 112.7986343);
  static final LatLng _kMapCenter = LatLng(-7.2941646, 112.7986343);
  static final CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);
  String service = "";
  String subService = "";
  String address = "-";
  String city;
  Partner partner;
  GoogleMapController _googleMapController;
  Marker _origin;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController serviceDescriptionController = TextEditingController();
  TextEditingController locationDescriptionController = TextEditingController();
  Future<void> _getAddress(double lat, double lang) async {
    final coordinates = new Coordinates(lat, lang);
    List<Address> add =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      this.address = add.first.addressLine;
    });
  String orderID;
  ApiService apiService = ApiService();
  Order order;
  String _getDistance(double latitude, double longitude) {
    var distance = "";
    if (latitude != null) {
      var R = 6371;
      var dLat = deg2rad(locationCoordinate.latitude - latitude);
      var dLon = deg2rad(locationCoordinate.longitude - longitude);
      var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
          Math.cos(deg2rad(latitude)) *
              Math.cos(deg2rad(locationCoordinate.latitude)) *
              Math.sin(dLon / 2) *
              Math.sin(dLon / 2);
      var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
      var _distanceInKm = R * c;
      distance = _distanceInKm.toStringAsFixed(2) + " Km dari anda";
    }
    return distance;
  double deg2rad(deg) {
    return deg * (Math.pi / 180);
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffFFFFFF),
      statusBarIconBrightness: Brightness.dark,
    ));
    super.initState();
  Future<void> _getArguments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    Order _order;
    Partner _partner;
    String _date, time = "";
    List<String> _images = [];
    if (arguments != null) {
      CustomResponse response =
          await apiService.getOrderById(arguments['orderID']);
      if (response.status == 200) {
        _order = Order.fromJson(response.data[0]);
        _order.location = CustomLocation.fromJson(response.data[0]['location']);
        for (int i = 0; i < response.data[0]['images'].length; i++)
          _images.add(response.data[0]['images'][i]['url'].toString());
        String _time = response.data[0]['time'];
        _date = response.data[0]['date'];
        int start = -1;
        for (int i = 0; i < _time.length; i++) {
          if (_time[i] == ')') break;
          if (start != -1) {
            time += _time[i];
          }
          if (_time[i] == '(') {
            start = i + 1;
          }
        }
        print("time: " + time);
        response = await apiService.getPartnerById(_order.partnerID);
        if (response.status == 200) {
          _partner = Partner.fromJson(response.data[0]);
          _partner.location =
              CustomLocation.fromJson(response.data[0]['location']);
          _partner.user = UserOlada.fromJson(response.data[0]['user']);
        }
      }
      print(_partner.toString());
      print(_order.toString());
      setState(() {
        this.order = _order;
        this.partner = _partner;
        this.time = time;
        this.date = _date.substring(0, 10);
        this.images = _images;
      });
      _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(order.location.latitude, order.location.longitude),
              zoom: 15.0)));
      _origin = Marker(
        markerId: const MarkerId('origin'),
        infoWindow: const InfoWindow(title: 'Origin'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: LatLng(order.location.latitude, order.location.longitude),
      );
      _getAddress(partner.location.latitude, partner.location.longitude);
    }
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        primary: true,
        appBar: AppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.white,
            centerTitle: true,
            title: Text('Detail Pesanan',
                style: TextStyle(
                  color: Colors.black,
                )),
            iconTheme: IconThemeData(color: Colors.black)),
        backgroundColor: Colors.white,
        body: _buildRightSide(),
      ),
    ]);
  Widget _buildRightSide() {
    return SingleChildScrollView(
        child: Column(
      children: [
        Container(
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 60.0,
                          width: 60.0,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              color: Color(0xffeeeeee),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: (order != null)
                              ? Image.asset(iconOfSubservices[order.subservice],
                                  height: 25.0, width: 25.0)
                              : Container(),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text((order != null) ? order.service : '-',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.grey)),
                        Text((order != null) ? order.subservice : '-',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold))
                      ],
                    )
                  ],
                ),
              ],
            )),
        Container(
          height: 4.0,
          width: double.infinity,
          transform: Matrix4.translationValues(0.0, 10.0, 0.0),
          decoration: BoxDecoration(color: Color(0xffeeeeee)),
        ),
        Container(
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Lokasi dan Waktu Pengerjaan',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  child: Container(
                    height: 150.0,
                    child: GoogleMap(
                      onMapCreated: (controller) =>
                          {_googleMapController = controller, _getArguments()},
                      initialCameraPosition: _kInitialPosition,
                      markers: {
                        if (_origin != null) _origin,
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(address != null ? address : '',
                    style: TextStyle(color: Colors.black, fontSize: 17.0)),
                SizedBox(
                  height: 20.0,
                ),
                Text('Deskripsi lokasi',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10.0,
                ),
                Text(order != null ? order.location.description : '-'),
                SizedBox(height: 20.0),
                Text('Waktu', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: 190.0,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: GestureDetector(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.calendar,
                                  color: Color(0xffFF5400)),
                              SizedBox(width: 8.0),
                              Text(date != null ? date : '-')
                            ],
                          ))),
                      Container(
                          width: 120.0,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: GestureDetector(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.clock,
                                    color: Color(0xffFF5400)),
                                SizedBox(width: 8.0),
                                Text(time != null ? time : '')
                              ],
                            ),
                          ))
                    ])
              ],
            )),
        Container(
          height: 4.0,
          width: double.infinity,
          transform: Matrix4.translationValues(0.0, 10.0, 0.0),
          decoration: BoxDecoration(color: Color(0xffeeeeee)),
        ),
        (partner != null)
            ? Container(
                decoration: BoxDecoration(color: Colors.white),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tukang',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          width: MediaQuery.of(context).size.width - 40.0,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 200.0,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          (partner != null)
                                              ? Image.network(
                                                  'http://213.190.4.239/img/users/${partner.user.image}',
                                                  height: 55.0,
                                                  width: 55.0)
                                              : Container()
                                        ],
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              left: 15.0, top: 0.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              (partner != null)
                                                  ? Text(
                                                      partner.user.firstname +
                                                          " " +
                                                          partner.user.lastname,
                                                      style: TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold))
                                                  : Container(),
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                              ]))
                    ]))
            : Text(''),
        Container(
          height: 4.0,
          width: double.infinity,
          transform: Matrix4.translationValues(0.0, 10.0, 0.0),
          decoration: BoxDecoration(color: Color(0xffeeeeee)),
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Deskripsi pekerjaan',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(order != null ? order.serviceDescription : '-')
                ])),
        Container(
          height: 4.0,
          width: double.infinity,
          transform: Matrix4.translationValues(0.0, 10.0, 0.0),
          decoration: BoxDecoration(color: Color(0xffeeeeee)),
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Foto pekerjaan yang harus dilakukan',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                SizedBox(height: 20.0),
                Container(
                    height: 120.0,
                    child: (images == null)
                        ? Container()
                        : ListView.builder(
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              return new Container(
                                height: 120.0,
                                width: 120.0,
                                child: Stack(children: <Widget>[
                                  Image.network(
                                      'http://213.190.4.239/img/orders/${images[index]}',
                                      height: 130.0,
                                      width: 120.0),
                                ]),
                              );
                            },
                            scrollDirection: Axis.horizontal,
                          )),
                SizedBox(height: 10.0),
                Text('*Opsional, maksimal 4',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey))
              ],
            )),
        Container(
          height: 4.0,
          width: double.infinity,
          transform: Matrix4.translationValues(0.0, 10.0, 0.0),
          decoration: BoxDecoration(color: Color(0xffeeeeee)),
        ),
        Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Metode Pembayaran',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.all(15.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tunai', style: TextStyle(color: Colors.grey)),
                      Transform.rotate(
                          angle: 180 * math.pi / 180,
                          child: Icon(CupertinoIcons.triangle_fill,
                              size: 12.0, color: Color(0xff222222)))
                    ],
                  ),
                )
              ],
            )),
        SizedBox(
          height: 70.0,
        )
      ],
    ));
(()?-0=3
NE2L
*,PQ
BD8(?#">!
$3QDH
,7NM	
<'!	
"#('958J1Q=-
BD"D#PG.N
!$#&4P@!6
G !(95DG
2*I(<=4>
!(95DG
2(K*;?6?!
@B %,M &
!AK&QL2+0.8BP0-4<?j@?<+)1CE9@J8@:O@QHJFPA/-'%#"
#,&,6<4/.A1Z55$!
1*-<>
G K(6DE
6package:olada/ui/main/order/detail/detail.dart
dfile:///C:/xampp/htdocs/pawonan/app/olada/lib/ui/main/order/detailpartner/detailpartner.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:olada/model/partner.dart';
import 'dart:io';
import 'dart:async';
import 'package:geocoder/geocoder.dart';
import 'dart:math' as Math;
class DetailPartnerOrderScreen extends StatefulWidget {
  @override
  _DetailPartnerOrderScreenState createState() =>
      _DetailPartnerOrderScreenState();
class _DetailPartnerOrderScreenState extends State<DetailPartnerOrderScreen> {
  String serviceDescription;
  Position locationCoordinate;
  String locationDescription;
  List<File> images;
  DateTime date;
  TimeOfDay time;
  var paymentMethod;
  Position location = Position(latitude: -7.2941646, longitude: 112.7986343);
  static final LatLng _kMapCenter = LatLng(-7.2941646, 112.7986343);
  static final CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);
  String service = "";
  String subService = "";
  String address = "-";
  String city;
  Partner partner;
  Future<void> _getAddress(double lat, double lang) async {
    final coordinates = new Coordinates(lat, lang);
    List<Address> add =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      this.address = add.first.addressLine;
    });
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffFFFFFF),
      statusBarIconBrightness: Brightness.dark,
    ));
    super.initState();
    _getArguments();
  Future<void> _getArguments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      setState(() {
        this.service = arguments['service'];
        this.subService = arguments['subService'];
        this.city = arguments['city'];
        this.serviceDescription = arguments['service_description'];
        this.locationCoordinate = arguments['location_coordinate'];
        this.locationDescription = arguments['location_description'];
        this.images = arguments['images'];
        this.date = arguments['date'];
        this.time = arguments['time'];
        this.partner = arguments['partner'];
        _getAddress(partner.location.latitude, partner.location.longitude);
      });
    }
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        primary: true,
        appBar: AppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.white,
            centerTitle: true,
            title: Text('Profil Tukang',
                style: TextStyle(
                  color: Colors.black,
                )),
            iconTheme: IconThemeData(color: Colors.black)),
        body: Container(
          child: _buildRightSide(),
        ),
      ),
      Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            child: Container(
              padding: EdgeInsets.all(15.0),
              height: 70.0,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                )
              ]),
              child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  elevation: 0.0,
                  minWidth: 50.0,
                  padding: EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                  height: 35,
                  color: Color(0xffFF5400),
                  child: new Text('Pesan',
                      style:
                          new TextStyle(fontSize: 16.0, color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed('/order/checkout', arguments: {
                      'service': service,
                      'subService': subService,
                      'service_description': serviceDescription,
                      'location_coordinate': location,
                      'location_description': locationDescription,
                      'city': city,
                      'images': images,
                      'date': date,
                      'time': time,
                      'partner': partner,
                    });
                  }),
            ),
          ))
    ]);
  Widget _buildRightSide() {
    List partners = [Container(), Container(), Container(), Container()];
    return SingleChildScrollView(
      child: Column(children: [
        Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                        'http://213.190.4.239/img/users/${partner.user.image}',
                        height: 120.0,
                        width: 120.0),
                    SizedBox(height: 20.0),
                    Text(partner.user.firstname + " " + partner.user.lastname,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 40.0),
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(CupertinoIcons.placemark),
                        SizedBox(width: 10.0),
                        Text('Alamat \t :', style: TextStyle(fontSize: 17.5)),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Text('$address', style: TextStyle(fontSize: 17.5)),
                    SizedBox(height: 15.0),
                    Row(
                      children: [
                        Icon(CupertinoIcons.star),
                        SizedBox(width: 10.0),
                        Text(
                            (partner.rating != null)
                                ? 'Rating \t : \t ' +
                                    partner.rating.average.toString()
                                : 'Rating \t : \t ' + '-',
                            style: TextStyle(fontSize: 17.5)),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      children: [
                        Icon(CupertinoIcons.doc),
                        SizedBox(width: 10.0),
                        Text('Sertifikat \t : \t Tersertifikasi',
                            style: TextStyle(fontSize: 17.5)),
                        SizedBox(width: 10.0),
                        MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0))),
                            elevation: 0.0,
                            minWidth: 30.0,
                            height: 25,
                            color: Color(0xffFF5400),
                            child: new Text('Lihat',
                                style: new TextStyle(
                                    fontSize: 14.0, color: Colors.white)),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed('/order/partner/{id}');
                            }),
                      ],
                    )
                  ],
                ),
              ],
            )),
        Container(
          height: 4.0,
          width: double.infinity,
          transform: Matrix4.translationValues(0.0, 10.0, 0.0),
          decoration: BoxDecoration(color: Color(0xffeeeeee)),
        ),
        SizedBox(height: 20.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 20.0, top: 20.0),
              child: Text('Review',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.0,
                  )),
            ),
            SizedBox(height: 20.0),
            Container(
              height: 300.0,
              child: ListView.builder(
                itemCount: partners.length,
                itemBuilder: (context, index) {
                  return new Container(
                      margin: EdgeInsets.only(
                          bottom: 20.0, left: 20.0, right: 20.0),
                      width: MediaQuery.of(context).size.width - 40.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 200.0,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Image.asset(
                                              'assets/images/avatar.png',
                                              height: 50.0,
                                              width: 50.0)
                                        ],
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              left: 15.0, top: 0.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Wahyudi',
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(height: 5.0),
                                              Text('2 minggu yang lalu'),
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                              ]),
                          SizedBox(height: 20.0),
                          Text(
                            '"Pelayanan memuaskan dan cepat"',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ],
                      ));
                },
                scrollDirection: Axis.vertical,
              ),
            )
          ],
        )
      ]),
    );
  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    super.dispose();
(()?-=3
NE2L
-3'DDF+''-
7#!(
%1M"",G
O"*C*0A7C$($$*
#P'',O*1,;
"8/O
56F;?
"2/B?/(;.M,,(656K,4E 
?$$)$
',0(/BG%F$
QL2+0.8BP0-47J<;+)1CE9@J8>DFBMEJ/-'%#"2 ?>
Dpackage:olada/ui/main/order/detailpartner/detailpartner.dart
Rfile:///C:/xampp/htdocs/pawonan/app/olada/lib/ui/main/order/form/form.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math' as math;
import 'package:olada/api/api_service.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:olada/utils/map/icon_map.dart';
import 'package:olada/model/partner.dart';
class FormOrderScreen extends StatefulWidget {
  @override
  _FormOrderScreenState createState() => _FormOrderScreenState();
class _FormOrderScreenState extends State<FormOrderScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController serviceDescriptionController = TextEditingController();
  TextEditingController locationDescriptionController = TextEditingController();
  var paymentMethod;
  File blank;
  List<File> images = [null];
  final picker = ImagePicker();
  GoogleMapController _googleMapController;
  Marker _origin;
  Position location = Position(latitude: -7.2941646, longitude: 112.7986343);
  static final LatLng _kMapCenter = LatLng(-7.2941646, 112.7986343);
  static final CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);
  String service = "";
  String subService = "";
  String address = "Lokasi: -";
  String city;
  Partner partner;
  Future getImagefromcamera(int index) async {
    final _picker = ImagePicker();
    PickedFile pickedImage = await _picker.getImage(source: ImageSource.camera);
    setState(() {
      images[index] = File(pickedImage.path);
    });
  Future getImagefromGallery(int index) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        images[index] = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate.subtract(Duration(days: 30)),
        lastDate: DateTime(selectedDate.year + 1));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  Future<Null> _selectedTime(BuildContext context) async {
    final TimeOfDay picked_time = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        });
    if (picked_time != null && picked_time != selectedTime)
      setState(() {
        selectedTime = picked_time;
      });
  Future<void> _getArguments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      setState(() {
        print(arguments);
        if (arguments['service'] != null) {
          service = arguments['service'];
          subService = arguments['subService'];
          print(arguments.toString());
          prefs.setString("form_service", service);
          prefs.setString("form_subService", subService);
        }
        if (arguments['location'] != null) {
          location = arguments['location'];
          prefs.setDouble("form_location_latitude", location.latitude);
          prefs.setDouble("form_location_longitude", location.longitude);
          _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(location.latitude, location.longitude),
                  zoom: 15.0)));
          _origin = Marker(
            markerId: const MarkerId('origin'),
            infoWindow: const InfoWindow(title: 'Origin'),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            position: LatLng(location.latitude, location.longitude),
          );
          _getAddress(location.latitude, location.longitude);
        }
        service = prefs.getString("form_service");
        subService = prefs.getString("form_subService");
      });
    }
  Future<void> _getAddress(double lat, double lang) async {
    final coordinates = new Coordinates(lat, lang);
    List<Address> add =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      this.address = add.first.addressLine;
      var city = add.first.subAdminArea;
      var partOfCity = city.split(" ");
      city = "";
      int i = 0;
      partOfCity.forEach((element) {
        if (i != 0) city += element;
        i++;
        if (i < partOfCity.length - 1) city += " ";
      });
      this.city = city;
      print(city);
      print(this.city);
    });
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffFFFFFF),
      statusBarIconBrightness: Brightness.dark,
    ));
    super.initState();
  @override
  Widget build(BuildContext context) {
    var apiService = new ApiService();
    return Stack(children: [
      Scaffold(
        primary: true,
        appBar: AppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.white,
            centerTitle: true,
            title: Text('Menyiapkan Pesanan',
                style: TextStyle(
                  color: Colors.black,
                )),
            iconTheme: IconThemeData(color: Colors.black)),
        body: _buildRightSide(),
      ),
      Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            child: Container(
                padding: EdgeInsets.all(15.0),
                height: 70.0,
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  )
                ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Rp _ _ _',
                        style: TextStyle(color: Colors.black, fontSize: 17.0)),
                    MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        elevation: 0.0,
                        minWidth: 50.0,
                        padding: EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                        height: 35,
                        color:
                            _origin != null ? Color(0xffFF5400) : Colors.grey,
                        child: new Text('Cari tukang',
                            style: new TextStyle(
                                fontSize: 16.0, color: Colors.white)),
                        onPressed: () async {
                          if (_origin != null) {
                            Navigator.of(context)
                                .pushNamed('/order/partner', arguments: {
                              'service': service,
                              'subService': subService,
                              'service_description':
                                  serviceDescriptionController.text,
                              'location_coordinate': location,
                              'location_description':
                                  locationDescriptionController.text,
                              'city': this.city,
                              'images': images,
                              'date': selectedDate,
                              'time': selectedTime,
                            });
                          }
                        }),
                  ],
                )),
          ))
    ]);
  Widget _buildRightSide() {
    return SingleChildScrollView(
        child: Column(
      children: [
        Container(
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 60.0,
                          width: 60.0,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              color: Color(0xffeeeeee),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: (service != "")
                              ? Image.asset(iconOfSubservices[subService],
                                  height: 25.0, width: 25.0)
                              : Text(''),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(service,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.grey)),
                        Text(subService,
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold))
                      ],
                    )
                  ],
                ),
              ],
            )),
        Container(
          height: 4.0,
          width: double.infinity,
          transform: Matrix4.translationValues(0.0, 10.0, 0.0),
          decoration: BoxDecoration(color: Color(0xffeeeeee)),
        ),
        Container(
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Lokasi dan Waktu Pengerjaan',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/order/form/maps');
                  },
                  child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(color: Colors.grey)),
                      width: 110.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(CupertinoIcons.map_pin,
                              color: Color(0xffFF5400)),
                          Text('Pin lokasi')
                        ],
                      )),
                ),
                SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/order/form/maps');
                  },
                  child: Container(
                    height: 150.0,
                    child: GoogleMap(
                      onMapCreated: (controller) =>
                          {_googleMapController = controller, _getArguments()},
                      initialCameraPosition: _kInitialPosition,
                      markers: {
                        if (_origin != null) _origin,
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(address,
                    style: TextStyle(color: Colors.black, fontSize: 17.0)),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: locationDescriptionController,
                  decoration: new InputDecoration(
                      contentPadding:
                          EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: BorderSide(color: Color(0xffFF5400))),
                      hintText: 'Keterangan Alamat (ex: RT/RW, Blok)'),
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                      fontSize: 18.0,
                      height: 1,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: 190.0,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: GestureDetector(
                            onTap: () => _selectedDate(context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.calendar,
                                    color: Color(0xffFF5400)),
                                SizedBox(width: 8.0),
                                Text(
                                    new DateFormat.yMMMd().format(selectedDate))
                              ],
                            ))),
                    Container(
                        width: 120.0,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: GestureDetector(
                          onTap: () => _selectedTime(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.clock,
                                  color: Color(0xffFF5400)),
                              SizedBox(width: 8.0),
                              Text(selectedTime.hour.toString() +
                                  ":" +
                                  selectedTime.minute.toString())
                            ],
                          ),
                        ))
                  ],
                )
              ],
            )),
        Container(
          height: 4.0,
          width: double.infinity,
          transform: Matrix4.translationValues(0.0, 10.0, 0.0),
          decoration: BoxDecoration(color: Color(0xffeeeeee)),
        ),
        Container(
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Deskripsi pekerjaan',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: serviceDescriptionController,
                    decoration: new InputDecoration(
                        contentPadding:
                            EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Color(0xffFF5400))),
                        hintText: 'Deskripsi pekerjaan)'),
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                        fontSize: 18.0,
                        height: 1,
                        color: Color(0xff000000),
                        fontWeight: FontWeight.w400),
                  )
                ])),
        Container(
          height: 4.0,
          width: double.infinity,
          transform: Matrix4.translationValues(0.0, 10.0, 0.0),
          decoration: BoxDecoration(color: Color(0xffeeeeee)),
        ),
        Container(
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Foto pekerjaan yang harus dilakukan',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                SizedBox(height: 20.0),
                Container(
                  height: 120.0,
                  child: ListView.builder(
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return new Container(
                        height: 120.0,
                        width: 120.0,
                        child: Stack(children: <Widget>[
                          GestureDetector(
                              onTap: () => getImagefromGallery(index),
                              child: Container(
                                height: 130.0,
                                width: 120.0,
                                margin: EdgeInsets.only(right: 20.0),
                                decoration: BoxDecoration(
                                    color: Color(0xffffffff),
                                    border: Border.all(color: Colors.grey),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                alignment: Alignment.center,
                                child: images[index] == null
                                    ? Icon(CupertinoIcons.add)
                                    : Image.file(images[index],
                                        height: 130.0, width: 120.0),
                              )),
                        ]),
                      );
                    },
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                SizedBox(height: 10.0),
                Text('*Opsional, maksimal 4',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey))
              ],
            )),
        Container(
          height: 4.0,
          width: double.infinity,
          transform: Matrix4.translationValues(0.0, 10.0, 0.0),
          decoration: BoxDecoration(color: Color(0xffeeeeee)),
        ),
        Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Metode Pembayaran',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.all(15.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tunai', style: TextStyle(color: Colors.grey)),
                      Transform.rotate(
                          angle: 180 * math.pi / 180,
                          child: Icon(CupertinoIcons.triangle_fill,
                              size: 12.0, color: Color(0xff222222)))
                    ],
                  ),
                )
              ],
            )),
        SizedBox(
          height: 70.0,
        )
      ],
    ));
?-)=83
=*,PQ
NE2L
#>44
,*0'4:
-,HJ
9%#*
%P$7*I((2M$
O72G.12J285E?6F1044 
"#('958J1K=*
BD"&#P).N
$51DC$"K$79-
$#&4P@!6
=3&O$/=HG=HMH4$&!04
&73BE
0A(K*>?6&Q!!
&73BE
0?&I(9=4B(B
!>5(Q&1?JI?JO;6&(#26
!+.4,'&9+G0/.F;>L2O==?@F"
1*-<>
G K(6DE
2package:olada/ui/main/order/form/form.dart
Wfile:///C:/xampp/htdocs/pawonan/app/olada/lib/ui/main/order/form/maps/maps.dart
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';
class FormOrderMapsScreen extends StatefulWidget {
  @override
  _FormOrderMapsScreenState createState() => _FormOrderMapsScreenState();
class _FormOrderMapsScreenState extends State<FormOrderMapsScreen> {
  Position _position = Position(latitude: -7.2941646, longitude: 112.7986343);
  String address = "";
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(-7.2941646, 112.7986343),
    zoom: 11.5,
  );
  GoogleMapController _googleMapController;
  Marker _origin;
  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  _getCurrentLocation() async {
    Location location = Location();
    LocationData locationData;
    locationData = await location.getLocation();
    _position = Position(
        latitude: locationData.latitude, longitude: locationData.longitude);
    _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(_position.latitude, _position.longitude),
            zoom: 15.0)));
  Future<void> _getAddress(double lat, double lang) async {
    final coordinates = new Coordinates(lat, lang);
    List<Address> add =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      this.address = add.first.addressLine;
    });
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.white,
            centerTitle: true,
            title: Text('Lokasi',
                style: TextStyle(
                  color: Colors.black,
                )),
            iconTheme: IconThemeData(color: Colors.black)),
        body: Stack(
          alignment: Alignment.center,
          children: [
            GoogleMap(
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (controller) =>
                  {_googleMapController = controller, _getCurrentLocation()},
              markers: {
                if (_origin != null) _origin,
              },
              onLongPress: _addMarker,
            ),
          ],
        ),
      ),
      Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            child: Container(
                padding: EdgeInsets.all(15.0),
                height: 180.0,
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  )
                ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_origin != null ? address : 'Silahkan pin lokasi',
                        style: TextStyle(color: Colors.black, fontSize: 17.0)),
                    MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        elevation: 0.0,
                        minWidth: double.infinity,
                        padding: EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                        height: 35,
                        color:
                            _origin != null ? Color(0xffFF5400) : Colors.grey,
                        child: new Text('Pilih lokasi',
                            style: new TextStyle(
                                fontSize: 16.0, color: Colors.white)),
                        onPressed: () async {
                          if (_origin != null) {
                            Navigator.pushNamed(context, '/order/form',
                                arguments: {'location': _position});
                          }
                        }),
                  ],
                )),
          ))
    ]);
  void _addMarker(LatLng pos) async {
    setState(() {
      Position position =
          Position(latitude: pos.latitude, longitude: pos.longitude);
      _position = position;
      _origin = Marker(
        markerId: const MarkerId('origin'),
        infoWindow: const InfoWindow(title: 'Origin'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: pos,
      );
    });
    List<geocoding.Placemark> placemarks =
        await geocoding.placemarkFromCoordinates(pos.latitude, pos.longitude);
    _getAddress(_origin.position.latitude, _origin.position.longitude);
(8-?))
-)=,N
9%#*
LP$7*I(32M$
O82G.1HE
7package:olada/ui/main/order/form/maps/maps.dart
`file:///C:/xampp/htdocs/pawonan/app/olada/lib/ui/main/order/listpartner/listpartner.dart
`import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:olada/api/api_service.dart';
import 'package:olada/model/response.dart';
import 'dart:io';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:olada/model/partner.dart';
import 'package:olada/model/user.dart';
import 'package:olada/model/customlocation.dart';
import 'dart:math' as Math;
class ListPartnerOrderScreen extends StatefulWidget {
  @override
  _ListPartnerOrderScreenState createState() => _ListPartnerOrderScreenState();
class _ListPartnerOrderScreenState extends State<ListPartnerOrderScreen> {
  String serviceDescription;
  Position locationCoordinate;
  String locationDescription;
  List<File> images;
  DateTime date;
  TimeOfDay time;
  var paymentMethod;
  Position location = Position(latitude: -7.2941646, longitude: 112.7986343);
  static final LatLng _kMapCenter = LatLng(-7.2941646, 112.7986343);
  static final CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);
  String service = "";
  String subService = "";
  String address = "Lokasi: -";
  String city;
  ApiService apiService = ApiService();
  List<Partner> _partners = [];
  List<Partner> partners = [];
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffFFFFFF),
      statusBarIconBrightness: Brightness.dark,
    ));
    super.initState();
    _getArguments();
  Future<void> _getPartnerByCityAndService(
      String city, String service, String subservice) async {
    _partners.clear();
    partners.clear();
    CustomResponse response =
        await apiService.getPartnerByCityAndService(city, service, subservice);
    if (response.status == 200) {
      print(response.data);
      setState(() {
        if (response.status == 200) {
          response.data.forEach(((_partner) {
            Partner partner = Partner.fromJson(_partner);
            partner.user = UserOlada.fromJson(_partner['user']);
            partner.location = CustomLocation.fromJson(_partner['location']);
            if (_partner['rating'] != null)
              partner.rating = PartnerRating.fromJson(_partner['rating']);
            _partners.add(partner);
          }));
          partners = _partners;
        } else {}
      });
    } else {
      print("oopss");
    }
  Future<void> _getArguments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      setState(() {
        this.service = arguments['service'];
        this.subService = arguments['subService'];
        this.city = arguments['city'];
        this.serviceDescription = arguments['service_description'];
        this.locationCoordinate = arguments['location_coordinate'];
        this.locationDescription = arguments['location_description'];
        this.images = arguments['images'];
        this.date = arguments['date'];
        this.time = arguments['time'];
        print(arguments);
        _getPartnerByCityAndService(city, service, subService);
      });
    }
  String _getDistance(double latitude, double longitude) {
    var distance = "";
    if (latitude != null) {
      var R = 6371;
      var dLat = deg2rad(locationCoordinate.latitude - latitude);
      var dLon = deg2rad(locationCoordinate.longitude - longitude);
      var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
          Math.cos(deg2rad(latitude)) *
              Math.cos(deg2rad(locationCoordinate.latitude)) *
              Math.sin(dLon / 2) *
              Math.sin(dLon / 2);
      var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
      var _distanceInKm = R * c;
      distance = _distanceInKm.toStringAsFixed(2) + " Km dari anda";
    }
    return distance;
  double deg2rad(deg) {
    return deg * (Math.pi / 180);
  void search(String value) {
    List<Partner> result = [];
    for (int i = 0; i < _partners.length; i++) {
      print(_partners.toString());
      if (_partners[i]
          .user
          .firstname
          .toLowerCase()
          .contains(value.toLowerCase())) {
        result.add(_partners[i]);
      } else {
        if (_partners[i]
            .user
            .lastname
            .toLowerCase()
            .contains(value.toLowerCase())) {
          result.add(_partners[i]);
        }
      }
    }
    setState(() {
      partners = result;
    });
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        primary: true,
        appBar: AppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.white,
            centerTitle: true,
            title: Text('Daftar Tukang',
                style: TextStyle(
                  color: Colors.black,
                )),
            iconTheme: IconThemeData(color: Colors.black)),
        body: Container(
          child: _buildRightSide(),
        ),
      ),
    ]);
  Widget _buildRightSide() {
    return SingleChildScrollView(
        child: Column(
      children: [
        Container(
            padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            decoration: BoxDecoration(color: Colors.white),
            child: TextFormField(
              decoration: new InputDecoration(
                  contentPadding: EdgeInsets.only(top: 20.0),
                  prefixIcon: Icon(CupertinoIcons.search),
                  filled: true,
                  fillColor: Color(0xffeeeeee),
                  enabledBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.white)),
                  hintText: 'Cari tukang'),
              keyboardType: TextInputType.text,
              style: TextStyle(
                  fontSize: 18.0,
                  height: 1,
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w400),
            )),
        Container(
          decoration: BoxDecoration(color: Colors.white),
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Row(
            children: [
              MaterialButton(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  elevation: 0.0,
                  minWidth: 50.0,
                  height: 40,
                  padding: EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                  child: Icon(CupertinoIcons.slider_horizontal_3,
                      color: Colors.black),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed('/order/partner', arguments: {});
                  }),
              SizedBox(width: 10.0),
              MaterialButton(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  elevation: 0.0,
                  minWidth: 50.0,
                  height: 40,
                  padding: EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                  child: Text('Terdekat', style: TextStyle(fontSize: 17.0)),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/order/partner');
                  }),
            ],
          ),
        ),
        Container(height: 10.0, decoration: BoxDecoration(color: Colors.white)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(color: Colors.white),
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            itemCount: partners.length,
            itemBuilder: (context, index) {
              return new Container(
                  margin: EdgeInsets.only(bottom: 25.0),
                  width: MediaQuery.of(context).size.width - 40.0,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 200.0,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Image.network(
                                      'http://213.190.4.239/img/users/${partners[index].user.image}',
                                      height: 55.0,
                                      width: 55.0)
                                ],
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: 15.0, top: 0.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          partners[index].user.firstname +
                                              " " +
                                              partners[index].user.lastname,
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(height: 5.0),
                                      Text(_getDistance(
                                          partners[index].location.latitude,
                                          partners[index].location.longitude)),
                                      SizedBox(height: 5.0),
                                      Row(children: [
                                        Icon(CupertinoIcons.star_fill,
                                            color: Colors.yellow, size: 18.0),
                                        SizedBox(width: 5.0),
                                        Text((partners[index].rating != null
                                            ? partners[index].rating.average
                                            : '-'))
                                      ])
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0))),
                            elevation: 0.0,
                            minWidth: 40.0,
                            height: 35,
                            color: Color(0xffFF5400),
                            child: new Text('Detail',
                                style: new TextStyle(
                                    fontSize: 14.0, color: Colors.white)),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  '/order/partner/detail',
                                  arguments: {
                                    'service': service,
                                    'subService': subService,
                                    'service_description': serviceDescription,
                                    'location_coordinate': location,
                                    'location_description': locationDescription,
                                    'city': city,
                                    'images': images,
                                    'date': date,
                                    'time': time,
                                    'partner': partners[index],
                                  });
                            }),
                      ]));
            },
            scrollDirection: Axis.vertical,
          ),
        )
      ],
    ));
  @override
  void dispose() {
    super.dispose();
(=()54
?-30:
NE2L
&.:BN,K$
DDF+''
BD8(?#">!
J<"/>; 09ED,0 "
1<N""
,GB,"*E
1<N""
,GM"G
;:6#(,$9C
ID*#(&JH(%,1f43#!)Q18B0,K4M<>M=9MP=6GO>MM4)'%
(;.M,,(666K,?;/8>OEQ2622@& 
@package:olada/ui/main/order/listpartner/listpartner.dart
Nfile:///C:/xampp/htdocs/pawonan/app/olada/lib/ui/main/order/order.dart
=import 'package:olada/widgets/rounded_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:olada/utils/routes/routes.dart';
import 'package:olada/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:olada/model/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:olada/api/api_service.dart';
import 'package:olada/model/user.dart';
import 'package:olada/model/order.dart';
import 'package:olada/model/customlocation.dart';
import 'package:olada/utils/map/icon_map.dart';
import 'package:intl/intl.dart';
class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
class _OrderScreenState extends State<OrderScreen> {
  ApiService apiService = ApiService();
  List<Order> orders = [];
  List<Order> _orders = [];
  int status = 0;
  UserOlada user;
  List<String> statusDescription = [
    "Memesan",
    "Survey",
    "Dikerjakan",
    "Selesai"
  ];
  Future<void> _getOrderByCustomerAndStatus(
      String customerID, int status) async {
    _orders.clear();
    orders.clear();
    CustomResponse response =
        await apiService.getOrderByCustomerAndStatus(customerID, status);
    if (response.status == 200) {
      setState(() {
        response.data.forEach(((_order) {
          Order order = Order.fromJson(_order);
          order.location = CustomLocation.fromJson(_order['location']);
          order.date = _getDate(_order['date']);
          print(order.toString());
          _orders.add(order);
        }));
        orders = _orders;
        _orders = orders;
      });
    } else {
      print("oopss");
    }
  DateTime _getDate(String date) {
    DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(date);
    return tempDate;
  void search(String value) {
    List<Order> result = [];
    for (int i = 0; i < _orders.length; i++) {
      print(_orders.toString());
      if (_orders[i].subservice.toLowerCase().contains(value.toLowerCase())) {
        result.add(_orders[i]);
      }
    }
    setState(() {
      orders = result;
    });
  Future<void> _init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user = userFromJson(prefs.getString("user"));
      _getOrderByCustomerAndStatus(user.id, status);
    });
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffFF5400),
      statusBarIconBrightness: Brightness.light,
    ));
    super.initState();
    _init();
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Container(
          padding: EdgeInsets.only(top: 30.0),
          height: 150.0,
          decoration: BoxDecoration(color: Color(0xffFF5400)),
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Container(
                          child: Theme(
                              data: Theme.of(context)
                                  .copyWith(primaryColor: Color(0xffFF5400)),
                              child: TextFormField(
                                cursorColor: Colors.grey,
                                onChanged: search,
                                decoration: new InputDecoration(
                                    contentPadding: EdgeInsets.only(top: 20.0),
                                    prefixIcon: Icon(CupertinoIcons.search,
                                        color: Colors.grey),
                                    focusColor: Colors.grey,
                                    filled: true,
                                    fillColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 0)),
                                    enabledBorder: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(10.0),
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    hintText: 'Cari pesanan'),
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    height: 1,
                                    color: Color(0xff000000),
                                    fontWeight: FontWeight.w400),
                              ))),
                    ],
                  )),
              SizedBox(height: 10.0),
              Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0))),
                              elevation: 0.0,
                              minWidth: 50.0,
                              height: 35,
                              color:
                                  (status == 0) ? Colors.white : Colors.black,
                              child: new Text('Pending',
                                  style: new TextStyle(
                                      fontSize: 14.0,
                                      color: (status == 0)
                                          ? Colors.black
                                          : Colors.white)),
                              onPressed: () {
                                setState(() {
                                  status = 0;
                                  _getOrderByCustomerAndStatus(user.id, status);
                                });
                              }),
                          SizedBox(
                            width: 10.0,
                          ),
                          MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0))),
                              elevation: 0.0,
                              minWidth: 50.0,
                              height: 35,
                              color:
                                  (status == 1) ? Colors.white : Colors.black,
                              child: new Text('Survey',
                                  style: new TextStyle(
                                      fontSize: 14.0,
                                      color: (status == 1)
                                          ? Colors.black
                                          : Colors.white)),
                              onPressed: () {
                                setState(() {
                                  status = 1;
                                  _getOrderByCustomerAndStatus(user.id, status);
                                });
                              }),
                          SizedBox(
                            width: 10.0,
                          ),
                          MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0))),
                              elevation: 0.0,
                              minWidth: 50.0,
                              height: 35,
                              color:
                                  (status == 2) ? Colors.white : Colors.black,
                              child: new Text('Proses',
                                  style: new TextStyle(
                                      fontSize: 14.0,
                                      color: (status == 2)
                                          ? Colors.black
                                          : Colors.white)),
                              onPressed: () {
                                setState(() {
                                  status = 2;
                                  _getOrderByCustomerAndStatus(user.id, status);
                                });
                              }),
                          SizedBox(
                            width: 10.0,
                          ),
                          MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0))),
                              elevation: 0.0,
                              minWidth: 50.0,
                              height: 35,
                              color:
                                  (status == 3) ? Colors.white : Colors.black,
                              child: new Text('Selesai',
                                  style: new TextStyle(
                                      fontSize: 14.0,
                                      color: (status == 3)
                                          ? Colors.black
                                          : Colors.white)),
                              onPressed: () {
                                setState(() {
                                  status = 3;
                                  _getOrderByCustomerAndStatus(user.id, status);
                                });
                              }),
                        ],
                      ))),
            ],
          )),
      SingleChildScrollView(
          child: Column(
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              width: double.infinity,
              height: 500.0,
              child: (orders != null)
                  ? ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        return new Container(
                            width: MediaQuery.of(context).size.width - 40.0,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 200.0,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 70.0,
                                          width: 70.0,
                                          padding: EdgeInsets.all(15.0),
                                          decoration: BoxDecoration(
                                              color: Color(0xffeeeeee),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Image.asset(
                                            iconOfSubservices[
                                                orders[index].subservice],
                                          ),
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: 15.0, top: 0.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(orders[index].subservice,
                                                    style: TextStyle(
                                                        fontSize: 17.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                                SizedBox(height: 5.0),
                                                Text(statusDescription[status]),
                                                SizedBox(height: 5.0),
                                                Text(orders[index]
                                                    .date
                                                    .toString()
                                                    .substring(0, 9))
                                              ],
                                            ))
                                      ],
                                    ),
                                  ),
                                  MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0))),
                                      elevation: 0.0,
                                      minWidth: 50.0,
                                      height: 35,
                                      color: Color(0xffFF5400),
                                      child: new Text('Detail',
                                          style: new TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.white)),
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                            '/order/detail',
                                            arguments: {
                                              'orderID': orders[index].id
                                            });
                                      }),
                                ]));
                      },
                      scrollDirection: Axis.horizontal,
                    )
                  : Text(''))
        ],
      ))
    ]));
C)9>(4=(501:8!
*0H1#
/!O 
C! !(6N4:3APL==2=GKK6M4N?B24/>B#
808"$*=0O..*%O986;9<...Q$"$)
*=0O..*%O886;9<...Q$"$)
*=0O..*%O886;9<...Q$"$)
*=0O..*%O986;9<...Q$"
&&06.M(3DN4-20:D9C2387IEHNI>?K-+3EG;BL:OFHDMOGQGC:@F1/)'%2EJF662@@@>E6I=9J0*%
.package:olada/ui/main/order/order.dart
Rfile:///C:/xampp/htdocs/pawonan/app/olada/lib/ui/main/profile/profile.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:olada/model/user.dart';
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
class _ProfileScreenState extends State<ProfileScreen> {
  final picker = ImagePicker();
  UserOlada user;
  SharedPreferences prefs;
  /*Future getImagefromcamera(int index) async {
    final _picker = ImagePicker();
    List<File> images = [null];
    PickedFile pickedImage = await _picker.getImage(source: ImageSource.camera);
    setState(() {
      images[index] = File(pickedImage.path);
    });
  Future getImagefromGallery(int index) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        images[index] = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }*/
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffFF5400),
      statusBarIconBrightness: Brightness.light,
    ));
    super.initState();
  Future<void> _getArguments() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      user = userFromJson(prefs.getString("user"));
    });
  @override
  Widget build(BuildContext context) {
    return _buildRightSide();
  Widget _buildRightSide() {
    _getArguments();
    return SingleChildScrollView(
        child: Column(
      children: [
        Container(
            padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
            decoration: BoxDecoration(color: Color(0xffFF5400)),
            height: 160.0,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: (user.firstname != null)
                              ? Row(
                                  children: [
                                    Image.network(
                                        'http://213.190.4.239/img/users/${user.image}',
                                        height: 80.0,
                                        width: 80.0),
                                    SizedBox(width: 20.0),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            user.firstname +
                                                " " +
                                                user.lastname,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(user.email,
                                            style:
                                                TextStyle(color: Colors.white))
                                      ],
                                    )
                                  ],
                                )
                              : Text('')),
                      Icon(
                        CupertinoIcons.pencil,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
              ],
            )),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Menu',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Container(
                      height: 60.0,
                      width: 60.0,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: Color(0xffeeeeee),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Icon(
                        CupertinoIcons.list_bullet,
                        size: 36.0,
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text('Pesanan saya', style: TextStyle(fontSize: 18.0))
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Container(
                      height: 60.0,
                      width: 60.0,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: Color(0xffeeeeee),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Icon(
                        CupertinoIcons.tag,
                        size: 36.0,
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text('Kupon saya', style: TextStyle(fontSize: 18.0))
                  ],
                ),
                SizedBox(height: 20.0),
                Text(
                  'Tentang Aplikasi',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Container(
                      height: 60.0,
                      width: 60.0,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: Color(0xffeeeeee),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Image.asset('assets/icons/policy.png',
                          height: 25.0, width: 25.0),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text('Kebijakan dan Privasi',
                        style: TextStyle(fontSize: 18.0))
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Container(
                      height: 60.0,
                      width: 60.0,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: Color(0xffeeeeee),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Image.asset('assets/icons/ask.png',
                          height: 25.0, width: 25.0),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text('Bantuan', style: TextStyle(fontSize: 18.0))
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Container(
                      height: 60.0,
                      width: 60.0,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: Color(0xffeeeeee),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Image.asset('assets/icons/information.png',
                          height: 25.0, width: 25.0),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text('Versi aplikasi', style: TextStyle(fontSize: 18.0))
                  ],
                ),
                SizedBox(height: 20.0),
                Text(
                  'Navigasi',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        prefs.remove('user');
                        Navigator.of(context).pushNamed('/signin');
                      },
                      child: Container(
                        height: 60.0,
                        width: 60.0,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            color: Color(0xffeeeeee),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Icon(CupertinoIcons.arrow_left),
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text('Keluar', style: TextStyle(fontSize: 18.0))
                  ],
                ),
              ],
            )),
      ],
    ));
)(1(
GB !:%.3X66;,:D2.=6?>E@O28+93P)&%"+
$#514F#4$
$#514F#,$
$#514FD6
$#514FA6
$#514FI6
%".C
(&%736H@
2package:olada/ui/main/profile/profile.dart
Pfile:///C:/xampp/htdocs/pawonan/app/olada/lib/ui/main/reward/reward.dart
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:olada/constants/assets.dart';
import 'package:olada/utils/routes/routes.dart';
import 'package:olada/widgets/app_icon_widget.dart';
import 'package:olada/widgets/empty_app_bar_widget.dart';
import 'package:olada/widgets/progress_indicator_widget.dart';
import 'package:olada/widgets/rounded_button_widget.dart';
import 'package:olada/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
class RewardScreen extends StatefulWidget {
  @override
  _RewardScreenState createState() => _RewardScreenState();
class _RewardScreenState extends State<RewardScreen> {
  //text controllers:-----------------------------------------------------------
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffFFFFFF),
      statusBarIconBrightness: Brightness.dark,
    ));
    super.initState();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: EmptyAppBar(),
      body: _buildBody(),
    );
  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Material(
      child: Stack(
        children: <Widget>[
          MediaQuery.of(context).orientation == Orientation.landscape
              ? Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: _buildLeftSide(),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildRightSide(),
                    ),
                  ],
                )
              : Center(child: _buildRightSide()),
        ],
      ),
    );
  Widget _buildLeftSide() {
    return SizedBox.expand(
      child: Image.asset(
        Assets.carBackground,
        fit: BoxFit.cover,
      ),
    );
  Widget _buildRightSide() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AppIconWidget(image: 'assets/images/otp.png'),
            Text(
              'Olada',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 24.0),
          ],
        ),
      ),
    );
869=BGC>(=(
7QHG
0package:olada/ui/main/reward/reward.dart
AZfile:///C:/xampp/htdocs/pawonan/app/olada/lib/ui/main/subservices/subservices.dart
=import 'package:another_flushbar/flushbar_helper.dart';
import 'package:olada/constants/assets.dart';
import 'package:olada/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
class SubServicesScreen extends StatefulWidget {
  @override
  _SubServicesScreenState createState() => _SubServicesScreenState();
class _SubServicesScreenState extends State<SubServicesScreen> {
  String services = "";
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffFFFFFF),
      statusBarIconBrightness: Brightness.dark,
    ));
    super.initState();
  void _getArguments() {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      setState(() {
        services = arguments['service'];
      });
    }
  @override
  Widget build(BuildContext context) {
    _getArguments();
    return Scaffold(
      primary: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
          centerTitle: true,
          title: Text('Semua Kategori',
              style: TextStyle(
                color: Colors.black,
              )),
          iconTheme: IconThemeData(color: Colors.black)),
      body: _buildRightSide(),
    );
  Widget _buildRightSide() {
    return SingleChildScrollView(
        child: Column(
      children: [
        Container(
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                (services == "Bangunan" || services == "")
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            Text('Bangunan',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 60.0,
                                      width: 60.0,
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                          color: Color(0xffeeeeee),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Image.asset(
                                          'assets/icons/subservices/fence.png',
                                          height: 25.0,
                                          width: 25.0),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('Pagar')
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: 60.0,
                                      width: 60.0,
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                          color: Color(0xffeeeeee),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Image.asset(
                                          'assets/icons/subservices/electric.png',
                                          height: 25.0,
                                          width: 25.0),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('Listrik')
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          Navigator.of(context).pushNamed(
                                              '/order/form',
                                              arguments: {
                                                'service': 'Bangunan',
                                                'subService': 'Renovasi'
                                              });
                                        });
                                      },
                                      child: Container(
                                        height: 60.0,
                                        width: 60.0,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xffeeeeee),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Image.asset(
                                            'assets/icons/subservices/brick.png',
                                            height: 25.0,
                                            width: 25.0),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('Renovasi')
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          Navigator.of(context).pushNamed(
                                              '/order/form',
                                              arguments: {
                                                'service': 'Bangunan',
                                                'subService': 'Pengecatan'
                                              });
                                        });
                                      },
                                      child: Container(
                                        height: 60.0,
                                        width: 60.0,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xffeeeeee),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Image.asset(
                                            'assets/icons/subservices/roller-brush.png',
                                            height: 25.0,
                                            width: 25.0),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('Pengecatan')
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          Navigator.of(context).pushNamed(
                                              '/order/form',
                                              arguments: {
                                                'service': 'Bangunan',
                                                'subService': 'Tangga'
                                              });
                                        });
                                      },
                                      child: Container(
                                        height: 60.0,
                                        width: 60.0,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xffeeeeee),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Image.asset(
                                            'assets/icons/subservices/stairs.png',
                                            height: 25.0,
                                            width: 25.0),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('Tangga')
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          Navigator.of(context).pushNamed(
                                              '/order/form',
                                              arguments: {
                                                'service': 'Bangunan',
                                                'subService': 'Sketsa'
                                              });
                                        });
                                      },
                                      child: Container(
                                        height: 60.0,
                                        width: 60.0,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xffeeeeee),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Image.asset(
                                            'assets/icons/subservices/sketch.png',
                                            height: 25.0,
                                            width: 25.0),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('Sketsa')
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          Navigator.of(context).pushNamed(
                                              '/order/form',
                                              arguments: {
                                                'service': 'Bangunan',
                                                'subService': 'Las'
                                              });
                                        });
                                      },
                                      child: Container(
                                        height: 60.0,
                                        width: 60.0,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xffeeeeee),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Image.asset(
                                            'assets/icons/subservices/welding.png',
                                            height: 25.0,
                                            width: 25.0),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('Las')
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          Navigator.of(context).pushNamed(
                                              '/order/form',
                                              arguments: {
                                                'service': 'Bangunan',
                                                'subService': 'Sapu'
                                              });
                                        });
                                      },
                                      child: Container(
                                        height: 60.0,
                                        width: 60.0,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xffeeeeee),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Image.asset(
                                            'assets/icons/subservices/broom.png',
                                            height: 25.0,
                                            width: 25.0),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('Sapu')
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          Navigator.of(context).pushNamed(
                                              '/order/form',
                                              arguments: {
                                                'service': 'Bangunan',
                                                'subService': 'Wallpaper'
                                              });
                                        });
                                      },
                                      child: Container(
                                        height: 60.0,
                                        width: 60.0,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xffeeeeee),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Image.asset(
                                            'assets/icons/subservices/wallpaper.png',
                                            height: 25.0,
                                            width: 25.0),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('Wallpapaer')
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: 60.0,
                                      width: 60.0,
                                      padding: EdgeInsets.all(10.0),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('')
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: 60.0,
                                      width: 60.0,
                                      padding: EdgeInsets.all(10.0),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('')
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: 60.0,
                                      width: 60.0,
                                      padding: EdgeInsets.all(10.0),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('')
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            )
                          ])
                    : Container(),
                (services == "Elektronik" || services == "")
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            Text('Elektronik',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          Navigator.of(context).pushNamed(
                                              '/order/form',
                                              arguments: {
                                                'service': 'Elektronik',
                                                'subService': 'Kulkas'
                                              });
                                        });
                                      },
                                      child: Container(
                                        height: 60.0,
                                        width: 60.0,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xffeeeeee),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Image.asset(
                                            'assets/icons/subservices/refrigerator.png',
                                            height: 25.0,
                                            width: 25.0),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('Kulkas')
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          Navigator.of(context).pushNamed(
                                              '/order/form',
                                              arguments: {
                                                'service': 'Elektronik',
                                                'subService': 'AC'
                                              });
                                        });
                                      },
                                      child: Container(
                                        height: 60.0,
                                        width: 60.0,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xffeeeeee),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Image.asset(
                                            'assets/icons/subservices/air-conditioner.png',
                                            height: 25.0,
                                            width: 25.0),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('AC')
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          Navigator.of(context).pushNamed(
                                              '/order/form',
                                              arguments: {
                                                'service': 'Elektronik',
                                                'subService': 'CCTV'
                                              });
                                        });
                                      },
                                      child: Container(
                                        height: 60.0,
                                        width: 60.0,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xffeeeeee),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Image.asset(
                                            'assets/icons/subservices/cctv.png',
                                            height: 25.0,
                                            width: 25.0),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('CCTV')
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          Navigator.of(context).pushNamed(
                                              '/order/form',
                                              arguments: {
                                                'service': 'Elektronik',
                                                'subService': 'Mesin Cuci'
                                              });
                                        });
                                      },
                                      child: Container(
                                        height: 60.0,
                                        width: 60.0,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xffeeeeee),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Image.asset(
                                            'assets/icons/subservices/washing-machine.png',
                                            height: 25.0,
                                            width: 25.0),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('Mesin cuci')
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          Navigator.of(context).pushNamed(
                                              '/order/form',
                                              arguments: {
                                                'service': 'Elektronik',
                                                'subService': 'Dinamo'
                                              });
                                        });
                                      },
                                      child: Container(
                                        height: 60.0,
                                        width: 60.0,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xffeeeeee),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Image.asset(
                                            'assets/icons/subservices/dynamo.png',
                                            height: 25.0,
                                            width: 25.0),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('Dinamo')
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          Navigator.of(context).pushNamed(
                                              '/order/form',
                                              arguments: {
                                                'service': 'Elektronik',
                                                'subService': 'Aki'
                                              });
                                        });
                                      },
                                      child: Container(
                                        height: 60.0,
                                        width: 60.0,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xffeeeeee),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Image.asset(
                                            'assets/icons/subservices/battery.png',
                                            height: 25.0,
                                            width: 25.0),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('Aki')
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          Navigator.of(context).pushNamed(
                                              '/order/form',
                                              arguments: {
                                                'service': 'Elektronik',
                                                'subService': 'Dispenser'
                                              });
                                        });
                                      },
                                      child: Container(
                                        height: 60.0,
                                        width: 60.0,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xffeeeeee),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Image.asset(
                                            'assets/icons/subservices/water-dispenser.png',
                                            height: 25.0,
                                            width: 25.0),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('Dispenser')
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          Navigator.of(context).pushNamed(
                                              '/order/form',
                                              arguments: {
                                                'service': 'Elektronik',
                                                'subService': 'Komputer'
                                              });
                                        });
                                      },
                                      child: Container(
                                        height: 60.0,
                                        width: 60.0,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xffeeeeee),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Image.asset(
                                            'assets/icons/subservices/computer.png',
                                            height: 25.0,
                                            width: 25.0),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('Komputer')
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                          ])
                    : Container(),
                (services == "Furnitur" || services == "")
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            Text('Furnitur',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          Navigator.of(context).pushNamed(
                                              '/order/form',
                                              arguments: {
                                                'service': 'Furnitur',
                                                'subService': 'Sofa'
                                              });
                                        });
                                      },
                                      child: Container(
                                        height: 60.0,
                                        width: 60.0,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xffeeeeee),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Image.asset(
                                            'assets/icons/subservices/couch.png',
                                            height: 25.0,
                                            width: 25.0),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('Sofa')
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          Navigator.of(context).pushNamed(
                                              '/order/form',
                                              arguments: {
                                                'service': 'Lemari',
                                                'subService': 'Sofa'
                                              });
                                        });
                                      },
                                      child: Container(
                                        height: 60.0,
                                        width: 60.0,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xffeeeeee),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Image.asset(
                                            'assets/icons/subservices/cupboard.png',
                                            height: 25.0,
                                            width: 25.0),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('Lemari')
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          Navigator.of(context).pushNamed(
                                              '/order/form',
                                              arguments: {
                                                'service': 'Furnitur',
                                                'subService': 'Kithchen set'
                                              });
                                        });
                                      },
                                      child: Container(
                                        height: 60.0,
                                        width: 60.0,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xffeeeeee),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Image.asset(
                                            'assets/icons/subservices/kitchen.png',
                                            height: 25.0,
                                            width: 25.0),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('Kitchen set')
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          Navigator.of(context).pushNamed(
                                              '/order/form',
                                              arguments: {
                                                'service': 'Furnitur',
                                                'subService': 'Meja'
                                              });
                                        });
                                      },
                                      child: Container(
                                        height: 60.0,
                                        width: 60.0,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xffeeeeee),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Image.asset(
                                            'assets/icons/subservices/table.png',
                                            height: 25.0,
                                            width: 25.0),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('Meja')
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          Navigator.of(context).pushNamed(
                                              '/order/form',
                                              arguments: {
                                                'service': 'Furnitur',
                                                'subService': 'Kaca'
                                              });
                                        });
                                      },
                                      child: Container(
                                        height: 60.0,
                                        width: 60.0,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xffeeeeee),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Image.asset(
                                            'assets/icons/subservices/glass.png',
                                            height: 25.0,
                                            width: 25.0),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('Kaca')
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: 60.0,
                                      width: 60.0,
                                      padding: EdgeInsets.all(10.0),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('')
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: 60.0,
                                      width: 60.0,
                                      padding: EdgeInsets.all(10.0),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('')
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: 60.0,
                                      width: 60.0,
                                      padding: EdgeInsets.all(10.0),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text('')
                                  ],
                                ),
                              ],
                            )
                          ])
                    : Container(),
              ],
            )),
      ],
    ));
869(
FD$-24C&,
!LQ*(./43EAD8L:P88'.3'2%#(./43EAD8L:S88'.3'4%#(.526K=;GI2,)865GCF:N<R::)'.3'5%#(.526K=;GK2,)865GCF:N<Y::)'.3'7%"!
4!Q*(.526K=;GG2,)865GCF:N<S::)'.3'3%#(.526K=;GG2,)865GCF:N<S::)'.3'3%#(.526K=;GD2,)865GCF:N<T::)'.3'0%#(.526K=;GE2,)865GCF:N<R::)'.3'1%#!
4!Q*(.526K=;GJ2,)865GCF:N<V::)'.3'7%#(./43E'.3'-%#(./43E'.3'-%#(./43E'.3'-%#!
FD$/24C&,
!LQ*(.526K=;IG2,)865GCF:N<Y::)'.3'3%#(.526K=;IC2,)865GCF:N<\::)'.3'/%#(.526K=;IE2,)865GCF:N<Q::)'.3'1%#(.526K=;IK2,)865GCF:N<\::)'.3'7%#!
!LQ*(.526K=;IG2,)865GCF:N<S::)'.3'3%#(.526K=;ID2,)865GCF:N<T::)'.3'0%#(.526K=;IJ2,)865GCF:N<\::)'.3'6%#(.526K=;II2,)865GCF:N<U::)'.3'5%#!
FD$-24C&,
!LQ*(.526K=;GE2,)865GCF:N<R::)'.3'1%#(.526K=;EE2,)865GCF:N<U::)'.3'3%#(.526K=;GM2,)865GCF:N<T::)'.3'8%#(.526K=;GE2,)865GCF:N<R::)'.3'1%#!
4!Q*(.526K=;GE2,)865GCF:N<R::)'.3'1%#(./43E'.3'-%#(./43E'.3'-%#(./43E'.3'-%#!
:package:olada/ui/main/subservices/subservices.dart
Dfile:///C:/xampp/htdocs/pawonan/app/olada/lib/ui/my_app.dart
import 'package:olada/constants/app_theme.dart';
import 'package:olada/constants/strings.dart';
import 'package:olada/utils/routes/routes.dart';
import 'package:olada/ui/signin/signin.dart';
import 'package:olada/ui/splash/splash.dart';
import 'package:olada/ui/welcome/welcome.dart';
import 'package:flutter/material.dart';
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.appName,
      routes: Routes.routes,
      home: SplashScreen(),
    );
:8:579)
$package:olada/ui/my_app.dart
Efile:///C:/xampp/htdocs/pawonan/app/olada/lib/ui/otp/otp.dart
import 'package:olada/widgets/app_icon_widget.dart';
import 'package:olada/widgets/empty_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:olada/api/api_service.dart';
import 'package:olada/model/response.dart';
import 'package:olada/widgets/rounded_button_widget.dart';
class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
      color: Colors.white,
      border: Border(bottom: BorderSide(color: Colors.grey, width: 1.0)));
  ApiService apiService = ApiService();
  String username;
  String firstname;
  String lastname;
  String email;
  String password;
  String phoneNumber;
  int sent = 0;
  Future<void> _getArguments() async {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      setState(() {
        this.username = arguments['username'];
        this.firstname = arguments['firstname'];
        this.lastname = arguments['lastname'];
        this.password = arguments['password'];
        this.email = arguments['email'];
        this.phoneNumber = arguments['phoneNumber'];
        print(arguments);
        _verifyPhone();
      });
      print(password + " " + email);
    }
  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              print(value.user.toString());
            }
          });
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
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffFFFFFF),
      statusBarIconBrightness: Brightness.dark,
    ));
    super.initState();
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1), () {
      if (sent == 0) {
        _getArguments();
        sent = 1;
      }
    });
    return Scaffold(
      primary: true,
      appBar: EmptyAppBar(),
      body: Stack(
        children: [
          _buildRightSide(),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0))),
                    elevation: 0.0,
                    minWidth: double.infinity,
                    padding: EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                    height: 35,
                    color: _pinPutController.text.length == 6
                        ? Color(0xffFF5400)
                        : Colors.grey,
                    child: new Text('Verifikasi',
                        style:
                            new TextStyle(fontSize: 16.0, color: Colors.white)),
                    onPressed: () async {
                      String pin = _pinPutController.text;
                      if (pin.length == 6) {
                        try {
                          await FirebaseAuth.instance
                              .signInWithCredential(
                                  PhoneAuthProvider.credential(
                                      verificationId: _verificationCode,
                                      smsCode: pin))
                              .then((value) async {
                            if (value.user != null) {
                              print(value.user.toString());
                              CustomResponse response = await apiService.signUp(
                                  username,
                                  firstname,
                                  lastname,
                                  password,
                                  email,
                                  phoneNumber);
                              if (response.status == 200) {
                                Navigator.of(context).pushNamed('/otp-success');
                              }
                            }
                          });
                        } catch (e) {
                          FocusScope.of(context).unfocus();
                          SweetAlert.show(context,
                              subtitle: "Kode OTP salah",
                              style: SweetAlertStyle.confirm);
                          print(e);
                        }
                      }
                    }),
              ))
        ],
      ),
      backgroundColor: Colors.white,
    );
  Widget _buildRightSide() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 80.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/otp.png', height: 100.0, width: 100.0),
            SizedBox(height: 24.0),
            Text(
              'Verifikasi ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0),
            ),
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
                  try {
                    await FirebaseAuth.instance
                        .signInWithCredential(PhoneAuthProvider.credential(
                            verificationId: _verificationCode, smsCode: pin))
                        .then((value) async {
                      CustomResponse response = await apiService.signUp(
                          username,
                          firstname,
                          lastname,
                          password,
                          email,
                          phoneNumber);
                      Navigator.of(context).pushNamed('/otp-success');
                    });
                  } catch (e) {
                    FocusScope.of(context).unfocus();
                    SweetAlert.show(context,
                        title: "Error",
                        subtitle: "Kode OTP salah",
                        style: SweetAlertStyle.error);
                    print(e);
                  }
                },
              ),
            ),
            RoundedButtonWidget(
              buttonText: 'Register',
              buttonColor: Colors.orangeAccent,
              textColor: Colors.white,
            )
          ],
        ),
      ),
    );
>C)4)/.65D
0200*6
4#I'1%'-
@*1	
4(4P%0/J!?-(3 R+<.
76AJ657=R-.--*1=R!
'=4;@%
!R'(.0=<=9:)
1MO/J%&%%")
!7.)58
"'1(
%package:olada/ui/otp/otp.dart
Ofile:///C:/xampp/htdocs/pawonan/app/olada/lib/ui/register/register.dart
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:olada/constants/assets.dart';
import 'package:olada/utils/routes/routes.dart';
import 'package:olada/widgets/app_icon_widget.dart';
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
class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
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
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: EmptyAppBar(),
      body: _buildBody(),
    );
  Widget _buildBody() {
    return Material(
      child: Stack(
        children: <Widget>[
          MediaQuery.of(context).orientation == Orientation.landscape
              ? Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: _buildLeftSide(),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildRightSide(),
                    ),
                  ],
                )
              : Center(child: _buildRightSide()),
        ],
      ),
    );
  Widget _buildLeftSide() {
    return SizedBox.expand(
      child: Image.asset(
        Assets.carBackground,
        fit: BoxFit.cover,
      ),
    );
  Widget _buildRightSide() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AppIconWidget(image: 'assets/images/register.png'),
            Text(
              'Registrasi',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0),
            ),
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
          ],
        ),
      ),
    );
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
  Widget _buildPasswordField() {
    return TextFieldWidget(
      hint: 'Password',
      isObscure: true,
      icon: Icons.lock,
      textController: passwordController,
      errorText: "",
    );
  Widget _buildConfirmPasswordField() {
    return TextFieldWidget(
      hint: 'Konfirmasi Password',
      isObscure: true,
      icon: Icons.lock,
      textController: confirmPasswordController,
      errorText: "",
    );
  Widget _buildSignUpButton() {
    return RoundedButtonWidget(
      buttonText: 'Register',
      buttonColor: Colors.orangeAccent,
      textColor: Colors.white,
      onPressed: () async {
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
                  usernameController.text,
                  emailController.text,
                  phoneNumberController.text);
              print(response.toString());
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
                  if (response.status == 200) {
                    Navigator.of(context).pushNamed('/otp-success');
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
        }
      },
    );
97:>CHD?)).65:
<)GHGGNDJ
@*1	
%"%%%$%
%"%$%+%#
0-307$30
L&=2
8(34
J,)0
+-.A0*%@ E
F0100-%1F
J:<:41:H
@.?:D.<:D.?:
/package:olada/ui/register/register.dart
AKfile:///C:/xampp/htdocs/pawonan/app/olada/lib/ui/splash/splash.dart
import 'dart:async';
import 'package:olada/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffFF5400),
      statusBarIconBrightness: Brightness.light,
    ));
    startTimer();
    super.initState();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Color(0xFFFF5400),
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/logo-white.png',
                height: 200,
                width: 200,
              ),
              Text(
                'Olada',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "RedHatDisplay",
                ),
              ),
              Text(
                'Cari tukang pilihan Anda',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300,
                  fontFamily: "RedHatDisplay",
                ),
              ),
            ],
          ))),
    );
  startTimer() {
    var _duration = Duration(milliseconds: 2000);
    return Timer(_duration, navigate);
  navigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userFromPeference = prefs.getString("user");
    if (userFromPeference != null) {
      Navigator.of(context).pushNamed('/dashboard');
    } else {
      Navigator.of(context).pushNamed('/welcome');
    }
    /*if (preferences.getBool(Preferences.is_logged_in) ?? false) {
      Navigator.of(context).pushReplacementNamed(Routes.welcome);
    } else {
      Navigator.of(context).pushReplacementNamed(Routes.welcome);
    }*/
:)>)4>)P
@*2	
"#(#00
-#(#00
F9&1
+package:olada/ui/splash/splash.dart
Mfile:///C:/xampp/htdocs/pawonan/app/olada/lib/ui/welcome/welcome.dart
kimport 'package:another_flushbar/flushbar_helper.dart';
import 'package:olada/constants/assets.dart';
import 'package:olada/utils/routes/routes.dart';
import 'package:olada/widgets/app_icon_widget.dart';
import 'package:olada/widgets/empty_app_bar_widget.dart';
import 'package:olada/widgets/rounded_button_widget.dart';
import 'package:olada/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffFFFFFF),
      statusBarIconBrightness: Brightness.dark,
    ));
    super.initState();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: EmptyAppBar(),
      body: _buildBody(),
    );
  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Material(
      color: Color(0xffffffff),
      child: Stack(
        children: <Widget>[
          MediaQuery.of(context).orientation == Orientation.landscape
              ? Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: _buildLeftSide(),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildRightSide(),
                    ),
                  ],
                )
              : Center(child: _buildRightSide())
        ],
      ),
    );
  Widget _buildLeftSide() {
    return SizedBox.expand(
      child: Image.asset(
        Assets.carBackground,
        fit: BoxFit.cover,
      ),
    );
  Widget _buildRightSide() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Selamat datang di Olada',
                style: TextStyle(fontSize: 24.0)),
            SizedBox(
              height: 50.0,
            ),
            Image.asset('assets/images/welcome.png'),
            SizedBox(height: 60.0),
            _buildNavigationButton(),
            SizedBox(height: 20.0),
            _buildTermAndCondition()
          ],
        ),
      ),
    );
  Widget _buildTermAndCondition() {
    return Text.rich(TextSpan(
        text: "Dengan masuk atau mendaftar kamu menyetujui ",
        children: <TextSpan>[
          TextSpan(
              text: 'Ketentuan Layanan',
              style: TextStyle(color: Color(0xffFF5400))),
          TextSpan(text: ' dan '),
          TextSpan(
              text: 'Kebijakan Privasi',
              style: TextStyle(color: Color(0xffFF5400)))
        ]));
  Widget _buildNavigationButton() {
    return Row(
      children: [
        Expanded(
          child: RoundedButtonWidget(
            buttonText: 'Login',
            buttonColor: Color(0xffFF5400),
            textColor: Colors.white,
            onPressed: () async {
              Navigator.of(context).pushNamed('/signin');
            },
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: RoundedButtonWidget(
            buttonText: 'Register',
            buttonColor: Color(0xffFF5400),
            textColor: Colors.white,
            onPressed: () async {
              Navigator.of(context).pushNamed('/register');
            },
          ),
        )
      ],
    );
97:>CD?)
@*1	
7%'%&
'"-&#:
'%-&#=
-package:olada/ui/welcome/welcome.dart
ANfile:///C:/xampp/htdocs/pawonan/app/olada/lib/utils/loader/loader.dart
import 'package:flutter/material.dart';
AlertDialog showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
  return alert;
.package:olada/utils/loader/loader.dart
Mfile:///C:/xampp/htdocs/pawonan/app/olada/lib/utils/map/icon_map.dart
Map<String, String> iconOfSubservices = {
  'Pagar': 'assets/icons/subservices/fence.png',
  'Listrik': 'assets/icons/subservices/electric.png',
  'Renovasi': 'assets/icons/subservices/brick.png',
  'Pengecatan': 'assets/icons/subservices/roller-brush.png',
  'Tangga': 'assets/icons/subservices/stairs.png',
  'Sketsa': 'assets/icons/subservices/sketch.png',
  'Las': 'assets/icons/subservices/welding.png',
  'Sapu': 'assets/icons/subservices/broom.png',
  'Wallpaper': 'assets/icons/subservices/wallpaper.png',
  'Kulkas': 'assets/icons/subservices/refrigerator.png',
  'AC': 'assets/icons/subservices/air-conditioner.png',
  'CCTV': 'assets/icons/subservices/cctv.png',
  'Mesin cuci': 'assets/icons/subservices/washing-machine.png',
  'Dinamo': 'assets/icons/subservices/dynamo.png',
  'Aki': 'assets/icons/subservices/battery.png',
  'Dispenser': 'assets/icons/subservices/water-dispenser.png',
  'Komputer': 'assets/icons/subservices/computer.png',
  'Sofa': 'assets/icons/subservices/couch.png',
  'Lemari': 'assets/icons/subservices/cupboard.png',
  'Kitchen set': 'assets/icons/subservices/kitchen.png',
  'Meja': 'assets/icons/subservices/table.png',
  'Kaca': 'assets/icons/subservices/glass.png',
+275>4421::90A42@816:11
-package:olada/utils/map/icon_map.dart
Nfile:///C:/xampp/htdocs/pawonan/app/olada/lib/utils/routes/routes.dart
import 'package:olada/ui/main/main.dart';
import 'package:olada/ui/signin/signin.dart';
import 'package:olada/ui/splash/splash.dart';
import 'package:olada/ui/welcome/welcome.dart';
import 'package:olada/ui/otp/otp.dart';
import 'package:olada/ui/register/register.dart';
import 'package:olada/ui/main/subservices/subservices.dart';
import 'package:olada/ui/main/order/detail/detail.dart';
import 'package:olada/ui/main/order/form/form.dart';
import 'package:olada/ui/main/order/form/maps/maps.dart';
import 'package:olada/ui/main/order/listpartner/listpartner.dart';
import 'package:olada/ui/main/order/detailpartner/detailpartner.dart';
import 'package:olada/ui/main/order/checkout/checkout.dart';
import 'package:flutter/material.dart';
class Routes {
  Routes._();
  static const String splash = '/splash';
  static const String login = '/signin';
  static const String main = '/dashboard';
  static const String welcome = '/welcome';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String otpSuccess = '/otp-succes';
  static const String subServices = '/subservices';
  static const String detailOrder = '/order/detail';
  static const String formOrder = '/order/form';
  static const String formOrderMaps = '/order/form/maps';
  static const String listPartnerOrder = '/order/partner';
  static const String detailPartnerOrder = '/order/partner/detail';
  static const String checkoutOrder = '/order/checkout';
  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    welcome: (BuildContext context) => WelcomeScreen(),
    register: (BuildContext context) => RegisterScreen(),
    otp: (BuildContext context) => OTPScreen(),
    login: (BuildContext context) => LoginScreen(),
    main: (BuildContext context) => MainPage(),
    subServices: (BuildContext context) => SubServicesScreen(),
    detailOrder: (BuildContext context) => DetailOrderScreen(),
    formOrder: (BuildContext context) => FormOrderScreen(),
    formOrderMaps: (BuildContext context) => FormOrderMapsScreen(),
    listPartnerOrder: (BuildContext context) => ListPartnerOrderScreen(),
    detailPartnerOrder: (BuildContext context) => DetailPartnerOrderScreen(),
    checkoutOrder: (BuildContext context) => CheckoutOrderScreen(),
  };
35791;FB>CLPF)
+)'-/%3562;<E:
279;151AA=EKOE
.package:olada/utils/routes/routes.dart
Rfile:///C:/xampp/htdocs/pawonan/app/olada/lib/widgets/app_icon_widget.dart
ximport 'package:flutter/material.dart';
class AppIconWidget extends StatelessWidget {
  final image;
  const AppIconWidget({
    Key key,
    this.image,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //getting screen size
    var size = MediaQuery.of(context).size;
    //calculating container width
    double imageSize;
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      imageSize = (size.width * 0.20);
    } else {
      imageSize = (size.height * 0.20);
    }
    return Image.asset(
      image,
      height: imageSize,
    );
2package:olada/widgets/app_icon_widget.dart
Wfile:///C:/xampp/htdocs/pawonan/app/olada/lib/widgets/empty_app_bar_widget.dart
	import 'package:flutter/material.dart';
class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  @override
  Size get preferredSize => Size(0.0, 0.0);
7package:olada/widgets/empty_app_bar_widget.dart
\file:///C:/xampp/htdocs/pawonan/app/olada/lib/widgets/progress_indicator_widget.dart
import 'package:flutter/material.dart';
class CustomProgressIndicatorWidget extends StatelessWidget {
  const CustomProgressIndicatorWidget({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 100,
        constraints: BoxConstraints.expand(),
        child: FittedBox(
          fit: BoxFit.none,
          child: SizedBox(
            height: 100,
            width: 100,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: CircularProgressIndicator(),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            ),
          ),
        ),
        decoration: BoxDecoration(color: Color.fromARGB(100, 105, 105, 105)),
      ),
    );
<package:olada/widgets/progress_indicator_widget.dart
Xfile:///C:/xampp/htdocs/pawonan/app/olada/lib/widgets/rounded_button_widget.dart
import 'package:flutter/material.dart';
class RoundedButtonWidget extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final VoidCallback onPressed;
  const RoundedButtonWidget({
    Key key,
    this.buttonText,
    this.buttonColor,
    this.textColor = Colors.white,
    this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: buttonColor,
      shape: StadiumBorder(),
      onPressed: onPressed,
      padding: EdgeInsets.all(12.0),
      child: Text(
        buttonText,
        style: Theme.of(context).textTheme.button.copyWith(color: textColor),
      ),
    );
8package:olada/widgets/rounded_button_widget.dart
Sfile:///C:/xampp/htdocs/pawonan/app/olada/lib/widgets/textfield_widget.dart
import 'package:flutter/material.dart';
class TextFieldWidget extends StatelessWidget {
  final IconData icon;
  final String hint;
  final String errorText;
  final bool isObscure;
  final bool isIcon;
  final TextInputType inputType;
  final TextEditingController textController;
  final EdgeInsets padding;
  final Color hintColor;
  final Color iconColor;
  final FocusNode focusNode;
  final ValueChanged onFieldSubmitted;
  final ValueChanged onChanged;
  final bool autoFocus;
  final TextInputAction inputAction;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
          controller: textController,
          onFieldSubmitted: onFieldSubmitted,
          onChanged: onChanged,
          autofocus: autoFocus,
          textInputAction: inputAction,
          obscureText: this.isObscure,
          style: Theme.of(context).textTheme.body1,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15.0),
            hintText: this.hint,
            fillColor: Colors.white,
            enabledBorder: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(40.0),
                borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(40.0),
                borderSide: BorderSide(color: Color(0xffFF5400))),
          )),
    );
  const TextFieldWidget({
    Key key,
    this.icon,
    this.errorText,
    this.textController,
    this.inputType,
    this.hint,
    this.isObscure = false,
    this.isIcon = true,
    this.padding = const EdgeInsets.all(0),
    this.hintColor = Colors.grey,
    this.iconColor = Colors.grey,
    this.focusNode,
    this.onFieldSubmitted,
    this.onChanged,
    this.autoFocus = false,
    this.inputAction,
  }) : super(key: key);
'/!!)(5(3"&4@>4@D
3package:olada/widgets/textfield_widget.dart
Rfile:///C:/src/flutter/.pub-cache/hosted/pub.dartlang.org/meta-1.3.0/lib/meta.dart
$// Copyright (c) 2016, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
/// Annotations that developers can use to express the intentions that otherwise
/// can't be deduced by statically analyzing the source code.
/// See also `@deprecated` and `@override` in the `dart:core` library.
/// Annotations provide semantic information that tools can use to provide a
/// better user experience. For example, an IDE might not autocomplete the name
/// of a function that's been marked `@deprecated`, or it might display the
/// function's name differently.
/// For information on installing and importing this library, see the [meta
/// package on pub.dev](https://pub.dev/packages/meta). For examples of using
/// annotations, see
/// [Metadata](https://dart.dev/guides/language/language-tour#metadata) in the
/// language tour.
library meta;
import 'meta_meta.dart';
/// Used to annotate a function `f`. Indicates that `f` always throws an
/// exception. Any functions that override `f`, in class inheritance, are also
/// expected to conform to this contract.
/// Tools, such as the analyzer, can use this to understand whether a block of
/// code "exits". For example:
/// ```dart
/// @alwaysThrows toss() { throw 'Thrown'; }
/// int fn(bool b) {
///   if (b) {
///     return 0;
///   } else {
///     toss();
///     print("Hello.");
///   }
/// }
/// ```
/// Without the annotation on `toss`, it would look as though `fn` doesn't
/// always return a value. The annotation shows that `fn` does always exit. In
/// addition, the annotation reveals that any statements following a call to
/// `toss` (like the `print` call) are dead code.
/// Tools, such as the analyzer, can also expect this contract to be enforced;
/// that is, tools may emit warnings if a function with this annotation
/// _doesn't_ always throw.
const _AlwaysThrows alwaysThrows = _AlwaysThrows();
/// Used to annotate a parameter of an instance method that overrides another
/// method.
/// Indicates that this parameter may have a tighter type than the parameter on
/// its superclass. The actual argument will be checked at runtime to ensure it
/// is a subtype of the overridden parameter type.
@Deprecated('Use the `covariant` modifier instead')
const _Checked checked = _Checked();
/// Used to annotate a method, getter or top-level getter or function to
/// indicate that the value obtained by invoking it should not be stored in a
/// field or top-level variable. The annotation can also be applied to a class
/// to implicitly annotate all of the valid members of the class, or applied to
/// a library to annotate all of the valid members of the library, including
/// classes. If a value returned by an element marked as `doNotStore` is returned
/// from a function or getter, that function or getter should be similarly
/// annotated.
/// Tools, such as the analyzer, can provide feedback if
/// * the annotation is associated with anything other than a library, class,
///   method or getter, top-level getter or function, or
/// * an invocation of a member that has this annotation is returned by a method,
///   getter or function that is not similarly annotated as `doNotStore`, or
/// * an invocation of a member that has this annotation is assigned to a field
///   or top-level variable.
const _DoNotStore doNotStore = _DoNotStore();
/// Used to annotate a library, or any declaration that is part of the public
/// interface of a library (such as top-level members, class members, and
/// function parameters) to indicate that the annotated API is experimental and
/// may be removed or changed at any-time without updating the version of the
/// containing package, despite the fact that it would otherwise be a breaking
/// change.
/// If the annotation is applied to a library then it is equivalent to applying
/// the annotation to all of the top-level members of the library. Applying the
/// annotation to a class does *not* apply the annotation to subclasses, but
/// does apply the annotation to members of the class.
/// Tools, such as the analyzer, can provide feedback if
/// * the annotation is associated with a declaration that is not part of the
///   public interface of a library (such as a local variable or a declaration
///   that is private) or a directive other than the first directive in the
///   library, or
/// * the declaration is referenced by a package that has not explicitly
///   indicated its intention to use experimental APIs (details TBD).
const _Experimental experimental = _Experimental();
/// Used to annotate an instance or static method `m`. Indicates that `m` must
/// either be abstract or must return a newly allocated object or `null`. In
/// addition, every method that either implements or overrides `m` is implicitly
/// annotated with this same annotation.
/// Tools, such as the analyzer, can provide feedback if
/// * the annotation is associated with anything other than a method, or
/// * a method that has this annotation can return anything other than a newly
///   allocated object or `null`.
const _Factory factory = _Factory();
/// Used to annotate a class `C`. Indicates that `C` and all subtypes of `C`
/// must be immutable.
/// A class is immutable if all of the instance fields of the class, whether
/// defined directly or inherited, are `final`.
/// Tools, such as the analyzer, can provide feedback if
/// * the annotation is associated with anything other than a class, or
/// * a class that has this annotation or extends, implements or mixes in a
///   class that has this annotation is not immutable.
const Immutable immutable = Immutable();
/// Used to annotate a declaration which should only be used from within the
/// package in which it is declared, and which should not be exposed from said
/// package's public API.
/// Tools, such as the analyzer, can provide feedback if
/// * the declaration is declared in a package's public API, or is exposed from
///   a package's public API, or
/// * the declaration is private, an unnamed extension, a static member of a
///   private class, mixin, or extension, a value of a private enum, or a
///   constructor of a private class, or
/// * the declaration is referenced outside the package in which it is declared.
const _Internal internal = _Internal();
/// Used to annotate a test framework function that runs a single test.
/// Tools, such as IDEs, can show invocations of such function in a file
/// structure view to help the user navigating in large test files.
/// The first parameter of the function must be the description of the test.
const _IsTest isTest = _IsTest();
/// Used to annotate a test framework function that runs a group of tests.
/// Tools, such as IDEs, can show invocations of such function in a file
/// structure view to help the user navigating in large test files.
/// The first parameter of the function must be the description of the group.
const _IsTestGroup isTestGroup = _IsTestGroup();
/// Used to annotate a const constructor `c`. Indicates that any invocation of
/// the constructor must use the keyword `const` unless one or more of the
/// arguments to the constructor is not a compile-time constant.
/// Tools, such as the analyzer, can provide feedback if
/// * the annotation is associated with anything other than a const constructor,
///   or
/// * an invocation of a constructor that has this annotation is not invoked
///   using the `const` keyword unless one or more of the arguments to the
///   constructor is not a compile-time constant.
const _Literal literal = _Literal();
/// Used to annotate an instance method `m`. Indicates that every invocation of
/// a method that overrides `m` must also invoke `m`. In addition, every method
/// that overrides `m` is implicitly annotated with this same annotation.
/// Note that private methods with this annotation cannot be validly overridden
/// outside of the library that defines the annotated method.
/// Tools, such as the analyzer, can provide feedback if
/// * the annotation is associated with anything other than an instance method,
///   or
/// * a method that overrides a method that has this annotation can return
///   without invoking the overridden method.
const _MustCallSuper mustCallSuper = _MustCallSuper();
/// Used to annotate an instance member (method, getter, setter, operator, or
/// field) `m` in a class `C` or mixin `M`. Indicates that `m` should not be
/// overridden in any classes that extend or mixin `C` or `M`.
/// Tools, such as the analyzer, can provide feedback if
/// * the annotation is associated with anything other than an instance member,
/// * the annotation is associated with an abstract member (because subclasses
///   are required to override the member),
/// * the annotation is associated with an extension method,
/// * the annotation is associated with a member `m` in class `C`, and there is
///   a class `D` or mixin `M`, that extends or mixes in `C`, that declares an
///   overriding member `m`.
const _NonVirtual nonVirtual = _NonVirtual();
/// Used to annotate a class, mixin, or extension declaration `C`. Indicates
/// that any type arguments declared on `C` are to be treated as optional.
/// Tools such as the analyzer and linter can use this information to suppress
/// warnings that would otherwise require type arguments on `C` to be provided.
const _OptionalTypeArgs optionalTypeArgs = _OptionalTypeArgs();
/// Used to annotate an instance member (method, getter, setter, operator, or
/// field) `m` in a class `C`. If the annotation is on a field it applies to the
/// getter, and setter if appropriate, that are induced by the field. Indicates
/// that `m` should only be invoked from instance methods of `C` or classes that
/// extend, implement or mix in `C`, either directly or indirectly. Additionally
/// indicates that `m` should only be invoked on `this`, whether explicitly or
/// implicitly.
/// Tools, such as the analyzer, can provide feedback if
/// * the annotation is associated with anything other than an instance member,
///   or
/// * an invocation of a member that has this annotation is used outside of an
///   instance member defined on a class that extends or mixes in (or a mixin
///   constrained to) the class in which the protected member is defined.
/// * an invocation of a member that has this annotation is used within an
///   instance method, but the receiver is something other than `this`.
const _Protected protected = _Protected();
/// Used to annotate a named parameter `p` in a method or function `f`.
/// Indicates that every invocation of `f` must include an argument
/// corresponding to `p`, despite the fact that `p` would otherwise be an
/// optional parameter.
/// Tools, such as the analyzer, can provide feedback if
/// * the annotation is associated with anything other than a named parameter,
/// * the annotation is associated with a named parameter in a method `m1` that
///   overrides a method `m0` and `m0` defines a named parameter with the same
///   name that does not have this annotation, or
/// * an invocation of a method or function does not include an argument
///   corresponding to a named parameter that has this annotation.
const Required required = Required();
/// Annotation marking a class as not allowed as a super-type.
/// Classes in the same package as the marked class may extend, implement or
/// mix-in the annotated class.
/// Tools, such as the analyzer, can provide feedback if
/// * the annotation is associated with anything other than a class,
/// * the annotation is associated with a class `C`, and there is a class or
///   mixin `D`, which extends, implements, mixes in, or constrains to `C`, and
///   `C` and `D` are declared in different packages.
const _Sealed sealed = _Sealed();
/// Used to annotate a field that is allowed to be overridden in Strong Mode.
/// Deprecated: Most of strong mode is now the default in 2.0, but the notion of
/// virtual fields was dropped, so this annotation no longer has any meaning.
/// Uses of the annotation should be removed.
@Deprecated('No longer has meaning')
const _Virtual virtual = _Virtual();
/// Used to annotate an instance member that was made public so that it could be
/// overridden but that is not intended to be referenced from outside the
/// defining library.
/// Tools, such as the analyzer, can provide feedback if
/// * the annotation is associated with a declaration other than a public
///   instance member in a class or mixin, or
/// * the member is referenced outside of the defining library.
const _VisibleForOverriding visibleForOverriding = _VisibleForOverriding();
/// Used to annotate a declaration that was made public, so that it is more
/// visible than otherwise necessary, to make code testable.
/// Tools, such as the analyzer, can provide feedback if
/// * the annotation is associated with a declaration not in the `lib` folder
///   of a package, or a private declaration, or a declaration in an unnamed
///   static extension, or
/// * the declaration is referenced outside of its defining library or a
///   library which is in the `test` folder of the defining package.
const _VisibleForTesting visibleForTesting = _VisibleForTesting();
/// Used to annotate a class.
/// See [immutable] for more details.
class Immutable {
  /// A human-readable explanation of the reason why the class is immutable.
  final String reason;
  /// Initialize a newly created instance to have the given [reason].
  const Immutable([this.reason = '']);
/// Used to annotate a named parameter `p` in a method or function `f`.
/// See [required] for more details.
class Required {
  /// A human-readable explanation of the reason why the annotated parameter is
  /// required. For example, the annotation might look like:
  ///
  ///     ButtonWidget({
  ///         Function onHover,
  ///         @Required('Buttons must do something when pressed')
  ///         Function onPressed,
  ///         ...
  ///     }) ...
  final String reason;
  /// Initialize a newly created instance to have the given [reason].
  const Required([this.reason = '']);
class _AlwaysThrows {
  const _AlwaysThrows();
class _Checked {
  const _Checked();
@Target({
  TargetKind.classType,
  TargetKind.function,
  TargetKind.getter,
  TargetKind.library,
  TargetKind.method,
class _DoNotStore {
  const _DoNotStore();
class _Experimental {
  const _Experimental();
class _Factory {
  const _Factory();
class _Internal {
  const _Internal();
class _IsTest {
  const _IsTest();
class _IsTestGroup {
  const _IsTestGroup();
class _Literal {
  const _Literal();
class _MustCallSuper {
  const _MustCallSuper();
class _NonVirtual {
  const _NonVirtual();
class _OptionalTypeArgs {
  const _OptionalTypeArgs();
class _Protected {
  const _Protected();
class _Sealed {
  const _Sealed();
@Deprecated('No longer has meaning')
class _Virtual {
  const _Virtual();
class _VisibleForOverriding {
  const _VisibleForOverriding();
class _VisibleForTesting {
  const _VisibleForTesting();
MPL!
KOM2
INOPMRK
N9RMP
NJPNO
PPM7
OMQ)
IO"%
9HL7)
P!MJ)Q(
Q	MK2%
P	K.7
PO,=PO
MKOP@
NQPQQO
P	ONJKH+
OPO2IC&
EMP6"
QN.%%
J.@L
package:meta/meta.dart