import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:olada/ui/main/home/home.dart';
import 'package:olada/ui/main/feed/feed.dart';
import 'package:olada/ui/main/basket/basket.dart';
import 'package:olada/ui/main/chatlist/chatlist.dart';
import 'package:olada/ui/main/profile/profile.dart';
import 'package:olada/constants/assets.dart';
import 'package:olada/constants/colors.dart';
import 'package:olada/constants/strings.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [];
  final List<Widget> pages = [
    HomeScreen(),
    FeedScreen(),
    BasketScreen(),
    ChatListScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
          child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
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
                                  ? AppColors.PrimaryColor
                                  : Colors.black54),
                          Text('Home',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: (_currentIndex == 0)
                                      ? AppColors.PrimaryColor
                                      : Colors.black54))
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
                          Icon(CupertinoIcons.doc_plaintext,
                              color: (_currentIndex == 1)
                                  ? AppColors.PrimaryColor
                                  : Colors.black54),
                          Text('Feed',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: (_currentIndex == 1)
                                      ? AppColors.PrimaryColor
                                      : Colors.black54))
                        ])))),
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
                          Icon(CupertinoIcons.shopping_cart,
                              color: (_currentIndex == 2)
                                  ? AppColors.PrimaryColor
                                  : Colors.black54),
                          Text('Keranjang',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: (_currentIndex == 2)
                                      ? AppColors.PrimaryColor
                                      : Colors.black54))
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
                          Icon(CupertinoIcons.chat_bubble,
                              color: (_currentIndex == 3)
                                  ? AppColors.PrimaryColor
                                  : Colors.black54),
                          Text('Chat',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: (_currentIndex == 3)
                                      ? AppColors.PrimaryColor
                                      : Colors.black54))
                        ])))),
            Expanded(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = 4;
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.only(top: 5.0),
                        height: 50.0,
                        child: Column(children: [
                          Icon(CupertinoIcons.person,
                              color: (_currentIndex == 4)
                                  ? AppColors.PrimaryColor
                                  : Colors.black54),
                          Text('Profil',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: (_currentIndex == 4)
                                      ? AppColors.PrimaryColor
                                      : Colors.black54))
                        ])))),
          ],
        ),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
         value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemStatusBarContrastEnforced: true,
        ),
        child: Container(
            height: double.infinity,
            width: double.infinity,
            child: pages[_currentIndex]),
      ),
    );
  }
}
