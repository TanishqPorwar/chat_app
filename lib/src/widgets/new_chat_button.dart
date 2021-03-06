import 'package:chat_app/src/styles/colors.dart';
import 'package:flutter/material.dart';

class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: fabGradient,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Icon(
        Icons.edit,
        size: 25,
      ),
      padding: EdgeInsets.all(15),
    );
  }
}
