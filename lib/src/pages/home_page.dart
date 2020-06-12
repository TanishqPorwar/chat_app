import 'package:chat_app/src/pages/page_viiew_screens/chat_list_scren.dart';
import 'package:chat_app/src/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController;
  int _page = 0;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: PageView(
        children: <Widget>[
          Container(
            child: ChatListScreen(),
          ),
          Center(child: Text("Call Logs")),
          Center(child: Text("Contacts")),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: CupertinoTabBar(
              currentIndex: _page,
              onTap: navigationTapped,
              inactiveColor: greyColor,
              activeColor: lightBlueColor,
              backgroundColor: blackColor,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.chat), title: Text("Chats")),
                BottomNavigationBarItem(
                    icon: Icon(Icons.call), title: Text("Logs")),
                BottomNavigationBarItem(
                    icon: Icon(Icons.contact_phone), title: Text("Contacts")),
              ]),
        ),
      ),
    );
  }
}
