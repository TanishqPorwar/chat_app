import 'package:chat_app/src/styles/colors.dart';
import 'package:chat_app/src/styles/font_styles.dart';
import 'package:flutter/material.dart';

class UserCircle extends StatelessWidget {
  final String text;

  const UserCircle({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: seperatorColor,
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              text ?? "G",
              style: userCircleStyle,
            ),
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
    );
  }
}
