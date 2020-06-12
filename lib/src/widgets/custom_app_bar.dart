import 'package:chat_app/src/styles/colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget> actions;
  final Widget leading;
  final bool centerTitle;

  CustomAppBar(
      {Key key, this.title, this.actions, this.leading, this.centerTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: blackColor,
        border: Border(
          bottom: BorderSide(
            color: seperatorColor,
            width: 1.4,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: AppBar(
        backgroundColor: blackColor,
        elevation: 0,
        leading: leading,
        title: title,
        centerTitle: centerTitle,
        actions: actions,
      ),
    );
  }

  final Size preferredSize = const Size.fromHeight(kToolbarHeight + 10);
}
