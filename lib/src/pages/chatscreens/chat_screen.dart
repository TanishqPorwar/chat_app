import 'package:chat_app/src/models/user.dart';
import 'package:chat_app/src/styles/colors.dart';
import 'package:chat_app/src/widgets/custom_app_bar.dart';
import 'package:chat_app/src/widgets/option_tile.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final User receiver;

  const ChatScreen({Key key, this.receiver}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textfieldController = TextEditingController();
  bool isTyping = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: customAppBar(context),
      body: Column(
        children: <Widget>[
          Flexible(
            child: messageList(),
          ),
          chatControls(),
        ],
      ),
    );
  }

  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: Text(
        widget.receiver.name,
      ),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.video_call), onPressed: () {}),
        IconButton(icon: Icon(Icons.phone), onPressed: () {})
      ],
    );
  }

  Widget messageList() {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: 6,
      itemBuilder: (context, index) {
        return chatMessageItem();
      },
    );
  }

  Widget chatMessageItem() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        child: senderLayout(),
        // child: receiverLayout(),
      ),
    );
  }

  Widget senderLayout() {
    Radius messageRadius = Radius.circular(10);

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(top: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.65,
        ),
        decoration: BoxDecoration(
          color: senderColor,
          borderRadius: BorderRadius.only(
            topLeft: messageRadius,
            topRight: messageRadius,
            bottomLeft: messageRadius,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Text("Hey!!"),
        ),
      ),
    );
  }

  Widget receiverLayout() {
    Radius messageRadius = Radius.circular(10);

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(top: 12),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
        decoration: BoxDecoration(
          color: receiverColor,
          borderRadius: BorderRadius.only(
            topLeft: messageRadius,
            topRight: messageRadius,
            bottomRight: messageRadius,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Text("Hey, how are you?"),
        ),
      ),
    );
  }

  addMediaOptions(context) {
    showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: blackColor,
      builder: (context) {
        return Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.maybePop(context),
                    child: Icon(Icons.close),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Content and tools",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
                child: ListView(
              children: <Widget>[
                OptionTile(
                  title: "Media",
                  subtitle: "Share Photos and Videos",
                  icon: Icons.image,
                ),
                OptionTile(
                  title: "File",
                  subtitle: "Share files",
                  icon: Icons.attach_file,
                ),
                OptionTile(
                  title: "Contacts",
                  subtitle: "Share contacts",
                  icon: Icons.contacts,
                ),
                OptionTile(
                  title: "Location",
                  subtitle: "Share location",
                  icon: Icons.add_location,
                ),
                OptionTile(
                  title: "Schedule Call",
                  subtitle: "Arrange a call and get reminders",
                  icon: Icons.schedule,
                ),
                OptionTile(
                  title: "Create Poll",
                  subtitle: "Share Poll",
                  icon: Icons.poll,
                ),
              ],
            ))
          ],
        );
      },
    );
  }

  Widget chatControls() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => addMediaOptions(context),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                gradient: fabGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: TextField(
              controller: textfieldController,
              onChanged: (value) {
                setState(() {
                  isTyping =
                      (value.length > 0 && value.trim() != "") ? true : false;
                });
              },
              decoration: InputDecoration(
                hintText: "Type a message",
                hintStyle: TextStyle(color: greyColor),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                filled: true,
                fillColor: seperatorColor,
                suffixIcon: GestureDetector(
                  onTap: () {},
                  child: Icon(Icons.face),
                ),
              ),
            ),
          ),
          isTyping
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.mic),
                ),
          isTyping ? Container() : Icon(Icons.camera_alt),
          isTyping
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    gradient: fabGradient,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                      icon: Icon(
                        Icons.send,
                        size: 15,
                      ),
                      onPressed: () {}),
                )
              : Container(),
        ],
      ),
    );
  }
}
