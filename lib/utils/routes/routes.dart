import 'package:olada/ui/main/dashboard.dart';
import 'package:olada/ui/signin/signin.dart';
import 'package:olada/ui/signup/signup.dart';
import 'package:olada/ui/splash/splash.dart';
import 'package:olada/ui/otp/otp.dart';
import 'package:olada/ui/otp-success/otp-success.dart';
import 'package:olada/ui/register/register.dart';
import 'package:olada/ui/main/notification/notification.dart';
import 'package:olada/ui/main/chatlist/chatlist.dart';
import 'package:olada/ui/main/like/like.dart';
import 'package:olada/ui/main/product/product.dart';
import 'package:olada/ui/main/order/order.dart';
import 'package:olada/ui/main/order/detail/detail.dart';
import 'package:olada/ui/main/post/post.dart';
import 'package:olada/ui/main/user/user.dart';
import 'package:olada/ui/main/search/search.dart';
import 'package:olada/ui/main/chat/chat.dart';
import 'package:olada/ui/main/list/list.dart';
import 'package:olada/ui/main/promo/promo.dart';
import 'package:olada/ui/main/merchant/merchant.dart';
import 'package:olada/ui/main/checkout/checkout.dart';
import 'package:olada/ui/main/profile/setting/setting.dart';
import 'package:olada/ui/main/profile/edit/edit.dart';
import 'package:olada/ui/main/profile/hobby/hobby.dart';
import 'package:olada/ui/main/profile/privacy/privacy.dart';
import 'package:olada/ui/main/profile/help/help.dart';
import 'package:olada/ui/main/profile/version/version.dart';
import 'package:olada/ui/main/profile/merchant/merchant.dart';
import 'package:olada/ui/main/profile/merchant/register/register.dart';
import 'package:olada/ui/main/profile/merchant/product/product.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes._();
  static const String splash = '/splash';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String main = '/dashboard';
  static const String welcome = '/welcome';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String otpSuccess = '/otp-success';
  static const String notifications = '/notifications';
  static const String chats = '/chats';
  static const String subServices = '/subservices';
  static const String chatOrder = '/order/chat';
  static const String user = '/user';
  static const String post = '/post';
  static const String product = '/product';
  static const String likes = '/likes';
  static const String search = '/search';
  static const String chat = '/chat';
  static const String list = '/list';
  static const String promo = '/promo';
  static const String merchant = '/merchant';
  static const String checkout = '/checkout';
  static const String orderList= '/order';
  static const String orderDetail = '/order/detail';
  static const String checkoutOrder = '/order/checkout';
  static const String surveyOrder = '/order/survey';
  static const String profileMerchant = '/profile/merchant';
  static const String registerMerchant = '/profile/merchant/register';
  static const String productMerchant = '/profile/merchant/product';
  static const String setting = '/profile/setting';
  static const String edit = '/profile/setting/edit';
  static const String hobby = '/profile/setting/hobby';
  static const String privacy  = '/profile/privacy';
  static const String help  = '/profile/help';
  static const String version  = '/profile/version';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    register: (BuildContext context) => RegisterScreen(),
    otp: (BuildContext context) => OTPScreen(),
    otpSuccess: (BuildContext context) => OTPSuccessScreen(),
    signin: (BuildContext context) => SignInScreen(),
    signup: (BuildContext context) => SignUpScreen(),
    main: (BuildContext context) => MainPage(),
    user: (BuildContext context) => UserScreen(),
    notifications: (BuildContext context) => NotificationScreen(),
    chats: (BuildContext context) => ChatListScreen(),
    likes: (BuildContext context) => LikeScreen(),
    product: (BuildContext context) => ProductScreen(),
    orderList: (BuildContext context) => OrderScreen(),
    orderDetail: (BuildContext context) => OrderDetailScreen(),
    search: (BuildContext context) => SearchScreen(),
    chat: (BuildContext context) => ChatScreen(),
    list: (BuildContext context) => ListScreen(),
    promo: (BuildContext context) => PromoScreen(),
    post: (BuildContext context) => PostScreen(),
    merchant: (BuildContext context) => MerchantScreen(),
    checkout: (BuildContext context) => CheckoutScreen(),
    setting: (BuildContext context) => SettingScreen(),
    profileMerchant : (BuildContext context) => MerchantProfileScreen(),
    productMerchant : (BuildContext context) => ProductMerchantScreen(),
    registerMerchant : (BuildContext context) => RegisterMerchantScreen(),
    edit : (BuildContext context) => EditProfileScreen(),
    hobby : (BuildContext context) => HobbyScreen(),
    privacy : (BuildContext context) => PrivacyScreen(),
    help : (BuildContext context) => HelpScreen(),
    version : (BuildContext context) => VersionScreen(),
  };
}
