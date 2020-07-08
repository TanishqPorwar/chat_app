import 'dart:io';

import 'package:chat_app/src/enum/view_state.dart';
import 'package:chat_app/src/models/message.dart';
import 'package:chat_app/src/models/user.dart';
import 'package:chat_app/src/provider/image_upload_provider.dart';
import 'package:chat_app/src/services/firebase_repository.dart';
import 'package:chat_app/src/styles/colors.dart';
import 'package:chat_app/src/utils/utilities.dart';
import 'package:chat_app/src/widgets/custom_app_bar.dart';
import 'package:chat_app/src/widgets/option_tile.dart';
import 'package:chat_app/src/widgets/cached_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final User receiver;

  const ChatScreen({Key key, this.receiver}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textfieldController = TextEditingController();
  FirebaseRepository _repository = FirebaseRepository();
  ScrollController _listScrollController = ScrollController();
  ImageUploadProvider _imageUploadProvider;
  bool isTyping = false;
  bool showEmojiPicker = false;
  User sender;
  String _currentUserId;
  FocusNode textFieldFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
      _currentUserId = user.uid;
      setState(() {
        sender = User(
          uid: user.uid,
          name: user.displayName,
          profilePhoto: user.photoUrl,
        );
      });
    });
  }

  showKeyboard() => textFieldFocus.requestFocus();
  hideKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    return Scaffold(
      backgroundColor: blackColor,
      appBar: customAppBar(context),
      body: Column(
        children: <Widget>[
          Flexible(
            child: messageList(),
          ),
          (_imageUploadProvider.getViewState == ViewState.LOADING)
              ? Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(right: 15),
                  child: Container(
                    height: 50,
                    width: 50,
                    child: SpinKitRipple(
                      color: blueColor,
                    ),
                  ),
                )
              : Container(),
          chatControls(),
          showEmojiPicker
              ? Container(
                  child: emojiContainer(),
                )
              : Container(),
        ],
      ),
    );
  }

  emojiContainer() {
    return EmojiPicker(
      bgColor: seperatorColor,
      indicatorColor: blueColor,
      rows: 4,
      columns: 7,
      recommendKeywords: textfieldController.text == null
          ? [""]
          : textfieldController.text.split(" "),
      numRecommended: 50,
      noRecommendationsText: "No Recommendations",
      noRecentsStyle: TextStyle(color: blueColor),
      noRecommendationsStyle: TextStyle(color: blueColor),
      onEmojiSelected: (emoji, category) {
        setState(() {
          isTyping = true;
        });
        textfieldController.text = textfieldController.text + emoji.emoji;
      },
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
    return StreamBuilder(
      stream: _repository.getMessageStream(_currentUserId, widget.receiver.uid),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return SpinKitPulse(
            color: blueColor,
          );
        }

        /// [Scrolldown to bottom when new message arrives]

        // SchedulerBinding.instance.addPostFrameCallback((_) {
        //   _listScrollController.animateTo(
        //       _listScrollController.position.minScrollExtent,
        //       duration: Duration(milliseconds: 250),
        //       curve: Curves.easeOut);
        // });

        return ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: snapshot.data.documents.length,
          controller: _listScrollController,
          reverse: true,
          itemBuilder: (context, index) {
            return chatMessageItem(snapshot.data.documents[index]);
          },
        );
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    Message _message = Message.fromMap(snapshot.data);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        child: chatBubble(_message),
      ),
    );
  }

  Widget chatBubble(Message message) {
    Radius messageRadius = Radius.circular(10);

    return Align(
      alignment: (message.senderId == _currentUserId)
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(top: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.65,
        ),
        decoration: (message.senderId == _currentUserId)
            ? BoxDecoration(
                color: senderColor,
                borderRadius: BorderRadius.only(
                  topLeft: messageRadius,
                  topRight: messageRadius,
                  bottomLeft: messageRadius,
                ),
              )
            : BoxDecoration(
                color: receiverColor,
                borderRadius: BorderRadius.only(
                  topLeft: messageRadius,
                  topRight: messageRadius,
                  bottomRight: messageRadius,
                ),
              ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: getMessage(message),
        ),
      ),
    );
  }

  getMessage(Message message) {
    return message.type != "image"
        ? Text(
            message.message,
            style: TextStyle(
              fontSize: 16,
            ),
          )
        : (message.photoUrl != null)
            ? CachedImage(url: message.photoUrl)
            : Text("url is null");
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
                  onTap: () => pickImage(source: ImageSource.gallery),
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
            child: Stack(
              children: <Widget>[
                TextField(
                  controller: textfieldController,
                  focusNode: textFieldFocus,
                  onTap: () => hideEmojiContainer(),
                  maxLines: 5,
                  minLines: 1,
                  onChanged: (value) {
                    setState(() {
                      isTyping = (value.length > 0 && value.trim() != "")
                          ? true
                          : false;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Type a message",
                    hintStyle: TextStyle(color: greyColor),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(20, 5, 40, 5),
                    filled: true,
                    fillColor: seperatorColor,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      if (!showEmojiPicker) {
                        hideKeyboard();
                        showEmojiContainer();
                      } else {
                        showKeyboard();
                        hideEmojiContainer();
                      }
                    },
                    icon: Icon(Icons.face),
                  ),
                ),
              ],
            ),
          ),
          isTyping
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.mic),
                ),
          isTyping
              ? Container()
              : GestureDetector(
                  onTap: () => pickImage(source: ImageSource.camera),
                  child: Icon(Icons.camera_alt),
                ),
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
                      onPressed: () => sendMessage()),
                )
              : Container(),
        ],
      ),
    );
  }

  pickImage({@required ImageSource source}) async {
    File selectedImage = await Utils.pickImage(source: source);
    _repository.uploadImage(
      image: selectedImage,
      receiverId: widget.receiver.uid,
      senderId: _currentUserId,
      imageUploadProvider: _imageUploadProvider,
    );
  }

  sendMessage() {
    var text = textfieldController.text;
    Message _message = Message(
      receiverId: widget.receiver.uid,
      senderId: sender.uid,
      message: text,
      timestamp: Timestamp.now(),
      type: 'text',
    );
    setState(() {
      isTyping = false;
    });

    textfieldController.text = "";
    _repository.addMessageToDb(_message, sender, widget.receiver);
  }
}
