import 'package:chat_app/src/services/firebase_repository.dart';
import 'package:chat_app/src/styles/colors.dart';
import 'package:chat_app/src/utils/utilities.dart';
import 'package:chat_app/src/widgets/chat_list.dart';
import 'package:chat_app/src/widgets/custom_app_bar.dart';
import 'package:chat_app/src/widgets/new_chat_button.dart';
import 'package:chat_app/src/widgets/user_circle.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

final FirebaseRepository _repository = FirebaseRepository();

class _ChatListScreenState extends State<ChatListScreen> {
  String currentUserId;
  String initials;

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
      setState(() {
        currentUserId = user.uid;
        initials = Utils.getInitials(user.displayName);
      });
    });
  }

  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.notifications,
        ),
        onPressed: () {},
      ),
      title: UserCircle(text: initials),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/search_screen');
          },
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: customAppBar(context),
      floatingActionButton: NewChatButton(),
      body: ChatList(uid: currentUserId),
    );
  }
}
