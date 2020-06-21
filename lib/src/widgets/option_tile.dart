import 'package:chat_app/src/styles/colors.dart';
import 'package:chat_app/src/widgets/custom_tile.dart';
import 'package:flutter/material.dart';

class OptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const OptionTile({Key key, this.title, this.subtitle, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: receiverColor,
          ),
          child: Icon(
            icon,
            color: greyColor,
            size: 38,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subTitle: Text(
          subtitle,
          style: TextStyle(color: greyColor, fontSize: 14),
        ),
        mini: false,
      ),
    );
  }
}
