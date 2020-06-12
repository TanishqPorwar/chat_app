import 'package:chat_app/src/styles/colors.dart';
import 'package:chat_app/src/styles/font_styles.dart';
import 'package:flutter/material.dart';

import 'custom_tile.dart';

class ChatList extends StatefulWidget {
  final String uid;

  const ChatList({Key key, this.uid}) : super(key: key);
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: 2,
        itemBuilder: (context, index) {
          return CustomTile(
            mini: false,
            onTap: () {},
            title: Text(
              "Tanishq Porwar",
              style: tileTitleStyle,
            ),
            subTitle: Text(
              "Hello",
              style: tileSubtitleStyle,
              overflow: TextOverflow.fade,
            ),
            leading: Container(
              constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
              child: Stack(
                children: <Widget>[
                  CircleAvatar(
                    maxRadius: 30,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                        NetworkImage("https://logodix.com/logo/466678.jpg"),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: blackColor,
                          width: 2,
                        ),
                        color: onlineDotColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
